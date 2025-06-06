#define MAX_PIN_LENGTH 9 // | * * * * * * * * * |

#define STATE_SET_PIN "SET"
#define STATE_AWAIT_PIN "AWAIT"
#define STATE_AUTOCLOSE "AUTO"
#define STATE_DOORSTOP "HOLD"

#define ROW_HEADER 1
#define ROW_PINOUT 2
#define ROW_STATUS 3

#define AC_COMMAND_OPEN 1
#define AC_COMMAND_CLOSE 2

/datum/c4_file/terminal_program/operating_system/rtos/pincode_door
	name = "pinworks-v1"

	/// Target airlock ID
	var/target_tag
	/// Request-Exit Button ID
	var/request_exit_tag
	/// Airlock open duration
	var/dwell_time
	/// Is this door allowed to be held open (Press * while unlocked)
	var/allow_lock_open
	/// Pin to compare to, if null, we need to collect one.
	var/correct_pin
	/// Pin buffer
	var/pin_buffer
	/// Pin length
	var/pin_length

	/// Current state machine state
	var/tmp/current_state
	/// Current airlock state from update packets. If it's mismatched, we correct our state.
	var/tmp/airlock_state

	/// Door autoclose timer
	COOLDOWN_DECLARE(door_timer)
	/// Timestamp for 4-second grace period.
	var/command_time

/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/populate_memory(datum/c4_file/record/conf_record)
	var/list/fields = conf_record.stored_record.fields

	target_tag = fields[RTOS_CONFIG_AIRLOCK_ID]
	request_exit_tag = fields[RTOS_CONFIG_REQUEST_EXIT_ID] //OPTIONAL
	dwell_time = fields[RTOS_CONFIG_HOLD_OPEN_TIME]
	allow_lock_open = fields[RTOS_CONFIG_ALLOW_HOLD_OPEN] //OPTIONAL
	correct_pin = fields[RTOS_CONFIG_PINCODE] //OPTIONAL
	pin_length = length(correct_pin)
	if(correct_pin) //If we don't have a known pin, get ready to learn one.
		current_state = STATE_AWAIT_PIN
	else
		current_state = STATE_SET_PIN

	if((pin_length > MAX_PIN_LENGTH) || (dwell_time > 99))
		halt(RTOS_HALT_DATA_TOO_LONG, "CFG_OVERRUN")
		return TRUE

	// there *HAS* to be a better way than this but it's 3am
	if(target_tag && dwell_time && allow_lock_open)
		return
	halt(RTOS_HALT_BAD_CONFIG, "BAD_CONFIG")
	return TRUE

/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/finish_startup()


	var/obj/item/peripheral/network_card/wireless/wcard = get_computer()?.get_peripheral(PERIPHERAL_TYPE_WIRELESS_CARD)
	wcard.listen_mode = WIRELESS_FILTER_ID_TAGS
	wcard.id_tags = list(target_tag, request_exit_tag)

	print_history = new /list(RTOS_OUTPUT_ROWS)

	update_screen()

/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/tick(delta_time)
	if(!is_operational())
		return
	if(current_state == STATE_AUTOCLOSE)
		if(COOLDOWN_FINISHED(src, door_timer))
			close_door()
			return
		fast_update_doortimer(TRUE)
	// 4-second grace period for commands and packets to go through.
	if(airlock_state && ((command_time + 4 SECONDS) < world.time))

		var/static/list/state_lut = list(
			STATE_SET_PIN =   "closed",
			STATE_AWAIT_PIN = "closed",
			STATE_AUTOCLOSE = "open",
			STATE_DOORSTOP =  "open"
		)
		if(state_lut[current_state] != airlock_state)
			// If the airlock isn't open, complain.
			halt(RTOS_HALT_STATE_VIOLATION, "CHECK_AIRLOCK")
			return
	return



