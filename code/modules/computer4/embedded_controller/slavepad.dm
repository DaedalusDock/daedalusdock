/obj/machinery/c4_embedded_controller/slave
	name = /obj/machinery/c4_embedded_controller/airlock_pinpad::name
	desc = /obj/machinery/c4_embedded_controller/airlock_pinpad::desc

	radio_frequency = FREQ_AIRLOCK_CONTROL
	default_operating_system = /datum/c4_file/terminal_program/operating_system/rtos/slave
	autolink_capable = TRUE

	// Uses standard id_tag var

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/c4_embedded_controller/slave, 24)

/obj/machinery/c4_embedded_controller/slave/setup_default_configuration(datum/c4_file/record/conf_db, obj/item/disk/data/floppy)
	var/list/fields = conf_db.stored_record.fields

	fields[RTOS_CONFIG_ID_TAG_GENERIC] = id_tag
