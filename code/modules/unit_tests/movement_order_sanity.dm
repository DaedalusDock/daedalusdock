/datum/unit_test/movement_order_sanity/Run()
	var/obj/movement_tester/test_obj = allocate(__IMPLIED_TYPE__, run_loc_floor_bottom_left)
	var/list/movement_cache = test_obj.movement_order

	var/obj/movement_interceptor = allocate(__IMPLIED_TYPE__, locate(run_loc_floor_bottom_left.x + 1, run_loc_floor_bottom_left.y, run_loc_floor_bottom_left.z))

	step(test_obj, EAST)

	TEST_ASSERT(length(movement_cache) == 4, "Movement order was not the expected value of 4, got: [length(movement_cache)].\n[jointext(movement_cache, "\n")]")
	TEST_ASSERT(findtext(movement_cache[1], "Moving from"),"Movement did not begin with a Move attempt.\n[jointext(movement_cache, "\n")]")
	TEST_ASSERT(findtext(movement_cache[2], "Moved from"),"Movement step 2 was not a Moved() call.\n[jointext(movement_cache, "\n")]")
	TEST_ASSERT(findtext(movement_cache[3], "Moving from"),"Movement step 3 was a Move attempt.\n[jointext(movement_cache, "\n")]")
	TEST_ASSERT(findtext(movement_cache[4], "Moved from"),"Movement step 4 was not a Moved() call.\n[jointext(movement_cache, "\n")]")

/obj/movement_tester
	name = "movement debugger"
	var/list/movement_order = list()

/obj/movement_tester/Move(atom/newloc, direct, glide_size_override, z_movement_flags)
	movement_order += "Moving from ([loc.x], [loc.y]) to [newloc ? "([newloc.x], [newloc.y])" : "NULL"]"
	return ..()

/obj/movement_tester/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	movement_order += "Moved from ([old_loc.x], [old_loc.y]) to [loc ? "([loc.x], [loc.y])" : "NULL"]"
	return ..()

/obj/movement_interceptor
	name = "movement interceptor"

/obj/movement_interceptor/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/connect_loc, list(COMSIG_ATOM_ENTERED, PROC_REF(on_crossed)))

/obj/movement_interceptor/proc/on_crossed(datum/source, atom/movable/arrived)
	SIGNAL_HANDLER
	qdel(arrived)
