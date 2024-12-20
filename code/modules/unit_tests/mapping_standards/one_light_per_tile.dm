/datum/unit_test/mapping_standards/lights_per_tile
	name = "MAPSTANDARDS: Tiles should have only one light"

/datum/unit_test/mapping_standards/lights_per_tile/Run()
	if(..()) {return};

	var/list/turf/checked_turfs = list()
	var/list/turf/failed_turfs = list()

	for(var/obj/machinery/light/fixture in INSTANCES_OF(/obj/machinery/light))
		if(!(get_area(fixture) in GLOB.the_station_areas))
			continue //Skip non-station lights.

		var/turf/light_turf = get_turf(fixture)
		if(light_turf in checked_turfs)

			if(light_turf in failed_turfs)
				continue //We've already reported this tile.

			failed_turfs.Add(light_turf)

			var/light_count = 0
			for(var/obj/machinery/light/_counter in light_turf)
				light_count++
			TEST_FAIL("[light_count] lights on tile at [AREACOORD(light_turf)]")
			continue //Continue, we've already added it to the list.

		checked_turfs.Add(light_turf)
