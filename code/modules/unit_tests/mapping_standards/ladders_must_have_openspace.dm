
// Ensure openspace between two linked ladders.
// There's an edge case here bay solves with 'allowed_directions'
// If you encounter it, well. Good luck and god help you -Francinum

/datum/unit_test/mapping_standards/ladders_must_have_openspace
	name = "MAPSTANDARDS: Ladders must have openspace"

/datum/unit_test/mapping_standards/ladders_must_have_openspace/Run()
	if(..())
		return

	for(var/obj/structure/ladder/ladder as anything in INSTANCES_OF(/obj/structure/ladder))
		if(ladder.down && (!isopenspaceturf(get_turf(ladder))))
			TEST_FAIL("Ladder with down linkage is not on openspace turf, at: [AREACOORD(ladder)]")
