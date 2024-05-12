GLOBAL_LIST_INIT(department_radio_prefixes, list(":", "."))

GLOBAL_LIST_INIT(department_radio_keys, list(
	// Location
	MODE_KEY_R_HAND = MODE_R_HAND,
	MODE_KEY_L_HAND = MODE_L_HAND,
	MODE_KEY_INTERCOM = MODE_INTERCOM,

	// Department
	MODE_KEY_DEPARTMENT = MODE_DEPARTMENT,
	RADIO_KEY_COMMAND = RADIO_CHANNEL_COMMAND,
	RADIO_KEY_SCIENCE = RADIO_CHANNEL_SCIENCE,
	RADIO_KEY_MEDICAL = RADIO_CHANNEL_MEDICAL,
	RADIO_KEY_ENGINEERING = RADIO_CHANNEL_ENGINEERING,
	RADIO_KEY_SECURITY = RADIO_CHANNEL_SECURITY,
	RADIO_KEY_SUPPLY = RADIO_CHANNEL_SUPPLY,
	RADIO_KEY_SERVICE = RADIO_CHANNEL_SERVICE,

	// Faction
	RADIO_KEY_SYNDICATE = RADIO_CHANNEL_SYNDICATE,
	RADIO_KEY_CENTCOM = RADIO_CHANNEL_CENTCOM,

	// Admin
	MODE_KEY_ADMIN = MODE_ADMIN,
	MODE_KEY_DEADMIN = MODE_DEADMIN,
	MODE_KEY_PUPPET = MODE_PUPPET,

	// Misc
	RADIO_KEY_AI_PRIVATE = RADIO_CHANNEL_AI_PRIVATE, // AI Upload channel


	//kinda localization -- rastaf0
	//same keys as above, but on russian keyboard layout.
	// Location
	"к" = MODE_R_HAND,
	"л" = MODE_L_HAND,
	"ш" = MODE_INTERCOM,

	// Department
	"р" = MODE_DEPARTMENT,
	"с" = RADIO_CHANNEL_COMMAND,
	"т" = RADIO_CHANNEL_SCIENCE,
	"ь" = RADIO_CHANNEL_MEDICAL,
	"у" = RADIO_CHANNEL_ENGINEERING,
	"ы" = RADIO_CHANNEL_SECURITY,
	"г" = RADIO_CHANNEL_SUPPLY,
	"м" = RADIO_CHANNEL_SERVICE,

	// Faction
	"е" = RADIO_CHANNEL_SYNDICATE,
	"н" = RADIO_CHANNEL_CENTCOM,

	// Admin
	"з" = MODE_ADMIN,
	"в" = MODE_KEY_DEADMIN,

	// Misc
	"щ" = RADIO_CHANNEL_AI_PRIVATE
))

/**
 * Whitelist of saymodes or radio extensions that can be spoken through even if not fully conscious.
 * Associated values are their maximum allowed mob stats.
 */
GLOBAL_LIST_INIT(message_modes_stat_limits, list(
	MODE_INTERCOM = UNCONSCIOUS,
	MODE_ALIEN = UNCONSCIOUS,
	MODE_BINARY = UNCONSCIOUS, //extra stat check on human/binarycheck()
	MODE_MONKEY = UNCONSCIOUS,
	MODE_MAFIA = UNCONSCIOUS
))

/mob/living/proc/Ellipsis(original_msg, chance = 50, keep_words)
	if(chance <= 0)
		return "..."
	if(chance >= 100)
		return original_msg

	var/list/words = splittext(original_msg," ")
	var/list/new_words = list()

	var/new_msg = ""

	for(var/w in words)
		if(prob(chance))
			new_words += "..."
			if(!keep_words)
				continue
		new_words += w

	new_msg = jointext(new_words," ")

	return new_msg

