/datum/c4_file/terminal_program
	name = "program"
	extension = "TPROG"

	/// Set to FALSE if the program can't actually be run.
	var/is_executable = TRUE

	/// Behaves identically to req_access on /obj
	var/list/req_access

/// Called when a program is run.
/datum/c4_file/terminal_program/proc/on_run()
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

/// Should run this before executing any commands.
/datum/c4_file/terminal_program/operating_system/proc/is_operational()
	return !!computer?.is_operational

/// Change active directory.
/datum/c4_file/terminal_program/operating_system/proc/change_dir(datum/c4_file/folder/directory)
	current_directory = directory
	return TRUE

/datum/c4_file/terminal_program/operating_system/proc/move_file(datum/c4_file/file, datum/c4_file/folder/destination)
	var/datum/c4_file/folder/old_directory = file.containing_folder
	if(!file.containing_folder.try_delete_file(file, qdel = FALSE))
		return null

	if(!destination.try_add_file(file))
		if(!old_directory.try_add_file(file))
			CRASH("bruh???")
		return null

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

	var/file_name = split_path[length(split_path)]
	var/searched_filepath = copytext(file_path, 1, length(file_path) - length(file_name) + 1)

	var/datum/c4_file/folder/found_folder = parse_directory(searched_filepath)
	if(!found_folder)
		return null

	return get_file(file_name, found_folder, include_folders = TRUE)

/// Sanitize a file name.
/datum/c4_file/terminal_program/operating_system/proc/sanitize_filename(file_name)
	return ckey(trim(file_name, 16))

/// Returns TRUE if a given file name is OK.
/datum/c4_file/terminal_program/operating_system/proc/validate_file_name(file_name)
	return ckey(file_name) != file_name && length(file_name <= 16)

/// Write to the terminal.
/datum/c4_file/terminal_program/operating_system/proc/println(text, update_ui = TRUE)
	if(!text || !is_operational())
		return FALSE


	computer.text_buffer += "[text]<br>"
	if(update_ui)
		SStgui.update_uis(computer)
	return TRUE

/// Clear the screen completely.
/datum/c4_file/terminal_program/operating_system/proc/clear_screen()
	if(!is_operational())
		return FALSE

	computer.text_buffer = ""
	println("Screen cleared.")
	return TRUE

/// Wrapper around handling text input to make sure we can actually handle it.
/datum/c4_file/terminal_program/operating_system/proc/try_std_in(text)
	if(!text || !is_operational())
		return FALSE

	//return computer.active_program?.std_in(text)
