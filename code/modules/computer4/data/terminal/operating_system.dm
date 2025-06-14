/datum/c4_file/terminal_program/operating_system
	name = "operating system"
	extension = "TSYS"
	size = 0

	is_executable = FALSE

	/// Gotta be logged in to access anything.
	var/logged_in = FALSE

	/// Current directory being operated on.
	var/datum/c4_file/folder/current_directory

	/// The current focused program.
	var/tmp/datum/c4_file/terminal_program/active_program
	/// All programs currently running on the machine.
	var/tmp/list/datum/c4_file/terminal_program/processing_programs = list()

	/// Halt And Catch Fire (Prevents STDIN, closest we can get to a HALT state.)
	var/deadlocked = FALSE

/datum/c4_file/terminal_program/operating_system/Destroy()
	if(length(processing_programs))
		clean_up()
	return ..()

/// Should run this before executing any commands.
/datum/c4_file/terminal_program/operating_system/proc/is_operational()
	return (!!get_computer()?.is_operational) && (!deadlocked)

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

	return active_program?.std_in(text)

/// Unload everything including myself
/datum/c4_file/terminal_program/operating_system/proc/clean_up()
	for(var/datum/c4_file/terminal_program/program as anything in processing_programs - src)
		unload_program(program)

	if(src in processing_programs)
		unload_program(src)

	get_computer()?.text_buffer = ""
	get_computer()?.operating_system = null

/// Run a program.
/datum/c4_file/terminal_program/operating_system/proc/execute_program(datum/c4_file/terminal_program/program)
	if(!program)
		return FALSE

	if(!program.can_execute(src))
		return FALSE

	if(!(program in processing_programs))
		add_processing_program(program)

	set_active_program(program)
	program.execute(src)
	return TRUE

/// Close a program.
/datum/c4_file/terminal_program/operating_system/proc/unload_program(datum/c4_file/terminal_program/program)
	if(!program)
		return FALSE

	// Un-deadlock ourselves.
	deadlocked = FALSE

	if(!(program in processing_programs))
		CRASH("Tried tried to remove a program we aren't even running.")

	remove_processing_program(program)

	if(active_program == program)
		if(active_program == src)
			set_active_program(null)
			clean_up()
		else
			set_active_program(src)

	return TRUE

/// Move a program to background
/datum/c4_file/terminal_program/operating_system/proc/try_background_program(datum/c4_file/terminal_program/program)
	if(length(processing_programs) > 6) // Sane limit IMO
		return FALSE

	if(active_program == program)
		set_active_program(src)

	return TRUE

/// Setter for the processing programs list. Use execute_program() instead!
/datum/c4_file/terminal_program/operating_system/proc/add_processing_program(datum/c4_file/terminal_program/program)
	PRIVATE_PROC(TRUE)

	processing_programs += program
	RegisterSignal(program, list(COMSIG_PARENT_QDELETING, COMSIG_COMPUTER4_FILE_ADDED), PROC_REF(processing_program_moved))


/// Setter for the processing programs list. Use unload_program() instead!
/datum/c4_file/terminal_program/operating_system/proc/remove_processing_program(datum/c4_file/terminal_program/program)
	processing_programs -= program
	program.on_close(src)
	UnregisterSignal(program, list(COMSIG_PARENT_QDELETING, COMSIG_COMPUTER4_FILE_ADDED))

/// Setter for active program. Use execute_program() or unload_program() instead!
/datum/c4_file/terminal_program/operating_system/proc/set_active_program(datum/c4_file/terminal_program/program)
	PRIVATE_PROC(TRUE)

	active_program = program

/// Handles any running programs being moved in the filesystem.
/datum/c4_file/terminal_program/operating_system/proc/processing_program_moved(datum/source)
	SIGNAL_HANDLER

	if(source == src)
		var/obj/machinery/computer4/computer = get_computer()
		if(QDELING(src))
			clean_up()
			return

		// Check if it's still in the root of either disk, this is fine :)
		if(src in computer.internal_disk?.root.contents)
			return

		if(src in computer.inserted_disk?.root.contents)
			return

		// OS is not in a root folder, KILL!!!
		clean_up()
		return


	unload_program(active_program)
