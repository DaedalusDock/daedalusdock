// A list of types that will not attempt to perform surgery if the user is on help intent.
GLOBAL_LIST_INIT(surgery_tool_exceptions, typecacheof(list(
	/obj/item/healthanalyzer,
	/obj/item/shockpaddles,
	/obj/item/reagent_containers/hypospray,
	/obj/item/modular_computer,
	/obj/item/reagent_containers/syringe,
	/obj/item/reagent_containers/borghypo
)))

/datum/surgery_step
	abstract_type = /datum/surgery_step
	var/name
	var/desc
	/// type path referencing tools that can be used for this step, and how well are they suited for it
	var/list/allowed_tools
	// type paths referencing races that this step applies to. All if null.
	var/list/allowed_species
	/// duration of the step
	var/min_duration = 0
	/// duration of the step
	var/max_duration = 0
	/// evil infection stuff that will make everyone hate me
	var/can_infect = 0
	/// How much blood this step can get on surgeon. 1 - hands, 2 - full body.
	var/blood_level = 0                  // How much blood this step can get on surgeon. 1 - hands, 2 - full body.
	/// How much pain to deliver to the patient
	var/pain_given =0
	/// if this step NEEDS stable optable or can be done on any valid surface with no penalty
	var/delicate = 0
	/// Various bitflags for requirements of the surgery.
	var/surgery_candidate_flags = 0      // Various bitflags for requirements of the surgery.
	/// Whether or not this surgery will be fuzzy on size requirements.
	var/strict_access_requirement = TRUE
	/// Does this step attempt to repeat itself after every success?
	var/looping = FALSE

	/// Sound to play during begin_step(). Can be a sound, and associative list of sound:path, or a flat list of sounds.
	var/preop_sound
	/// Sound to play on success.
	var/success_sound
	/// Sound to play on failure.
	var/failure_sound


/// Returns how well tool is suited for this step
/datum/surgery_step/proc/tool_potency(obj/item/tool)
	if(tool.tool_behaviour)
		. = allowed_tools["[tool.tool_behaviour]"]
		if(!isnull(.))
			return

	for (var/T in allowed_tools)
		if (istype(tool,T))
			return allowed_tools[T]
	return 0

/// Checks if the target is valid.
/datum/surgery_step/proc/is_valid_target(mob/living/carbon/human/H)
	if(!istype(H))
		return FALSE

	if(length(allowed_species))
		if(!(H.dna.species.type in allowed_species))
			return FALSE

	return TRUE

/// Checks if this surgery step can be performed with the given parameters.
/datum/surgery_step/proc/can_operate(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return is_valid_target(target) && assess_bodypart(user, target, target_zone, tool)

/datum/surgery_step/proc/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!istype(target) || !target_zone)
		return FALSE

	var/obj/item/bodypart/affected = target.get_bodypart(target_zone, TRUE)
	if(!affected)
		return FALSE

	// Check various conditional flags.
	if(((surgery_candidate_flags & SURGERY_NO_ROBOTIC) && !IS_ORGANIC_LIMB(affected)) || \
		((surgery_candidate_flags & SURGERY_NO_STUMP) && affected.is_stump)         || \
		((surgery_candidate_flags & SURGERY_NO_FLESH) && (IS_ORGANIC_LIMB(affected))))
		return FALSE

	// Check if the surgery target is accessible.
	if(!IS_ORGANIC_LIMB(affected))
		if(((surgery_candidate_flags & SURGERY_NEEDS_DEENCASEMENT) || \
			(surgery_candidate_flags & SURGERY_NEEDS_INCISION)      || \
			(surgery_candidate_flags & SURGERY_NEEDS_RETRACTED))    && \
			affected.hatch_state != HATCH_OPENED)
			return FALSE
	else
		var/open_threshold = 0
		if(surgery_candidate_flags & SURGERY_NEEDS_INCISION)
			open_threshold = SURGERY_OPEN

		else if(surgery_candidate_flags & SURGERY_NEEDS_RETRACTED)
			open_threshold = SURGERY_RETRACTED

		else if(surgery_candidate_flags & SURGERY_NEEDS_DEENCASEMENT)
			open_threshold = (affected.encased ? SURGERY_DEENCASED : SURGERY_RETRACTED)

		if(open_threshold && ((strict_access_requirement && affected.how_open() != open_threshold) || \
			affected.how_open() < open_threshold))
			return FALSE

	// Check if clothing is blocking access
	for(var/obj/item/I as anything in target.clothingonpart(affected))
		if(I.obj_flags & THICKMATERIAL)
			to_chat(user, span_notice("The material covering this area is too thick for you to do surgery through!"))
			return FALSE

	return affected

