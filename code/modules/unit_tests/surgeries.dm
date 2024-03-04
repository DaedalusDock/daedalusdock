/mob
	/// We use this during unit testing to force a specific surgery by an uncliented mob.
	var/desired_surgery

/datum/unit_test/amputation/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)
	var/obj/structure/table/table = allocate(/obj/structure/table/optable)

	table.forceMove(get_turf(patient)) //Not really needed but it silences the linter and gives insurance

	var/obj/item/circular_saw/saw = allocate(/obj/item/circular_saw)

	TEST_ASSERT_EQUAL(patient.get_missing_limbs().len, 0, "Patient is somehow missing limbs before surgery.")
	user.desired_surgery = /datum/surgery_step/generic_organic/amputate
	patient.set_lying_down()
	user.zone_selected = BODY_ZONE_R_ARM

	user.put_in_active_hand(saw)
	saw.melee_attack_chain(user, patient)

	TEST_ASSERT_EQUAL(patient.get_missing_limbs().len, 1, "Patient did not lose any limbs.")
	TEST_ASSERT_EQUAL(patient.get_missing_limbs()[1], BODY_ZONE_R_ARM, "Patient is missing a limb that isn't the one we operated on.")

/datum/unit_test/limb_attach/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)
	var/obj/structure/table/table = allocate(/obj/structure/table/optable)
	var/obj/item/fixovein/fixovein = allocate(/obj/item/fixovein)

	table.forceMove(get_turf(patient)) //Not really needed but it silences the linter and gives insurance

	var/obj/item/bodypart/BP = patient.get_bodypart(BODY_ZONE_R_ARM)
	BP.dismember(silent = TRUE, clean = TRUE)
	TEST_ASSERT(!patient.get_bodypart(BODY_ZONE_R_ARM), "Patient did not lose limb to dismember()")
	TEST_ASSERT((BP.bodypart_flags & BP_CUT_AWAY), "Arm did not gain CUT_AWAY flag after dismemberment")

	patient.set_lying_down()
	user.desired_surgery = /datum/surgery_step/limb/attach
	user.zone_selected = BODY_ZONE_R_ARM
	user.put_in_active_hand(BP)
	BP.melee_attack_chain(user, patient)

	TEST_ASSERT(patient.get_bodypart(BODY_ZONE_R_ARM), "Patient did not regain arm after attack chain.")
	TEST_ASSERT((BP.bodypart_flags & BP_CUT_AWAY), "Arm lost CUT_AWAY flag after attachment")

	user.desired_surgery = /datum/surgery_step/limb/connect
	user.put_in_active_hand(fixovein)
	fixovein.melee_attack_chain(user, patient)

	TEST_ASSERT(!(BP.bodypart_flags & BP_CUT_AWAY), "Arm did not lose CUT_AWAY flag after connection.")
	TEST_ASSERT(patient.usable_hands == 2, "Patient's hand was not usable after connection.")


/datum/unit_test/tend_wounds/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)
	var/obj/structure/table/table = allocate(/obj/structure/table/optable)
	var/obj/item/hemostat/hemostat = allocate(/obj/item/hemostat)

	table.forceMove(get_turf(patient)) //Not really needed but it silences the linter and gives insurance

	var/obj/item/bodypart/BP = patient.get_bodypart(BODY_ZONE_CHEST)
	BP.receive_damage(BP.max_damage, modifiers = NONE)
	TEST_ASSERT(BP.get_damage() == BP.max_damage, "Patient did not take [BP.max_damage] damage, took [BP.get_damage()]")

	patient.set_lying_down()
	user.zone_selected = BODY_ZONE_CHEST
	user.desired_surgery = /datum/surgery_step/tend_wounds
	user.put_in_active_hand(hemostat)
	hemostat.melee_attack_chain(user, patient)

	TEST_ASSERT(BP.get_damage() <= BP.max_damage * 0.25, "Chest did not heal to less than [BP.max_damage/2], healed to [BP.get_damage()]")

/datum/unit_test/test_retraction/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)
	var/obj/structure/table/table = allocate(/obj/structure/table/optable)
	var/obj/item/scalpel/scalpel = allocate(__IMPLIED_TYPE__)
	var/obj/item/retractor/retractor = allocate(__IMPLIED_TYPE__)
	var/obj/item/circular_saw/saw = allocate(__IMPLIED_TYPE__)

	table.forceMove(get_turf(patient)) //Not really needed but it silences the linter and gives insurance
	patient.set_lying_down()

	for(var/zone in list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		var/obj/item/bodypart/BP = patient.get_bodypart(zone)

		user.zone_selected = zone
		user.desired_surgery = /datum/surgery_step/generic_organic/incise
		user.put_in_active_hand(scalpel)
		scalpel.melee_attack_chain(user, patient)

		TEST_ASSERT(BP.how_open() == SURGERY_OPEN, "[parse_zone(zone)] was not incised.")

		user.desired_surgery = /datum/surgery_step/generic_organic/retract_skin
		user.drop_all_held_items()
		user.put_in_active_hand(retractor)
		retractor.melee_attack_chain(user, patient)

		TEST_ASSERT(BP.how_open() == SURGERY_RETRACTED, "[parse_zone(zone)]'s incision was not widened (Openness: [BP.how_open()]).")

		if(BP.encased)
			user.desired_surgery = /datum/surgery_step/open_encased
			user.drop_all_held_items()
			user.put_in_active_hand(saw)
			saw.melee_attack_chain(user, patient)

			TEST_ASSERT(BP.how_open() == SURGERY_DEENCASED, "[parse_zone(zone)] was not de-encased (Openness: [BP.how_open()]).")

		user.drop_all_held_items()
		patient.fully_heal()
