/obj/machinery/c4_embedded_controller/simple_door_control

	radio_frequency = FREQ_AIRLOCK_CONTROL

	default_operating_system = /datum/c4_file/terminal_program/operating_system/rtos/simple_door_control

	/// Target airlock ID
	var/tag_target

/obj/machinery/c4_embedded_controller/simple_door_control/setup_default_configuration(datum/c4_file/record/conf_db, obj/item/disk/data/floppy)
	var/datum/data/record/db_record = conf_db.stored_record

	db_record.fields[RTOS_CONFIG_ID_TAG_GENERIC] = tag_target

/obj/item/disk/data/floppy/doorcon_test

	preloaded_programs = list(/datum/c4_file/terminal_program/operating_system/rtos/simple_door_control)

/obj/item/disk/data/floppy/doorcon_test/Initialize(mapload)
	. = ..()
	var/datum/c4_file/record/rec = new()
	rec.name = RTOS_CONFIG_FILE
	root.try_add_file(rec)
