/datum/c4_file/terminal_program/medtrak
	name = "MedTrak"
	size = 12

	req_access = list(ACCESS_MEDICAL)

	/// Ref to the medical datacore, for convenience.
	var/datum/data_library/medical_records

	var/list/home_commands
	var/list/index_commands
	var/list/record_commands

	var/current_menu = MEDTRAK_MENU_HOME

/datum/c4_file/terminal_program/medtrak/New()
	..()
	if(!home_commands)
		home_commands = list()
		for(var/path in subtypesof(/datum/shell_command/medtrak/home))
			home_commands += new path

/datum/c4_file/terminal_program/medtrak/execute(datum/c4_file/terminal_program/operating_system/thinkdos/system)
	. = ..()

	var/title_art = @{"<pre>
 __  __              _    _____                    _
|  \/  |   ___    __| |  |_   _|    _ _   __ _    | |__
| |\/| |  / -_)  / _` |    | |     | '_| / _` |   | / /
|_|__|_|  \___|  \__,_|   _|_|_   _|_|_  \__,_|   |_\_\
_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|
"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'</pre>"}
	system.println(title_art)

	medical_records = SSdatacore.library[DATACORE_RECORDS_MEDICAL]
	var/datum/c4_file/folder/log_dir = system.get_log_folder()
	if(!log_dir)
		system.println("<b>Error: Unable to locate logging directory.")

	var/datum/c4_file/text/record_log = log_dir.get_file("medtrak_logs")
	if(!istype(record_log))
		var/datum/c4_file/text/log_file = new
		log_file.set_name("medtrak_logs")
		if(!log_dir.try_add_file(log_file))
			qdel(log_file)
			system.println("<b>Error: Unable to write log file.")

	write_log("[stationtime2text()]| [html_encode(system.current_user.registered_name)] accessed the records database.")

	//src.print_text(mainmenu_text())

/// Getter for the log file. This isn't kept as a ref because I don't want to manage the ref. :)
/datum/c4_file/terminal_program/medtrak/proc/get_log_file()
	RETURN_TYPE(/datum/c4_file/text)
	var/datum/c4_file/folder/log_dir = get_os().get_log_folder()
	if(!log_dir)
		return null

	var/datum/c4_file/text/record_log = log_dir.get_file("medtrak_logs")
	if(!istype(record_log))
		return null

	return record_log

/// Write to the MedTrak log.
/datum/c4_file/terminal_program/medtrak/proc/write_log(text)
	var/datum/c4_file/text/log = get_log_file()
	if(!istype(log))
		return FALSE

	log.data += text
	return TRUE

/datum/c4_file/terminal_program/medtrak/std_in(text)
	. = ..()
	if(.)
		return

	var/os = get_os()
	var/datum/shell_stdin/parsed_stdin = parse_std_in(text)
	switch(current_menu)
		if(MEDTRAK_MENU_HOME)
			for(var/datum/shell_command/command as anything in home_commands)
				if(command.try_exec(parsed_stdin.command, os, src, parsed_stdin.arguments, parsed_stdin.options))
					return TRUE

/datum/c4_file/terminal_program/medtrak/proc/view_index()
	current_menu = MEDTRAK_MENU_INDEX

	var/datum/c4_file/terminal_program/operating_system/thinkdos/system = get_os()
	system.clear_screen(TRUE)

	if(!length(medical_records.records))
		system.println("<b>Error:</b> No records found in database.")
		return

	var/list/out = list()

	var/records_len = length(medical_records.records)
	var/zeros = length("[records_len]") // Gets the number of digits

	for(var/i in 1 to length(medical_records.records))
		var/datum/data/record/R = medical_records.records[i]
		out +="<b>\[[fit_with_zeros("[i]", zeros)]\]</b>[R.fields[DATACORE_ID]]: [R.fields[DATACORE_NAME]]"

	out += "<br>Enter a record number or 'back' to return."
	system.println(jointext(out, "<br>"))
