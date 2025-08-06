#define MAX_PIN_LENGTH 9 // | * * * * * * * * * |

#define STATE_SET_PIN "SET"
#define STATE_AWAIT_PIN "AWAIT"
#define STATE_COUNTDOWN "AUTO"
#define STATE_HOLD "HOLD"
#define STATE_FAULT "FAULT"

#define ROW_HEADER 1
#define ROW_PINOUT 2
#define ROW_STATUS 3

#define AC_COMMAND_OPEN 1
#define AC_COMMAND_CLOSE 2
#define AC_COMMAND_UPDATE 3
#define AC_COMMAND_BOLT 4
#define AC_COMMAND_UNBOLT 5

/datum/c4_file/terminal_program/operating_system/rtos/pincode_door
	name = "pinworks-v1"

	/// Target airlock ID
	var/tag_target
	/// Request-Exit Button ID
	var/tag_request_exit
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
	/// Control Mode
	var/control_mode

	/// Current state machine state
	var/tmp/current_state

	/// Current airlock state from update packets. If it's mismatched, we correct our state.
	var/tmp/airlock_state
	/// Current airlock bolt state from update packets. If it's mismatched, we correct our state.
	var/tmp/airlock_bolt_state

	/// Door autoclose timer
	COOLDOWN_DECLARE(door_timer)
	/// Timestamp for 4-second grace period.
	var/command_time

	/// Get our initial airlock state within 10 seconds.
	COOLDOWN_DECLARE(door_state_timeout)

	/// Recoverable fault string
	var/fault_string

	/// Expected airlock state
	var/expected_airlock_state
	/// Expected bolt state
	var/expected_bolt_state

	/// Slaved pad ID
	var/tag_slave


/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/populate_memory(datum/c4_file/record/conf_record)
	var/list/fields = conf_record.stored_record.fields

	tag_target = fields[RTOS_CONFIG_AIRLOCK_ID]
	tag_request_exit = fields[RTOS_CONFIG_REQUEST_EXIT_ID] //OPTIONAL
	dwell_time = fields[RTOS_CONFIG_HOLD_OPEN_TIME]
	allow_lock_open = fields[RTOS_CONFIG_ALLOW_HOLD_OPEN] //OPTIONAL
	correct_pin = fields[RTOS_CONFIG_PINCODE] //OPTIONAL
	control_mode = fields[RTOS_CONFIG_CMODE]
	tag_slave = fields[RTOS_CONFIG_SLAVE_ID]

	pin_length = length(correct_pin)
	if(correct_pin) //If we don't have a known pin, get ready to learn one.
		current_state = STATE_AWAIT_PIN
	else
		current_state = STATE_SET_PIN

	if((pin_length > MAX_PIN_LENGTH) || (dwell_time > 99))
		halt(RTOS_HALT_DATA_TOO_LONG, "CFG_OVERRUN")
		return TRUE

	// there *HAS* to be a better way than this but it's 3am
	if(tag_target && allow_lock_open && control_mode)
		return

	halt(RTOS_HALT_BAD_CONFIG, "BAD_CONFIG")
	return TRUE

/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/finish_startup()
	var/obj/item/peripheral/network_card/wireless/wcard = get_computer()?.get_peripheral(PERIPHERAL_TYPE_WIRELESS_CARD)
	wcard.listen_mode = WIRELESS_FILTER_ID_TAGS
	wcard.id_tags = list(tag_target, tag_request_exit, tag_slave)

	print_history = new /list(RTOS_OUTPUT_ROWS)
	fault_string = null

	COOLDOWN_START(src, door_state_timeout, (10 SECONDS))
	control_airlock(AC_COMMAND_BOLT)
	update_screen()

/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/tick(delta_time)
	if(!is_operational() || current_state == STATE_FAULT)
		return
	if(current_state == STATE_COUNTDOWN)
		if(COOLDOWN_FINISHED(src, door_timer))
			timer_expire()
			return
		fast_update_doortimer(TRUE)

	// We give 5 seconds to get initial state.
	if(COOLDOWN_FINISHED(src, door_state_timeout) && !airlock_state)
		fault("DOOR NOT RESPONDING?")
		return

	// 4-second grace period for commands and packets to go through.
	if(airlock_state && ((command_time + 4 SECONDS) < world.time))

		//If we have an expected state, verify it.
		if((expected_airlock_state && (expected_airlock_state != airlock_state)) || (expected_bolt_state && (expected_bolt_state != airlock_bolt_state)))
			// If the airlock state is mismatched, complain
			fault("DOOR NOT RESPONDING?")
			return

	return


/// Soft-Halt
/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/proc/fault(error_text)
	playsound(get_computer(), 'sound/machines/nuke/angry_beep.ogg', 50, FALSE)
	current_state = STATE_FAULT
	fault_string = error_text
	update_screen()

