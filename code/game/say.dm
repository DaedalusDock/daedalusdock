/*
Miauw's big Say() rewrite.
This file has the basic atom/movable level speech procs.
And the base of the send_speech() proc, which is the core of saycode.
*/
GLOBAL_LIST_INIT(freqtospan, list(
	"[FREQ_SCIENCE]" = "sciradio",
	"[FREQ_MEDICAL]" = "medradio",
	"[FREQ_ENGINEERING]" = "engradio",
	"[FREQ_SUPPLY]" = "suppradio",
	"[FREQ_SERVICE]" = "servradio",
	"[FREQ_SECURITY]" = "secradio",
	"[FREQ_COMMAND]" = "comradio",
	"[FREQ_AI_PRIVATE]" = "aiprivradio",
	"[FREQ_SYNDICATE]" = "syndradio",
	"[FREQ_CENTCOM]" = "centcomradio",
	"[FREQ_CTF_RED]" = "redteamradio",
	"[FREQ_CTF_BLUE]" = "blueteamradio",
	"[FREQ_CTF_GREEN]" = "greenteamradio",
	"[FREQ_CTF_YELLOW]" = "yellowteamradio"
	))

/atom/movable/proc/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null, filterproof = null, range = 7)
	if(!can_speak())
		return
	if(sanitize)
		message = trim(copytext_char(sanitize(message), 1, MAX_MESSAGE_LEN))
	if(message == "" || !message)
		return
	spans |= speech_span
	if(!language)
		language = get_selected_language()
	send_speech(message, range, src, , spans, message_language=language)

/atom/movable/proc/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, list/message_mods = list(), atom/sound_loc, message_range)
	SEND_SIGNAL(src, COMSIG_MOVABLE_HEAR, args)
	return TRUE

/mob/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, list/message_mods = list(), atom/sound_loc, message_range)
	. = ..()
	if(LAZYLEN(observers))
		for(var/mob/dead/observer/O as anything in observers)
			O.Hear(arglist(args))

	if(client && radio_freq)
		var/atom/movable/virtualspeaker/V = speaker
		if(isAI(V.source))
			playsound_local(get_turf(src), 'goon/sounds/radio_ai.ogg', 170, 1, 0, 0, pressure_affected = FALSE, use_reverb = FALSE)

/atom/movable/proc/can_speak()
	//SHOULD_BE_PURE(TRUE)
	return TRUE

/atom/movable/proc/send_speech(message, range = 7, obj/source = src, bubble_type, list/spans, datum/language/message_language, list/message_mods = list())
	var/rendered = compose_message(src, message_language, message, , spans, message_mods)
	for(var/atom/movable/hearing_movable as anything in get_hearers_in_view(range, source))
		if(!hearing_movable)//theoretically this should use as anything because it shouldnt be able to get nulls but there are reports that it does.
			stack_trace("somehow theres a null returned from get_hearers_in_view() in send_speech!")
			continue
		hearing_movable.Hear(rendered, src, message_language, message, null, spans, message_mods, message_range = range)

