/datum/c4_file/terminal_program/medtrak
	name = "MedTrak"
	size = 12

	req_access = list(ACCESS_MEDICAL)

	/// Ref to the medical datacore, for convenience.
	var/datum/data_library/medical_records
	/// Current open record, if any.
	var/datum/data/record/current_record

	/// Callback to fulfill on std in
	var/datum/callback/awaiting_input

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

	if(!index_commands)
		index_commands = list()
		for(var/path in subtypesof(/datum/shell_command/medtrak/index))
			index_commands += new path

	if(!record_commands)
		record_commands = list()
		for(var/path in subtypesof(/datum/shell_command/medtrak/record))
			record_commands += new path

/datum/c4_file/terminal_program/medtrak/on_close()
	awaiting_input = null

/datum/c4_file/terminal_program/medtrak/execute(datum/c4_file/terminal_program/operating_system/thinkdos/system)
	. = ..()


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

	home_text()

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

	var/datum/c4_file/terminal_program/operating_system/thinkdos/system = get_os()
	var/datum/shell_stdin/parsed_stdin = parse_std_in(text)

	if(awaiting_input)
		var/datum/callback/_awaiting = awaiting_input // Null beforehand incase the awaiting input awaits another input.
		awaiting_input = null
		_awaiting.Invoke(parsed_stdin)
		return

	switch(current_menu)
		if(MEDTRAK_MENU_HOME)
			for(var/datum/shell_command/command as anything in home_commands)
				if(command.try_exec(parsed_stdin.command, system, src, parsed_stdin.arguments, parsed_stdin.options))
					return TRUE

		if(MEDTRAK_MENU_INDEX)
			var/input_num = text2num(parsed_stdin.command)
			if(isnum(input_num))
				if(input_num == 0)
					view_home()
					return TRUE

				if(!(input_num in 1 to length(medical_records.records)))
					system.println("<b>Error:</b> Array index out of bounds.")
					return TRUE

				var/datum/data/record/R = medical_records.records[input_num]
				write_log("Record loaded: [R.fields[DATACORE_ID]]")
				view_record(R)
				return TRUE

			for(var/datum/shell_command/command as anything in index_commands)
				if(command.try_exec(parsed_stdin.command, system, src, parsed_stdin.arguments, parsed_stdin.options))
					return TRUE

		if(MEDTRAK_MENU_RECORD)
			var/input_num = text2num(parsed_stdin.command)
			if(isnum(input_num))
				if(input_num == 0)
					view_index()
					return TRUE

				record_input_num(input_num)
				return TRUE

			for(var/datum/shell_command/command as anything in record_commands)
				if(command.try_exec(parsed_stdin.command, system, src, parsed_stdin.arguments, parsed_stdin.options))
					return TRUE

/// Prints the home menu options
/datum/c4_file/terminal_program/medtrak/proc/home_text()
	var/title_art = @{"<pre>
 __  __              _    _____                    _
|  \/  |   ___    __| |  |_   _|    _ _   __ _    | |__
| |\/| |  / -_)  / _` |    | |     | '_| / _` |   | / /
|_|__|_|  \___|  \__,_|   _|_|_   _|_|_  \__,_|   |_\_\
_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|
"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'</pre>"}
	current_menu = MEDTRAK_MENU_HOME

	var/list/out = list(
		"[title_art]",
		"Commands:",
		"(1) View Medical Records",
		"(2) Record Search",
		"(0) Quit",
	)
	get_os().println(jointext(out, "<br>"))

/datum/c4_file/terminal_program/medtrak/proc/await_input(text, datum/callback/on_input)
	var/datum/c4_file/terminal_program/operating_system/thinkdos/system = get_os()
	system.clear_screen(TRUE)
	awaiting_input = on_input
	system.println(text)

/datum/c4_file/terminal_program/medtrak/proc/view_home()
	current_menu = MEDTRAK_MENU_HOME

	var/datum/c4_file/terminal_program/operating_system/thinkdos/system = get_os()
	system.clear_screen(TRUE)

	home_text()

/datum/c4_file/terminal_program/medtrak/proc/view_index()
	current_menu = MEDTRAK_MENU_INDEX

	var/datum/c4_file/terminal_program/operating_system/thinkdos/system = get_os()
	system.clear_screen(TRUE)

	if(!length(medical_records.records))
		system.println("<b>Error:</b> No records found in database.<br>Enter 'back' to return.")
		return

	var/list/out = list()

	var/records_len = length(medical_records.records)
	var/zeros = length("[records_len]") // Gets the number of digits

	for(var/i in 1 to length(medical_records.records))
		var/datum/data/record/R = medical_records.records[i]
		out +="<b>\[[fit_with_zeros("[i]", zeros)]\]</b>[R.fields[DATACORE_ID]]: [R.fields[DATACORE_NAME]]"

	out += "<br>Enter a record number or 'back' to return."
	system.println(jointext(out, "<br>"))

/datum/c4_file/terminal_program/medtrak/proc/view_record(datum/data/record/R)
	get_os().clear_screen(TRUE)
	current_record = R
	current_menu = MEDTRAK_MENU_RECORD

	var/list/fields = current_record.fields
	#warn add mental/physical health
	var/list/out = list(
		"<b>Record Data:</b>",
		"\[01\] Name: [fields[DATACORE_NAME]] | ID: [fields[DATACORE_ID]]",
		"\[02\] Sex: [fields[DATACORE_GENDER]]",
		"\[03\] Age: [fields[DATACORE_AGE]]",
		"\[04\] Species: [fields[DATACORE_SPECIES]]",
		"\[05\] Blood Type: [fields[DATACORE_BLOOD_TYPE]]",
		"\[06\] Blood DNA: [fields[DATACORE_BLOOD_DNA]]",
		"\[06\] Disabilities: [fields[DATACORE_DISABILITIES]]",
		"\[07\] Disabilities (Details): [fields[DATACORE_DISABILITIES_DETAILS]]",
		"\[08\] Diseases: [fields[DATACORE_DISEASES]]",
		"\[09\] Diseases (Details): [fields[DATACORE_DISEASES_DETAILS]]",
		"\[10\] Notes: [fields[DATACORE_NOTES_DETAILS]]",
		"\[11\] Age: [fields[DATACORE_AGE]]",
		"<br>Enter field number to edit a field",
		"(R) Refresh | (D) Delete | (P) Print | (0) Return to index"
	)

	get_os().println(jointext(out, "<br>"))

/datum/c4_file/terminal_program/medtrak/proc/record_input_num(number)
