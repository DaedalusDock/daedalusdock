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

/datum/c4_file/terminal_program/operating_system
	name = "operating system"
	extension = "TSYS"
	size = 0

	is_executable = FALSE

	/// Gotta be logged in to access anything.
	var/logged_in = FALSE

	/// Current directory being operated on.
	var/datum/c4_file/folder/current_directory

/// Should run this before executing any commands.
/datum/c4_file/terminal_program/operating_system/proc/is_operational()
	return !!get_computer()?.is_operational

/// Change active directory.
/datum/c4_file/terminal_program/operating_system/proc/change_dir(datum/c4_file/folder/directory)
	current_directory = directory
	return TRUE

/// Move a file to another location.
/datum/c4_file/terminal_program/operating_system/proc/move_file(datum/c4_file/file, datum/c4_file/folder/destination, error_pointer, overwrite = FALSE, new_name = "")
	if(file.containing_folder == destination)
		*error_pointer = "Cannot move folder into itself."
		return FALSE

	if(!destination.can_add_file(file))
		*error_pointer = "Unable to move file to target."
		return FALSE

	var/datum/c4_file/file_at_dest = destination.get_file(new_name || file.name, TRUE)
	if(file_at_dest)
		if(!overwrite)
			*error_pointer = "Target in use."
			return FALSE

		if(!destination.can_remove_file(file_at_dest))
			*error_pointer = "Unable to delete target."
			return FALSE

	if(!file.containing_folder.can_remove_file(file))
		*error_pointer = "Unable to delete source."
		return FALSE

	if(file_at_dest)
		destination.try_delete_file(file_at_dest)

	file.containing_folder.try_remove_file(file)
	destination.try_add_file(file)

	file.set_name(new_name)
	return TRUE

/// Find a file by it's name in the given directory. Defaults to the current directory.
/datum/c4_file/terminal_program/operating_system/proc/get_file(file_name, datum/c4_file/folder/working_directory, include_folders = FALSE)
	if(!file_name)
		return

	if(!working_directory)
		working_directory = current_directory

	return working_directory.get_file(file_name, include_folders)

/// Returns a file or folder with the given name inside of the given filepath relative to the working directory.
/datum/c4_file/terminal_program/operating_system/proc/resolve_filepath(file_path, datum/c4_file/folder/working_directory)
	if(!file_path)
		return

	if(!working_directory)
		working_directory = current_directory

	var/list/split_path = splittext(file_path, "/")

	if(length(split_path) == 1)
		if(split_path[1] == ".")
			return working_directory
		return get_file(split_path[1], working_directory, include_folders = TRUE)

	var/datum/file_path/path_info = text_to_filepath(file_path)

	var/datum/c4_file/folder/found_folder = parse_directory(path_info.directory, working_directory)
	if(!found_folder)
		return null

	if(!path_info.file_name)
		return found_folder

	return get_file(path_info.file_name, found_folder, include_folders = TRUE)

/// Write to the terminal.
/datum/c4_file/terminal_program/operating_system/proc/println(text, update_ui = TRUE)
	if(isnull(text) || !is_operational())
		return FALSE


	var/obj/machinery/computer4/computer = get_computer()
	computer.text_buffer += "[text]<br>"
	if(update_ui)
		SStgui.update_uis(computer)
	return TRUE

/// Clear the screen completely.
/datum/c4_file/terminal_program/operating_system/proc/clear_screen(fully = FALSE)
	if(!is_operational())
		return FALSE

	get_computer().text_buffer = ""
	if(!fully)
		println("Screen cleared.")
	return TRUE

/datum/c4_file/terminal_program/operating_system/proc/get_log_folder()
	return

/// Wrapper around handling text input to make sure we can actually handle it.
/datum/c4_file/terminal_program/operating_system/proc/try_std_in(text)
	if(!text || !is_operational())
		return FALSE

	return get_computer().active_program?.std_in(text)
