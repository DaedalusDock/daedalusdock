/obj/machinery/c4_embedded_controller/simple_door_control

	radio_frequency = FREQ_AIRLOCK_CONTROL

	default_operating_system = /datum/c4_file/terminal_program/operating_system/embedded/simple_door_control

	/// Target airlock ID
	var/target_tag

/obj/machinery/c4_embedded_controller/simple_door_control/setup_default_configuration(datum/c4_file/record/conf_db)
	var/datum/data/record/db_record = conf_db.stored_record

	db_record.fields[EC_CONFIG_ID_TAG_GENERIC] = target_tag
