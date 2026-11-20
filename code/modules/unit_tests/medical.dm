// Regression tests for the human medical model: pain, shock, blood, organs, wounds and germs.

/// Fractional pain amounts must still map onto a pain class.
/datum/unit_test/pain_class_fractional/Run()
	TEST_ASSERT_EQUAL(pain_class(0), PAIN_CLASS_NONE, "pain_class(0) was not NONE")
	TEST_ASSERT_EQUAL(pain_class(0.4), PAIN_CLASS_NEGLIGIBLE, "Any pain above zero should be at least NEGLIGIBLE")
	TEST_ASSERT_EQUAL(pain_class(PAIN_AMT_LOW - 0.5), PAIN_CLASS_LOW, "pain just below PAIN_AMT_LOW fell between switch cases")
	TEST_ASSERT_EQUAL(pain_class(PAIN_AMT_MEDIUM - 0.5), PAIN_CLASS_MEDIUM, "pain just below PAIN_AMT_MEDIUM fell between switch cases")
	TEST_ASSERT_EQUAL(pain_class(PAIN_AMT_AGONIZING - 0.5), PAIN_CLASS_AGONIZING, "pain just below PAIN_AMT_AGONIZING fell between switch cases")

/// Pain slowdown should apply when in pain, not when pain-free.
/datum/unit_test/pain_slowdown/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)

	patient.handle_pain(SSMOBS_DT)
	TEST_ASSERT(!patient.has_movespeed_modifier(/datum/movespeed_modifier/pain), "Pain-free human received the pain slowdown")

	patient.apply_pain(50, BODY_ZONE_CHEST)
	patient.handle_pain(SSMOBS_DT)
	TEST_ASSERT(patient.has_movespeed_modifier(/datum/movespeed_modifier/pain), "Human in pain ([patient.getPain()]) did not receive the pain slowdown")

/// Negative pain with no zone should reduce pain instead of doing nothing.
/datum/unit_test/pain_unzoned_healing/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)

	patient.apply_pain(80)
	var/pain_before = patient.getPain()
	TEST_ASSERT(pain_before > 0, "Unzoned pain was not applied")

	patient.apply_pain(-40)
	TEST_ASSERT(patient.getPain() < pain_before, "Unzoned negative pain did not reduce pain ([pain_before] -> [patient.getPain()])")

/// Shock recovery: pain between 25% and 50% of the shock stage should use the middle recovery rate.
/datum/unit_test/shock_recovery_tiers/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)

	patient.traumatic_shock_stage = 100
	patient.apply_pain(30, BODY_ZONE_CHEST)
	var/pain = patient.getPain()
	TEST_ASSERT(pain >= 25 && pain < 50, "Test setup produced unexpected pain value [pain]")

	patient.handle_shock(SSMOBS_DT)
	var/recovered = 100 - patient.traumatic_shock_stage
	// Recovery is 3, doubled to 6 on a successful roll.
	TEST_ASSERT(recovered == 3 || recovered == 6, "Shock recovered by [recovered] with pain [pain] at stage 100, expected 3 or 6")

/// Mob-to-mob blood transfer should give the recipient the blood the donor lost.
/datum/unit_test/blood_transfusion/Run()
	var/mob/living/carbon/human/donor = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/recipient = allocate(/mob/living/carbon/human)

	recipient.dna.blood_type = donor.dna.blood_type
	donor.setBloodVolume(BLOOD_VOLUME_NORMAL)
	recipient.setBloodVolume(300)

	TEST_ASSERT(donor.transfer_blood_to(recipient, 50), "transfer_blood_to() failed")
	TEST_ASSERT_EQUAL(donor.blood_volume, BLOOD_VOLUME_NORMAL - 50, "Donor did not lose the transferred blood")
	TEST_ASSERT_EQUAL(recipient.blood_volume, 350, "Recipient did not gain the transferred blood")

/// The heartbeat sound should not alternate between fast and slow while the pulse stays fast.
/datum/unit_test/heartbeat_sound_stable/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/obj/item/organ/heart/heart = patient.getorganslot(ORGAN_SLOT_HEART)

	patient.traumatic_shock_stage = SHOCK_TIER_3 // Makes the heart audible
	heart.pulse = PULSE_2FAST

	heart.handle_heartbeat()
	TEST_ASSERT_EQUAL(heart.beat, BEAT_FAST, "Fast pulse did not play the fast heartbeat")
	heart.handle_heartbeat()
	TEST_ASSERT_EQUAL(heart.beat, BEAT_FAST, "Fast heartbeat switched to slow on the next tick")

/// Jitter should make the heartbeat audible.
/datum/unit_test/heartbeat_jitter/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/obj/item/organ/heart/heart = patient.getorganslot(ORGAN_SLOT_HEART)

	patient.traumatic_shock_stage = 0
	heart.pulse = PULSE_NORM

	heart.handle_heartbeat()
	TEST_ASSERT_EQUAL(heart.beat, BEAT_NONE, "Heartbeat was audible without shock or jitter; the test turf may be low pressure")

	patient.set_timed_status_effect(10 SECONDS, /datum/status_effect/jitter)
	heart.handle_heartbeat()
	TEST_ASSERT_EQUAL(heart.beat, BEAT_SLOW, "Jitter did not make the heartbeat audible")

