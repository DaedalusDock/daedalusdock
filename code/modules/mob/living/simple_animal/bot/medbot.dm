//MEDBOT
//MEDBOT PATHFINDING
//MEDBOT ASSEMBLY
#define MEDBOT_PANIC_NONE 0
#define MEDBOT_PANIC_LOW 15
#define MEDBOT_PANIC_MED 35
#define MEDBOT_PANIC_HIGH 55
#define MEDBOT_PANIC_FUCK 70
#define MEDBOT_PANIC_ENDING 90
#define MEDBOT_PANIC_END 100

#define MEDBOT_NEW_PATIENTSPEAK_DELAY (30 SECONDS)
#define MEDBOT_PATIENTSPEAK_DELAY (20 SECONDS)
#define MEDBOT_FREAKOUT_DELAY (15 SECONDS)

/mob/living/simple_animal/bot/medbot
	name = "\improper Medibot"
	desc = "A little medical robot. He looks somewhat underwhelmed."
	icon = 'icons/mob/aibots.dmi'
	icon_state = "medibot0"
	base_icon_state = "medibot"
	density = FALSE
	anchored = FALSE
	health = 20
	maxHealth = 20
	pass_flags = PASSMOB | PASSFLAPS
	status_flags = (CANPUSH | CANSTUN)

	maints_access_required = list(ACCESS_ROBOTICS, ACCESS_MEDICAL)
	radio_key = /obj/item/encryptionkey/headset_med
	radio_channel = RADIO_CHANNEL_MEDICAL
	bot_type = MED_BOT
	data_hud_type = DATA_HUD_MEDICAL_ADVANCED
	hackables = "health processor circuits"
	path_image_color = "#DDDDFF"

	var/list/idle_phrases = list(
		MEDIBOT_VOICED_MASK_ON = 'sound/voice/medbot/radar.ogg',
		MEDIBOT_VOICED_ALWAYS_A_CATCH = 'sound/voice/medbot/catch.ogg',
		MEDIBOT_VOICED_PLASTIC_SURGEON = 'sound/voice/medbot/surgeon.ogg',
		MEDIBOT_VOICED_LIKE_FLIES = 'sound/voice/medbot/flies.ogg',
		MEDIBOT_VOICED_DELICIOUS = 'sound/voice/medbot/delicious.ogg',
		MEDIBOT_VOICED_SUFFER = 'sound/voice/medbot/why.ogg'
	)

	var/list/finish_healing_phrases = list(
		MEDIBOT_VOICED_ALL_PATCHED_UP = 'sound/voice/medbot/patchedup.ogg',
		MEDIBOT_VOICED_APPLE_A_DAY = 'sound/voice/medbot/apple.ogg',
		MEDIBOT_VOICED_FEEL_BETTER = 'sound/voice/medbot/feelbetter.ogg',
	)

	var/list/located_patient_phrases = list(
		MEDIBOT_VOICED_HOLD_ON = 'sound/voice/medbot/coming.ogg',
		MEDIBOT_VOICED_WANT_TO_HELP = 'sound/voice/medbot/help.ogg',
		MEDIBOT_VOICED_YOU_ARE_INJURED = 'sound/voice/medbot/injured.ogg'
	)

	var/list/patient_died_phrases = list(
		MEDIBOT_VOICED_STAY_WITH_ME = 'sound/voice/medbot/no.ogg',
		MEDIBOT_VOICED_LIVE = 'sound/voice/medbot/live.ogg',
		MEDIBOT_VOICED_NEVER_LOST = 'sound/voice/medbot/lost.ogg'
	)

	var/list/pre_tip_phrases = list(
		MEDIBOT_VOICED_WAIT = 'sound/voice/medbot/hey_wait.ogg',
		MEDIBOT_VOICED_DONT = 'sound/voice/medbot/please_dont.ogg',
		MEDIBOT_VOICED_TRUSTED_YOU = 'sound/voice/medbot/i_trusted_you.ogg',
		MEDIBOT_VOICED_NO_SAD = 'sound/voice/medbot/nooo.ogg',
		MEDIBOT_VOICED_OH_FUCK = 'sound/voice/medbot/oh_fuck.ogg',
	)

	var/list/untip_phrases = list(
		MEDIBOT_VOICED_FORGIVE = 'sound/voice/medbot/forgive.ogg',
		MEDIBOT_VOICED_THANKS = 'sound/voice/medbot/thank_you.ogg',
		MEDIBOT_VOICED_GOOD_PERSON = 'sound/voice/medbot/youre_good.ogg',
		MEDIBOT_VOICED_FUCK_YOU = 'sound/voice/medbot/fuck_you.ogg',
		MEDIBOT_VOICED_BEHAVIOUR_REPORTED = 'sound/voice/medbot/reported.ogg'
	)

	var/list/panic_phrases = list(
		MEDIBOT_VOICED_ASSISTANCE = 'sound/voice/medbot/i_require_asst.ogg',
		MEDIBOT_VOICED_PUT_BACK = 'sound/voice/medbot/please_put_me_back.ogg',
		MEDIBOT_VOICED_IM_SCARED = 'sound/voice/medbot/please_im_scared.ogg',
		MEDIBOT_VOICED_NEED_HELP = 'sound/voice/medbot/dont_like.ogg',
		MEDIBOT_VOICED_THIS_HURTS = 'sound/voice/medbot/pain_is_real.ogg',
		MEDIBOT_VOICED_THE_END = 'sound/voice/medbot/is_this_the_end.ogg',
		MEDIBOT_VOICED_NOOO = 'sound/voice/medbot/nooo.ogg'
	)

	/// Compiled list of all the phrase lists.
	var/list/all_phrases

	/// drop determining variable
	var/healthanalyzer = /obj/item/healthanalyzer
	/// drop determining variable
	var/medkit_type = /obj/item/storage/medkit
	///based off medkit_X skins in aibots.dmi for your selection; X goes here IE medskin_tox means skin var should be "tox"
	var/skin
	var/mob/living/carbon/patient
	/// Weakref to the last patient. The last patient is ignored for a bit when finding a new target.
	var/datum/weakref/previous_patient
	/// Timestamp of the last time we found a patient.
	var/last_found = 0
	/// Bots must wait this long before considering the previous patient a valid target.
	var/repeat_patient_cooldown = 20 SECONDS

	/// Start healing when they have this much damage in a category
	var/heal_threshold = 10
	/// How long it takes to inject.
	var/heal_time = 2 SECONDS
	/// How many units of reagent to inject.
	var/injection_amount = 15

	/// What damage type does this bot support. Set to "all" for it to heal any of the 4 base damage types
	var/damagetype_healer = BRUTE

	/// Reagents to use for each healing type.
	var/list/healing_reagents = list(
		BRUTE = /datum/reagent/medicine/tricordrazine,
		BURN = /datum/reagent/medicine/tricordrazine,
		TOX = /datum/reagent/medicine/tricordrazine,
		OXY = /datum/reagent/medicine/tricordrazine,
		"emag" = /datum/reagent/toxin/chloralhydrate,
	)

	///Flags Medbots use to decide how they should be acting.
	var/medical_mode_flags = MEDBOT_DECLARE_CRIT | MEDBOT_SPEAK_MODE
