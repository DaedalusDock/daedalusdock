/datum/action/cooldown/flock/radio_talk
	name = "Narrowbeam Transmission"
	desc = "Hijack a radio headset of a target to broadcast a message."
	button_icon_state = "talk"
	cooldown_time = 2 SECONDS
	click_to_activate = TRUE

/datum/action/cooldown/flock/radio_talk/Activate(atom/target)
	var/obj/item/radio/radio_target

	if(!ishuman(target) && !istype(target, /obj/item/radio))
		to_chat(owner, span_warning("[target] is not a valid target."))
		return FALSE

	if(istype(target, /obj/item/radio))
		radio_target = target
		if(!radio_target.get_listening())
			to_chat(owner, span_warning("[target] is not turned on."))
			return FALSE

		if(radio_target.canhear_range == -1)
			to_chat(owner, span_warning("[target] is not a valid target."))
			return FALSE

	if(ishuman(target))
		var/mob/living/carbon/human/schmuck = target
		for(var/obj/item/I in schmuck.get_contents())
			if(istype(I, /obj/item/radio))
				radio_target = I
				break

		if(!istype(radio_target) || !radio_target.get_listening() || radio_target.canhear_range == -1)
			to_chat(owner, span_warning("[target] does not have a working radio."))
			return FALSE

	var/msg = uppertext(tgui_input_text(usr, "What do you wish to broadcast?", "Narrowbeam Transmission", ""))
	if(!msg)
		return FALSE

	. = ..()

	playsound(get_turf(radio_target), pick('goon/sounds/radio_sweep1.ogg','goon/sounds/radio_sweep2.ogg','goon/sounds/radio_sweep3.ogg','goon/sounds/radio_sweep4.ogg','goon/sounds/radio_sweep5.ogg'), 20, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	to_chat(owner, span_notice("You transmit a message through [radio_target]."))

	if(radio_target == target)
		msg = Gibberish(msg, 70, 50)

	var/atom/movable/virtualspeaker/speaker = new(null, null)
	speaker.name = "Unknown"

	var/rendered = speaker.compose_message(speaker, GET_LANGUAGE_DATUM(/datum/language/common), msg, FREQ_COMMON, list("flocksay", SPAN_ITALICS), list())

	for(var/atom/movable/hearer in get_hearers_in_LOS(radio_target.canhear_range, radio_target))
		hearer.Hear(
			rendered,
			speaker,
			GET_LANGUAGE_DATUM(/datum/language/common),
			msg,
			FREQ_COMMON,
			list("flocksay", SPAN_ITALICS), // spans
			list(), // message mods
			sound_loc = radio_target.speaker_location(),
			message_range = INFINITY
		)
