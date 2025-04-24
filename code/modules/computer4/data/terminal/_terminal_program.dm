/datum/c4_file/terminal_program
	name = "program"
	extension = "TPROG"

	/// Set to FALSE if the program can't actually be run.
	var/is_executable = TRUE

	/// Behaves identically to req_access on /obj
	var/list/req_access

/datum/c4_file/terminal_program/Destroy()
	if(containing_folder?.computer?.active_program == src)
		containing_folder.computer.active_program = null
	return ..()

/// Called when a program is run.
/datum/c4_file/terminal_program/proc/execute()
	return

/*
 * Called by the operating system when a user enters text into the input field.
 * Don't call directly, call os.try_std_in() instead
 */
/datum/c4_file/terminal_program/proc/std_in(text)
	return FALSE

/// Helper for splitting stdin into command and arguments.
/datum/c4_file/terminal_program/proc/parse_std_in(text) as /list
	RETURN_TYPE(/list)

	return splittext(text, " ")

/datum/c4_file/terminal_program/operating_system
	name = "operating system"
	extension = "TSYS"

	is_executable = FALSE

	/// Gotta be logged in to access anything.
	var/logged_in = FALSE

	/// Current directory being operated on.
	var/datum/c4_file/folder/current_directory

/datum/c4_file/terminal_program/operating_system/Destroy()
	if(containing_folder?.computer?.operating_system == src)
		containing_folder.computer.operating_system = null
	return ..()

/// Should run this before executing any commands.
/datum/c4_file/terminal_program/operating_system/proc/is_operational()
	return !!containing_folder?.computer?.is_operational

/// Change active directory.
/datum/c4_file/terminal_program/operating_system/proc/change_dir(datum/c4_file/folder/directory)
	current_directory = directory
	return TRUE

/// Move a file to another location.
/datum/c4_file/terminal_program/operating_system/proc/move_file(datum/c4_file/file, datum/c4_file/folder/destination, error_pointer, overwrite = FALSE, new_name = "")
	if(file.containing_folder == destination)
		return FALSE

	if(!destination.can_add_file(file))
		return FALSE

	var/datum/c4_file/file_at_dest = destination.get_file(new_name || file.name, TRUE)
	if(file_at_dest)
		if(!overwrite)
			*error_pointer = "Target in use."
			return FALSE

		if(!destination.can_delete_file(file_at_dest))
			*error_pointer = "Unable to delete target."
			return FALSE

	if(!file.containing_folder.can_delete_file(file))
		*error_pointer = "Unable to delete source."
		return FALSE

	if(file_at_dest)
		destination.try_delete_file(file_at_dest)

	file.containing_folder.try_delete_file(file, qdel = FALSE)
	destination.try_add_file(file)

	file.name = new_name
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
		return get_file(split_path[1], working_directory, include_folders = TRUE)

	var/datum/file_path/path_info = text_to_filepath(file_path)
	var/file_name = split_path[length(split_path)]

	var/datum/c4_file/folder/found_folder = parse_directory(path_info.directory, working_directory)
	if(!found_folder)
		return null

	return get_file(path_info.file_name, found_folder, include_folders = TRUE)

/// Sanitize a file name.
/datum/c4_file/terminal_program/operating_system/proc/sanitize_filename(file_name)
	return ckey(trim(file_name, 16))

/// Returns TRUE if a given file name is OK.
/datum/c4_file/terminal_program/operating_system/proc/validate_file_name(file_name)
	return (ckey(file_name) == file_name) && (length(file_name) <= 16)

/// Write to the terminal.
/datum/c4_file/terminal_program/operating_system/proc/println(text, update_ui = TRUE)
	if(!text || !is_operational())
		return FALSE


	containing_folder.computer.text_buffer += "[text]<br>"
	if(update_ui)
		SStgui.update_uis(containing_folder.computer)
	return TRUE

/// Clear the screen completely.
/datum/c4_file/terminal_program/operating_system/proc/clear_screen()
	if(!is_operational())
		return FALSE

	containing_folder.computer.text_buffer = ""
	println("Screen cleared.")
	return TRUE

/// Wrapper around handling text input to make sure we can actually handle it.
/datum/c4_file/terminal_program/operating_system/proc/try_std_in(text)
	if(!text || !is_operational())
		return FALSE

	return containing_folder.computer.active_program?.std_in(text)