/**  The core proc behind say as a concept. Terrifyingly horrible. Called twice for no good reason.
 * Arguments:
 * * `speaker` - Either the mob speaking, or a virtualspeaker if this is a remote message of some kind.
 * * `message_language` - The language the message is ICly in. For understanding.
 * * `translated_message` - The actual text of the message, after being translated across languages.
 * * `radio_freq` - can be either a numeric radio frequency, or an assoc list of `span` and `name`, to directly override them.
 * * `face_name` - Do we use the "name" of the speaker, or get it's `real_name`, Used solely for hallucinations.
*/
/atom/movable/proc/compose_message(atom/movable/speaker, datum/language/message_language, translated_message, radio_freq, list/spans, list/message_mods = list(), face_name = FALSE)

	var/voice = "[speaker.GetVoice()]"
	var/alt_name = speaker.get_alt_name()

	//Basic span
	var/wrapper_span = "<span class = 'game say'>"
	if(radio_freq)
		wrapper_span = "<span class = '[get_radio_span(radio_freq)]'>"

	else if(message_mods[MODE_CUSTOM_SAY_ERASE_INPUT] || isnull(message_language))
		wrapper_span = "<span class = 'emote'>"

	//Radio freq/name display
	var/freqpart = ""
	if(radio_freq)
		freqpart = "[RADIO_TAG(get_radio_icon(radio_freq))]\[[get_radio_name(radio_freq)]\] "

	//Speaker name
	var/namepart = "[voice][alt_name]"
	if(face_name && ishuman(speaker))
		var/mob/living/carbon/human/H = speaker
		namepart = "[H.get_face_name()]" //So "fake" speaking like in hallucinations does not give the speaker away if disguised
	else
		speaker.update_name_chat_color(voice)

	//Start name span.
	var/name_span = "<span class='name'>"
	//End name span.
	var/end_name_span = "</span>"

	//href for AI tracking
	var/ai_track_href = compose_track_href(speaker, namepart)
	//shows the speaker's job to AIs
	var/ai_job_display = compose_job(speaker, message_language, translated_message, radio_freq)
	//AI smiley face :)
	var/ai_snowflake
	if(radio_freq && isAI(speaker.GetSource()))
		ai_snowflake = RADIO_TAG("ai.png")

	//Message
	var/messagepart
	var/languageicon = ""
	if (message_mods[MODE_CUSTOM_SAY_ERASE_INPUT])
		messagepart = "<span class='emote'>[message_mods[MODE_CUSTOM_SAY_EMOTE]]</span>"
	else
		if(message_mods[MODE_NO_QUOTE] || isnull(message_language))
			messagepart = translated_message
		else
			messagepart = speaker.say_quote(translated_message, spans, message_mods, message_language)

		if(message_language?.display_icon(src))
			languageicon = "[message_language.get_icon()] "

	messagepart = " <span class='message'>[speaker.say_emphasis(messagepart)]</span></span>" //These close the wrapper_span and the "message" class span

	return "[wrapper_span][freqpart][ai_snowflake][name_span][languageicon][ai_track_href][namepart][ai_job_display][end_name_span][messagepart]"

/atom/movable/proc/compose_track_href(atom/movable/speaker, message_langs, raw_message, radio_freq)
	return ""

/atom/movable/proc/compose_job(atom/movable/speaker, message_langs, raw_message, radio_freq)
	return ""

/atom/movable/proc/say_mod(input, list/message_mods = list(), datum/language/language)
	var/ending = copytext_char(input, -1)
	if(copytext_char(input, -2) == "!!")
		return verb_yell

	else if(message_mods[MODE_SING])
		. = verb_sing

	else if(ending == "?")
		return verb_ask

	else if(ending == "!")
		return verb_exclaim

	else
		return verb_say

/atom/movable/proc/say_quote(input, list/spans=list(speech_span), list/message_mods = list(), datum/language/language)
	if(!input)
		input = "..."

	var/say_mod = message_mods[MODE_CUSTOM_SAY_EMOTE]
	if (!say_mod)
		say_mod = say_mod(input, message_mods, language)

	if(copytext_char(input, -2) == "!!")
		spans |= SPAN_YELL

	var/spanned = attach_spans(input, spans)
	return "<span class='sayverb'>[say_mod],</span> \"[spanned]\""

/// Transforms the speech emphasis mods from [/atom/movable/proc/say_emphasis] into the appropriate HTML tags. Includes escaping.
#define ENCODE_HTML_EMPHASIS(input, char, html, varname) \
	var/static/regex/##varname = regex("(?<!\\\\)[char](.+?)(?<!\\\\)[char]", "g");\
	input = varname.Replace_char(input, "<[html]>$1</[html]>&#8203;") //zero-width space to force maptext to respect closing tags.

/// Scans the input sentence for speech emphasis modifiers, notably |italics|, +bold+, and _underline_ -mothblocks
/atom/movable/proc/say_emphasis(input)
	ENCODE_HTML_EMPHASIS(input, "\\|", "i", italics)
	ENCODE_HTML_EMPHASIS(input, "\\+", "b", bold)
	ENCODE_HTML_EMPHASIS(input, "_", "u", underline)
	var/static/regex/remove_escape_backlashes = regex("\\\\(_|\\+|\\|)", "g") // Removes backslashes used to escape text modification.
	input = remove_escape_backlashes.Replace_char(input, "$1")
	return input

