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



/datum/c4_file/terminal_program/operating_system/embedded
	abstract_type = /datum/c4_file/terminal_program/operating_system/embedded

	name = "firmware"
	extension = "EFW" //Embedded FirmWare

	/// List containing the last RTOS_OUTPUT_ROWS lines, FIFO queue.
	var/tmp/list/print_history = list()


/datum/c4_file/terminal_program/operating_system/embedded/execute(datum/c4_file/terminal_program/operating_system/thinkdos/system)
	. = ..()
	//Populate our working directory
	change_dir(containing_folder)
	//Load our config file
	var/datum/c4_file/record/conf_record = get_file("config")
	if(!istype(conf_record))
		halt("HALT SYS1000 - CONF_MISSING")
		return

	var/pop_output = populate_memory(conf_record)
	if(pop_output)
		halt(pop_output)
		return

	finish_startup()

/// Program-specific startup code, Usually calls UI draw procs.
/datum/c4_file/terminal_program/operating_system/embedded/proc/finish_startup()

/// Load our variables from the configuration database. Return a string to halt.
/datum/c4_file/terminal_program/operating_system/embedded/proc/populate_memory(datum/c4_file/record/conf_record)
	return "HALT SYS0WTF - BAD_FIRMWARE"

// Overriden to enforce output size requirements
/datum/c4_file/terminal_program/operating_system/embedded/println(text, update_ui)
	if(isnull(text) || !is_operational())
		return FALSE

	LAZYINITLIST(print_history)

	print_history += text
	if(length(print_history) > RTOS_OUTPUT_ROWS)
		//Discard the oldest row
		popleft(print_history)

	redraw_screen(update_ui)

// Hooked to clear print buffer.
/datum/c4_file/terminal_program/operating_system/embedded/clear_screen(fully)
	. = ..()
	if(.)
		// Clear the print buffer too.
		print_history.Cut()

// Hooked to clear print buffer.
/datum/c4_file/terminal_program/operating_system/embedded/on_close(datum/c4_file/terminal_program/operating_system/thinkdos/system)
	. = ..()
	print_history.Cut()

/// Finish starting up, as the execute function is sealed.
/datum/c4_file/terminal_program/operating_system/embedded/finish_startup()

/*
 * RTOS.h - RTOS Helper Functions
 */

/** RTOS.h - Halt
 * error_message - Error message to print onscreen, In red.
 * Sets `deadlocked`, consider this the RTOS equivalent of CRASH()
 */
/datum/c4_file/terminal_program/operating_system/embedded/proc/halt(error_message)
	println("<font color=red>[error_message]</font>")
	deadlocked = TRUE

/** RTOS.h - Post Signal
 *  Follows standard post_signal calling conventions.
 */
/datum/c4_file/terminal_program/operating_system/embedded/proc/post_signal(datum/signal/sending_signal, filter)
	if(!is_operational())
		return

	var/obj/item/peripheral/network_card/wireless/netcard = get_computer()?.get_peripheral(PERIPHERAL_TYPE_WIRELESS_CARD)
	if(!netcard)
		halt("HALT SYS2001 - MISSING_NETCARD")
		return
	netcard.post_signal(sending_signal, filter)

/** RTOS.h - Redraw Screen
 *  Redraws the print_history buffers to the screen. Call after manual editing.
 */
/datum/c4_file/terminal_program/operating_system/embedded/proc/redraw_screen(update_ui)
	var/obj/machinery/computer4/computer = get_computer()
	computer?.text_buffer = jointext(print_history,"<br>")
	if(update_ui)
		SStgui.update_uis(computer)
	return TRUE
