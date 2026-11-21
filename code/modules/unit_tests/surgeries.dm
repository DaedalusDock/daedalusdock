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

	var/expected_damage = /datum/surgery_step/tend_wounds::cant_heal_below
	TEST_ASSERT(BP.get_damage() == expected_damage, "Chest did not heal to [expected_damage], healed to [BP.get_damage()]")

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

/datum/unit_test/test_repair_organ/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)
	var/obj/structure/table/table = allocate(/obj/structure/table/optable)
	var/obj/item/scalpel/scalpel = allocate(__IMPLIED_TYPE__)
	var/obj/item/retractor/retractor = allocate(__IMPLIED_TYPE__)
	var/obj/item/circular_saw/saw = allocate(__IMPLIED_TYPE__)
	var/obj/item/stack/medical/suture/suture = allocate(__IMPLIED_TYPE__)

	table.forceMove(get_turf(patient)) //Not really needed but it silences the linter and gives insurance
	patient.set_lying_down()

	var/obj/item/organ/liver/patient_liver = patient.getorganslot(ORGAN_SLOT_LUNGS)
	patient_liver.applyOrganDamage(20)

	var/obj/item/bodypart/chest/patient_chest = patient.get_bodypart(BODY_ZONE_CHEST)

	user.zone_selected = BODY_ZONE_CHEST
	user.desired_surgery = /datum/surgery_step/generic_organic/incise
	user.put_in_active_hand(scalpel)
	scalpel.melee_attack_chain(user, patient)

	TEST_ASSERT(patient_chest.how_open() == SURGERY_OPEN, "[parse_zone(user.zone_selected)] was not incised.")

	user.desired_surgery = /datum/surgery_step/generic_organic/retract_skin
	user.drop_all_held_items()
	user.put_in_active_hand(retractor)
	retractor.melee_attack_chain(user, patient)

	TEST_ASSERT(patient_chest.how_open() == SURGERY_RETRACTED, "[parse_zone(user.zone_selected)]'s incision was not widened (Openness: [patient_chest.how_open()]).")

	user.desired_surgery = /datum/surgery_step/open_encased
	user.drop_all_held_items()
	user.put_in_active_hand(saw)
	saw.melee_attack_chain(user, patient)

	TEST_ASSERT(patient_chest.how_open() == SURGERY_DEENCASED, "[parse_zone(user.zone_selected)] was not de-encased (Openness: [patient_chest.how_open()]).")

	user.desired_surgery = /datum/surgery_step/internal/fix_organ
	user.drop_all_held_items()
	user.put_in_active_hand(suture)
	suture.melee_attack_chain(user, patient)

	TEST_ASSERT(patient_liver.damage == 0, "Liver damage value was not zero, instead it was [patient_liver.damage].")

/// success_modifier() must return the modifiers it calculates.
/datum/unit_test/surgery_success_modifier/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)
	var/obj/item/bonesetter/bonesetter = allocate(/obj/item/bonesetter)
	var/datum/surgery_step/bone/set_bone/step = locate() in GLOB.surgeries_list
	TEST_ASSERT_NOTNULL(step, "Could not find the set bone surgery step")

	patient.set_lying_down()
	var/floor_modifier = step.success_modifier(user, patient, bonesetter, BODY_ZONE_CHEST)
	TEST_ASSERT(floor_modifier < 0, "Delicate surgery on the floor had a modifier of [floor_modifier], expected a penalty")

	allocate(/obj/structure/table/optable, get_turf(patient))
	var/table_modifier = step.success_modifier(user, patient, bonesetter, BODY_ZONE_CHEST)
	TEST_ASSERT(table_modifier > 0, "Delicate surgery on an operating table had a modifier of [table_modifier], expected a bonus")

/// Attach limb must only accept a limb that matches the targeted zone.
/datum/unit_test/surgery_attach_limb_zone/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)
	var/datum/surgery_step/limb/attach/step = locate() in GLOB.surgeries_list
	TEST_ASSERT_NOTNULL(step, "Could not find the attach limb surgery step")

	var/obj/item/bodypart/arm = patient.get_bodypart(BODY_ZONE_R_ARM)
	arm.dismember(silent = TRUE, clean = TRUE)
	var/obj/item/bodypart/leg/left/leg = allocate(/obj/item/bodypart/leg/left)

	TEST_ASSERT(!step.can_operate(user, patient, BODY_ZONE_R_ARM, leg), "A leg could be attached to the right arm slot")
	TEST_ASSERT(step.can_operate(user, patient, BODY_ZONE_R_ARM, arm), "The right arm could not be attached to the right arm slot")