#undef ENCODE_HTML_EMPHASIS

/// Processes a spoken message's language based on if the hearer can understand it.
/atom/movable/proc/translate_speech(atom/movable/speaker, datum/language/language, raw_message, list/spans, list/message_mods = list(), quote = FALSE)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/atom/movable/source = speaker.GetSource() || speaker //is the speaker virtual

	// Understands the language?
	if(has_language(language))
		return language.speech_understood(source, raw_message, spans, message_mods, quote)

	else if(language)
		return language.speech_not_understood(source, raw_message, spans, message_mods, quote)

	else
		. = "makes a strange sound."
		if(quote)
			. = source.say_quote(.)

/proc/get_radio_span(freq)
	if(islist(freq)) //Heehoo hijack bullshit
		return freq["span"]
	var/returntext = GLOB.freqtospan["[freq]"]
	if(returntext)
		return returntext
	return "radio"

/proc/get_radio_name(freq)
	if(islist(freq)) //Heehoo hijack bullshit
		return freq["name"]
	var/returntext = GLOB.reverseradiochannels["[freq]"]
	if(returntext)
		return returntext
	return "[copytext_char("[freq]", 1, 4)].[copytext_char("[freq]", 4, 5)]"

/// Pass in a frequency, get a file name. See chat_icons.dm
/proc/get_radio_icon(freq)
	. = GLOB.freq2icon["[freq]"]
	. ||= "unknown.png"

/proc/attach_spans(input, list/spans)
	return "[message_spans_start(spans)][input]</span>"

/proc/message_spans_start(list/spans)
	var/output = "<span class='"
	for(var/S in spans)
		output = "[output][S] "
	output = "[output]'>"
	return output

/proc/say_test(text)
	var/ending = copytext_char(text, -1)
	if (ending == "?")
		return "1"
	else if (ending == "!")
		return "2"
	return "0"

/atom/movable/proc/GetVoice()
	return "[src]" //Returns the atom's name, prepended with 'The' if it's not a proper noun

/atom/movable/proc/IsVocal()
	return TRUE

/atom/movable/proc/get_alt_name()

//HACKY VIRTUALSPEAKER STUFF BEYOND THIS POINT
//these exist mostly to deal with the AIs hrefs and job stuff.

/atom/movable/proc/GetJob() //Get a job, you lazy butte

/atom/movable/proc/GetSource()

/atom/movable/proc/GetRadio()

//VIRTUALSPEAKERS
/atom/movable/virtualspeaker
	var/job
	var/atom/movable/source
	var/obj/item/radio/radio
	///goon speech sound voice type
	var/voice_type = ""

INITIALIZE_IMMEDIATE(/atom/movable/virtualspeaker)
/atom/movable/virtualspeaker/Initialize(mapload, atom/movable/M, _radio)
	. = ..()
	radio = _radio
	source = M
	if(istype(M))
		name = radio?.anonymize ? "Unknown" : M.GetVoice()
		verb_say = M.verb_say
		verb_ask = M.verb_ask
		verb_exclaim = M.verb_exclaim
		verb_yell = M.verb_yell

	// The mob's job identity
	if(ishuman(M))
		// Humans use their job as seen on the crew manifest. This is so the AI
		// can know their job even if they don't carry an ID.
		var/datum/data/record/findjob = SSdatacore.get_record_by_name(name, DATACORE_RECORDS_STATION)
		if(findjob)
			job = findjob.fields[DATACORE_RANK]
		else
			job = "Unknown"

	else if(iscarbon(M))  // Carbon nonhuman
		job = "No ID"
	else if(isAI(M))  // AI
		job = "AI"
	else if(iscyborg(M))  // Cyborg
		var/mob/living/silicon/robot/B = M
		job = "[B.designation] Cyborg"
	else if(istype(M, /mob/living/silicon/pai))  // Personal AI (pAI)
		job = JOB_PERSONAL_AI
	else if(isobj(M))  // Cold, emotionless machines
		job = "Machine"
	else  // Unidentifiable mob
		job = "Unknown"

/atom/movable/virtualspeaker/GetJob()
	return job

/atom/movable/virtualspeaker/GetSource()
	return source

/atom/movable/virtualspeaker/GetRadio()
	return radio