/mob/living/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null, filterproof = null, range = 7)
	language = GET_LANGUAGE_DATUM(language)

	var/list/filter_result
	var/list/soft_filter_result
	if(client && !forced && !filterproof)
		//The filter doesn't act on the sanitized message, but the raw message.
		filter_result = CAN_BYPASS_FILTER(src) ? null : is_ic_filtered(message)
		if(!filter_result)
			soft_filter_result = CAN_BYPASS_FILTER(src) ? null : is_soft_ic_filtered(message)

	if(sanitize)
		message = trim(copytext_char(sanitize(message), 1, MAX_MESSAGE_LEN))

	if(!message || message == "")
		return

	if(filter_result  && !filterproof)
		//The filter warning message shows the sanitized message though.
		to_chat(src, span_warning("That message contained a word prohibited in IC chat! Consider reviewing the server rules."))
		to_chat(src, span_warning("\"[message]\""))
		REPORT_CHAT_FILTER_TO_USER(src, filter_result)
		log_filter("IC", message, filter_result)
		SSblackbox.record_feedback("tally", "ic_blocked_words", 1, lowertext(config.ic_filter_regex.match))
		return

	if(soft_filter_result && !filterproof)
		if(tgui_alert(usr,"Your message contains \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\". \"[soft_filter_result[CHAT_FILTER_INDEX_REASON]]\", Are you sure you want to say it?", "Soft Blocked Word", list("Yes", "No")) != "Yes")
			SSblackbox.record_feedback("tally", "soft_ic_blocked_words", 1, lowertext(config.soft_ic_filter_regex.match))
			log_filter("Soft IC", message, filter_result)
			return
		message_admins("[ADMIN_LOOKUPFLW(usr)] has passed the soft filter for \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" they may be using a disallowed term. Message: \"[message]\"")
		log_admin_private("[key_name(usr)] has passed the soft filter for \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" they may be using a disallowed term. Message: \"[message]\"")
		SSblackbox.record_feedback("tally", "passed_soft_ic_blocked_words", 1, lowertext(config.soft_ic_filter_regex.match))
		log_filter("Soft IC (Passed)", message, filter_result)

	var/list/message_mods = list()
	var/original_message = message
	message = get_message_mods(message, message_mods)

	var/datum/saymode/saymode = SSpackets.saymodes[message_mods[RADIO_KEY]]
	if (!forced && !saymode)
		message = check_for_custom_say_emote(message, message_mods)

	if(!message)
		return

	if(message_mods[RADIO_EXTENSION] == MODE_ADMIN)
		client?.cmd_admin_say(message)
		return

	if(message_mods[RADIO_EXTENSION] == MODE_DEADMIN)
		client?.dsay(message)
		return

	// dead is the only state you can never emote
	if(stat != DEAD && check_emote(original_message, forced))
		return

	language = message_mods[LANGUAGE_EXTENSION]

	if(!language)
		language = get_selected_language()

	if(language && !language.can_speak_language(src, FALSE))
		return

	if(!can_speak_basic(original_message, ignore_spam, forced))
		return

	var/is_visual_language = istype(language, /datum/language/visual)

	if(is_visual_language)
		message_mods -= WHISPER_MODE

	// Checks if the saymode or channel extension can be used even if not totally conscious.
	if(!is_visual_language)
		var/say_radio_or_mode = saymode || message_mods[RADIO_EXTENSION]
		if(say_radio_or_mode)
			var/mob_stat_limit = GLOB.message_modes_stat_limits[say_radio_or_mode]
			if(stat > (isnull(mob_stat_limit) ? CONSCIOUS : mob_stat_limit))
				saymode = null
				message_mods -= RADIO_EXTENSION

		if(message_mods[RADIO_KEY] || message_mods[MODE_HEADSET])
			SEND_SIGNAL(src, COMSIG_LIVING_USE_RADIO)

	switch(stat)
		if(CONSCIOUS)
			if(!is_visual_language && HAS_TRAIT(src, TRAIT_SOFT_CRITICAL_CONDITION))
				message_mods[WHISPER_MODE] = MODE_WHISPER

		if(UNCONSCIOUS)
			return

		if(DEAD)
			say_dead(original_message)
			return

	if(client && SSlag_switch.measures[SLOWMODE_SAY] && !HAS_TRAIT(src, TRAIT_BYPASS_MEASURES) && !forced && src == usr)
		if(!COOLDOWN_FINISHED(client, say_slowmode))
			to_chat(src, span_warning("Message not sent due to slowmode. Please wait [SSlag_switch.slowmode_cooldown/10] seconds between messages.\n\"[message]\""))
			return

		COOLDOWN_START(client, say_slowmode, SSlag_switch.slowmode_cooldown)

	// If there's a custom say emote it gets logged differently.
	if(message_mods[MODE_CUSTOM_SAY_EMOTE])
		log_message(message_mods[MODE_CUSTOM_SAY_EMOTE], LOG_RADIO_EMOTE)

	// If it's not erasing the input portion, then something is being said and this isn't a pure custom say emote.
	if(!message_mods[MODE_CUSTOM_SAY_ERASE_INPUT])
		if(message_mods[WHISPER_MODE] == MODE_WHISPER)
			range = 1
			log_talk(message, LOG_WHISPER, forced_by = forced, custom_say_emote = message_mods[MODE_CUSTOM_SAY_EMOTE])
		else
			log_talk(message, LOG_SAY, forced_by = forced, custom_say_emote = message_mods[MODE_CUSTOM_SAY_EMOTE])

	message = treat_message(message) // unfortunately we still need this

	spans |= speech_span

	if(language)
		spans |= language.spans

	if(message_mods[MODE_SING])
		var/randomnote = pick("\u2669", "\u266A", "\u266B")
		message = "[randomnote] [message] [randomnote]"
		spans |= SPAN_SINGING

	#ifdef UNIT_TESTS
	// Saves a ref() to our arglist specifically.
	// We do this because we need to check that COMSIG_MOB_SAY is getting EXACTLY this list.
	last_say_args_ref = REF(args)
	#endif

	// Leaving this here so that anything that handles speech this way will be able to have spans affecting it and all that.
	var/sigreturn = SEND_SIGNAL(src, COMSIG_MOB_SAY, args)
	if (sigreturn & COMPONENT_UPPERCASE_SPEECH)
		message = uppertext(message)

	if(!message)
		return

	//This is before anything that sends say a radio message, and after all important message type modifications, so you can scumb in alien chat or something
	if(saymode && !saymode.handle_message(src, message, language))
		return

	if(is_visual_language)
		if(message_mods[MODE_HEADSET] || message_mods[RADIO_KEY])
			return
	else
		var/radio_message = message
		if(message_mods[WHISPER_MODE])
			// radios don't pick up whispers very well
			radio_message = stars(radio_message)
			spans |= SPAN_ITALICS


		//REMEMBER KIDS, LISTS ARE REFERENCES. RADIO PACKETS GET QUEUED.
		var/radio_return = radio(radio_message, message_mods.Copy(), spans.Copy(), language)//roughly 27% of living/say()'s total cost
		if(radio_return & ITALICS)
			spans |= SPAN_ITALICS
		if(radio_return & REDUCE_RANGE)
			range = 1
			if(!message_mods[WHISPER_MODE])
				message_mods[WHISPER_MODE] = MODE_WHISPER
		if(radio_return & NOPASS)
			return TRUE

	if(!is_visual_language)
		//No screams in space, unless you're next to someone.
		var/turf/T = get_turf(src)
		var/datum/gas_mixture/environment = T.unsafe_return_air()
		var/pressure = (environment)? environment.returnPressure() : 0
		if(pressure < SOUND_MINIMUM_PRESSURE)
			range = 1

		if(pressure < ONE_ATMOSPHERE*0.4) //Thin air, let's italicise the message
			spans |= SPAN_ITALICS

	if(language)
		message = language.before_speaking(src, message)
		if(isnull(message))
			return FALSE

	send_speech(message, range, src, bubble_type, spans, language, message_mods)//roughly 58% of living/say()'s total cost

	///Play a sound to indicate we just spoke
	if(client && !is_visual_language)
		var/ending = copytext_char(message, -1)
		var/sound/speak_sound
		if(ending == "?")
			speak_sound = voice_type2sound[voice_type]["?"]
		else if(ending == "!")
			speak_sound = voice_type2sound[voice_type]["!"]
		else
			speak_sound = voice_type2sound[voice_type][voice_type]
		playsound(src, speak_sound, 300, 1, range - SOUND_RANGE, falloff_exponent = 0, pressure_affected = FALSE, ignore_walls = FALSE, use_reverb = FALSE)

	talkcount++
	return TRUE

