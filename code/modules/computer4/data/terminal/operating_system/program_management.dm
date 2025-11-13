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
