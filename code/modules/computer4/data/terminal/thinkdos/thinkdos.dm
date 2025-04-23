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

/datum/c4_file/terminal_program/operating_system/thinkdos/std_in(text)
	. = ..()
	if(.)
		return

	var/list/command_list = parse_std_in(text)
	var/command_raw = command_list[1]
	var/command = lowertext(command_list[1])
	var/list/arguments = length(command_list) > 1 ? command_list.Copy(2) : null

	for(var/datum/shell_command/potential_command as anything in commands)
		if(potential_command.try_exec(src, command, arguments))
			return TRUE

	println("'[html_encode(command_raw)]' is not recognized as an internal or external command.")
	return TRUE
