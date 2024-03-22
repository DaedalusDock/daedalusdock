/datum/language/visual/sign
	name = "Universal Sign Language"
	desc = "The universally understood sign language format."
	key = "s"
	default_priority = 90
	spans = list("emote")
	icon_state = "sign"
	flags = parent_type::flags | (LANGUAGE_SELECTABLE_SPEAK | LANGUAGE_SELECTABLE_UNDERSTAND)

/datum/language/visual/sign/speech_not_understood(atom/movable/source, raw_message, spans, list/message_mods, no_quote)
	spans |= "italics"
	return span_emote("makes weird gestures with [source.p_their()] hands.")

/datum/language/visual/sign/speech_understood(atom/movable/source, raw_message, spans, list/message_mods, no_quote)
	var/static/regex/remove_tone = regex("\[?!\]", "g")
	// Replace all tonal indicators with periods.
	raw_message = remove_tone.Replace(raw_message, ".")

	// Strip out extra ending punctuation
	while(length(raw_message) > 1 && raw_message[length(raw_message)] == ".")
		if(length(raw_message) == 1 || raw_message[length(raw_message) - 1] != ".")
			break

		raw_message = copytext(raw_message, 1, length(raw_message))

	// Remove capital letters except the first.
	raw_message = capitalize(lowertext(raw_message))
	return ..()