/datum/surgery_step/proc/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return TRUE

/// Does stuff to begin the step, usually just printing messages. Moved germs transfering and bloodying here too
/datum/surgery_step/proc/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	SHOULD_CALL_PARENT(TRUE)

	play_preop_sound(user, target, target_zone, tool)

	var/obj/item/bodypart/affected = target.get_bodypart(deprecise_zone(target_zone), TRUE)

	if (can_infect)
		spread_germs(user, affected)

	if(user && affected)
		if(ishuman(user) && prob(60) && (affected.bodypart_flags & BP_HAS_BLOOD))
			var/mob/living/carbon/human/H = user
			if (blood_level)
				H.blood_in_hands = blood_level

			if (blood_level > 1)
				user.add_mob_blood(target)

		if((ishuman(user) && user:gloves) && IS_ORGANIC_LIMB(affected))
			for(var/datum/disease/D as anything in user.diseases)
				if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
					target.ContactContractDisease(D)

			for(var/datum/disease/D as anything in target.diseases)
				if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
					user.ContactContractDisease(D)

	if(pain_given && !(HAS_TRAIT(target, TRAIT_NO_PAINSHOCK) || HAS_TRAIT(target, TRAIT_FAKEDEATH)) && !(affected.bodypart_flags & BP_NO_PAIN))
		target.apply_pain(pain_given, affected.body_zone, ignore_cd = TRUE)

	if (target.stat == UNCONSCIOUS && prob(20))
		to_chat(target, span_boldnotice("... [pick("bright light", "faraway pain", "something moving in you", "soft beeping")] ..."))
	return

// Does stuff to end the step, which is normally print a message + do whatever this step changes
/datum/surgery_step/proc/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	SHOULD_CALL_PARENT(TRUE)
	if(!success_sound)
		return
	playsound(get_turf(target), success_sound, 75, TRUE, falloff_exponent = 12, falloff_distance = 1)

// Stuff that happens when the step fails
/datum/surgery_step/proc/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	SHOULD_CALL_PARENT(TRUE)
	if(!failure_sound)
		return

	playsound(get_turf(target), failure_sound, 75, TRUE, falloff_exponent = 12, falloff_distance = 1)


/// The chance for success vs failure
/datum/surgery_step/proc/success_chance(mob/living/user, mob/living/carbon/human/target, obj/item/tool, target_zone)
	. = tool_potency(tool)
	if(user == target)
		. -= 10

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		. -= round(H.shock_stage / 2)
		if(H.eye_blurry)
			. -= 20
		if(H.eye_blind)
			. -= 60

	if(delicate)
		if(user.has_status_effect(/datum/status_effect/speech/slurring/drunk))
			. -= 10
		if(target.body_position == STANDING_UP)
			. -= 30
		var/turf/T = get_turf(target)

		if(locate(/obj/structure/table/optable, T))
			. -= 0
		else if(locate(/obj/structure/bed, T))
			. -= 5
		else if(locate(/obj/structure/table, T))
			. -= 10
		else if(locate(/obj/effect/rune, T))
			. -= 10

	. = max(., 0)

/datum/surgery_step/proc/play_preop_sound(mob/user, mob/living/carbon/target, target_zone, obj/item/tool)
	if(!preop_sound)
		return
	var/sound_file_use
	if(islist(preop_sound))
		if(!preop_sound[1]) //Test to see if the list is assoc
			sound_file_use = pick(preop_sound)

		for(var/typepath in preop_sound)//iterate and assign subtype to a list, works best if list is arranged from subtype first and parent last
			if(istype(tool, typepath))
				sound_file_use = preop_sound[typepath]
				break
	else
		sound_file_use = preop_sound
	playsound(get_turf(target), sound_file_use, 75, TRUE, falloff_exponent = 12, falloff_distance = 1)