/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/proc/update_screen()
	if(!is_operational())
		return

	// Header Row

	var/static/list/headers = list(
		//                "--------------------"
		STATE_SET_PIN =   " ? PLEASE SET PIN ? ",
		STATE_AWAIT_PIN = " > INPUT PIN CODE < ",
	//	STATE_COUNTDOWN =  " ! DOOR OPEN: %SS ! ",
		STATE_HOLD =      " # TIMER  STOPPED # ",
		STATE_FAULT =     " !! SYSTEM FAULT !! "
	)

	if(current_state == STATE_COUNTDOWN)
		fast_update_doortimer(FALSE)
	else
		print_history[ROW_HEADER] = headers[current_state]


	// Pinout / countdown row
	var/write_buffer = "" //Shared write buffer.
	switch(current_state)
		if(STATE_SET_PIN, STATE_AWAIT_PIN)
			draw_pin_dots(FALSE)
		if(STATE_COUNTDOWN)


			if(allow_lock_open)
				write_buffer = "  PRESS # FOR HOLD  "
			else
				write_buffer = " TIME HOLD DISABLED "

			print_history[ROW_PINOUT] = write_buffer

		if(STATE_HOLD)
			print_history[ROW_PINOUT] = "  PRESS # TO START  "
		if(STATE_FAULT)
			// Recoverable faults (Door in unexpected state, etc.)
			print_history[ROW_PINOUT] = "[fixed_center(fault_string, 20)]"
		else
			halt(RTOS_HALT_STATE_VIOLATION, "BAD_STATE")
			return

	// Status Row

	var/static/list/status_rows = list(
		//                "--------------------"
		STATE_SET_PIN =   " * - SET || # - CLR ",
		STATE_AWAIT_PIN = "* - SUBMIT | # - CLR",
		STATE_COUNTDOWN =  "    * TO END NOW    ",
		STATE_HOLD =      "   * TO START NOW   ",
		STATE_FAULT =     "  PRESS * TO RESET  "
	)

	print_history[ROW_STATUS] = status_rows[current_state]
	redraw_screen(TRUE)

	// Visuals

	/// Base color for displays. Mode-based.
	var/new_display = null
	switch(control_mode)
		if(RTOS_CMODE_SECURE)
			new_display = "red"
		if(RTOS_CMODE_BOLTS)
			new_display = "blue"

	switch(current_state)
		if(STATE_SET_PIN)
			display_icon = "screen_dots_yellow"
			display_indicators = RTOS_YELLOW

		if(STATE_AWAIT_PIN)
			display_icon = "screen_blank_[new_display]"
			display_indicators = RTOS_RED

		if(STATE_COUNTDOWN)
			display_icon = "screen_cycle_[new_display]"
			display_indicators = RTOS_GREEN

		if(STATE_HOLD)
			display_icon = "screen_hold_[new_display]"
			display_indicators = RTOS_YELLOW | RTOS_GREEN
		if(STATE_FAULT)
			display_icon = "screen_!_yellow"
			display_indicators = RTOS_RED | RTOS_YELLOW | RTOS_GREEN

	update_visuals()
	send_slave_update()

/// Draws the pin position indicators, Cut out for cleanliness so it can be called in std_in().
/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/proc/draw_pin_dots(redraw = TRUE)
	var/list/char_list = list()

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
		send_slave_update()

/// Calculate the door open header, Cut out so it can safely be placed in tick()
/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/proc/fast_update_doortimer(redraw = TRUE)
	if(current_state != STATE_COUNTDOWN)
		return

	var/seconds_left = "[round((COOLDOWN_TIMELEFT(src, door_timer)*0.1))]"
	print_history[ROW_HEADER] = " ! DOOR OPEN: [fit_with_zeros(seconds_left, 2)]S ! "

	if(redraw)
		redraw_screen(TRUE)
		send_slave_update()

/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/std_in(text)
	. = ..()
	if(!isnull(text2num(text)))
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
				draw_pin_dots(TRUE)

		if(STATE_AWAIT_PIN)
			if(text == "*")
				if(pin_buffer == correct_pin)
					pin_accepted()
					pin_buffer = ""
					update_screen()
				else
					playsound(get_computer(),'sound/machines/deniedbeep.ogg',50,FALSE,3)
					pin_buffer = ""
					draw_pin_dots(TRUE)
			else // "#"
				pin_buffer = ""
				draw_pin_dots(TRUE)

		if(STATE_COUNTDOWN)
			if(text == "*")
				timer_expire()
			else // "#"
				if(allow_lock_open)
					doorstop()

		if(STATE_HOLD)
			if(text == "*")
				timer_expire()

			else // "#"
				// Start time timer back up again, but don't actually do any actions.
				pin_accepted(TRUE)
		if(STATE_FAULT)
			if(text == "*")
				get_computer().reboot()


/// Fired on accepting a pin, If we have a dwell time, start the timer.
/// `skip_action` - Skip action, just restart the timer.
/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/proc/pin_accepted(skip_action = FALSE)

	if(!skip_action)
		switch(control_mode)
			if(RTOS_CMODE_SECURE)
				control_airlock(AC_COMMAND_OPEN)
			if(RTOS_CMODE_BOLTS)
				if(airlock_bolt_state == "locked") //If locked
					control_airlock(AC_COMMAND_UNBOLT)
				else
					control_airlock(AC_COMMAND_BOLT)



	// If we have a set dwell time, we'll start the timer.
	if(dwell_time)
		current_state = STATE_COUNTDOWN
		COOLDOWN_START(src, door_timer, (dwell_time SECONDS))
	// Else, we don't change state and will never fire timer_expire().

