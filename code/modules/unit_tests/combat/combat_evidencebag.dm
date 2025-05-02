/datum/unit_test/combat/evidencebag
	name = "COMBAT/FINGERPRINTS: Evidence Bags Shall Not Leave Fingerprints."

/datum/unit_test/combat/evidencebag/Run()
	var/mob/living/carbon/human/consistent/user = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/storage/evidencebag/bag = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/wrench/evidence = ALLOCATE_BOTTOM_LEFT()

	user.put_in_active_hand(bag)
	click_wrapper(user, evidence)

	TEST_ASSERT(evidence in bag, "Evidence bag did not pick up the wrench.")
	TEST_ASSERT(isnull(evidence.forensics?.fingerprints), "Wrench has fingerprints after being picked up.")

	var/turf/place_target = get_step(user, EAST)
	click_wrapper(user, place_target)

	TEST_ASSERT(!(evidence in bag), "Wrench did not leave the bag.")
	TEST_ASSERT(isnull(evidence.forensics?.fingerprints), "Wrench has fingerprints after being put down.")