/mob/living/Hear(message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, list/message_mods = list(), atom/sound_loc, message_range)
	SEND_SIGNAL(src, COMSIG_MOVABLE_HEAR, args)

	if(!GET_CLIENT(src) && !LAZYLEN(observers))
		return

	if(radio_freq && can_hear())
		var/atom/movable/virtualspeaker/V = speaker
		if(isAI(V.source))
			playsound_local(get_turf(src), 'goon/sounds/radio_ai.ogg', 170, 1, 0, 0, pressure_affected = FALSE, use_reverb = FALSE)

	// Message has a language, the language handles it.
	if(message_language)
		raw_message = message_language.hear_speech(src, speaker, raw_message, radio_freq, spans, message_mods, sound_loc, message_range)

	//Language-less snowflake
	else
		if(!can_hear())
			return

		var/avoid_highlight = FALSE
		if(istype(speaker, /atom/movable/virtualspeaker))
			var/atom/movable/virtualspeaker/virt = speaker
			avoid_highlight = speaker == virt.source
		else
			avoid_highlight = src == speaker

		var/enable_runechat
		if(ismob(speaker))
			enable_runechat = client.prefs.read_preference(/datum/preference/toggle/enable_runechat)
		else
			enable_runechat = client.prefs.read_preference(/datum/preference/toggle/enable_runechat_non_mobs)

		raw_message = translate_speech(speaker, null, raw_message, spans, message_mods)

		if(enable_runechat)
			create_chat_message(speaker, null, raw_message, sound_loc = sound_loc, runechat_flags = EMOTE_MESSAGE)

		var/chat_message = compose_message(speaker, null, raw_message, radio_freq)
		var/shown = show_message(chat_message, MSG_AUDIBLE, avoid_highlighting = avoid_highlight)
		if(shown && LAZYLEN(observers))
			for(var/mob/dead/observer/O in observers)
				to_chat(O, shown)

	if(raw_message) // If this is null, we didn't hear shit.
		SEND_SIGNAL(src, COMSIG_LIVING_HEAR_POST_TRANSLATION, args)
	return raw_message

