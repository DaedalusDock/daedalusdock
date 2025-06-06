#define MAX_PIN_LENGTH 9 // | * * * * * * * * * |

#define STATE_SET_PIN "SET"
#define STATE_AWAIT_PIN "AWAIT"
#define STATE_AUTOCLOSE "AUTO"
#define STATE_DOORSTOP "HOLD"

#define ROW_HEADER 1
#define ROW_PINOUT 2
#define ROW_STATUS 3

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

	var/tmp/current_state

	COOLDOWN_DECLARE(door_timer)

/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/populate_memory(datum/c4_file/record/conf_record)
	. = ..()
	var/list/fields = conf_record.stored_record.fields

	target_tag = fields[RTOS_CONFIG_AIRLOCK_ID]
	request_exit_tag = fields[RTOS_CONFIG_REQUEST_EXIT_ID]
	dwell_time = fields[RTOS_CONFIG_HOLD_OPEN_TIME]
	allow_lock_open = fields[RTOS_CONFIG_ALLOW_HOLD_OPEN]
	correct_pin = fields[RTOS_CONFIG_PINCODE]
	pin_length = length(correct_pin)
	if(correct_pin) //If we don't have a known pin, get ready to learn one.
		current_state = STATE_AWAIT_PIN
	else
		current_state = STATE_SET_PIN

	if((pin_length > MAX_PIN_LENGTH) || (dwell_time > 99))
		halt(RTOS_HALT_DATA_TOO_LONG, "CFG_OVERRUN")
		return TRUE

	// there *HAS* to be a better way than this but it's 3am
	if(target_tag && request_exit_tag && dwell_time && allow_lock_open)
		halt(RTOS_HALT_BAD_CONFIG, "BAD_CONFIG")
		return TRUE

/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/finish_startup()


	var/obj/item/peripheral/network_card/wireless/wcard = get_computer()?.get_peripheral(PERIPHERAL_TYPE_WIRELESS_CARD)
	wcard.listen_mode = WIRELESS_FILTER_ID_TAGS
	wcard.id_tags = list(target_tag, request_exit_tag)

	print_history = new /list(RTOS_OUTPUT_ROWS)

	update_screen()

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
			//Going to slip in the header replace rq:
			print_history[ROW_HEADER]
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

/// Draws the pin position indicators, Cut out for cleanliness so it can be called in std_in().
/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/proc/draw_pin_dots(redraw = TRUE)
	var/write_buffer = ""
	#warn THIS ROUTINE SUCKS. NEED TO WRITE A SPACE-CENTERING HELPER.
	//If we're setting the pin, show an illusory extra empty position.
	var/buffer_len = min((length(pin_buffer) + (current_state == STATE_SET_PIN)), MAX_PIN_LENGTH)
	var/left_to_print = pin_length
	while(left_to_print)
		if(buffer_len)
			write_buffer += " #"
			buffer_len--
		else
			write_buffer += " -"
		left_to_print--
	print_history[ROW_PINOUT] = write_buffer+" " //One last padding space.
	if(redraw)
		redraw_screen(TRUE)

/// Calculate the door open header, Cut out so it can safely be placed in tick()
/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/proc/fast_update_doortimer(redraw = TRUE)
	if(current_state != STATE_AUTOCLOSE)
		return

	var/seconds_left = (COOLDOWN_TIMELEFT(src, door_timer)*0.1)
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
				conf_file.stored_record.fields[RTOS_CONFIG_PINCODE] = pin_buffer
			else // "#"
				pin_buffer = "" //Reset the buffer
		if(STATE_AWAIT_PIN)
			if(text == "*")
				if(pin_buffer == correct_pin)
					open_door()
				else
					#warn play a buzz here or smth.
					pin_buffer = ""
			else // "#"
				pin_buffer = ""
		if(STATE_AUTOCLOSE)
			if(text == "*")
				close_door()
			else // "#"
				#warn check allowed and move to doorstop.
		if(STATE_DOORSTOP)
			if(text == "*")
				close_door()
			else // "#"
				#warn Restart the auto close timer

/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/proc/open_door()

/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/proc/close_door()

/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/proc/pin_input(text)
	var/effective_max_length = pin_length || MAX_PIN_LENGTH
	switch(current_state)
		if(STATE_SET_PIN, STATE_AWAIT_PIN)
			if(length(pin_buffer) == effective_max_length)
				return //Drop the overrunning character.
			pin_buffer += text
		else //We don't care.
			return


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
