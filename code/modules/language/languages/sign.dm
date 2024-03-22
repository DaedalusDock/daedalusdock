/datum/language/visual/sign
	name = "Universal Sign Language"
	desc = "The universally understood sign language format."
	key = "-"
	default_priority = 90
	spans = list("emote")
	icon_state = "sign"

/datum/language/visual/sign/speech_not_understood(atom/movable/source, raw_message, spans, list/message_mods, no_quote)
	spans |= "italics"
	return span_emote("makes weird gestures with [source.p_their()] hands.")