/mob/living/send_speech(message, message_range = 6, obj/source = src, bubble_type = bubble_icon, list/spans, datum/language/message_language=null, list/message_mods = list())
	var/is_whispering = 0
	var/whisper_range = 0
	if(message_mods[WHISPER_MODE]) //If we're whispering
		// Needed for good hearing trait. The actual filtering for whispers happens at the /mob/living/Hear proc
		whisper_range = MESSAGE_RANGE - WHISPER_RANGE
		is_whispering = TRUE

	var/list/listening = get_hearers_in_view(message_range + whisper_range, source)

	#ifdef ZMIMIC_MULTIZ_SPEECH
	if(bound_overlay)
		listening += get_hearers_in_view(message_range + whisper_range, bound_overlay)
	#endif

	var/list/the_dead = list()

	if(client) //client is so that ghosts don't have to listen to mice
		for(var/mob/player_mob as anything in GLOB.player_list)
			if(QDELETED(player_mob)) //Some times nulls and deleteds stay in this list. This is a workaround to prevent ic chat breaking for everyone when they do.
				continue //Remove if underlying cause (likely byond issue) is fixed. See TG PR #49004.
			if(player_mob.stat != DEAD) //not dead, not important
				continue
			if(!player_mob.z) //Observing ghosts are in nullspace, pretend they don't exist
				continue
			if(player_mob.z != z || get_dist(player_mob, src) > 7) //they're out of range of normal hearing
				if(is_whispering)
					if(!(player_mob.client?.prefs.chat_toggles & CHAT_GHOSTWHISPER)) //they're whispering and we have hearing whispers at any range off
						continue
				else if(!(player_mob.client?.prefs.chat_toggles & CHAT_GHOSTEARS)) //they're talking normally and we have hearing at any range off
					continue

			listening |= player_mob
			the_dead[player_mob] = TRUE

	var/rendered = compose_message(src, message_language, message, null, spans, message_mods)
	for(var/atom/movable/listening_movable as anything in listening)
		if(!listening_movable)
			stack_trace("somehow theres a null returned from get_hearers_in_view() in send_speech!")
			continue

		listening_movable.Hear(rendered, src, message_language, message, null, spans, message_mods, message_range = message_range)

	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_LIVING_SAY_SPECIAL, src, message)

	//speech bubble
	var/list/speech_bubble_recipients = list()
	for(var/mob/M in listening)
		if(M.client && (!M.client.prefs.read_preference(/datum/preference/toggle/enable_runechat) || (SSlag_switch.measures[DISABLE_RUNECHAT] && !HAS_TRAIT(src, TRAIT_BYPASS_MEASURES))))
			speech_bubble_recipients.Add(M.client)

	var/image/I = image('icons/mob/talk.dmi', src, "[bubble_type][say_test(message)]", FLY_LAYER)
	I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA

	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(animate_speechbubble), I, speech_bubble_recipients, 30)