//	Selections:  MEDBOT_DECLARE_CRIT | MEDBOT_STATIONARY_MODE | MEDBOT_SPEAK_MODE

	///How panicked we are about being tipped over (why would you do this?)
	var/tipped_status = MEDBOT_PANIC_NONE
	///The name we got when we were tipped
	var/tipper_name

	///Last announced healing a person in critical condition
	COOLDOWN_DECLARE(last_patient_message)
	///Last announced trying to catch up to a new patient
	COOLDOWN_DECLARE(last_newpatient_speak)
	///Last time we were tipped/righted and said a voice line
	COOLDOWN_DECLARE(last_tipping_action_voice)

/mob/living/simple_animal/bot/medbot/autopatrol
	bot_mode_flags = BOT_MODE_ON | BOT_MODE_AUTOPATROL | BOT_MODE_REMOTE_ENABLED | BOT_MODE_PAI_CONTROLLABLE

/mob/living/simple_animal/bot/medbot/stationary
	medical_mode_flags = MEDBOT_DECLARE_CRIT | MEDBOT_STATIONARY_MODE | MEDBOT_SPEAK_MODE

/mob/living/simple_animal/bot/medbot/mysterious
	name = "\improper Mysterious Medibot"
	desc = "International Medibot of mystery."
	skin = "bezerk"
	damagetype_healer = "all"
	injection_amount = 20
	heal_time = 1 SECOND

