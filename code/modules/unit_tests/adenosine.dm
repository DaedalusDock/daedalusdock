/datum/unit_test/adenosine/Run()
	var/mob/living/carbon/human/victim = ALLOCATE_BOTTOM_LEFT()

	TEST_ASSERT(!victim.undergoing_cardiac_arrest(), "Wtf why is a freshly spawned human undergoing cardiac arrest.")

	victim.bloodstream.add_reagent(/datum/reagent/medicine/adenosine, 7)

	for(var/i in 1 to 7)
		victim.Life(SSmobs.wait)

	TEST_ASSERT(victim.undergoing_cardiac_arrest(), "Mob heart did not stop during the first 7 cycles.")

	victim.Life(SSmobs.wait)

	TEST_ASSERT(!victim.undergoing_cardiac_arrest(), "Mob heart did not restart on 8th cycle.")
