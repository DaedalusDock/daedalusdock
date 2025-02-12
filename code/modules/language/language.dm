#define SCRAMBLE_CACHE_LEN 50 //maximum of 50 specific scrambled lines per language

/*
	Datum based languages. Easily editable and modular.
*/

/datum/language
	var/name = "an unknown language"  // Fluff name of language if any.
	var/desc = "A language."          // Short description for 'Check Languages'.
	var/key                           // Character used to speak in language
	// If key is null, then the language isn't real or learnable.
	var/flags = NONE // Various language flags.
	var/list/syllables                // Used when scrambling text for a non-speaker.
	var/sentence_chance = 5      // Likelihood of making a new sentence after each syllable.
	var/space_chance = 55        // Likelihood of getting a space in the random scramble string
	var/list/spans = list()
	var/list/scramble_cache = list()
	var/default_priority = 0          // the language that an atom knows with the highest "default_priority" is selected by default.

	// if you are seeing someone speak popcorn language, then something is wrong.
	var/icon = 'icons/misc/language.dmi'
	var/icon_state = "popcorn"

/datum/language/proc/display_icon(atom/movable/hearer)
	var/understands = hearer.has_language(src.type)
	if((flags & LANGUAGE_HIDE_ICON_IF_UNDERSTOOD) && understands)
		return FALSE
	if((flags & LANGUAGE_HIDE_ICON_IF_NOT_UNDERSTOOD) && !understands)
		return FALSE
	return TRUE

/datum/language/proc/get_icon()
	var/datum/asset/spritesheet/sheet = get_asset_datum(/datum/asset/spritesheet/chat)
	return sheet.icon_tag("language-[icon_state]")

/// Called by /atom/proc/say_mod if LANGUAGE_OVERRIDE_SAY_MOD is present.
/datum/language/proc/get_say_mod(mob/living/speaker)
	return

/datum/language/proc/get_random_name(gender, name_count=2, syllable_count=4, syllable_divisor=2)
	if(!syllables || !syllables.len)
		if(gender==FEMALE)
			return capitalize(pick(GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))
		else
			return capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))

	var/full_name = ""
	var/new_name = ""

	for(var/i in 0 to name_count)
		new_name = ""
		var/Y = rand(FLOOR(syllable_count/syllable_divisor, 1), syllable_count)
		for(var/x in Y to 0)
			new_name += pick(syllables)
		full_name += " [capitalize(lowertext(new_name))]"

	return "[trim(full_name)]"

/datum/language/proc/check_cache(input)
	var/lookup = scramble_cache[input]
	if(lookup)
		scramble_cache -= input
		scramble_cache[input] = lookup
	. = lookup

/datum/language/proc/add_to_cache(input, scrambled_text)
	// Add it to cache, cutting old entries if the list is too long
	scramble_cache[input] = scrambled_text
	if(scramble_cache.len > SCRAMBLE_CACHE_LEN)
		scramble_cache.Cut(1, scramble_cache.len-SCRAMBLE_CACHE_LEN-1)

/datum/language/proc/before_speaking(atom/movable/speaker, message)
	return message

/// Called by process_received_message() when the hearer does not understand the language.
/datum/language/proc/speech_not_understood(atom/movable/source, raw_message, spans, list/message_mods, quote)
	raw_message = scramble(raw_message)
	return !quote ? raw_message : source.say_quote(raw_message, spans, message_mods, src)

/// Called by process_received_message() when the hearer does understand the language.
/datum/language/proc/speech_understood(atom/movable/source, raw_message, spans, list/message_mods, quote)
	return !quote ? raw_message : source.say_quote(raw_message, spans, message_mods, src)

/datum/language/proc/scramble(input)
	if(!syllables || !syllables.len)
		return stars(input)

	// If the input is cached already, move it to the end of the cache and return it
	var/lookup = check_cache(input)
	if(lookup)
		return lookup

	var/input_size = length_char(input)
	var/scrambled_text = ""
	var/capitalize = TRUE

	while(length_char(scrambled_text) < input_size)
		var/next = pick(syllables)
		if(capitalize)
			next = capitalize(next)
			capitalize = FALSE
		scrambled_text += next
		var/chance = rand(100)
		if(chance <= sentence_chance)
			scrambled_text += ". "
			capitalize = TRUE
		else if(chance > sentence_chance && chance <= space_chance)
			scrambled_text += " "

	scrambled_text = trim(scrambled_text)
	var/ending = copytext_char(scrambled_text, -1)
	if(ending == ".")
		scrambled_text = copytext_char(scrambled_text, 1, -2)
	var/input_ending = copytext_char(input, -1)
	if(input_ending in list("!","?","."))
		scrambled_text += input_ending

	add_to_cache(input, scrambled_text)

	return scrambled_text

#undef SCRAMBLE_CACHE_LEN

