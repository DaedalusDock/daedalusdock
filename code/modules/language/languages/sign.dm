/datum/language/visual/sign
	name = "Universal Sign Language"
	desc = "The universally understood sign language format."
	key = "-"
	default_priority = 90

	icon_state = "galcom"

/datum/language/visual/sign/speech_not_understood(atom/movable/source, raw_message, spans, list/message_mods, no_quote)
	return "makes weird gestures with [source.p_their()] hands."
