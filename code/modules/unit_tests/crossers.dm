/datum/unit_test/crossers_sanity

/datum/unit_test/crossers_sanity/Run()
	var/obj/machinery/mineral/ore_redemption/ORM = allocate(/obj/machinery/mineral/ore_redemption)
	var/obj/item/stack/ore/gold/stack = allocate(/obj/item/stack/ore/gold)

	ORM.forceMove(get_step(run_loc_floor_bottom_left, NORTH))
	ORM.unregister_input_turf()
	ORM.input_dir = SOUTH
	ORM.register_input_turf()

	stack.moveToNullspace()
	stack.forceMove(run_loc_floor_bottom_left)

	TEST_ASSERT(QDELING(stack), "Stack was not qdeleted when entering ORM input turf.")
	TEST_ASSERT(stack.loc == null, "Stack is not in nullspace after entering ORM input turf.")
	TEST_ASSERT(!(stack in run_loc_floor_bottom_left.crossers), "Stack was found in ORM input turf crossers list.")
	TEST_ASSERT(isnull(run_loc_floor_bottom_left.crossers), "ORM input turf crossers list is not null. Contents: [json_encode(run_loc_floor_bottom_left.crossers)]")
