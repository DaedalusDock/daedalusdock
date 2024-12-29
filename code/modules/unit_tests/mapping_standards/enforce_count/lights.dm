/datum/unit_test/mapping_standards/enforce_count/lights
	name = "MAPSTANDARDS: Tiles Must Have At Most 1 Light"

	checked_type = /obj/machinery/light
	failed_name = "Lights"

/datum/unit_test/mapping_standards/enforce_count/lights/get_collection()
	return INSTANCES_OF(/obj/machinery/light)
