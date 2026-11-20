/// Deconstructing a structure should refund at most its resource cost.
/datum/unit_test/flock/deconstruct_refund

/datum/unit_test/flock/deconstruct_refund/Run()
	var/turf/T = run_loc_floor_top_right
	var/obj/structure/flock/interceptor/structure = allocate(/obj/structure/flock/interceptor, T, flock)
	var/cost = structure.resource_cost
	TEST_ASSERT(cost > 0, "Test structure has no resource cost")
	TEST_ASSERT_EQUAL(structure.get_integrity_percentage(), 100, "Test structure was not at full integrity")

	structure.deconstruct(TRUE)

	var/obj/item/flock_cube/cube = locate() in T
	TEST_ASSERT_NOTNULL(cube, "Deconstructing a structure did not drop a cube")
	TEST_ASSERT_EQUAL(cube.substrate, cost, "Full integrity deconstruction refunded the wrong amount")

/// Damaged structures should show a health notice that uses an existing icon state.
/datum/unit_test/flock/structure_health_notice

/datum/unit_test/flock/structure_health_notice/Run()
	var/obj/structure/flock/interceptor/structure = allocate(/obj/structure/flock/interceptor, run_loc_floor_top_right, flock)
	structure.take_damage(structure.max_integrity * 0.27)

	var/percent = structure.get_integrity_percentage()
	TEST_ASSERT(percent < 100 && percent > 0, "Structure did not take partial damage, at [percent]%")

	var/datum/atom_hud/alternate_appearance/basic/flock/notice = structure.get_alt_appearance(FLOCK_NOTICE_HEALTH)
	TEST_ASSERT_NOTNULL(notice, "Damaged structure had no health notice")
	TEST_ASSERT_EQUAL(notice.image.icon_state, "hp-[clamp(round(percent, 10), 10, 100)]", "Structure health notice used the wrong icon state at [percent]%")

/// A completed tealprint should build a structure in the tealprint's flock.
/datum/unit_test/flock/tealprint_keeps_flock

/datum/unit_test/flock/tealprint_keeps_flock/Run()
	var/turf/T = run_loc_floor_top_right
	var/obj/structure/flock/tealprint/tealprint = allocate(/obj/structure/flock/tealprint, T, flock, /obj/structure/flock/interceptor)
	TEST_ASSERT(!QDELETED(tealprint), "Tealprint failed to initialize")

	tealprint.substrate.add_points(tealprint.substrate.get_max_points())

	var/obj/structure/flock/interceptor/built = locate() in T
	TEST_ASSERT_NOTNULL(built, "Completed tealprint did not build its structure")
	allocated += built
	TEST_ASSERT_EQUAL(built.flock, flock, "Tealprint built its structure in the wrong flock")
