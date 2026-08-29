//Dead mobs can exist whenever. This is needful

INITIALIZE_IMMEDIATE(/mob/dead)

/mob/dead
	appearance_flags = parent_type::appearance_flags | KEEP_TOGETHER
	sight = SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF
	move_resist = INFINITY
	throwforce = 0
	stat = DEAD

	/// Can the player return to their corpse?
	var/can_reenter_corpse = FALSE

	// Used for displaying in ghost chat, without changing the actual name
	// of the mob
	var/deadchat_name

/mob/dead/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE)
	if(initialized)
		stack_trace("Warning: [src]([type]) initialized multiple times!")

	initialized = TRUE
	add_to_mob_list()
	add_to_dead_mob_list()

	AddElement(/datum/element/movetype_handler)

	prepare_huds()
	register_init_signals()

	if(length(CONFIG_GET(keyed_list/cross_server)))
		add_verb(src, /mob/dead/proc/server_hop)

	set_focus(src)
	become_hearing_sensitive()


	for(var/v in GLOB.active_alternate_appearances)
		if(!v)
			continue
		var/datum/atom_hud/alternate_appearance/AA = v
		AA.onNewMob(src)
	return INITIALIZE_HINT_NORMAL

//Modified version of get_message_mods, removes the trimming, the only thing we care about here is admin channels
/mob/dead/get_message_mods(message, list/mods)
	var/key = message[1]
	if((key in GLOB.department_radio_prefixes) && length(message) > length(key) + 1 && !mods[RADIO_EXTENSION])
		mods[RADIO_KEY] = lowertext(message[1 + length(key)])
		mods[RADIO_EXTENSION] = GLOB.department_radio_keys[mods[RADIO_KEY]]
	return message

/// Helper for setting can_reenter_corpse to FALSE
/mob/dead/proc/unset_reenter_corpse()
	can_reenter_corpse = FALSE
	mind = null

/// Adds or removes the monochrome filter based on certain traits.
/mob/dead/proc/update_monochrome()
	if(client?.prefs?.read_preference(/datum/preference/toggle/monochrome_ghost) == FALSE) // Null != false
		remove_client_colour(/datum/client_colour/ghostmono)
		return

	add_client_colour(/datum/client_colour/ghostmono)

/mob/dead/canUseStorage()
	return FALSE

/mob/dead/get_status_tab_items()
	. = ..()
	. += ""

	if(SSticker.HasRoundStarted())
		return

	var/time_remaining = SSticker.GetTimeLeft()
	if(time_remaining > 0)
		. += "Time To Start: [round(time_remaining/10)]s"
	else if(time_remaining == -10)
		. += "Time To Start: DELAYED"
	else
		. += "Time To Start: SOON"

	. += "Players: [LAZYLEN(GLOB.clients)]"
	if(client.holder)
		. += "Players Ready: [SSticker.totalPlayersReady]"
		. += "Admins Ready: [SSticker.total_admins_ready] / [length(GLOB.admins)]"

/mob/dead/proc/server_hop()
	set category = "OOC"
	set name = "Server Hop!"
	set desc= "Jump to the other server"
	if(notransform)
		return
	var/list/our_id = CONFIG_GET(string/cross_comms_name)
	var/list/csa = CONFIG_GET(keyed_list/cross_server) - our_id
	var/pick
	switch(length(csa))
		if(0)
			remove_verb(src, /mob/dead/proc/server_hop)
			to_chat(src, span_notice("Server Hop has been disabled."))
		if(1)
			pick = csa[1]
		else
			pick = tgui_input_list(src, "Server to jump to", "Server Hop", csa)

	if(isnull(pick))
		return

	var/addr = csa[pick]

	if(tgui_alert(usr, "Jump to server [pick] ([addr])?", "Server Hop", list("Yes", "No")) != "Yes")
		return

	var/client/C = client
	to_chat(C, span_notice("Sending you to [pick]."))

	if(!C)
		return

	winset(src, null, "command=.options") //other wise the user never knows if byond is downloading resources

	C << link("[addr]")