/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/proc/update_screen()
	if(!is_operational())
		return

	// Header Row

	var/static/list/headers = list(
		//                "--------------------"
		STATE_SET_PIN =   " > PLEASE SET PIN < ",
		STATE_AWAIT_PIN = " > INPUT PIN CODE < ",
	//	STATE_AUTOCLOSE = " ! DOOR OPEN: %SS ! ",
		STATE_DOORSTOP =  " # DOOR HELD OPEN # "
	)

	if(current_state == STATE_AUTOCLOSE)
		fast_update_doortimer(FALSE)
	else
		print_history[ROW_HEADER] = headers[current_state]


	// Pinout / countdown row
	var/write_buffer = "" //Shared write buffer.
	switch(current_state)
		if(STATE_SET_PIN, STATE_AWAIT_PIN)
			draw_pin_dots(FALSE)
		if(STATE_AUTOCLOSE)


			if(allow_lock_open)
				write_buffer = "  PRESS # FOR HOLD  "
			else
				write_buffer = " DOOR HOLD DISABLED "

			print_history[ROW_PINOUT] = write_buffer

		if(STATE_DOORSTOP)
			print_history[ROW_PINOUT] = "  PRESS # TO CLOSE  "
		else
			halt(RTOS_HALT_STATE_VIOLATION, "BAD_STATE")
			return

	// Status Row

	var/static/list/status_rows = list(
		//                "--------------------"
		STATE_SET_PIN =   " * - SET || # - CLR ",
		STATE_AWAIT_PIN = "* - SUBMIT | # - CLR",
		STATE_AUTOCLOSE = "   * TO CLOSE NOW   ",
		STATE_DOORSTOP =  "   * TO CLOSE NOW   "
	)

	print_history[ROW_STATUS] = status_rows[current_state]
	redraw_screen(TRUE)

/// Draws the pin position indicators, Cut out for cleanliness so it can be called in std_in().
/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/proc/draw_pin_dots(redraw = TRUE)
	var/list/char_list = list()
	#warn THIS ROUTINE SUCKS. NEED TO WRITE A SPACE-CENTERING HELPER.
	var/buffer_len = length(pin_buffer)
	//If we're setting the pin, show an illusory extra empty position.
	var/left_to_print = min((max(buffer_len, pin_length) + (current_state == STATE_SET_PIN)), MAX_PIN_LENGTH)
	while(left_to_print)
		if(buffer_len)
			char_list += "#"
			buffer_len--
		else
			char_list += "-"
		left_to_print--
	print_history[ROW_PINOUT] = fixed_center(jointext(char_list, " "), 20) //One last padding space.
	if(redraw)
		redraw_screen(TRUE)

/// Calculate the door open header, Cut out so it can safely be placed in tick()
/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/proc/fast_update_doortimer(redraw = TRUE)
	if(current_state != STATE_AUTOCLOSE)
		return

	var/seconds_left = "[round((COOLDOWN_TIMELEFT(src, door_timer)*0.1))]"
	print_history[ROW_HEADER] = " ! DOOR OPEN: [fit_with_zeros(seconds_left, 2)]S ! "

	if(redraw)
		redraw_screen(TRUE)

/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/std_in(text)
	. = ..()
	if(text2num(text))
		return pin_input(text)

	switch(current_state)
		if(STATE_SET_PIN)
			if(text == "*")
				//Write to the config file
				var/datum/c4_file/record/conf_file = get_file(RTOS_CONFIG_FILE)
				correct_pin = pin_buffer
				pin_length = length(correct_pin)
				conf_file.stored_record.fields[RTOS_CONFIG_PINCODE] = pin_buffer
				pin_buffer = ""
				current_state = STATE_AWAIT_PIN
				update_screen(TRUE)
			else // "#"
				pin_buffer = "" //Reset the buffer

		if(STATE_AWAIT_PIN)
			if(text == "*")
				if(pin_buffer == correct_pin)
					open_door()
					pin_buffer = ""
				else
					#warn play a buzz here or smth
					pin_buffer = ""
					draw_pin_dots(TRUE)
			else // "#"
				pin_buffer = ""
				draw_pin_dots(TRUE)

		if(STATE_AUTOCLOSE)
			if(text == "*")
				close_door()
			else // "#"
				if(allow_lock_open)
					doorstop()

		if(STATE_DOORSTOP)
			if(text == "*")
				close_door()

			else // "#"
				open_door(TRUE)

