/datum/language/visual/sign
	name = "Universal Sign Language"
	desc = "The universally understood sign language format."
	key = "s"
	default_priority = 90
	icon_state = "sign"
	flags = parent_type::flags | (LANGUAGE_SELECTABLE_SPEAK | LANGUAGE_SELECTABLE_UNDERSTAND | LANGUAGE_OVERRIDE_SAY_MOD)

/datum/language/visual/sign/speech_not_understood(atom/movable/source, raw_message, spans, list/message_mods, quote)
	spans |= "italics"
	spans |= "emote"
	message_mods[MODE_NO_QUOTE] = TRUE
	return span_emote("makes weird gestures with [source.p_their()] hands.")

/datum/language/visual/sign/speech_understood(atom/movable/source, raw_message, spans, list/message_mods, quote)
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

/datum/language/visual/sign/before_speaking(atom/movable/speaker, message)
	if(!iscarbon(speaker))
		return message

	var/mob/living/carbon/mute = speaker
	switch(mute.check_signables_state())
		if(SIGN_ONE_HAND, SIGN_CUFFED) // One arm
			return stars(message)

		if(SIGN_HANDS_FULL) // Full hands
			to_chat(mute, span_warning("Your hands are full."))
			return

		if(SIGN_ARMLESS) // No arms
			to_chat(mute, span_warning("You can't sign with no hands."))
			return

		if(SIGN_TRAIT_BLOCKED) // Hands Blocked or Emote Mute traits
			to_chat(mute, span_warning("You can't sign at the moment."))
			return

		else
			return message

/datum/language/visual/sign/get_say_mod(mob/living/speaker)
	var/signs = pick("signs", "gestures")

	// Any subtype of slurring in our status effects make us "slur"
	if(speaker.has_status_effect(/datum/status_effect/speech/slurring))
		return "loosely [signs]"

	else if(speaker.has_status_effect(/datum/status_effect/speech/stutter))
		. = "shakily [signs]"

	else if(speaker.has_status_effect(/datum/status_effect/speech/stutter/derpspeech))
		. = "incoherently [signs]"

	else
		if(speaker.combat_mode)
			return "aggressively [signs] with their hands"
		else
			return "[signs] with their hands"