/mob/living/simple_animal/bot/medbot/derelict
	name = "\improper Old Medibot"
	desc = "Looks like it hasn't been modified since the late 2080s."
	skin = "bezerk"
	damagetype_healer = "all"
	medical_mode_flags = MEDBOT_SPEAK_MODE
	heal_threshold = 0
	injection_amount = 5
	heal_time = 5 SECONDS

/mob/living/simple_animal/bot/medbot/examine(mob/user)
	. = ..()
	if(tipped_status == MEDBOT_PANIC_NONE)
		return

	switch(tipped_status)
		if(MEDBOT_PANIC_NONE to MEDBOT_PANIC_LOW)
			. += "It appears to be tipped over, and is quietly waiting for someone to set it right."
		if(MEDBOT_PANIC_LOW to MEDBOT_PANIC_MED)
			. += "It is tipped over and requesting help."
		if(MEDBOT_PANIC_MED to MEDBOT_PANIC_HIGH)
			. += "They are tipped over and appear visibly distressed." // now we humanize the medbot as a they, not an it
		if(MEDBOT_PANIC_HIGH to MEDBOT_PANIC_FUCK)
			. += span_warning("They are tipped over and visibly panicking!")
		if(MEDBOT_PANIC_FUCK to INFINITY)
			. += span_warning("<b>They are freaking out from being tipped over!</b>")

/mob/living/simple_animal/bot/medbot/update_icon_state()
	. = ..()
	if(!(bot_mode_flags & BOT_MODE_ON))
		icon_state = "[base_icon_state]0"
		return
	if(HAS_TRAIT(src, TRAIT_INCAPACITATED))
		icon_state = "[base_icon_state]a"
		return
	if(mode == BOT_HEALING)
		icon_state = "[base_icon_state]s[get_bot_flag(medical_mode_flags, MEDBOT_STATIONARY_MODE)]"
		return
	icon_state = "[base_icon_state][get_bot_flag(medical_mode_flags, MEDBOT_STATIONARY_MODE) ? 2 : 1]" //Bot has yellow light to indicate stationary mode.

/mob/living/simple_animal/bot/medbot/update_overlays()
	. = ..()
	if(skin)
		. += "medskin_[skin]"

/mob/living/simple_animal/bot/medbot/Initialize(mapload, new_skin)
	. = ..()

	// Doing this hurts my soul, but simplebot access reworks are for another day.
	var/datum/id_trim/job/para_trim = SSid_access.trim_singletons_by_path[/datum/id_trim/job/paramedic]
	access_card.add_access(para_trim.access + para_trim.wildcard_access)
	prev_access = access_card.access.Copy()

	skin = new_skin
	update_appearance()

	all_phrases = idle_phrases + located_patient_phrases + finish_healing_phrases + patient_died_phrases + pre_tip_phrases + untip_phrases + panic_phrases

	AddComponent(/datum/component/tippable, \
		tip_time = 3 SECONDS, \
		untip_time = 3 SECONDS, \
		self_right_time = 3.5 MINUTES, \
		pre_tipped_callback = CALLBACK(src, PROC_REF(pre_tip_over)), \
		post_tipped_callback = CALLBACK(src, PROC_REF(after_tip_over)), \
		post_untipped_callback = CALLBACK(src, PROC_REF(after_righted)))

/mob/living/simple_animal/bot/medbot/bot_reset()
	..()
	patient = null
	previous_patient = null
	last_found = world.time
	update_appearance()

/mob/living/simple_animal/bot/medbot/proc/soft_reset() //Allows the medibot to still actively perform its medical duties without being completely halted as a hard reset does.
	path = list()
	patient = null
	set_mode(BOT_IDLE)
	last_found = world.time
	frustration = 0
	update_appearance()

/mob/living/simple_animal/bot/medbot/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