/mob/proc/binarycheck()
	return FALSE

/mob/living/can_speak(message) //For use outside of Say()
	if(can_speak_basic(message) && can_speak_vocal(message))
		return TRUE

/mob/living/proc/can_speak_basic(message, ignore_spam = FALSE, forced = FALSE) //Check BEFORE handling of xeno and ling channels
	if(client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, span_danger("You cannot speak in IC (muted)."))
			return FALSE
		if(!(ignore_spam || forced) && client.handle_spam_prevention(message,MUTE_IC))
			return FALSE

	return TRUE

/mob/living/proc/can_speak_vocal(message) //Check AFTER handling of xeno and ling channels
	if(HAS_TRAIT(src, TRAIT_MUTE))
		return FALSE //Makes sure mimes can't speak using sign language

	if(is_muzzled())
		return FALSE

	if(!IsVocal())
		return FALSE

	return TRUE

/mob/living/proc/can_speak_sign(message)
	return TRUE

/**
 * Treats the passed message with things that may modify speech (stuttering, slurring etc).
 *
 * message - The message to treat.
 * correct_grammar - Whether or not to capitalize the first letter and add punctuation.
 */
/mob/living/proc/treat_message(message, correct_grammar = TRUE)
	if(HAS_TRAIT(src, TRAIT_UNINTELLIGIBLE_SPEECH))
		message = unintelligize(message)

	SEND_SIGNAL(src, COMSIG_LIVING_TREAT_MESSAGE, args)

	if(correct_grammar)
		message = capitalize(message)

		var/static/regex/ends_with_punctuation = regex("\[?!-.\]")
		if((!client || client.prefs.read_preference(/datum/preference/toggle/auto_punctuation)) && !ends_with_punctuation.Find(message, length(message)))
			message += "."

	return message

