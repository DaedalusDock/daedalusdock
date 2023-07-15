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
	BP.dismember(clean = TRUE)
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
	BP.receive_damage(150)
	TEST_ASSERT(BP.get_damage() == 150, "Patient did not take 150 damage, took [BP.get_damage()]")

	patient.set_lying_down()
	user.zone_selected = BODY_ZONE_CHEST
	user.desired_surgery = /datum/surgery_step/tend_wounds
	user.put_in_active_hand(hemostat)
	hemostat.melee_attack_chain(user, patient)

	TEST_ASSERT(BP.get_damage() <= BP.max_damage * 0.25, "Chest did not heal to less than [BP.max_damage/2], healed to [BP.get_damage()]")

/*
/datum/unit_test/brain_surgery/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	patient.gain_trauma_type(BRAIN_TRAUMA_MILD, TRAUMA_RESILIENCE_SURGERY)
	patient.setOrganLoss(ORGAN_SLOT_BRAIN, 20)

	TEST_ASSERT(patient.has_trauma_type(), "Patient does not have any traumas, despite being given one")

	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)

	var/datum/surgery_step/fix_brain/fix_brain = new
	fix_brain.success(user, patient)

	TEST_ASSERT(!patient.has_trauma_type(), "Patient kept their brain trauma after brain surgery")
	TEST_ASSERT(patient.getOrganLoss(ORGAN_SLOT_BRAIN) < 20, "Patient did not heal their brain damage after brain surgery")

/datum/unit_test/head_transplant/Run()
	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/alice = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/bob = allocate(/mob/living/carbon/human)

	alice.fully_replace_character_name(null, "Alice")
	bob.fully_replace_character_name(null, "Bob")

	var/obj/item/bodypart/head/alices_head = alice.get_bodypart(BODY_ZONE_HEAD)
	alices_head.drop_limb()

	var/obj/item/bodypart/head/bobs_head = bob.get_bodypart(BODY_ZONE_HEAD)
	bobs_head.drop_limb()

	TEST_ASSERT_EQUAL(alice.get_bodypart(BODY_ZONE_HEAD), null, "Alice still has a head after dismemberment")
	TEST_ASSERT_EQUAL(alice.get_visible_name(), "Unknown", "Alice's head was dismembered, but they are not Unknown")

	TEST_ASSERT_EQUAL(bobs_head.real_name, "Bob", "Bob's head does not remember that it is from Bob")

	// Put Bob's head onto Alice's body
	var/datum/surgery_step/add_prosthetic/add_prosthetic = new
	user.put_in_active_hand(bobs_head)
	add_prosthetic.success(user, alice, BODY_ZONE_HEAD, bobs_head)

	TEST_ASSERT(!isnull(alice.get_bodypart(BODY_ZONE_HEAD)), "Alice has no head after prosthetic replacement")
	TEST_ASSERT_EQUAL(alice.get_visible_name(), "Bob", "Bob's head was transplanted onto Alice's body, but their name is not Bob")

/datum/unit_test/multiple_surgeries/Run()
	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/patient_zero = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/patient_one = allocate(/mob/living/carbon/human)

	var/obj/item/scalpel/scalpel = allocate(/obj/item/scalpel)

	var/datum/surgery_step/incise/surgery_step = new
	var/datum/surgery/organ_manipulation/surgery_for_zero = new(patient_zero, BODY_ZONE_CHEST, patient_zero.get_bodypart(BODY_ZONE_CHEST))

	INVOKE_ASYNC(surgery_step, TYPE_PROC_REF(/datum/surgery_step, initiate), user, patient_zero, BODY_ZONE_CHEST, scalpel, surgery_for_zero)
	TEST_ASSERT(surgery_for_zero.step_in_progress, "Surgery on patient zero was not initiated")

	var/datum/surgery/organ_manipulation/surgery_for_one = new(patient_one, BODY_ZONE_CHEST, patient_one.get_bodypart(BODY_ZONE_CHEST))

	// Without waiting for the incision to complete, try to start a new surgery
	TEST_ASSERT(!surgery_step.initiate(user, patient_one, BODY_ZONE_CHEST, scalpel, surgery_for_one), "Was allowed to start a second surgery without the rod of asclepius")
	TEST_ASSERT(!surgery_for_one.step_in_progress, "Surgery for patient one is somehow in progress, despite not initiating")

	user.apply_status_effect(/datum/status_effect/hippocratic_oath)
	INVOKE_ASYNC(surgery_step, TYPE_PROC_REF(/datum/surgery_step, initiate), user, patient_one, BODY_ZONE_CHEST, scalpel, surgery_for_one)
	TEST_ASSERT(surgery_for_one.step_in_progress, "Surgery on patient one was not initiated, despite having rod of asclepius")

/// Ensures that the tend wounds surgery can be started
/datum/unit_test/start_tend_wounds

/datum/unit_test/start_tend_wounds/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)

	var/datum/surgery/surgery = new /datum/surgery/healing/brute/basic

	if (!surgery.can_start(user, patient))
		TEST_FAIL("Can't start basic tend wounds!")

	qdel(surgery)

/datum/unit_test/tend_wounds/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	patient.take_overall_damage(100, 100)

	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)

	// Test that tending wounds actually lowers damage
	var/datum/surgery_step/heal/brute/basic/basic_brute_heal = new
	basic_brute_heal.success(user, patient, BODY_ZONE_CHEST)
	TEST_ASSERT(patient.getBruteLoss() < 100, "Tending brute wounds didn't lower brute damage ([patient.getBruteLoss()])")

	var/datum/surgery_step/heal/burn/basic/basic_burn_heal = new
	basic_burn_heal.success(user, patient, BODY_ZONE_CHEST)
	TEST_ASSERT(patient.getFireLoss() < 100, "Tending burn wounds didn't lower burn damage ([patient.getFireLoss()])")
*/