// Variables sent to TGUI
/mob/living/simple_animal/bot/medbot/ui_data(mob/user)
	var/list/data = ..()
	if(!(bot_cover_flags & BOT_COVER_LOCKED) || issilicon(user) || isAdminGhostAI(user))
		data["custom_controls"]["heal_threshold"] = heal_threshold
		data["custom_controls"]["speaker"] = medical_mode_flags & MEDBOT_SPEAK_MODE
		data["custom_controls"]["crit_alerts"] = medical_mode_flags & MEDBOT_DECLARE_CRIT
		data["custom_controls"]["stationary_mode"] = medical_mode_flags & MEDBOT_STATIONARY_MODE
	return data

// Actions received from TGUI
/mob/living/simple_animal/bot/medbot/ui_act(action, params)
	. = ..()
	if(. || (bot_cover_flags & BOT_COVER_LOCKED && !usr.has_unlimited_silicon_privilege))
		return

	switch(action)
		if("heal_threshold")
			var/adjust_num = round(text2num(params["threshold"]))
			heal_threshold = adjust_num
			if(heal_threshold < 5)
				heal_threshold = 5
			if(heal_threshold > 75)
				heal_threshold = 75
		if("speaker")
			medical_mode_flags ^= MEDBOT_SPEAK_MODE
		if("crit_alerts")
			medical_mode_flags ^= MEDBOT_DECLARE_CRIT
		if("stationary_mode")
			medical_mode_flags ^= MEDBOT_STATIONARY_MODE
			path = list()

	update_appearance()

/mob/living/simple_animal/bot/medbot/attackby(obj/item/W as obj, mob/user as mob, params)
	var/current_health = health
	..()
	if(health < current_health) //if medbot took some damage
		step_to(src, (get_step_away(src,user)))

