/datum/unit_test/mapping_standards/no_renamed_areas
	name = "MAPSTANDARDS: Areas must not be renamed"

	var/list/area/exempt_areas = list(
		//None
	)

/datum/unit_test/mapping_standards/no_renamed_areas/Run()
	if(..()) {return};

	for(var/area/area in GLOB.areas)
		if(area.name != initial(area.name))
			TEST_FAIL("Area [area]/([initial(area.name)]) (Unique: [!!(area.area_flags & UNIQUE_AREA)]) has been renamed. ")