/// Open the door, sets state to autoclose and starts the cooldown.
/// `skip_open` - Skip opening the door.
/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/proc/open_door(skip_open = FALSE)

	if(!skip_open)
		control_airlock(AC_COMMAND_OPEN)

	command_time = world.time
	current_state = STATE_AUTOCLOSE
	COOLDOWN_START(src, door_timer, (dwell_time SECONDS))
	update_screen()
	return


/// Closes the door, sets state to await pin.
/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/proc/close_door()
	if(!(current_state in list(STATE_AUTOCLOSE, STATE_DOORSTOP)))
		halt(RTOS_HALT_STATE_VIOLATION, "BAD_STATE")

	command_time = world.time
	control_airlock(AC_COMMAND_CLOSE)
	current_state = STATE_AWAIT_PIN
	update_screen()
	return

/// (if allowed) stop the timer and hold the door open.
/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/proc/doorstop()
	if((current_state != STATE_AUTOCLOSE) && (!allow_lock_open))
		halt(RTOS_HALT_STATE_VIOLATION, "BAD_STATE")

	COOLDOWN_RESET(src, door_timer)
	current_state = STATE_DOORSTOP
	update_screen()
	return

/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/proc/pin_input(text)
	var/effective_max_length = pin_length || MAX_PIN_LENGTH
	switch(current_state)
		if(STATE_SET_PIN, STATE_AWAIT_PIN)
			if(length(pin_buffer) == effective_max_length)
				return //Drop the overrunning character.
			pin_buffer += text
			draw_pin_dots(TRUE)
		else //We don't care.
			return

/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/peripheral_input(obj/item/peripheral/invoker, command, datum/signal/packet)
	. = ..()
	if(command == PERIPHERAL_CMD_RECEIVE_PACKET)
		handle_packet(packet)

/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/proc/handle_packet(datum/signal/packet)
	var/list/data = packet.data
	if(!data["tag"])
		return //what
	if((data["tag"] == target_tag) && data["timestamp"])
		//State update from airlock
		airlock_state = packet.data["door_status"]
		return

	if((data["tag"] == request_exit_tag) && (current_state == STATE_AWAIT_PIN))
		// Request to exit, Attempt to open the door if in valid state.
		open_door()
		return




/// Send airlock control packet.
/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/proc/control_airlock(airlock_command)
	var/datum/signal/signal
	switch(airlock_command)
		if(AC_COMMAND_OPEN)
			signal = new(
				src,
				list(
					"tag" = target_tag,
					PACKET_CMD = "secure_open"
				)
			)
		if(AC_COMMAND_CLOSE)
			signal = new(
				src,
				list(
					"tag" = target_tag,
					PACKET_CMD = "secure_close"
				)
			)
	if(signal)
		post_signal(signal, RADIO_AIRLOCK)

/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/on_close(datum/c4_file/terminal_program/operating_system/thinkdos/system)
	. = ..()

	// Cleanliness
	target_tag = null
	request_exit_tag = null
	dwell_time = null
	allow_lock_open = null
	correct_pin = null
	pin_length = null


#undef MAX_PIN_LENGTH
#undef STATE_SET_PIN
#undef STATE_AWAIT_PIN
#undef STATE_AUTOCLOSE
#undef STATE_DOORSTOP
#undef ROW_HEADER
#undef ROW_PINOUT
#undef ROW_STATUS
#undef AC_COMMAND_OPEN
#undef AC_COMMAND_CLOSE
