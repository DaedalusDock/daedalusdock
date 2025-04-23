/datum/c4_file/terminal_program/operating_system/thinkdos
	name = "ThinkDOS"

	var/system_version = "ThinkDOS 0.7.2"

	/// Shell commmands for std_in, built on new.
	var/static/list/commands

	/// The command log.
	var/datum/c4_file/text/command_log

/datum/c4_file/terminal_program/operating_system/thinkdos/New()
	if(!commands)
		commands = list()
		for(var/datum/shell_command/thinkdos/command_path as anything in subtypesof(/datum/shell_command/thinkdos))
			commands += new command_path

/datum/c4_file/terminal_program/operating_system/thinkdos/on_run()
	initialize_logs()

/// Create the log file, or append a startup log.
/datum/c4_file/terminal_program/operating_system/thinkdos/proc/initialize_logs()
	var/datum/c4_file/folder/log_dir = parse_directory("logs", drive.root)
	if(!log_dir)
		log_dir = new /datum/c4_file/folder
		log_dir.name = "logs"
		if(!drive.root.try_add_file(log_dir))
			return FALSE

	var/datum/c4_file/text/log_file = get_file("syslog", log_dir)
	if(!log_file)
		log_file = new /datum/c4_file/text()
		log_file.name = "syslog"
		if(!log_dir.try_add_file(log_file))
			return FALSE

	command_log = log_file
	log_file.data += "<br><b>STARTUP:</b> [stationtime2text()], [stationdate2text()]"
	return TRUE

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
	output.command = split_list[1]

	if(length(split_list) == 1)
		return output


	split_list.Cut(1, 2)

	// Parse out options
	for(var/str in split_list)
		if(length(str) == 1)
			break

		if(str[1] != "-")
			break

		if(str[2] == "-")
			if(length(str) < 3) // Double --, stop parsing
				split_list.Cut(1,2)
				break

			if(str[3] == "-")
				break

			output.options += copytext(str, 3)
			split_list.Cut(1, 2)
			continue

		// Single dash, but multiple letters. Rip it apart and pass all of them.
		if(length(str) != 2)
			var/list/letters = splittext(copytext(str, 2), "", 1)
			output.options |= letters
			split_list.Cut(1, 2)
			continue

		output.options += copytext(str, 2)
		split_list.Cut(1, 2)

	output.arguments = split_list
	return output

/datum/c4_file/terminal_program/operating_system/thinkdos/std_in(text)
	. = ..()
	if(.)
		return

	var/datum/thinkdos_stdin/parsed_stdin = parse_std_in(text)
	var/command = lowertext(command_list[1])
	var/list/arguments = length(command_list) > 1 ? command_list.Copy(2) : null

	for(var/datum/shell_command/potential_command as anything in commands)
		if(potential_command.try_exec(src, parsed_stdin.command, parsed_stdin.arguments, parsed_stdin.options))
			return TRUE

	println("'[html_encode(parsed_stdin.raw)]' is not recognized as an internal or external command.")
	return TRUE
