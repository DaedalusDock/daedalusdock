/datum/c4_file/terminal_program/operating_system/thinkdos
	name = "ThinkDOS"

	var/system_version = "ThinkDOS 0.7.2"

	/// Shell commmands for std_in, built on new.
	var/static/list/commands

	/// Boolean, determines if errors are written to the log file.
	var/log_errors = TRUE

	/// The command log.
	var/datum/c4_file/text/command_log

/datum/c4_file/terminal_program/operating_system/thinkdos/New()
	if(!commands)
		commands = list()
		for(var/datum/shell_command/thinkdos/command_path as anything in subtypesof(/datum/shell_command/thinkdos))
			commands += new command_path

/datum/c4_file/terminal_program/operating_system/thinkdos/execute()
	initialize_logs()
	if(!current_directory)
		change_dir(containing_folder)

/// Struct for the parsed stdin
/datum/thinkdos_stdin
	var/raw = ""
	var/command = ""
	var/list/arguments = list()
	var/list/options = list()

/datum/c4_file/terminal_program/operating_system/thinkdos/parse_std_in(text)
	var/list/split_list = splittext(text, " ")
	var/datum/thinkdos_stdin/output = new

	output.raw = text
	output.command = lowertext(split_list[1])

	if(length(split_list) == 1)
		return output


	split_list.Cut(1, 2)

	// Parse out options
	for(var/str in split_list)
		// Dangling "-" is considered an argument per POSIX, so do not trim it from the arguments list.
		if(length(str) == 1 || str[1] != "-")
			break

		if(str[2] == "-")
			if(length(str) == 2) // "--", cease parsing options
				split_list.Cut(1,2)
				break

			if(str[3] == "-") //This is an argument, not an option.
				break

			output.options += copytext(str, 3)
			split_list.Cut(1, 2)
			continue

		output.options |= splittext(copytext(str, 2), "")
		split_list.Cut(1, 2)

	output.arguments = split_list
	return output

/datum/c4_file/terminal_program/operating_system/thinkdos/std_in(text)
	. = ..()
	if(.)
		return

	var/encoded_in = html_encode(text)
	println(encoded_in)
	write_log(encoded_in)

	var/datum/thinkdos_stdin/parsed_stdin = parse_std_in(text)
	for(var/datum/shell_command/potential_command as anything in commands)
		if(potential_command.try_exec(src, parsed_stdin.command, parsed_stdin.arguments, parsed_stdin.options))
			return TRUE

	println("'[html_encode(parsed_stdin.raw)]' is not recognized as an internal or external command.")
	return TRUE

/// Create the log file, or append a startup log.
/datum/c4_file/terminal_program/operating_system/thinkdos/proc/initialize_logs()
	var/datum/c4_file/folder/log_dir = parse_directory("logs", drive.root)
	if(!log_dir)
		log_dir = new /datum/c4_file/folder
		log_dir.name = "logs"
		if(!drive.root.try_add_file(log_dir))
			qdel(log_dir)
			return FALSE

	var/datum/c4_file/text/log_file = get_file("syslog", log_dir)
	if(!log_file)
		log_file = new /datum/c4_file/text()
		log_file.name = "syslog"
		if(!log_dir.try_add_file(log_file))
			qdel(log_file)
			return FALSE

	command_log = log_file
	RegisterSignal(command_log, COMSIG_PARENT_QDELETING, PROC_REF(log_file_del))
	RegisterSignal(command_log, COMSIG_COMPUTER4_FILE_MOVED, PROC_REF(log_file_moved))

	log_file.data += "<br><b>STARTUP:</b> [stationtime2text()], [stationdate2text()]"
	return TRUE

/// Handles the log file being deleted. Harddels bad.
/datum/c4_file/terminal_program/operating_system/thinkdos/proc/log_file_del(datum/source)
	SIGNAL_HANDLER

	command_log = null

/// Handles the log file being moved.
/datum/c4_file/terminal_program/operating_system/thinkdos/proc/log_file_del(datum/source)
	SIGNAL_HANDLER

	UnregisterSignal(command_log, list(COMSIG_COMPUTER4_FILE_MOVED, COMSIG_PARENT_QDELETING))
	command_log = null

/// Write to the command log.
/datum/c4_file/terminal_program/operating_system/thinkdos/proc/write_log(text)
	if(!command_log || drive.read_only)
		return FALSE

	command_log.data += "html_encode(text)"
	return TRUE

/// Write to the command log if it's enabled, then print to the screen.
/datum/c4_file/terminal_program/operating_system/thinkdos/proc/print_error(text)
	if(log_errors)
		write_log(text)

	return println(text)
