/// Tests the droppper picks up and dispenses reagents correctly.
/datum/unit_test/reagents/dropper_use

/datum/unit_test/reagents/dropper_use/Run()
	var/mob/living/carbon/human/consistent/chemist = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/reagent_containers/dropper/dropper = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/reagent_containers/glass/beaker/large/beaker = ALLOCATE_BOTTOM_LEFT()

	var/starting_volume = 50
	beaker.reagents.add_reagent(/datum/reagent/water, starting_volume)

	chemist.put_in_active_hand(dropper)
	click_wrapper(chemist, beaker)

	TEST_ASSERT_EQUAL(dropper.reagents.total_volume, 5, "Dropper should have taken 5 units of reagents from the beaker.")
	TEST_ASSERT_EQUAL(beaker.reagents.total_volume, starting_volume - 5, "Beaker should have transferred reagents to the dropper.")

	click_wrapper(chemist, beaker)

	TEST_ASSERT_EQUAL(dropper.reagents.total_volume, 0, "Dropper should have emptied itself into the beaker.")
	TEST_ASSERT_EQUAL(beaker.reagents.total_volume, starting_volume, "Beaker should have received reagents from the dropper.")
