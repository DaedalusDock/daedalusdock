/datum/unit_test/mapping_standards/no_renamed_areas
	name = "MAPSTANDARDS: Areas must not be renamed"

	var/list/area/exempt_areas = list(
		//None
	)

/datum/unit_test/mapping_standards/no_renamed_areas/Run()
	if(..())
		return

	for(var/area/area in GLOB.areas)
		if(!(area.type in exempt_areas) && (area.name != initial(area.name)))
			// Unique areas might be worth exempting here? But at the same time, there's no throws here with no check. -Francinum
			TEST_FAIL("Area [area]/([initial(area.name)]) at [AREACOORD(area.contents[1])] (Unique: [BOOLEAN(area.area_flags & UNIQUE_AREA)]) has been renamed. ")
