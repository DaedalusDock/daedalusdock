/// Tests that airlocks can be closed by clicking on the floor, as [/datum/component/redirect_attack_hand_from_turf ] dictates
/datum/unit_test/combat/door_click
	name = "COMBAT/INTERACTION: Doors Shall Open and Close On Click."

/datum/unit_test/combat/door_click/Run()
	var/mob/living/carbon/human/consistent/tider = ALLOCATE_BOTTOM_LEFT()
	var/obj/machinery/door/airlock/public/glass/door = ALLOCATE_BOTTOM_LEFT()

	tider.forceMove(locate(door.x + 1, door.y, door.z))
	door.open() // this sleeps we just have to cope
	TEST_ASSERT(!door.operating, "Airlock was operating after being opened.")
	TEST_ASSERT(!door.density, "Airlock was not open after being opened.")
	click_wrapper(tider, get_turf(door))
	TEST_ASSERT(door.operating, "Airlock was not closing after clicking the turf below, as per /datum/component/redirect_attack_hand_from_turf.")
