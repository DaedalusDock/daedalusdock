/datum/emote/dead
	stat_allowed = DEAD
	mob_type_allowed_typecache = /mob/dead

/datum/emote/dead/run_emote(mob/user, params, type_override, intentional)
	. = TRUE
	if(!can_run_emote(user, TRUE, intentional))
		return FALSE
	var/msg = select_message_type(user, message, intentional)
	if(params && message_param)
		msg = select_param(user, params)

	msg = replace_pronoun(user, msg)

	if(!msg)
		return

	user.log_message(msg, LOG_EMOTE)

	var/space = should_have_space_before_emote(html_decode(msg)[1]) ? " " : ""
	var/dchatmsg = "<b>[user]</b>[space][msg]"
	var/livingmsg = "<b>The Spirit</b>[space][msg]"
	var/tmp_sound = get_sound(user, intentional)

	if(tmp_sound && should_play_sound(user, intentional) && !TIMER_COOLDOWN_CHECK(user, type))
		TIMER_COOLDOWN_START(user, type, audio_cooldown)
		playsound(user, tmp_sound, 50, vary, frequency = get_frequency(user))

	// Send chat message to all dead mobs.
	if (user.client)
		for(var/mob/ghost as anything in GLOB.dead_mob_list) // These lists should never overlap.
			if(!ghost.client || isnewplayer(ghost))
				continue
			ghost.show_message("[isobserver(ghost) ? FOLLOW_LINK(ghost, user) : ""]<span class='emote'>[dchatmsg]</span>")

	// Send chat message to theatre goers
	if(isghost(user))
		for(var/mob/visitor as anything in GLOB.ghost_theatre_visitors)
			to_chat(visitor, "<span class='emote'>[livingmsg]</span>")

	// Send runechat to nearby mobs and visitors
	var/list/runechat_targets = viewers(user)
	if(isghost(user))
		runechat_targets += GLOB.ghost_theatre_visitors

	for(var/mob/viewer in runechat_targets)
		if(!viewer.client || isnewplayer(viewer))
			continue

		viewer.create_chat_message(user, raw_message = msg, runechat_flags = EMOTE_MESSAGE)

	SEND_SIGNAL(user, COMSIG_MOB_EMOTED(key))
	return TRUE

/datum/emote/dead/custom
	key = "me"
	key_third_person = "custom"
	message = null

/datum/emote/dead/custom/can_run_emote(mob/user, status_check, intentional)
	. = ..() && intentional

/datum/emote/dead/custom/proc/check_invalid(mob/user, input)
	var/static/regex/stop_bad_mime = regex(@"says|exclaims|yells|asks")
	if(stop_bad_mime.Find(input, 1, 1))
		to_chat(user, span_danger("Invalid emote."))
		return TRUE
	return FALSE

/datum/emote/dead/custom/run_emote(mob/user, params, type_override = null, intentional = FALSE)
	var/custom_emote
	if(!can_run_emote(user, TRUE, intentional))
		return FALSE

	if(is_banned_from(user.ckey, "Emote"))
		to_chat(user, span_boldwarning("You cannot send custom emotes (banned)."))
		return FALSE

	else if(QDELETED(user))
		return FALSE

	else if(user.client && user.client.prefs.muted & MUTE_IC)
		to_chat(user, span_boldwarning("You cannot send IC messages (muted)."))
		return FALSE

	else if(!params)
		custom_emote = copytext(sanitize(input("Choose an emote to display.") as text|null), 1, MAX_MESSAGE_LEN)
	else
		custom_emote = params

	message = custom_emote
	. = ..()
	message = null

