/datum/unit_test/mapping_standards/enforce_count/doors
	abstract_type = /datum/unit_test/mapping_standards/enforce_count/doors

/datum/unit_test/mapping_standards/enforce_count/doors/get_collection()
	return INSTANCES_OF(/obj/machinery/door)

/datum/unit_test/mapping_standards/enforce_count/doors/airlock
	name = "MAPSTANDARDS: Tiles Must Have At Most 1 Airlock"
	checked_type = /obj/machinery/door/airlock
	failed_name = "Airlocks"

/datum/unit_test/mapping_standards/enforce_count/doors/firedoor
	name = "MAPSTANDARDS: Tiles Must Have At Most 1 Firedoor"
	checked_type = /obj/machinery/door/firedoor
	failed_name = "Firedoors"

/datum/unit_test/mapping_standards/enforce_count/doors/blastdoor
	name = "MAPSTANDARDS: Tiles Must Have At Most 1 Blast Door"
	checked_type = /obj/machinery/door/poddoor
	failed_name = "Blast Doors"
