/datum/unit_test/wounds/Run()
	var/mob/living/carbon/human/H = allocate(/mob/living/carbon/human)

	var/obj/item/bodypart/BP = H.get_bodypart(BODY_ZONE_CHEST)

	BP.receive_damage(15)
	TEST_ASSERT(BP.brute_dam != 0, "Bodypart failed to update brute damage.")
	TEST_ASSERT(H.getBruteLoss() != 0, "Human failed to update brute damage.")

	var/old_dam = BP.brute_dam
	var/old_human_dam = H.getBruteLoss()

	var/datum/wound/W = BP.wounds[1]
	W.open_wound(15)

	TEST_ASSERT(BP.brute_dam != old_dam, "Bodypart failed to update brute damage.")
	TEST_ASSERT(H.getBruteLoss() != old_human_dam, "Human failed to update brute damage.")
