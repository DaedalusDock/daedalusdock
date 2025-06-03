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

#define RTOS_OUTPUT_ROWS 3
#define RTOS_OUTPUT_COLS 20

/datum/c4_file/terminal_program/operating_system/embedded
	abstract_type = /datum/c4_file/terminal_program/operating_system/embedded

	name = "firmware"

	/// List containing the last RTOS_OUTPUT_ROWS lines, FIFO queue.
	var/tmp/list/print_history = list()

/datum/c4_file/terminal_program/operating_system/embedded/execute(datum/c4_file/terminal_program/operating_system/thinkdos/system)
	. = ..()
	//Populate our working directory
	change_dir(containing_folder)
	//Load our config file
	var/datum/c4_file/record/conf_record = get_file("config")
	if(!istype(conf_record))
		println("<font color=red>HALT SYS1000 - CONF_MISSING</font>")
		deadlocked = TRUE
		return

	if(!populate_memory(conf_record))
		println("<font color=red>HALT SYS1001 - CONF_BAD</font>")
		deadlocked = TRUE
		return

/// Load our variables from the configuration database. Return FALSE to halt on error.
/datum/c4_file/terminal_program/operating_system/embedded/proc/populate_memory(datum/c4_file/record/conf_record)
	return FALSE //Override, or it'll always fail.

/datum/c4_file/terminal_program/operating_system/embedded/println(text, update_ui)
	if(isnull(text) || !is_operational())
		return FALSE

	var/obj/machinery/computer4/computer = get_computer()
	LAZYINITLIST(print_history)

	print_history += text
	if(length(print_history) > RTOS_OUTPUT_ROWS)
		//Discard the oldest row
		popleft(print_history)

	computer.text_buffer = jointext(print_history,"<br>")
	if(update_ui)
		SStgui.update_uis(computer)
	return TRUE

/datum/c4_file/terminal_program/operating_system/embedded/clear_screen(fully)
	if(.)
		print_history.Cut()

/datum/c4_file/terminal_program/operating_system/embedded/on_close(datum/c4_file/terminal_program/operating_system/thinkdos/system)
	. = ..()
	print_history.Cut()

/*
 * RTOS.h - RTOS Helper Functions
 */



#undef RTOS_OUTPUT_ROWS
#undef RTOS_OUTPUT_COLS
