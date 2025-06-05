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

/datum/c4_file/terminal_program/operating_system/rtos/execute(datum/c4_file/terminal_program/operating_system/thinkdos/system)
	. = ..()
	//Populate our working directory
	change_dir(containing_folder)
	//Load our config file
	var/datum/c4_file/record/conf_record = get_file("config")
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

/// Finish starting up, as the execute function is sealed.
/datum/c4_file/terminal_program/operating_system/rtos/finish_startup()

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
 *  Deadlocks if the Access DB is missing.
 */
/datum/c4_file/terminal_program/operating_system/rtos/proc/check_access(var/list/access_list)
	var/datum/c4_file/record/access_file

/** RTOS.h - Check ID
 *  Check if an inserted ID is allowed. Wrapps rtos/check_access()
 *  Deadlocks if there is no card reader.
 */
/datum/c4_file/terminal_program/operating_system/rtos/proc/check_id()
