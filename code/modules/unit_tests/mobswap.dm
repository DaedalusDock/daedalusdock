/datum/unit_test/mob_swap_grab
	name = "BUMPSWAP: Swapping Shall Break Grabs Under Correct Conditions"

/datum/unit_test/mob_swap_grab/Run()
	var/mob/living/carbon/human/grabbed = ALLOCATE_BOTTOM_LEFT()
	var/mob/living/carbon/human/grabber = ALLOCATE_BOTTOM_LEFT()
	var/mob/living/carbon/human/bumped = ALLOCATE_BOTTOM_LEFT()

	grabber.forceMove(get_step(grabber, EAST))
	grabbed.forceMove(get_step(grabber, EAST))

	grabber.try_make_grab(grabbed)

	TEST_ASSERT(grabber.is_grabbing(grabbed), "Grabber failed to grab the target.")

	step(grabber, WEST)

	TEST_ASSERT(grabber.loc == run_loc_floor_bottom_left, "Grabber did not end up on the correct turf.")
	TEST_ASSERT(!grabber.is_grabbing(grabbed, "Grab did not release after shuffling away."))

/datum/unit_test/mob_swap_grab_inverse
	name = "BUMPSWAP: Swapping Shall Not Break Grabs Under Correct Conditions"

/datum/unit_test/mob_swap_grab_inverse/Run()
	var/mob/living/carbon/human/grabbed = ALLOCATE_BOTTOM_LEFT()
	var/mob/living/carbon/human/grabber = ALLOCATE_BOTTOM_LEFT()
	var/mob/living/carbon/human/bumped = ALLOCATE_BOTTOM_LEFT()

	grabber.forceMove(get_step(grabber, EAST))
	grabbed.forceMove(get_step(grabber, NORTH))

	grabber.try_make_grab(grabbed)

	TEST_ASSERT(grabber.is_grabbing(grabbed), "Grabber failed to grab the target.")

	step(grabber, WEST)

	TEST_ASSERT(grabber.loc == run_loc_floor_bottom_left, "Grabber did not end up on the correct turf.")
	TEST_ASSERT(grabber.is_grabbing(grabbed, "Grab released after shuffling, despite being adjacent still."))

