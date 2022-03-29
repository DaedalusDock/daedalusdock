///////////////// SUBTLE 3: NO GHOST TETRALOO

/datum/emote/living/subtler
	key = "subtler"
	key_third_person = "subtler"
	message = null
	mob_type_blacklist_typecache = list(/mob/living/brain)


/datum/emote/living/subtler/proc/check_invalid(mob/user, input)
	/* TO DO
	if(stop_bad_mime.Find(input, 1, 1))
		to_chat(user, "<span class='danger'>Invalid emote.</span>")
		return TRUE
	*/
	return FALSE

/datum/emote/living/subtler/run_emote(mob/user, params, type_override = null)
	var/subtler_message
	var/subtler_emote = params
	if(SSdbcore.Connect())
		if(is_banned_from(user, "emote"))
			to_chat(user, "You cannot send subtle emotes (banned).")
			return FALSE
	else if(user.client && user.client.prefs.muted & MUTE_IC)
		to_chat(user, "You cannot send IC messages (muted).")
		return FALSE
	else if(!params)
		subtler_emote = stripped_multiline_input(user, "Choose an emote to display.", "Subtler" , null, MAX_MESSAGE_LEN)
		if(subtler_emote && !check_invalid(user, subtler_emote))
			var/type = input("Is this a visible or hearable emote?") as null|anything in list("Visible", "Hearable")
			switch(type)
				if("Visible")
					emote_type = EMOTE_VISIBLE
				if("Hearable")
					emote_type = EMOTE_AUDIBLE
				else
					alert("Unable to use this emote, must be either hearable or visible.")
					return
			subtler_message = subtler_emote
		else
			return FALSE
	else
		subtler_message = params
		if(type_override)
			emote_type = type_override
	. = TRUE
	if(!can_run_emote(user))
		return FALSE

	user.log_message(subtler_message, LOG_SUBTLER)

	var/space = should_have_space_before_emote(html_decode(subtler_emote)[1]) ? " " : ""

	subtler_message = span_emote("<b>[user]</b>[space]<i>[user.say_emphasis(subtler_message)]</i>")

	if(emote_type == EMOTE_AUDIBLE)
		user.audible_message_subtler(message = subtler_message, hearing_distance = 1, ignored_mobs = GLOB.dead_mob_list, separation = space)
	else
		user.visible_message(message = subtler_message, self_message = subtler_message, vision_distance = 1, ignored_mobs = GLOB.dead_mob_list, separation = space)
///////////////// VERB CODE
/mob/living/proc/subtle_keybind()
	var/message = input(src, "", "subtle") as text|null
	if(!length(message))
		return
	return subtler(message)

///////////////// VERB CODE 2
/mob/living/verb/subtler()
	set name = "Subtle"
	set category = "IC"
	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return
	usr.emote("subtler")

//This is bad code.
/atom/proc/audible_message_subtler(message, deaf_message, hearing_distance = DEFAULT_MESSAGE_RANGE, list/ignored_mobs, self_message, audible_message_flags = NONE, separation = " ")
	var/list/hearers = get_hearers_in_view(hearing_distance, src)
	if(self_message)
		hearers -= src
	hearers -= ignored_mobs
	var/raw_msg = message
	if(audible_message_flags & EMOTE_MESSAGE)
		message = "<b>[src]</b>[separation][message]"
	for(var/mob/listener in hearers)
		if(audible_message_flags & EMOTE_MESSAGE && runechat_prefs_check(listener, audible_message_flags) && listener.can_hear())
			listener.create_chat_message(src, raw_message = raw_msg, runechat_flags = audible_message_flags)
		listener.show_message(message, MSG_AUDIBLE, deaf_message, MSG_VISUAL)
