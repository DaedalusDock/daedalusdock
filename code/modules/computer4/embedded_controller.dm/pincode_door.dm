/obj/machinery/c4_embedded_controller/airlock_pinpad
	name = "pinpad"

	default_operating_system = /datum/c4_file/terminal_program/operating_system/rtos/pincode_door

	radio_frequency = FREQ_AIRLOCK_CONTROL
	/// Target airlock ID
	var/target_tag
	/// Request-Exit Button ID
	var/request_exit_tag
	/// Airlock open duration
	var/dwell_time = 10 SECONDS
	/// Is this door allowed to be held open (Press * while unlocked)
	var/allow_lock_open = TRUE
	/// Static pin ID to use.
	var/static_pin_id
	/// Static pin length.
	var/static_pin_length = 4
	/// Manually assigned pin number. Ignores static pin config. Auto-calculates length.
	var/forced_pin


/obj/machinery/c4_embedded_controller/airlock_pinpad/setup_default_configuration(datum/c4_file/record/conf_db, obj/item/disk/data/floppy)
	. = ..()
	var/list/fields = conf_db.stored_record.fields

	var/final_pin = forced_pin
	if(!final_pin && static_pin_id)
		final_pin = SSid_access.get_static_pincode(static_pin_id, static_pin_length)

	// If there's still no pin it'll just ask you to set one.
	fields[RTOS_CONFIG_AIRLOCK_ID] = target_tag
	fields[RTOS_CONFIG_REQUEST_EXIT_ID] = request_exit_tag
	fields[RTOS_CONFIG_HOLD_OPEN_TIME] = dwell_time
	fields[RTOS_CONFIG_ALLOW_HOLD_OPEN] = allow_lock_open
	fields[RTOS_CONFIG_PINCODE] = final_pin


/obj/item/disk/data/floppy/ec_test/airlock_pinpad

	preloaded_programs = list(/datum/c4_file/terminal_program/operating_system/rtos/pincode_door)

/obj/item/disk/data/floppy/ec_test/airlock_pinpad/Initialize(mapload)
	. = ..()
	var/datum/c4_file/record/rec = new()
	rec.name = RTOS_CONFIG_FILE
	root.try_add_file(rec)
	var/list/fields = rec.stored_record.fields
	fields[RTOS_CONFIG_HOLD_OPEN_TIME] = 10
	fields[RTOS_CONFIG_ALLOW_HOLD_OPEN] = TRUE
	fields[RTOS_CONFIG_AIRLOCK_ID] = INCINERATOR_ATMOS_AIRLOCK_INTERIOR

