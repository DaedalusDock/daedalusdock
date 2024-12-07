/datum/unit_test/can_reach_range/Run()
	var/mob/living/carbon/human/user = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/wrench/wrench = ALLOCATE_BOTTOM_LEFT()

	TEST_ASSERT(wrench.IsReachableBy(user), "Wrench was not reachable by mob on the same turf.")

	wrench.forceMove(get_step(wrench, EAST))
	TEST_ASSERT(wrench.IsReachableBy(user), "Wrench was not reachable by mob within 1-turf range.")

	wrench.forceMove(get_step(wrench, EAST))
	TEST_ASSERT(!wrench.IsReachableBy(user), "Wrench was reachable over 1 turf away.")

/datum/unit_test/can_reach_adjacency
	var/east_turf_type
	var/north_turf_type

/datum/unit_test/can_reach_adjacency/Run()
	var/mob/living/carbon/human/user = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/wrench/wrench = ALLOCATE_BOTTOM_LEFT()

	wrench.forceMove(locate(run_loc_floor_bottom_left.x + 1, run_loc_floor_bottom_left.y + 1, run_loc_floor_bottom_left.z))

	var/turf/east_turf = get_step(run_loc_floor_bottom_left, EAST)
	var/turf/north_turf = get_step(run_loc_floor_bottom_left, NORTH)

	east_turf_type = east_turf.type
	north_turf_type = north_turf.type

	east_turf.ChangeTurf(/turf/closed/wall)
	TEST_ASSERT(wrench.IsReachableBy(user), "Wrench was not reachable despite only one direction being blocked.")

	north_turf.ChangeTurf(/turf/closed/wall)
	TEST_ASSERT(!wrench.IsReachableBy(user), "Wrench was reachable despite both directions being blocked.")


/datum/unit_test/can_reach_adjacency/Destroy()
	var/turf/east_turf = get_step(run_loc_floor_bottom_left, EAST)
	var/turf/north_turf = get_step(run_loc_floor_bottom_left, NORTH)
	east_turf.ChangeTurf(east_turf_type)
	north_turf.ChangeTurf(north_turf_type)
	return ..()

/datum/unit_test/can_reach_depth/Run()
	var/mob/living/carbon/human/user = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/wrench/wrench = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/storage/box/box = ALLOCATE_BOTTOM_LEFT()
	var/obj/item/storage/backpack/backpack = ALLOCATE_BOTTOM_LEFT()

	// Storage depth 1
	wrench.forceMove(backpack)
	TEST_ASSERT(wrench.IsReachableBy(user), "Wrench was not reachable inside of backpack.")

	// Storage depth 2
	box.forceMove(backpack)
	wrench.forceMove(box)
	TEST_ASSERT(!wrench.IsReachableBy(user, depth = REACH_DEPTH_SELF), "Wrench was reachable inside of box inside of backpack, despite only searching a depth of 1.")
