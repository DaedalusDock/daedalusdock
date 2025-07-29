/obj/machinery/c4_embedded_controller/airlock_access
	abstract_type = /obj/machinery/c4_embedded_controller/airlock_access

	default_operating_system = /datum/c4_file/terminal_program/operating_system/rtos/access_door

	radio_frequency = FREQ_AIRLOCK_CONTROL
	autolink_capable = TRUE

	/// Target airlock ID
	var/tag_target
	/// Request-Exit Button ID
	var/tag_request_exit
	/// Airlock open duration
	var/dwell_time
	/// Is this door allowed to be held open (Press * while unlocked)
	var/allow_lock_open = TRUE
	/// Control mode: 1 - Secure Open/Close (Airlock), 2 - Toggle Bolts (Soft Security)
	var/control_mode
	/// Slaved pad ID.
	var/tag_slave

/obj/machinery/c4_embedded_controller/airlock_access/secure
	dwell_time = 10
	control_mode = RTOS_CMODE_SECURE

/obj/machinery/c4_embedded_controller/airlock_access/bolt
	dwell_time = 0
	control_mode = RTOS_CMODE_BOLTS

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/c4_embedded_controller/airlock_access/secure, 24)
MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/c4_embedded_controller/airlock_access/bolt, 24)

/obj/machinery/c4_embedded_controller/airlock_access/setup_default_configuration(datum/c4_file/record/conf_db, obj/item/disk/data/floppy)
	. = ..()
	var/list/fields = conf_db.stored_record.fields


	fields[RTOS_CONFIG_AIRLOCK_ID] = tag_target
	fields[RTOS_CONFIG_REQUEST_EXIT_ID] = tag_request_exit
	fields[RTOS_CONFIG_HOLD_OPEN_TIME] = dwell_time
	fields[RTOS_CONFIG_ALLOW_HOLD_OPEN] = allow_lock_open
	fields[RTOS_CONFIG_CMODE] = control_mode
	fields[RTOS_CONFIG_SLAVE_ID] = tag_slave