/// Returns TRUE if the movable can speak the language. This does not check it knows the language.
/datum/language/proc/can_speak_language(atom/movable/speaker, silent = TRUE, ignore_mute = FALSE)
	if(!isliving(speaker))
		return TRUE

	var/mob/living/L = speaker
	. = ignore_mute ? TRUE : L.can_speak_vocal()
	if(!.)
		if(!silent)
			to_chat(speaker, span_warning("You find yourself unable to speak!"))
		return

	if(!ishuman(speaker))
		return TRUE

	var/mob/living/carbon/human/H = speaker
	if(H.mind?.miming)
		if(!silent)
			to_chat(speaker, span_green("Your vow of silence prevents you from speaking!"))
		return FALSE

	var/obj/item/organ/tongue/T = H.getorganslot(ORGAN_SLOT_TONGUE)
	if(T)
		. = T.can_physically_speak_language(type)
		if(!. && !silent)
			to_chat(speaker, span_warning("You do not have the biology required to speak that language!"))
		return .

	return (flags & TONGUELESS_SPEECH)

/// Returns TRUE if the movable can even "see" or "hear" the language. This does not check it knows the language.
/datum/language/proc/can_receive_language(atom/movable/hearer, ignore_stat)
	if(ismob(hearer))
		var/mob/M = hearer
		return M.can_hear(ignore_stat)
	return TRUE

/// Called by Hear() to process a language and display it to the hearer. Returns NULL if cannot hear, otherwise returns the translated raw_message.
/datum/language/proc/hear_speech(mob/living/hearer, atom/movable/speaker, raw_message, radio_freq, list/spans, list/message_mods, atom/sound_loc, message_range)
	if(!istype(hearer))
		return

	// if someone is whispering we make an extra type of message that is obfuscated for people out of range
	// Less than or equal to 0 means normal hearing. More than 0 and less than or equal to EAVESDROP_EXTRA_RANGE means
	// partial hearing. More than EAVESDROP_EXTRA_RANGE means no hearing. Exception for GOOD_HEARING trait
	var/dist = get_dist(speaker, hearer) - message_range
	var/is_observer = isobserver(hearer)
	var/mangle_message = FALSE
	if (message_range != INFINITY && dist > EAVESDROP_EXTRA_RANGE && !HAS_TRAIT(hearer, TRAIT_GOOD_HEARING) && !is_observer)
		return // Too far away and don't have good hearing, you can't hear anything

	if(dist > 0 && dist <= EAVESDROP_EXTRA_RANGE && !HAS_TRAIT(hearer, TRAIT_GOOD_HEARING) && !is_observer) // ghosts can hear all messages clearly
		mangle_message = TRUE

	if(hearer.stat == UNCONSCIOUS && can_receive_language(hearer, ignore_stat = TRUE))
		var/sleep_message = hearer.translate_speech(speaker, src, raw_message)
		if(mangle_message)
			sleep_message = stars(sleep_message)
		hearer.hear_sleeping(sleep_message)
		return

	var/avoid_highlight = FALSE
	if(istype(speaker, /atom/movable/virtualspeaker))
		var/atom/movable/virtualspeaker/virt = speaker
		avoid_highlight = hearer == virt.source
	else
		avoid_highlight = hearer == speaker

	var/deaf_message
	var/deaf_type
	if(speaker != hearer)
		if(!radio_freq) //These checks have to be separate, else people talking on the radio will make "You can't hear yourself!" appear when hearing people over the radio while deaf.
			deaf_message = "[span_name("[speaker]")] [speaker.verb_say] something but you cannot hear [speaker.p_them()]."
			deaf_type = MSG_VISUAL
	else
		deaf_message = span_notice("You can't hear yourself!")
		deaf_type = MSG_AUDIBLE // Since you should be able to hear yourself without looking

	var/enable_runechat = FALSE
	if(ismob(speaker))
		enable_runechat = hearer.client?.prefs.read_preference(/datum/preference/toggle/enable_runechat)
	else
		enable_runechat = hearer.client?.prefs.read_preference(/datum/preference/toggle/enable_runechat_non_mobs)

	var/can_receive_language = can_receive_language(hearer)
	var/translated_message = hearer.translate_speech(speaker, src, raw_message, spans, message_mods)
	if(mangle_message)
		translated_message = stars(translated_message)

	// Create map text prior to modifying message for goonchat
	if (enable_runechat && !(hearer.stat == UNCONSCIOUS) && can_receive_language)
		if (message_mods[MODE_CUSTOM_SAY_ERASE_INPUT])
			hearer.create_chat_message(speaker, null, message_mods[MODE_CUSTOM_SAY_EMOTE], spans, EMOTE_MESSAGE, sound_loc = sound_loc)
		else
			hearer.create_chat_message(speaker, src, translated_message, spans, sound_loc = sound_loc)

	// Recompose message for AI hrefs, language incomprehension.
	var/parsed_message = hearer.compose_message(speaker, src, translated_message, radio_freq, spans, message_mods)

	var/shown = hearer.show_message(parsed_message, MSG_AUDIBLE, deaf_message, deaf_type, avoid_highlight)
	if(LAZYLEN(hearer.observers))
		for(var/mob/dead/observer/O in hearer.observers)
			to_chat(O, shown)

	return translated_message