/mob/dead/proc/update_z(new_z) // 1+ to register, null to unregister
	if (registered_z != new_z)
		if (registered_z)
			SSmobs.dead_players_by_zlevel[registered_z] -= src
		if (client)
			if (new_z)
				SSmobs.dead_players_by_zlevel[new_z] += src
			registered_z = new_z
		else
			registered_z = null

/mob/dead/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	var/turf/T = get_turf(src)
	if (isturf(T))
		update_z(T.z)

/mob/dead/auto_deadmin_on_login()
	return

/mob/dead/Logout()
	update_z(null)
	return ..()

/mob/dead/on_changed_z_level(turf/old_turf, turf/new_turf)
	..()
	update_z(new_turf?.z)

/mob/dead/can_smell()
	return FALSE

/// Attempts to retrieve a name from a corpse, otherwise returns a randomly generated one.
/mob/dead/proc/get_name_from_corpse(mob/corpse)
	if(!ismob(corpse))
		var/datum/name_generator/human/name_gen = new()
		name_gen.ensure_unique = TRUE
		return name_gen.Generate()

	if(corpse.mind && corpse.mind.name)
		if(corpse.mind.ghostname)
			. = corpse.mind.ghostname
		else
			. = corpse.mind.name
	else
		if(corpse.real_name)
			. = corpse.real_name

	if(!.)
		var/datum/name_generator/human/name_gen = new()
		name_gen.ensure_unique = TRUE
		return name_gen.Generate()

/mob/dead/proc/set_ghost_appearance(mob/living/to_copy)
	cut_viscontents()
	overlays.Cut()

	if(isAI(to_copy)) // Yay I love hacks
		icon = null
		icon_state = null
		alpha = 127

		var/obj/effect/overlay/holder = new
		holder.vis_flags = VIS_INHERIT_ID | VIS_INHERIT_LAYER | VIS_INHERIT_PLANE
		holder.icon = /obj/effect/overlay/ai_holder::icon
		holder.icon_state = /obj/effect/overlay/ai_holder::icon_state
		holder.pixel_x = -32
		holder.pixel_y = -32
		holder.overlays += image(/obj/effect/overlay/ai_holder::icon, "oldai-static")
		holder.overlays += image(/obj/effect/overlay/ai_holder::icon, "oldai-faceoverlay")
		add_viscontents(holder)
		return

	var/mutable_appearance/appearance = to_copy?.mind?.body_appearance || to_copy
	if(!appearance || !appearance.icon)
		icon = initial(icon)
		icon_state = "ghost"
		alpha = 255
	else
		icon = appearance.icon
		icon_state = appearance.icon_state
		overlays = appearance.overlays
		alpha = 127


/mob/dead/verb/reenter_corpse()
	set category = "Ghost"
	set name = "Re-enter Corpse"

	if(!client)
		return

	if(!mind || QDELETED(mind.current))
		to_chat(src, span_warning("You have no body."))
		return

	if(!can_reenter_corpse)
		to_chat(src, span_warning("You cannot re-enter your body."))
		return

	if(mind.current.key && mind.current.key[1] != "@") //makes sure we don't accidentally kick any clients
		to_chat(usr, span_warning("Another consciousness is in your body...It is resisting you."))
		return

	client.view_size.setDefault(getScreenSize(client.prefs.read_preference(/datum/preference/toggle/widescreen)))//Let's reset so people can't become allseeing gods
	SStgui.on_transfer(src, mind.current) // Transfer NanoUIs.

	if(mind.current.stat == DEAD && SSlag_switch.measures[DISABLE_DEAD_KEYLOOP])
		to_chat(src, span_warning("To leave your body again use the Ghost verb."))

	mind.current.PossessByPlayer(key)
	mind.current.client.init_verbs()
	qdel(src)
	return TRUE
