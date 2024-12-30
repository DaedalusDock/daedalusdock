/mob/living/carbon/proc/handle_tongueless_speech(mob/living/carbon/speaker, list/speech_args)
	SIGNAL_HANDLER

	var/message = speech_args[SPEECH_MESSAGE]
	var/static/regex/tongueless_lower = new("\[gdntke]+", "g")
	var/static/regex/tongueless_upper = new("\[GDNTKE]+", "g")
	if(message[1] != "*")
		message = tongueless_lower.Replace(message, pick("aa","oo","'"))
		message = tongueless_upper.Replace(message, pick("AA","OO","'"))
		speech_args[SPEECH_MESSAGE] = message

/mob/living/carbon/can_speak_vocal(message)
	if(silent)
		return FALSE

	if(HAS_TRAIT(src, TRAIT_EXHAUSTED))
		return FALSE

	return ..()

/mob/living/carbon/can_speak_sign()
	return usable_hands > 0

/mob/living/carbon/get_message_mods(message, list/mods)
	. = ..()
	if(CHEM_EFFECT_MAGNITUDE(src, CE_VOICELOSS) && !mods[WHISPER_MODE])
		mods[WHISPER_MODE] = MODE_WHISPER
