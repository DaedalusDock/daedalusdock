/datum/language/visual
	abstract_type = /datum/language/visual

/datum/language/visual/can_receive_language(atom/movable/hearer)
	if(!ismob(hearer))
		return TRUE

	var/mob/M = hearer
	return !M.is_blind()

/datum/language/visual/can_speak_language(atom/movable/speaker, silent = TRUE)
	if(!isliving(speaker))
		return TRUE

	var/mob/living/L = speaker

	. = L.can_speak_sign()

	if(!.)
		if(!silent)
			to_chat(speaker, span_warning("You find yourself unable to speak!"))
		return

/datum/language/visual/hear_speech(mob/living/hearer, atom/movable/speaker, raw_message, radio_freq, list/spans, list/message_mods, atom/sound_loc)
	if(!istype(hearer))
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

	// Create map text prior to modifying message for goonchat, sign lang edition
	if (enable_runechat && !(hearer.stat == UNCONSCIOUS || !can_receive_language))
		hearer.create_chat_message(speaker, src, raw_message, spans, sound_loc = sound_loc)

	if(!can_receive_language)
		return

	var/parsed_message = hearer.compose_message(speaker, src, raw_message, radio_freq, spans, message_mods)

	to_chat(hearer, parsed_message, avoid_highlighting = avoid_highlight)
	return parsed_message
