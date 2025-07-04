/*
 * "RTOS" Embedded Operating System
 *
 * Designed to operate purely on Embedded Controllers.
 *
 * 90% of the time, stdin will be [0-9] or `*` or `#`
 * (aside from maybe an engineering debugger tool in the future)
 *
 * Screen size is a fixed $WHATEVERKAPUDECIDESON
 * println has been overridden to enforce this assumption.
 * I beg of you do not pass it a multiline string.
 *
 */



/datum/c4_file/terminal_program/operating_system/rtos
	abstract_type = /datum/c4_file/terminal_program/operating_system/rtos

	name = "firmware"
	extension = "EFW" //Embedded FirmWare

	/// List containing the last RTOS_OUTPUT_ROWS lines, FIFO queue.
	var/tmp/list/print_history = list()

	/// Icon state for the containing controller's screen.
	var/display_icon = null

	/// Bitflag (RTOS_RED, RTOS_YELLOW, RTOS_GREEN) for indicator lights.
	var/display_indicators = NONE

/datum/c4_file/terminal_program/operating_system/rtos/execute(datum/c4_file/terminal_program/operating_system/thinkdos/system)
	. = ..()
	//Populate our working directory
	change_dir(containing_folder)
	//Load our config file
	var/datum/c4_file/record/conf_record = get_file(RTOS_CONFIG_FILE)
	if(!istype(conf_record))
		halt(RTOS_HALT_NO_CONFIG, "MISSING_CONFIG")
		return

	var/list/pop_output = populate_memory(conf_record)
	if(pop_output) //Halt internally.
		return

	finish_startup()

/// Program-specific startup code, Usually calls UI draw procs.
/datum/c4_file/terminal_program/operating_system/rtos/proc/finish_startup()

/// Load our variables from the configuration database. Return a string to halt.
/datum/c4_file/terminal_program/operating_system/rtos/proc/populate_memory(datum/c4_file/record/conf_record)
	halt("FUCK", "NOT_REAL_FIRMWARE")
	return

// Overriden to enforce output size requirements
/datum/c4_file/terminal_program/operating_system/rtos/println(text, update_ui)
	if(isnull(text) || !is_operational())
		return FALSE

	LAZYINITLIST(print_history)

	print_history += text
	if(length(print_history) > RTOS_OUTPUT_ROWS)
		//Discard the oldest row
		popleft(print_history)

	redraw_screen(update_ui)

// Hooked to clear print buffer.
/datum/c4_file/terminal_program/operating_system/rtos/clear_screen(fully)
	. = ..()
	if(.)
		// Clear the print buffer too.
		print_history.Cut()

// Hooked to clear print buffer.
/datum/c4_file/terminal_program/operating_system/rtos/on_close(datum/c4_file/terminal_program/operating_system/thinkdos/system)
	. = ..()
	print_history.Cut()

/*
 * RTOS.h - RTOS Helper Functions
 */

/** RTOS.h - Halt
 * error_code - 4 number error code
 * error_message - 20-character free text error message
 * Sets `deadlocked`, consider this the RTOS equivalent of CRASH()
 */
/datum/c4_file/terminal_program/operating_system/rtos/proc/halt(error_code, error_message)
	//Completely seizes the output buffer.
	clear_screen(TRUE)
	print_history = list(
		"   HALT!CODE:[error_code]   ",
		"FW:[name]",
		"[error_message]"
	)
	redraw_screen(TRUE)
	deadlocked = TRUE
	playsound(get_computer(), 'sound/machines/nuke/confirm_beep.ogg', 50, FALSE)

/** RTOS.h - Post Signal
 *  Follows standard post_signal calling conventions.
 */
/datum/c4_file/terminal_program/operating_system/rtos/proc/post_signal(datum/signal/sending_signal, filter)
	if(!is_operational())
		return

	var/obj/item/peripheral/network_card/wireless/netcard = get_computer()?.get_peripheral(PERIPHERAL_TYPE_WIRELESS_CARD)
	if(!netcard)
		halt(RTOS_HALT_MISSING_NETWORK_CARD, "NO_NETWORK_CARD")
		return
	netcard.post_signal(sending_signal, filter)

/** RTOS.h - Redraw Screen
 *  Redraws the print_history buffers to the screen. Call after manual editing.
 */
/datum/c4_file/terminal_program/operating_system/rtos/proc/redraw_screen(update_ui)
	var/obj/machinery/computer4/computer = get_computer()
	computer?.text_buffer = jointext(print_history,"<br>")
	if(update_ui)
		SStgui.update_uis(computer)
	return TRUE

/** RTOS.h - Check Access
 *  Softcode allowed(), takes an ID access list from the ID peripheral.
 *  Deadlocks if the Access DB is missing or invalid
 */
/datum/c4_file/terminal_program/operating_system/rtos/proc/check_access(list/access_list)
	var/datum/c4_file/record/access_file = get_file(RTOS_ACCESS_FILE)
	if(!istype(access_file))
		halt(RTOS_HALT_NO_ACCESS, "ACCESS_FILE_MISSING")
		return
	var/list/auth_list = access_file.stored_record.fields[RTOS_ACCESS_LIST]
	if(istext(access_list))
		access_list = text2access(access_list)
	if(!islist(auth_list))
		halt(RTOS_HALT_NO_ACCESS, "BAD_ACCESS_LIST")
		return

	var/mode = access_file.stored_record.fields[RTOS_ACCESS_MODE]
	switch(mode)
		// Got these from Lohi looking over my shoulder.
		// Consider replacing actual access code with these?
		if(RTOS_ACCESS_CALC_MODE_ALL)
			if (length(auth_list & access_list) != length(auth_list))
				return FALSE
			return TRUE
		if(RTOS_ACCESS_CALC_MODE_ANY)
			if (length(auth_list & access_list))
				return TRUE
			return FALSE
		else
			halt(RTOS_HALT_BAD_CONFIG, "BAD_ACCESS_MODE")
			return FALSE

/** RTOS.h - Update Visuals
 *  Updates the visual-related vars, and triggers an icon update for the parent machine. Otherwise, halts.
 */
/datum/c4_file/terminal_program/operating_system/rtos/proc/update_visuals()
	var/obj/machinery/computer4/embedded_controller/computer = get_computer()
	if(!istype(computer))
		halt(RTOS_HALT_WRONG_COMPUTER_TYPE, "BAD_MACHINE")
		return
	var/obj/machinery/c4_embedded_controller/overmachine = computer.controller
	if(!istype(overmachine))
		halt(RTOS_HALT_WRONG_COMPUTER_TYPE, "BAD_MACHINE")
		return

	overmachine.display_icon = display_icon
	overmachine.display_indicators = display_indicators

	overmachine.update_appearance()

/** RTOS.h - Check ID
 *  Check if an inserted ID is allowed. Wraps rtos/check_access()
 *  Deadlocks if there is no card reader.
 */
/datum/c4_file/terminal_program/operating_system/rtos/proc/check_id()
	var/obj/item/peripheral/card_reader/reader = get_computer()?.get_peripheral(PERIPHERAL_TYPE_CARD_READER)
	if(!reader)
		halt(RTOS_HALT_MISSING_CARD_READER, "NO_CARD_READER")
		. = FALSE
		CRASH("No card reader in an embedded controller, this should never happen??")

	var/datum/signal/packet = reader.scan_card()
	if(packet == "nocard")
		return FALSE //No card inserted.

	var/access_string = packet.data["access"]
	var/list/access_list = text2access(access_string)

	return check_access(access_list)