/datum/surgery_step/proc/spread_germs(mob/living/carbon/user, obj/item/bodypart/BP)
	if(!istype(user) || !istype(BP))
		return

	if(!IS_ORGANIC_LIMB(BP))
		return

	var/germ_level = user.germ_level
	var/wearing_gloves = FALSE
	if(user.gloves)
		wearing_gloves = TRUE
		germ_level = user.gloves.germ_level

	germ_level = max(germ_level, BP.germ_level)
	if(!wearing_gloves)
		user.germ_level = germ_level
	else
		user.germ_level = germ_level

	BP.germ_level = germ_level //as funny as scrubbing microbes out with clean gloves is - no.

/// Attempt to perform a surgery step.
/obj/item/proc/attempt_surgery(mob/living/carbon/M, mob/living/user)
	// Check for the Hippocratic oath.
	if(!istype(M) || user.combat_mode || GLOB.surgery_tool_exceptions[type])
		return FALSE

	// Check for multi-surgery drifting.
	var/zone = deprecise_zone(user.zone_selected)
	if(LAZYACCESS(M.surgeries_in_progress, zone))
		to_chat(user, span_warning("You can't operate on this area while surgery is already in progress."))
		return TRUE

	// What surgeries does our tool/target enable?
	var/list/possible_surgeries
	for(var/datum/surgery_step/step in GLOB.surgeries_list)
		if(step.tool_potency(src) && step.can_operate(user, M, zone, src))
			LAZYSET(possible_surgeries, step, TRUE)

	// Which surgery, if any, do we actually want to do?
	var/datum/surgery_step/step
	if(LAZYLEN(possible_surgeries) == 1)
		step = possible_surgeries[1]

		#ifdef UNIT_TESTS
		if(!istype(step, user.desired_surgery))
			CRASH("User ended up with a surgery that wasn't the desied [user.desired_surgery]!")
		#endif

	else if(LAZYLEN(possible_surgeries) >= 1)
		if(user.client) // In case of future autodocs.
			step = input(user, "Which surgery would you like to perform?", "Surgery") as null|anything in possible_surgeries
			if(!step)
				return TRUE
		#ifdef UNIT_TESTS
		if(!step)
			step = locate(user.desired_surgery) in possible_surgeries
			if(!step)
				CRASH("Failed to find desired surgery [user.desired_surgery]!")
		#else
		if(!step)
			step = pick(possible_surgeries)
		#endif

	// We didn't find a surgery.
	if(!istype(step))
		return FALSE

	var/obj/item/bodypart/BP = M.get_bodypart(zone)
	if(BP?.bandage)
		to_chat(user, span_warning("You cannot operate on a bandaged bodypart, remove it!"))
		return TRUE

	if(M == user)
		if(user.zone_selected == BODY_ZONE_HEAD)
			to_chat(user, span_warning("You cannot operate on your own head!"))
			return TRUE
		var/hand = user.get_active_hand().body_zone
		if(user.zone_selected == hand)
			to_chat(src, span_warning("You cannot operate on that arm with that hand!"))
			return TRUE

	// Otherwise we can make a start on surgery!
	do_it_all_again:
	if(istype(M) && !QDELETED(M) && !user.combat_mode && (user.get_active_held_item() == src))
		// Double-check this in case it changed between initial check and now.
		if(zone in M.surgeries_in_progress)
			to_chat(user, span_warning("You can't operate on this area while surgery is already in progress."))

		else if(step.can_operate(user, M, zone, src))

			var/operation_data = step.pre_surgery_step(user, M, zone, src)

			if(!operation_data) // Surgery step recognized but failed for some reason, terminate attack chain.
				return TRUE

			LAZYSET(M.surgeries_in_progress, zone, operation_data)

			step.begin_step(user, M, zone, src)

			var/can_loop = FALSE
			#ifndef UNIT_TESTS
			var/duration = rand(step.min_duration, step.max_duration)
			#else
			var/duration = 0
			#endif
			if(do_after(user, M, duration, DO_PUBLIC, display = src))
				if (step.can_operate(user, M, zone, src))
					if(prob(step.success_chance(user, M, src, zone)))
						step.succeed_step(user, M, zone, src)
						handle_post_surgery()
						can_loop = TRUE
					else
						step.fail_step(user, M, zone, src)
				else
					to_chat(user, span_warning("The patient lost the target organ before you could finish operating!"))

			else
				step.fail_step(user, M, zone, src)

			if(!QDELETED(M))
				LAZYREMOVE(M.surgeries_in_progress, zone) // Clear the in-progress flag.
				/*if(ishuman(M))
					var/mob/living/carbon/human/H = M
					H.update_surgery()*/

			if(step.looping && can_loop)
				goto do_it_all_again

		return TRUE
	return FALSE