/// Fired upon the expiration (or manual triggering therein) of the door timer.
/// This never gets called if the dwell time is zero.
/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/proc/timer_expire()
	if(!(current_state in list(STATE_COUNTDOWN, STATE_HOLD)))
		halt(RTOS_HALT_STATE_VIOLATION, "BAD_STATE")

	switch(control_mode)
		if(RTOS_CMODE_SECURE)
			control_airlock(AC_COMMAND_CLOSE)
		if(RTOS_CMODE_BOLTS) //This, doesn't make a whole lot of sense but we support it anyways!
			if(airlock_bolt_state == "locked") //If locked
				control_airlock(AC_COMMAND_UNBOLT)
			else
				control_airlock(AC_COMMAND_BOLT)

	current_state = STATE_AWAIT_PIN
	update_screen()

/// (if allowed) stop the timer and hold the door open.
/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/proc/doorstop()
	if((current_state != STATE_COUNTDOWN) && (!allow_lock_open))
		halt(RTOS_HALT_STATE_VIOLATION, "BAD_STATE")

	COOLDOWN_RESET(src, door_timer)
	current_state = STATE_HOLD
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

/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/proc/send_slave_update()
	var/datum/signal/signal = new(
		src,
		list(
			"tag" = tag_slave,
			PACKET_CMD = NETCMD_UPDATE_DATA,
			PACKET_ARG_TEXTBUFFER = list2params(print_history),
			PACKET_ARG_DISPLAY = display_icon,
			PACKET_ARG_LEDS = display_indicators
		)
	)
	post_signal(signal)

/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/proc/handle_packet(datum/signal/packet)
	var/list/data = packet.data
	if(!data["tag"])
		return //what
	if(tag_slave && (data["tag"] == tag_slave))
		switch(data[PACKET_CMD])
			if("key")
				std_in(copytext(data["key"],1,2)) //Only one char, sorry.
			if(NETCMD_UPDATE_REQUEST)
				send_slave_update()
		return
	if((data["tag"] == tag_target) && data["timestamp"])
		//State update from airlock
		airlock_state = packet.data["door_status"]
		airlock_bolt_state = packet.data["lock_status"]
		return

	if(tag_request_exit && (data["tag"] == tag_request_exit) && (current_state == STATE_AWAIT_PIN))
		switch(current_state)
			if(STATE_AWAIT_PIN)
				pin_accepted()
			if(STATE_COUNTDOWN, STATE_HOLD)
				timer_expire()
			if(STATE_FAULT)
				return
			else
				fault("BAD MODE??")




/// Send airlock control packet. Also updates expected states.
/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/proc/control_airlock(airlock_command)
	command_time = world.time
	var/datum/signal/signal
	switch(airlock_command)
		if(AC_COMMAND_OPEN)
			signal = new(
				src,
				list(
					"tag" = tag_target,
					PACKET_CMD = "secure_open"
				)
			)
			expected_airlock_state = "open"
		if(AC_COMMAND_CLOSE)
			signal = new(
				src,
				list(
					"tag" = tag_target,
					PACKET_CMD = "secure_close"
				)
			)
			expected_airlock_state = "closed"
		if(AC_COMMAND_UPDATE)
			signal = new(
				src,
				list(
					"tag" = tag_target,
					PACKET_CMD = "status"
				)
			)
		if(AC_COMMAND_BOLT)
			signal = new(
				src,
				list(
					"tag" = tag_target,
					PACKET_CMD = "lock"
				)
			)
			expected_bolt_state = "locked"
		if(AC_COMMAND_UNBOLT)
			signal = new(
				src,
				list(
					"tag" = tag_target,
					PACKET_CMD = "unlock"
				)
			)
			expected_bolt_state = "unlocked"
	if(signal)
		post_signal(signal, RADIO_AIRLOCK)

/datum/c4_file/terminal_program/operating_system/rtos/pincode_door/on_close(datum/c4_file/terminal_program/operating_system/thinkdos/system)
	. = ..()

	// Cleanliness
	tag_target = null
	tag_request_exit = null
	dwell_time = null
	allow_lock_open = null
	correct_pin = null
	pin_length = null

	airlock_state = null
	airlock_bolt_state = null
	expected_airlock_state = null
	expected_bolt_state = null

	fault_string = null

#undef MAX_PIN_LENGTH

#undef STATE_SET_PIN
#undef STATE_AWAIT_PIN
#undef STATE_COUNTDOWN
#undef STATE_HOLD
#undef STATE_FAULT

#undef ROW_HEADER
#undef ROW_PINOUT
#undef ROW_STATUS

#undef AC_COMMAND_OPEN
#undef AC_COMMAND_CLOSE
#undef AC_COMMAND_UPDATE
#undef AC_COMMAND_BOLT
#undef AC_COMMAND_UNBOLT
