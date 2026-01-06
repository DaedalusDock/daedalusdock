/datum/language/visual
	abstract_type = /datum/language/visual

/datum/language/visual/can_receive_language(atom/movable/hearer, ignore_stat)
	if(!ismob(hearer))
		return TRUE

	var/mob/M = hearer
	return !M.is_blind()

/datum/language/visual/can_speak_language(atom/movable/speaker, silent = TRUE, ignore_mute = FALSE)
	if(!isliving(speaker))
		return TRUE

	var/mob/living/L = speaker

	. = ignore_mute ? TRUE : L.can_speak_sign()

	if(!.)
		if(!silent)
			to_chat(speaker, span_warning("You find yourself unable to speak!"))
		return

/datum/language/visual/hear_speech(mob/living/hearer, atom/movable/speaker, raw_message, radio_freq, list/spans, list/message_mods, atom/sound_loc, message_range)
	if(!istype(hearer))
		return

	if(!isturf(speaker.loc) && hearer.loc != speaker.loc)
		return

	var/dist = get_dist(speaker, hearer) - message_range
	var/is_observer = isobserver(hearer)
	if (message_range != INFINITY && dist > 0 && !is_observer)
		return

	var/avoid_highlight = FALSE
	if(istype(speaker, /atom/movable/virtualspeaker))
		var/atom/movable/virtualspeaker/virt = speaker
		avoid_highlight = hearer == virt.source
	else
		avoid_highlight = hearer == speaker

	var/enable_runechat
	if(ismob(speaker))
		enable_runechat = hearer.client?.prefs.read_preference(/datum/preference/toggle/enable_runechat)
	else
		enable_runechat = hearer.client?.prefs.read_preference(/datum/preference/toggle/enable_runechat_non_mobs)

	var/can_receive_language = can_receive_language(hearer)
	var/translated_message = hearer.translate_speech(speaker, src, raw_message, spans, message_mods)

	// Create map text prior to modifying message for goonchat, sign lang edition
	if(message_mods[MODE_CUSTOM_SAY_ERASE_INPUT] && !hearer.is_blind())
		hearer.create_chat_message(speaker, null, message_mods[MODE_CUSTOM_SAY_EMOTE], spans, EMOTE_MESSAGE, sound_loc = sound_loc)

	else if (enable_runechat && !(hearer.stat == UNCONSCIOUS || !can_receive_language))
		hearer.create_chat_message(speaker, src, translated_message, spans, sound_loc = sound_loc)

	if(!can_receive_language)
		return

	var/parsed_message = hearer.compose_message(speaker, src, translated_message, radio_freq, spans, message_mods)

	to_chat(hearer, parsed_message, avoid_highlighting = avoid_highlight)
	if(LAZYLEN(hearer.observers))
		for(var/mob/dead/observer/O in hearer.observers)
			to_chat(O, parsed_message)

	return translated_message
