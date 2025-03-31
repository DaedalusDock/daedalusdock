/obj/item/clothing/glasses/hud/security
	name = "security HUD"
	desc = "A heads-up display that scans the humanoids in view and provides accurate data about their ID status and security records."
	icon_state = "securityhud"
	hud_type = null
	hud_trait = TRAIT_SECURITY_HUD
	glass_colour_type = null
	supports_variations_flags = CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION
	actions_types = list(/datum/action/innate/investigate)

/obj/item/clothing/glasses/hud/security/chameleon
	name = "chameleon security HUD"
	desc = "A stolen security HUD integrated with Syndicate chameleon technology. Provides flash protection."
	flash_protect = FLASH_PROTECTION_FLASH

	// Yes this code is the same as normal chameleon glasses, but we don't
	// have multiple inheritance, okay?
	var/datum/action/item_action/chameleon/change/chameleon_action

/obj/item/clothing/glasses/hud/security/chameleon/Initialize(mapload)
	. = ..()
	chameleon_action = new(src)
	chameleon_action.chameleon_type = /obj/item/clothing/glasses
	chameleon_action.chameleon_name = "Glasses"
	chameleon_action.chameleon_blacklist = typecacheof(/obj/item/clothing/glasses/changeling, only_root_path = TRUE)
	chameleon_action.initialize_disguises()
	add_item_action(chameleon_action)

/obj/item/clothing/glasses/hud/security/chameleon/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	chameleon_action.emp_randomise()


/obj/item/clothing/glasses/hud/security/sunglasses/eyepatch
	name = "eyepatch HUD"
	desc = "A heads-up display that connects directly to the optical nerve of the user, replacing the need for that useless eyeball."
	icon_state = "hudpatch"
	supports_variations_flags = NONE

/obj/item/clothing/glasses/hud/security/sunglasses
	name = "security HUDSunglasses"
	desc = "Sunglasses with a security HUD."
	icon_state = "sunhudsec"
	darkness_view = 1
	flash_protect = FLASH_PROTECTION_FLASH
	tint = 1
	glass_colour_type = null
	supports_variations_flags = NONE

/obj/item/clothing/glasses/hud/security/night
	name = "night vision security HUD"
	desc = "An advanced heads-up display that provides ID data and vision in complete darkness."
	icon_state = "securityhudnight"
	darkness_view = 8
	flash_protect = FLASH_PROTECTION_SENSITIVE
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	glass_colour_type = /datum/client_colour/glass_colour/green
	supports_variations_flags = NONE

/obj/item/clothing/glasses/hud/security/sunglasses/gars
	name = "\improper HUD gar glasses"
	desc = "GAR glasses with a HUD."
	icon_state = "gar_sec"
	inhand_icon_state = "gar_black"
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER
	force = 10
	throwforce = 10
	throw_speed = 1.5
	attack_verb_continuous = list("slices")
	attack_verb_simple = list("slice")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = SHARP_EDGED

/obj/item/clothing/glasses/hud/security/sunglasses/gars/giga
	name = "giga HUD gar glasses"
	desc = "GIGA GAR glasses with a HUD."
	icon_state = "gigagar_sec"
	force = 12
	throwforce = 12

/datum/action/innate/investigate
	name = "Investigate"
	check_flags = AB_CHECK_HANDS_BLOCKED | AB_CHECK_CONSCIOUS
	click_action = TRUE
	ranged_mousepointer = 'icons/effects/mouse_pointers/supplypod_target.dmi'

	button_icon = /obj/item/clothing/glasses/hud/security::icon
	button_icon_state = /obj/item/clothing/glasses/hud/security::icon_state

	/// The sound channel we're using
	var/used_channel
	/// The sound datum for the loop
	var/sound/loop
	/// Timer ID for the looping timer that checks the owner's mouse over atom.
	var/timer
	/// A weakref to the most recently hovered human
	var/datum/weakref/last_hover_ref
	/// The screentext object, we handle it ourselves
	var/atom/movable/screen/text/screen_text/atom_hud/hud_obj

	COOLDOWN_DECLARE(usage_cd)

/datum/action/innate/investigate/Grant(mob/grant_to)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_WANTED_CRIMINAL, PROC_REF(wanted_fool), override = TRUE)

/datum/action/innate/investigate/Remove(mob/removed_from)
	. = ..()
	if(used_channel)
		SEND_SOUND(removed_from, sound(channel = used_channel))

	hud_obj?.end_play(removed_from)
	UnregisterSignal(SSdcs, COMSIG_GLOB_WANTED_CRIMINAL)