/obj/item/proc/handle_post_surgery()
	use(1)
	return

/mob/proc/can_operate_on(mob/living/target)
	var/turf/T = get_turf(target)

	if(target.body_position == LYING_DOWN)
		. = TRUE
	else if(locate(/obj/structure/table, T))
		. = TRUE
	else if(locate(/obj/structure/bed, T))
		. = TRUE
	else if(locate(/obj/effect/rune, T))
		. = TRUE

/mob/living/can_operate_on(mob/living/target, silent)
	if(combat_mode)
		return FALSE
	return ..()


/proc/get_location_accessible(mob/located_mob, location)
	var/covered_locations = 0 //based on body_parts_covered
	var/face_covered = 0 //based on flags_inv
	var/eyesmouth_covered = 0 //based on flags_cover
	if(iscarbon(located_mob))
		var/mob/living/carbon/clothed_carbon = located_mob
		for(var/obj/item/clothing/clothes in list(clothed_carbon.back, clothed_carbon.wear_mask, clothed_carbon.head))
			covered_locations |= clothes.body_parts_covered
			face_covered |= clothes.flags_inv
			eyesmouth_covered |= clothes.flags_cover
		if(ishuman(clothed_carbon))
			var/mob/living/carbon/human/clothed_human = clothed_carbon
			for(var/obj/item/clothes in list(clothed_human.wear_suit, clothed_human.w_uniform, clothed_human.shoes, clothed_human.belt, clothed_human.gloves, clothed_human.glasses, clothed_human.ears))
				covered_locations |= clothes.body_parts_covered
				face_covered |= clothes.flags_inv
				eyesmouth_covered |= clothes.flags_cover

	switch(location)
		if(BODY_ZONE_HEAD)
			if(covered_locations & HEAD)
				return FALSE
		if(BODY_ZONE_PRECISE_EYES)
			if(covered_locations & HEAD || face_covered & HIDEEYES || eyesmouth_covered & GLASSESCOVERSEYES)
				return FALSE
		if(BODY_ZONE_PRECISE_MOUTH)
			if(covered_locations & HEAD || face_covered & HIDEFACE || eyesmouth_covered & MASKCOVERSMOUTH || eyesmouth_covered & HEADCOVERSMOUTH)
				return FALSE
		if(BODY_ZONE_CHEST)
			if(covered_locations & CHEST)
				return FALSE
		if(BODY_ZONE_PRECISE_GROIN)
			if(covered_locations & GROIN)
				return FALSE
		if(BODY_ZONE_L_ARM)
			if(covered_locations & ARM_LEFT)
				return FALSE
		if(BODY_ZONE_R_ARM)
			if(covered_locations & ARM_RIGHT)
				return FALSE
		if(BODY_ZONE_L_LEG)
			if(covered_locations & LEG_LEFT)
				return FALSE
		if(BODY_ZONE_R_LEG)
			if(covered_locations & LEG_RIGHT)
				return FALSE
		if(BODY_ZONE_PRECISE_L_HAND)
			if(covered_locations & HAND_LEFT)
				return FALSE
		if(BODY_ZONE_PRECISE_R_HAND)
			if(covered_locations & HAND_RIGHT)
				return FALSE
		if(BODY_ZONE_PRECISE_L_FOOT)
			if(covered_locations & FOOT_LEFT)
				return FALSE
		if(BODY_ZONE_PRECISE_R_FOOT)
			if(covered_locations & FOOT_RIGHT)
				return FALSE

	return TRUE
