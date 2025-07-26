/datum/c4_file/terminal_program
	name = "program"
	extension = "TPROG"


	/// Set to FALSE if the program can't actually be run.
	var/is_executable = TRUE

	/// Behaves identically to req_access on /obj
	var/list/req_access

/// Called before a program is run.
/datum/c4_file/terminal_program/proc/can_execute(datum/c4_file/terminal_program/operating_system/thinkdos/system)
	SHOULD_CALL_PARENT(TRUE)

	if(!length(req_access))
		return TRUE

	if(!system.current_user)
		system.println("<b>Error:</b> Unable to locate credentials.")
		return FALSE

	if(length(req_access & system.current_user.access) != length(req_access))
		system.println("<b>Error:</b> User '[html_encode(system.current_user.registered_name)]' does not have the required access credentials.")
		return FALSE

	return TRUE

/// Called when a program is run.
/datum/c4_file/terminal_program/proc/execute(datum/c4_file/terminal_program/operating_system/thinkdos/system)
	system.clear_screen(TRUE)

/// Called when a program is no longer running
/datum/c4_file/terminal_program/proc/on_close(datum/c4_file/terminal_program/operating_system/thinkdos/system)
	return

/// Processing function, Called by the OS, or the computer if src is the OS.
/datum/c4_file/terminal_program/proc/tick(delta_time)
	return

/// Returns the operating system.
/datum/c4_file/terminal_program/proc/get_os()
	RETURN_TYPE(/datum/c4_file/terminal_program/operating_system)
	return get_computer()?.operating_system

/*
 * Called by the operating system when a user enters text into the input field.
 * Don't call directly, call os.try_std_in() instead
 */
/datum/c4_file/terminal_program/proc/std_in(text)
	return FALSE

/// Helper for splitting stdin into command and arguments.
/datum/c4_file/terminal_program/proc/parse_std_in(text) as /datum/shell_stdin
	RETURN_TYPE(/datum/shell_stdin)

	return new /datum/shell_stdin(text)

/// Called by computers to forward commands from peripherals to programs. Should probably be on OS but oh well.
/datum/c4_file/terminal_program/proc/peripheral_input(obj/item/peripheral/invoker, command, datum/signal/packet)
	return