/mob/living/simple_animal/bot/medbot/emag_act(mob/user)
	..()
	if(!(bot_cover_flags & BOT_COVER_EMAGGED))
		return
	medical_mode_flags &= ~MEDBOT_DECLARE_CRIT
	if(user)
		to_chat(user, span_notice("You short out [src]'s reagent synthesis circuits."))
	audible_message(span_danger("[src] buzzes oddly!"))
	z_flick("medibot_spark", src)
	playsound(src, SFX_SPARKS, 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	if(user)
		previous_patient = WEAKREF(user)

/mob/living/simple_animal/bot/medbot/process_scan(mob/living/carbon/human/H)
	if(H.stat == DEAD)
		return null
	if(IS_WEAKREF_OF(H, previous_patient) && (world.time < last_found + repeat_patient_cooldown))
		return null
	if(!is_viable_patient(H))
		return null

	last_found = world.time
	if(COOLDOWN_FINISHED(src, last_newpatient_speak))
		COOLDOWN_START(src, last_newpatient_speak, MEDBOT_NEW_PATIENTSPEAK_DELAY)
		medbot_phrase(pick(located_patient_phrases), H)
	return H

/*
 * Proc used in a callback for before this medibot is tipped by the tippable component.
 *
 * user - the mob who is tipping us over
 */
/mob/living/simple_animal/bot/medbot/proc/pre_tip_over(mob/user)
	if(!COOLDOWN_FINISHED(src, last_tipping_action_voice))
		return

	COOLDOWN_START(src, last_tipping_action_voice, MEDBOT_FREAKOUT_DELAY) // message for tipping happens when we start interacting, message for righting comes after finishing
	medbot_phrase(pick(pre_tip_phrases), user)

/*
 * Proc used in a callback for after this medibot is tipped by the tippable component.
 *
 * user - the mob who tipped us over
 */
/mob/living/simple_animal/bot/medbot/proc/after_tip_over(mob/user)
	set_mode(BOT_TIPPED)
	tipper_name = user.name
	playsound(src, 'sound/machines/warning-buzzer.ogg', 50)

/*
 * Proc used in a callback for after this medibot is righted, either by themselves or by a mob, by the tippable component.
 *
 * user - the mob who righted us. Can be null.
 */
/mob/living/simple_animal/bot/medbot/proc/after_righted(mob/user)
	var/phrase
	if(user)
		if(user.name == tipper_name)
			phrase = MEDIBOT_VOICED_FORGIVE
		else
			phrase = pick(MEDIBOT_VOICED_THANKS, MEDIBOT_VOICED_GOOD_PERSON)
	else
		phrase = pick(MEDIBOT_VOICED_FUCK_YOU, MEDIBOT_VOICED_BEHAVIOUR_REPORTED)

	tipper_name = null

	if(COOLDOWN_FINISHED(src, last_tipping_action_voice))
		COOLDOWN_START(src, last_tipping_action_voice, MEDBOT_FREAKOUT_DELAY)
		medbot_phrase(phrase, user)

	tipped_status = MEDBOT_PANIC_NONE
	set_mode(BOT_IDLE)

/// if someone tipped us over, check whether we should ask for help or just right ourselves eventually
/mob/living/simple_animal/bot/medbot/proc/handle_panic()
	tipped_status++
	var/phrase

	switch(tipped_status)
		if(MEDBOT_PANIC_LOW)
			phrase = MEDIBOT_VOICED_ASSISTANCE
		if(MEDBOT_PANIC_MED)
			phrase = MEDIBOT_VOICED_PUT_BACK
		if(MEDBOT_PANIC_HIGH)
			phrase = MEDIBOT_VOICED_IM_SCARED
		if(MEDBOT_PANIC_FUCK)
			phrase = pick(MEDIBOT_VOICED_NEED_HELP, MEDIBOT_VOICED_THIS_HURTS)
		if(MEDBOT_PANIC_ENDING)
			phrase = pick(MEDIBOT_VOICED_NOOO, MEDIBOT_VOICED_THE_END)
		if(MEDBOT_PANIC_END)
			speak("PSYCH ALERT: Crewmember [tipper_name] recorded displaying antisocial tendencies torturing bots in [get_area(src)]. Please schedule psych evaluation.", radio_channel)

	if(prob(tipped_status))
		do_jitter_animation(tipped_status * 0.1)

	if(phrase)
		medbot_phrase(phrase)

	else if(prob(tipped_status * 0.2))
		playsound(src, 'sound/machines/warning-buzzer.ogg', 30, extrarange=-2)

/mob/living/simple_animal/bot/medbot/handle_automated_action()
	. = ..()
	if(!.)
		return

	switch(mode)
		if(BOT_TIPPED)
			handle_panic()
			return
		if(BOT_HEALING)
			return

	if(IsStun() || IsParalyzed())
		previous_patient = WEAKREF(patient)
		patient = null
		set_mode(BOT_IDLE)
		return

	if(frustration > 5)
		previous_patient = WEAKREF(patient)
		soft_reset()
		medbot_phrase(MEDIBOT_VOICED_FUCK_YOU)

	if(QDELETED(patient))
		if(medical_mode_flags & MEDBOT_SPEAK_MODE && prob(1))
			if(bot_cover_flags & BOT_COVER_EMAGGED && prob(30))
				var/list/i_need_scissors = list(
					'sound/voice/medbot/fuck_you.ogg',
					'sound/voice/medbot/turn_off.ogg',
					'sound/voice/medbot/im_different.ogg',
					'sound/voice/medbot/close.ogg',
					'sound/voice/medbot/shindemashou.ogg',
				)
				playsound(src, pick(i_need_scissors), 70)
			else
				medbot_phrase(pick(idle_phrases))

		var/scan_range = (medical_mode_flags & MEDBOT_STATIONARY_MODE ? 1 : DEFAULT_SCAN_RANGE) //If in stationary mode, scan range is limited to adjacent patients.
		patient = scan(list(/mob/living/carbon/human), scan_range = scan_range)
		//previous_patient = WEAKREF(patient)

	if(patient)
		if((get_dist(src,patient) <= 1)) //Patient is next to us, begin treatment!
			if(mode != BOT_HEALING)
				update_appearance()
				try_medicate_patient(patient)
			return

		else if(medical_mode_flags & MEDBOT_STATIONARY_MODE) //Since we cannot move in this mode, ignore the patient and wait for another.
			soft_reset()
			return

		//Patient has moved away from us!
		else if(!path.len || (path.len && (get_dist(patient,path[path.len]) > 2)))
			path = list()
			set_mode(BOT_IDLE)
			last_found = world.time

		if(path.len == 0 && (get_dist(src,patient) > 1))
			set_mode(BOT_PATHING)
			path = jps_path_to(src, patient, max_distance=30, mintargetdist=1, access = access_card?.GetAccess())
			set_mode(BOT_MOVING)
			if(!path.len) //Do not chase a patient we cannot reach.
				add_to_ignore(patient)
				soft_reset()

		if(path.len > 0)
			frustration++
			if(!bot_move(path[path.len]))
				previous_patient = WEAKREF(patient)
				soft_reset()
			return

	if(bot_mode_flags & BOT_MODE_AUTOPATROL && !(medical_mode_flags & MEDBOT_STATIONARY_MODE) && !patient)
		switch(mode)
			if(BOT_IDLE, BOT_START_PATROL)
				start_patrol()
			if(BOT_PATROL)
				bot_patrol()

/// Returns a reagent to inject, if we can treat the mob.
/mob/living/simple_animal/bot/medbot/proc/is_viable_patient(mob/living/carbon/C, declare_crit = TRUE)
	//Time to see if they need medical help!
	if((medical_mode_flags & MEDBOT_STATIONARY_MODE) && !Adjacent(C)) //YOU come to ME, BRO
		return

	if(C.stat == DEAD || (HAS_TRAIT(C, TRAIT_FAKEDEATH)))
		return //welp too late for them!

	if(!(loc == C.loc) && !(isturf(C.loc) && isturf(loc)))
		return

	if(C.suiciding)
		return //Kevorkian school of robotic medical assistants.

	if(bot_cover_flags & BOT_COVER_EMAGGED) //Everyone needs our medicine. (Our medicine is toxins)
		return

	if(HAS_TRAIT(C, TRAIT_MEDIBOTCOMINGTHROUGH) && !HAS_TRAIT_FROM(C, TRAIT_MEDIBOTCOMINGTHROUGH, tag)) //the early medbot gets the worm (or in this case the patient)
		return

	//Critical condition! Call for help!
	if(declare_crit && (medical_mode_flags & MEDBOT_DECLARE_CRIT) && C.undergoing_cardiac_arrest())
		declare(C)

	if(!C.try_inject(src, zone_selected || BODY_ZONE_CHEST))
		return

	if(bot_cover_flags & BOT_COVER_EMAGGED)
		return healing_reagents["emag"]

	//They're injured enough for it!
	var/heals_all = damagetype_healer == "all"

	if((heals_all || (damagetype_healer == BRUTE)) && C.getBruteLoss() > heal_threshold && !C.bloodstream.has_reagent(healing_reagents[BRUTE]))
		return healing_reagents[BRUTE]

	if((heals_all || (damagetype_healer == BURN)) && C.getFireLoss() > heal_threshold && !C.bloodstream.has_reagent(healing_reagents[BURN]))
		return healing_reagents[BURN]

	if((heals_all || (damagetype_healer == TOX)) && C.getToxLoss() > heal_threshold && !C.bloodstream.has_reagent(healing_reagents[TOX]))
		return healing_reagents[TOX]

	if((heals_all || (damagetype_healer == OXY)) && C.getOxyLoss() > (5 + heal_threshold) && !C.bloodstream.has_reagent(healing_reagents[OXY]))
		return healing_reagents[OXY]

/mob/living/simple_animal/bot/medbot/UnarmedAttack(atom/A, proximity_flag, list/modifiers)
	if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
		return
	if(iscarbon(A) && mode != BOT_HEALING)
		var/mob/living/carbon/C = A
		patient = C
		update_appearance()
		try_medicate_patient(C)
		update_appearance()
		return
	..()

/mob/living/simple_animal/bot/medbot/examinate(atom/A as mob|obj|turf in view())
	..()
	if(!is_blind())
		chemscan(src, A)

/// Attempt to inject a patient with the goods.
/mob/living/simple_animal/bot/medbot/proc/try_medicate_patient(mob/living/carbon/C)
	if(!(bot_mode_flags & BOT_MODE_ON))
		return

	if(!istype(C))
		previous_patient = WEAKREF(patient)
		soft_reset()
		return

	if(C.stat == DEAD || (HAS_TRAIT(C, TRAIT_FAKEDEATH)))
		medbot_phrase(pick(patient_died_phrases), C)
		previous_patient = WEAKREF(patient)
		soft_reset()
		return

	if(!is_viable_patient(C, declare_crit = FALSE))
		previous_patient = WEAKREF(patient)
		soft_reset()
		return

	set_mode(BOT_HEALING)

	visible_message(span_warning("[src] is trying to inject [C]."))

	var/datum/callback/medicate_check = CALLBACK(src, PROC_REF(medicate_callback), C)
	while(TRUE)
		if(!patient)
			break

		var/reagent_type = is_viable_patient(C, declare_crit = FALSE)

		if(!reagent_type) //If they don't need any of that they're probably cured!
			if(C.maxHealth - C.get_organic_health() < heal_threshold)
				to_chat(src, span_notice("[C] is healthy! Your programming prevents you from tending the wounds of anyone without at least [heal_threshold] damage of any one type ([heal_threshold + 5] for oxygen damage.)"))

			visible_message(span_notice("[src] retracts it's syringe arm."))
			medbot_phrase(pick(finish_healing_phrases), C)
			bot_reset()
			return

		ADD_TRAIT(patient,TRAIT_MEDIBOTCOMINGTHROUGH, tag)
		addtimer(TRAIT_CALLBACK_REMOVE(patient, TRAIT_MEDIBOTCOMINGTHROUGH, tag), (30 SECONDS), TIMER_UNIQUE|TIMER_OVERRIDE)

		visible_message(span_warning("[src] is trying to inject [patient]."))

		if(!do_after(src, patient, heal_time, DO_PUBLIC, extra_checks = medicate_check, display = image('icons/obj/syringe.dmi', "syringe_0"))) //Slightly faster than default tend wounds, but does less HPS
			break

		var/datum/reagent/R = SSreagents.chemical_reagents_list[reagent_type]
		R.expose_mob(patient, injection_amount, methods = INJECT)
		patient.bloodstream.add_reagent(R.type, injection_amount)

		log_combat(src, patient, "injected", "internal tools", "([injection_amount]u [reagent_type][bot_cover_flags & BOT_COVER_EMAGGED ? " (EMAGGED)" : ""])")

		visible_message(span_notice("[src] injects [patient]."))

	visible_message(span_notice("[src] retracts it's syringe arm."))
	soft_reset()

/mob/living/simple_animal/bot/medbot/proc/medicate_callback(mob/living/carbon/target)
	if((get_dist(src, patient) > 1) || !(bot_mode_flags & BOT_MODE_ON) || !is_viable_patient(patient, declare_crit = FALSE))
		return FALSE
	return TRUE

/mob/living/simple_animal/bot/medbot/explode()
	var/atom/Tsec = drop_location()

	drop_part(medkit_type, Tsec)
	new /obj/item/assembly/prox_sensor(Tsec)
	drop_part(healthanalyzer, Tsec)

	if(bot_cover_flags & BOT_COVER_EMAGGED && prob(25))
		playsound(src, 'sound/voice/medbot/insult.ogg', 50)
	return ..()

/mob/living/simple_animal/bot/medbot/proc/declare(crit_patient)
	if(!COOLDOWN_FINISHED(src, last_patient_message))
		return
	COOLDOWN_START(src, last_patient_message, MEDBOT_PATIENTSPEAK_DELAY)

	var/area/location = get_area(crit_patient)
	speak("Medical emergency! [crit_patient] is in critical condition at [location]!", radio_channel)

/mob/living/simple_animal/bot/medbot/proc/medbot_phrase(phrase, mob/target)
	var/sound_path = all_phrases[phrase]
	if(target)
		phrase = replacetext(phrase, "%TARGET%", "[target]")

	speak(phrase)
	playsound(src, sound_path, 75, FALSE)

#undef MEDBOT_NEW_PATIENTSPEAK_DELAY
#undef MEDBOT_PATIENTSPEAK_DELAY
#undef MEDBOT_FREAKOUT_DELAY

#undef MEDBOT_PANIC_NONE
#undef MEDBOT_PANIC_LOW
#undef MEDBOT_PANIC_MED
#undef MEDBOT_PANIC_HIGH
#undef MEDBOT_PANIC_FUCK
#undef MEDBOT_PANIC_ENDING
#undef MEDBOT_PANIC_END