/// Robotic repair steps must actually heal the right damage type.
/datum/unit_test/surgery_robotic_repair/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)
	var/obj/item/bodypart/arm/left/robot/robot_arm = allocate(/obj/item/bodypart/arm/left/robot)
	robot_arm.replace_limb(patient, TRUE)
	robot_arm.hatch_state = HATCH_OPENED

	// Repair damage to prosthetic: heals brute.
	var/datum/surgery_step/robotics/repair_brute/repair_brute = locate() in GLOB.surgeries_list
	var/obj/item/weldingtool/welder = allocate(/obj/item/weldingtool)
	robot_arm.receive_damage(40, modifiers = NONE)
	var/brute_before = robot_arm.brute_dam
	TEST_ASSERT(brute_before > 0, "Robotic arm took no brute damage")
	repair_brute.succeed_step(user, patient, BODY_ZONE_L_ARM, welder)
	TEST_ASSERT(robot_arm.brute_dam < brute_before, "Repair damage to prosthetic did not heal brute damage")

	// Repair third degree burns (robotic): heals burn, not brute.
	robot_arm.heal_damage(1000, 1000)
	var/datum/surgery_step/tend_wounds/robotic/burn/tend_burn = locate() in GLOB.surgeries_list
	var/obj/item/stack/cable_coil/cable = allocate(/obj/item/stack/cable_coil)
	robot_arm.receive_damage(30, 40, modifiers = NONE)
	brute_before = robot_arm.brute_dam
	var/burn_before = robot_arm.burn_dam
	tend_burn.succeed_step(user, patient, BODY_ZONE_L_ARM, cable)
	TEST_ASSERT(robot_arm.burn_dam < burn_before, "Robotic burn repair did not heal burn damage")
	TEST_ASSERT_EQUAL(robot_arm.brute_dam, brute_before, "Robotic burn repair healed brute damage")

/// Cavity space must be based on the size of the items already inside.
/datum/unit_test/surgery_cavity_volume/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)
	var/datum/surgery_step/cavity/place_item/step = locate() in GLOB.surgeries_list
	var/obj/item/bodypart/chest = patient.get_bodypart(BODY_ZONE_CHEST)
	chest.cavity = TRUE

	// Fill the cavity past capacity with items of the maximum size.
	var/max_volume = 7 * (chest.cavity_storage_max_weight - 1)
	var/item_volume = (chest.cavity_storage_max_weight - 1) ** 2
	for(var/i in 1 to (max_volume / item_volume) + 1)
		var/obj/item/filler = allocate(/obj/item)
		filler.w_class = chest.cavity_storage_max_weight
		filler.forceMove(chest)
		chest.add_cavity_item(filler)

	var/obj/item/tiny = allocate(/obj/item)
	tiny.w_class = WEIGHT_CLASS_TINY
	TEST_ASSERT(!step.pre_surgery_step(user, patient, BODY_ZONE_CHEST, tiny), "An item fit into a cavity that was already over capacity")

/// Sterilize wound should accept strong alcohol and reject plain liquids.
/datum/unit_test/surgery_sterilize_alcohol/Run()
	var/datum/surgery_step/sterilize_wound/step = locate() in GLOB.surgeries_list

	var/obj/item/reagent_containers/cup/beaker/booze = allocate(/obj/item/reagent_containers/cup/beaker)
	booze.reagents.add_reagent(/datum/reagent/consumable/ethanol/hooch, 10)
	TEST_ASSERT(step.check_chemicals(booze), "Strong alcohol was not accepted for sterilization")

	var/obj/item/reagent_containers/cup/beaker/water = allocate(/obj/item/reagent_containers/cup/beaker)
	water.reagents.add_reagent(/datum/reagent/water, 10)
	TEST_ASSERT(!step.check_chemicals(water), "Water was accepted for sterilization")