/datum/action/innate/investigate/IsAvailable(feedback)
	if(!ishuman(owner))
		return FALSE

	var/mob/living/carbon/human/H = owner
	if(H.glasses != target)
		if(feedback)
			to_chat(owner, span_warning("You cannot use [target] without putting it on."))
		return FALSE

	return ..()

/datum/action/innate/investigate/set_ranged_ability(mob/living/on_who, text_to_show)
	. = ..()
	used_channel ||= SSsounds.random_available_channel()

	loop = sound('sound/items/sec_hud/inspect_loop.mp3', TRUE)

	owner.playsound_local(get_turf(owner), 'sound/items/sec_hud/inspect_open.mp3', 100, channel = used_channel)
	owner.playsound_local(get_turf(owner), vol = 200, channel = used_channel, sound_to_use = loop, wait = TRUE)
	timer = addtimer(CALLBACK(src, PROC_REF(check_mouse_over)), 1, TIMER_STOPPABLE | TIMER_LOOP)

	var/obj/item/clothing/glasses/G = target
	if(isnull(initial(G.glass_colour_type)))
		G.change_glass_color(owner, /datum/client_colour/glass_colour/red)

/datum/action/innate/investigate/unset_ranged_ability(mob/living/on_who, text_to_show)
	. = ..()
	var/turf/T = get_turf(owner)
	if(T)
		owner.playsound_local(get_turf(owner), sound('sound/items/sec_hud/inspect_close.mp3'), 100, channel = used_channel)
	else if(used_channel)
		SEND_SOUND(owner, sound(channel = used_channel))

	deltimer(timer)
	hud_obj?.end_play()

	var/obj/item/clothing/glasses/G = target
	if(isnull(initial(G.glass_colour_type)))
		G.change_glass_color(owner, null)

/datum/action/innate/investigate/proc/check_mouse_over()
	if(!owner.client)
		unset_ranged_ability(owner)
		return

	var/atom/hovered = SSmouse_entered.sustained_hovers[owner.client]
	if(isnull(hovered))
		clear_hovered()
		return

	if(IS_WEAKREF_OF(hovered, last_hover_ref))
		return

	if(!ishuman(hovered))
		clear_hovered()
		return

	owner.playsound_local(get_turf(owner), 'sound/items/sec_hud/inspect_highlight.mp3', 100, channel = used_channel)
	last_hover_ref = WEAKREF(hovered)

/datum/action/innate/investigate/proc/clear_hovered()
	if(last_hover_ref)
		last_hover_ref = null
		if(COOLDOWN_FINISHED(src, usage_cd))
			owner.playsound_local(get_turf(owner), 'sound/items/sec_hud/inspect_unhighlight.mp3', 100, channel = used_channel)
			owner.playsound_local(get_turf(owner), vol =  200, channel = used_channel, sound_to_use = loop, wait = TRUE)

/datum/action/innate/investigate/do_ability(mob/living/invoker, atom/clicked_on, list/params)
	if(!ishuman(clicked_on) || params?[RIGHT_CLICK])
		unset_ranged_ability(owner)
		return TRUE

	if(!COOLDOWN_FINISHED(src, usage_cd))
		return TRUE

	COOLDOWN_START(src, usage_cd, 2 SECONDS)
	addtimer(VARSET_CALLBACK(src, last_hover_ref, null), 2.5 SECONDS)

	owner.playsound_local(get_turf(owner), 'sound/items/sec_hud/inspect_perform.mp3', 100, channel = used_channel)

	var/mob/living/carbon/human/H = clicked_on
	var/name_to_search = H.get_idcard()?.registered_name

	var/datum/data/record/general_record = SSdatacore.get_record_by_name(name_to_search, DATACORE_RECORDS_STATION)
	var/datum/data/record/security_record = SSdatacore.get_record_by_name(name_to_search, DATACORE_RECORDS_SECURITY)

	scan_record(general_record, security_record)
	return TRUE