/mob/living/proc/radio(message, list/message_mods = list(), list/spans, language)
	var/obj/item/implant/radio/imp = locate() in src
	if(imp?.radio.is_on())
		if(message_mods[MODE_HEADSET])
			imp.radio.talk_into(src, message, , spans, language, message_mods)
			return ITALICS | REDUCE_RANGE
		if(message_mods[RADIO_EXTENSION] == MODE_DEPARTMENT || (message_mods[RADIO_EXTENSION] in imp.radio.channels))
			imp.radio.talk_into(src, message, message_mods[RADIO_EXTENSION], spans, language, message_mods)
			return ITALICS | REDUCE_RANGE
	switch(message_mods[RADIO_EXTENSION])
		if(MODE_R_HAND)
			for(var/obj/item/r_hand in get_held_items_for_side(RIGHT_HANDS, all = TRUE))
				if (r_hand)
					return r_hand.talk_into(src, message, , spans, language, message_mods)
				return ITALICS | REDUCE_RANGE
		if(MODE_L_HAND)
			for(var/obj/item/l_hand in get_held_items_for_side(LEFT_HANDS, all = TRUE))
				if (l_hand)
					return l_hand.talk_into(src, message, , spans, language, message_mods)
				return ITALICS | REDUCE_RANGE

		if(MODE_INTERCOM)
			for (var/obj/item/radio/intercom/I in view(MODE_RANGE_INTERCOM, null))
				I.talk_into(src, message, , spans, language, message_mods)
			return ITALICS | REDUCE_RANGE

	return 0

/mob/living/say_mod(input, list/message_mods = list(), datum/language/language)
	if(language && (language.flags & LANGUAGE_OVERRIDE_SAY_MOD))
		return language.get_say_mod(src)

	if(message_mods[WHISPER_MODE] == MODE_WHISPER)
		. = verb_whisper

	else if(message_mods[MODE_SING])
		. = verb_sing

	if(.)
		return

	// Any subtype of slurring in our status effects make us "slur"
	if(has_status_effect(/datum/status_effect/speech/slurring))
		return "slurs"

	else if(has_status_effect(/datum/status_effect/speech/stutter))
		. = "stammers"

	else if(has_status_effect(/datum/status_effect/speech/stutter/derpspeech))
		. = "gibbers"
	else
		. = ..()

/**
 * Living level whisper.
 *
 * Living mobs which whisper have their message only appear to people very close.
 *
 * message - the message to display
 * bubble_type - the type of speech bubble that shows up when they speak (currently does nothing)
 * spans - a list of spans to apply around the message
 * sanitize - whether we sanitize the message
 * language - typepath language to force them to speak / whisper in
 * ignore_spam - whether we ignore the spam filter
 * forced - string source of what forced this speech to happen, also bypasses spam filter / mutes if supplied
 * filterproof - whether we ignore the word filter
 */
/mob/living/whisper(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language, ignore_spam = FALSE, forced, filterproof)
	if(!message)
		return
	say("#[message]", bubble_type, spans, sanitize, language, ignore_spam, forced, filterproof)

/mob/living/get_language_holder(get_minds = TRUE)
	if(get_minds && mind)
		return mind.get_language_holder()
	. = ..()

/mob/living/proc/hear_sleeping(message)
	var/heard = ""
	if(prob(15))
		var/list/punctuation = list(",", "!", ".", ";", "?")
		var/list/messages = splittext(message, " ")
		var/R = rand(1, length(messages))
		var/heardword = messages[R]
		if(copytext(heardword,1, 1) in punctuation)
			heardword = copytext(heardword,2)
		if(copytext(heardword,-1) in punctuation)
			heardword = copytext(heardword,1,length(heardword))
		heard = "<span class = 'game say obviousnotice'>...You hear something about...[heardword]</span>"

	else
		heard = "<span class = 'game say obviousnotice'><i>...You almost hear someone talking...</i></span>"

	to_chat(src, heard)
