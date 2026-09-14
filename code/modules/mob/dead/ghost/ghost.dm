/// All mobs whose minds are currently in the Theatre
GLOBAL_LIST_EMPTY(ghost_theatre_visitors)

/mob/dead/ghost
	name = "Ghost"

	sight = NONE
	simulated = FALSE
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE

	hud_type = /datum/hud/ghost

	movement_delay = 4

	/// Prefixed adjective to the ghost's name
	var/ghost_adjective = ""
	/// name = "[ghost_adjective] [ghost_term] of [real_name]"
	var/ghost_term = ""

/mob/dead/ghost/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/footstep, FOOTSTEP_MOB_SHOE, 1, -6, TRUE)
	add_client_colour(/datum/client_colour/ghostmono)

/mob/dead/ghost/proc/from_corpse(mob/corpse)
	ghost_term = pick(GLOB.ghost_synonyms)
	ghost_adjective = pick(GLOB.fresh_ghost_adjectives)

	if(ismob(corpse))
		mind = corpse.mind //we don't transfer the mind but we keep a reference to it.
		set_suicide(corpse.suiciding) // Transfer whether they committed suicide.

		gender = corpse.gender
		died_as_name = corpse.died_as_name
		set_ghost_appearance(corpse)
		set_real_name(get_name_from_corpse(corpse))

/mob/dead/ghost/Move(atom/newloc, direct, glide_size_override, z_movement_flags)
	// Requires this hacky copy-pasting from client/Move() to get gliding to behave.
	//We are now going to move
	var/old_move_delay
	var/add_delay
	var/new_glide_size
	if(client)
		old_move_delay = client?.move_delay
		add_delay = movement_delay
		new_glide_size = DELAY_TO_GLIDE_SIZE(add_delay * ( (NSCOMPONENT(direct) && EWCOMPONENT(direct)) ? DIAGONAL_MOVEMENT_MULTIPLIER : 1 ) )

		set_glide_size(new_glide_size) // set it now in case of pulled objects
		if(old_move_delay + world.tick_lag > world.time)
			client.move_delay = old_move_delay
		else
			client.move_delay = world.time

		client.visual_delay = 0

	. = ..()
	if(client)
		if((direct & (direct - 1)) && loc == newloc) //moved diagonally successfully
			add_delay *= DIAGONAL_MOVEMENT_MULTIPLIER

		var/after_glide = 0
		if(client.visual_delay)
			after_glide = client.visual_delay
		else
			after_glide = DELAY_TO_GLIDE_SIZE(add_delay)

		set_glide_size(after_glide)

		client.move_delay += add_delay

/mob/dead/ghost/update_name(updates)
	. = ..()
	deadchat_name = name

/mob/dead/ghost/get_visible_name()
	return "[ghost_adjective] [ghost_term] of [real_name]"

/mob/dead/ghost/canUseTopic(atom/movable/target, flags)
	return FALSE

/mob/dead/ghost/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null, filterproof = null, range = 7)
	message = trim(message) //trim now and sanitize after checking for special admin radio keys

	var/list/filter_result = CAN_BYPASS_FILTER(src) ? null : is_ooc_filtered(message)
	if (filter_result)
		REPORT_CHAT_FILTER_TO_USER(usr, filter_result)
		log_filter("OOC", message, filter_result)
		return

	var/list/soft_filter_result = CAN_BYPASS_FILTER(src) ? null : is_soft_ooc_filtered(message)
	if (soft_filter_result)
		if(tgui_alert(usr,"Your message contains \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\". \"[soft_filter_result[CHAT_FILTER_INDEX_REASON]]\", Are you sure you want to say it?", "Soft Blocked Word", list("Yes", "No")) != "Yes")
			return
		message_admins("[ADMIN_LOOKUPFLW(usr)] has passed the soft filter for \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" they may be using a disallowed term. Message: \"[message]\"")
		log_admin_private("[key_name(usr)] has passed the soft filter for \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" they may be using a disallowed term. Message: \"[message]\"")

	if(!message)
		return
	var/list/message_mods = list()
	message = get_message_mods(message, message_mods)
	if(client?.holder && (message_mods[RADIO_EXTENSION] == MODE_ADMIN || message_mods[RADIO_EXTENSION] == MODE_DEADMIN || (message_mods[RADIO_EXTENSION] == MODE_PUPPET && mind?.current)))
		message = trim_left(copytext_char(message, length(message_mods[RADIO_KEY]) + 2))
		switch(message_mods[RADIO_EXTENSION])
			if(MODE_ADMIN)
				client.cmd_admin_say(message)
			if(MODE_DEADMIN)
				client.dsay(message)
			if(MODE_PUPPET)
				if(!mind.current.say(message))
					to_chat(src, span_warning("Your linked body was unable to speak!"))
		return

	message = copytext_char(sanitize(message), 1, MAX_MESSAGE_LEN)
	if(message[1] == "*" && check_emote(message, forced))
		return

	. = say_dead(message)