/datum/action/innate/investigate/proc/scan_record(datum/data/record/general_record, datum/data/record/security_record, print = TRUE)
	owner.playsound_local(get_turf(owner), 'sound/items/sec_hud/inspect_perform.mp3', 100, channel = used_channel)

	if(hud_obj)
		UnregisterSignal(hud_obj, COMSIG_PARENT_QDELETING)
		hud_obj.fade_out()
		hud_obj = null

	hud_obj = new()
	RegisterSignal(hud_obj, COMSIG_PARENT_QDELETING, PROC_REF(hud_obj_gone))

	var/atom/movable/screen/holder = make_holder(general_record)

	animate(holder, dir = WEST, 0.5 SECONDS, loop = -1)
	animate(dir = NORTH, 0.5 SECONDS)
	animate(dir = EAST, 0.5 SECONDS)
	animate(dir = SOUTH, 0.5 SECONDS)

	hud_obj.add_viscontents(holder)

	var/list/text = list("<span style='text-align:center'>[uppertext(general_record?.fields[DATACORE_NAME]) || "UNKNOWN"]</span>")
	text += "<br><br><br><br><br><br><br>"
	if(!security_record)
		text += "<br><span style='text-align:center'>NO DATA</span>"
	else
		var/wanted_status = security_record.fields[DATACORE_CRIMINAL_STATUS]
		if(wanted_status == CRIMINAL_WANTED)
			wanted_status = "<span style='font-weight:bold'>WANTED</span>"
		else
			wanted_status = uppertext(wanted_status)

		text += "<br><span style='text-align:center'>[wanted_status]</span>"

	owner.play_screen_text(jointext(text, ""), hud_obj)
	if(print)
		print_message(security_record)

/datum/action/innate/investigate/proc/print_message(datum/data/record/security)
	var/list/text = list()
	var/wanted = security?.fields[DATACORE_CRIMINAL_STATUS]
	switch(wanted)
		if(null)
			wanted = "UNKNOWN"
		if(CRIMINAL_WANTED)
			wanted = "WANTED"
		else
			wanted = uppertext(wanted)

	text += "<div class='examine_block' style='text-align:center'>"
	text += "<div style='font-size: 160%'><span class='danger'>[wanted]</span>"
	text += "<hr>"
	if(isnull(security))
		text += "<span class='warning' style='font-size: 120%'>NO DATA</span>"
	else
		text += "<div style='text-shadow: 0 0 0.3em #FF0000'><span class='warning' style='font-style:normal; font-size: 120%'>[security.fields[DATACORE_NAME]]</span></div>"

		if(length(security.fields[DATACORE_CRIMES]))
			text += "<table style='min-width:100%;border: 2px solid rgba(255, 100, 100, 1);border-collapse: collapse;'>"
			for(var/i in 1 to min(4, length(security.fields[DATACORE_CRIMES])))
				var/datum/data/crime/crime = security.fields[DATACORE_CRIMES][i]
				text += {"
					<tr style='border: 2px solid rgba(255, 100, 100, 1)'>
						<td style='vertical-align: middle; border: 2px solid rgba(255, 100, 100, 1); text-align:center; padding: 4px'><span class='warning' style='font-style:normal;style='font-size: 100%'>[crime.crimeName]</span></td>
						<td style='vertical-align: middle; border: 2px solid rgba(255, 100, 100, 1); text-align:center; padding: 4px'><span class='warning' style='font-style:normal;style='font-size: 100%'>[crime.crimeDetails]>/span></td>
					</tr>
				"}
			text += "</table>"
	text += "</div>"

	to_chat(owner, jointext(text, ""))

/datum/action/innate/investigate/proc/make_holder(datum/data/record/general_record)
	var/atom/movable/screen/holder = new()
	if(general_record?.fields[DATACORE_APPEARANCE])
		holder.appearance = new /mutable_appearance(general_record.fields[DATACORE_APPEARANCE])
	else
		holder.icon = 'icons/hud/noimg.dmi'

	holder.vis_flags = VIS_INHERIT_ID | VIS_INHERIT_LAYER | VIS_INHERIT_PLANE
	holder.dir = SOUTH

	holder.makeHologram(rgb(225,125,125, 0.7 * 255))

	holder.transform = holder.transform.Scale(2, 2)
	holder.pixel_y = -16
	holder.pixel_x = -16
	return holder

/datum/action/innate/investigate/proc/hud_obj_gone(atom/movable/source)
	SIGNAL_HANDLER
	hud_obj = null

/// Invoked by a crew member's criminal status changing.
/datum/action/innate/investigate/proc/wanted_fool(datum/source, datum/data/record/R)
	SIGNAL_HANDLER
	if(hud_obj || !owner)
		return

	var/datum/data/record/general_record = SSdatacore.find_record("id", R.fields[DATACORE_ID], DATACORE_RECORDS_STATION)
	UNLINT(scan_record(general_record, R, FALSE)) //IT DOESNT SLEEP STUPID LINTER!!!

	addtimer(CALLBACK(hud_obj, TYPE_PROC_REF(/atom/movable/screen/text/screen_text/atom_hud, fade_out)), 7 SECONDS)

	var/obj/item/target = src.target
	owner.visible_message(
		span_notice("[owner]'s [target.name] emit[copytext_char(target.name, -1) == "s" ? "" : "s"] a quiet click."),
		null,
		span_hear("You hear a quiet click."),
		COMBAT_MESSAGE_RANGE,
	)