/// Organ threshold messages: the high threshold cleared message must be reachable.
/datum/unit_test/organ_threshold_messages/Run()
	var/obj/item/organ/heart/heart = allocate(/obj/item/organ/heart)
	TEST_ASSERT_EQUAL(heart.damage_threshold_message(ORGAN_HIGH_THRESHOLD_CLEARED), heart.high_threshold_cleared, "ORGAN_HIGH_THRESHOLD_CLEARED did not return high_threshold_cleared")
	TEST_ASSERT_EQUAL(heart.damage_threshold_message(ORGAN_HIGH_THRESHOLD_PASSED), heart.high_threshold_passed, "ORGAN_HIGH_THRESHOLD_PASSED did not return high_threshold_passed")

/// Organ scan results should compare damage against thresholds scaled by max health.
/datum/unit_test/organ_scan_results/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/obj/item/organ/heart/heart = patient.getorganslot(ORGAN_SLOT_HEART)

	heart.setOrganDamage(1)
	var/list/results = heart.get_scan_results(FALSE)
	TEST_ASSERT(!("Severely Damaged" in results), "A heart with 1 damage scanned as Severely Damaged")
	TEST_ASSERT(!("Mildly Damaged" in results), "A heart with 1 damage scanned as Mildly Damaged")

	heart.setOrganDamage(heart.maxHealth * heart.high_threshold + 1)
	results = heart.get_scan_results(FALSE)
	TEST_ASSERT("Severely Damaged" in results, "A heart past its high threshold did not scan as Severely Damaged")

	heart.setOrganDamage(0)
	heart.germ_level = INFECTION_LEVEL_TWO + 10
	results = heart.get_scan_results(FALSE)
	TEST_ASSERT("Acute Infection" in results, "Germ level just above INFECTION_LEVEL_TWO did not scan as Acute Infection: [jointext(results, ", ")]")
	heart.germ_level = 0

/// create_wound_easy() should merge into one wound and return the surviving wound.
/datum/unit_test/wound_easy_merge/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/obj/item/bodypart/arm = patient.get_bodypart(BODY_ZONE_L_ARM)

	var/datum/wound/first = arm.create_wound_easy(/datum/wound/cut/small, 5)
	var/datum/wound/second = arm.create_wound_easy(/datum/wound/cut/small, 5)

	TEST_ASSERT(!QDELETED(second), "create_wound_easy() returned a deleted wound after merging")
	TEST_ASSERT_EQUAL(second, first, "create_wound_easy() did not return the wound it merged into")
	TEST_ASSERT_EQUAL(first.damage, 10, "Merged wound damage was wrong")
	TEST_ASSERT_EQUAL(length(arm.wounds), 1, "Merged wound left extra wounds on the limb")

/// Healing a limb must not push cremation progress below zero or reset it.
/datum/unit_test/cremation_progress_heal/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/obj/item/bodypart/arm = patient.get_bodypart(BODY_ZONE_R_ARM)

	arm.cremation_progress = 10
	arm.heal_damage(5, 5)
	TEST_ASSERT_EQUAL(arm.cremation_progress, 10, "Healing an undamaged limb changed its cremation progress")

/// Limbs that can't be disabled (such as the chest) must still react to TRAIT_NOBLEED.
/datum/unit_test/chest_nobleed/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/obj/item/bodypart/chest = patient.get_bodypart(BODY_ZONE_CHEST)

	chest.set_sever_artery(TRUE)
	TEST_ASSERT(chest.cached_bleed_rate > 0, "Severed chest artery did not bleed")

	ADD_TRAIT(patient, TRAIT_NOBLEED, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT_EQUAL(chest.cached_bleed_rate, 0, "Chest kept bleeding after gaining TRAIT_NOBLEED")

	REMOVE_TRAIT(patient, TRAIT_NOBLEED, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(chest.cached_bleed_rate > 0, "Chest did not resume bleeding after losing TRAIT_NOBLEED")

/// A frozen limb must not process germs.
/datum/unit_test/frozen_limb_germs/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/obj/item/bodypart/leg = patient.get_bodypart(BODY_ZONE_L_LEG)

	ADD_TRAIT(leg, TRAIT_ORGAN_FROZEN, TRAIT_SOURCE_UNIT_TESTS)
	var/germs = INFECTION_LEVEL_THREE + 10
	leg.germ_level = germs
	leg.update_germs()

	TEST_ASSERT_EQUAL(leg.germ_level, germs, "Frozen limb's germ level changed")
	TEST_ASSERT(!(leg.bodypart_flags & BP_NECROTIC), "Frozen limb became necrotic")

/// Puncture wounds should be able to become infected.
/datum/unit_test/puncture_infection/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human)
	var/obj/item/bodypart/leg = patient.get_bodypart(BODY_ZONE_R_LEG)

	// 100 damage means a 100% infection chance for an untreated wound.
	var/datum/wound/puncture = leg.create_wound_easy(/datum/wound/puncture/massive, 100)
	TEST_ASSERT(puncture.infection_check(), "Large untreated puncture wound could not become infected")

/// Detached limbs and organs must not runtime when their bones break or they are EMP'd.
/datum/unit_test/detached_medical_runtimes/Run()
	var/obj/item/bodypart/arm/left/arm = allocate(/obj/item/bodypart/arm/left)
	arm.break_bones(FALSE)
	TEST_ASSERT(arm.bodypart_flags & BP_BROKEN_BONES, "Detached arm did not break")
	arm.heal_bones()

	var/obj/item/organ/heart/cybernetic/heart = allocate(/obj/item/organ/heart/cybernetic)
	heart.emp_act(EMP_HEAVY)

	var/obj/item/organ/lungs/cybernetic/lungs = allocate(/obj/item/organ/lungs/cybernetic)
	lungs.emp_act(EMP_HEAVY)
