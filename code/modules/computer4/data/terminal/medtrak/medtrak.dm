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

	var/static/list/home_commands
	var/static/list/index_commands
	var/static/list/record_commands
	var/static/list/comment_commands

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

	if(!comment_commands)
		comment_commands = list()
		for(var/path in subtypesof(/datum/shell_command/medtrak/comment))
			comment_commands += new path

/datum/c4_file/terminal_program/medtrak/on_close()
	awaiting_input = null

/datum/c4_file/terminal_program/medtrak/execute(datum/c4_file/terminal_program/operating_system/thinkdos/system)
	. = ..()


	medical_records = SSdatacore.library[DATACORE_RECORDS_MEDICAL]
	var/datum/c4_file/folder/log_dir = system.get_log_folder()
	if(!log_dir)
		system.println("<b>Error:</b> Unable to locate logging directory.")

	var/datum/c4_file/text/record_log = log_dir.get_file("medtrak_logs")
	if(!istype(record_log))
		var/datum/c4_file/text/log_file = new
		log_file.set_name("medtrak_logs")
		if(!log_dir.try_add_file(log_file))
			qdel(log_file)
			system.println("<b>Error: Unable to write log file.")

	write_log("[system.current_user.registered_name] accessed the records database.")

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

/// Write to the MedTrak log. Encodes the inputted text.
/datum/c4_file/terminal_program/medtrak/proc/write_log(text)
	var/datum/c4_file/text/log = get_log_file()
	if(!istype(log))
		return FALSE

	log.data += "[stationtime2text()]| [html_encode(text)]"
	return TRUE

/// Updates the current record and logs it.
/datum/c4_file/terminal_program/medtrak/proc/update_record(field, field_name, new_value)
	write_log("Updated record [current_record.fields[DATACORE_ID]] Field: [field_name] | Old: [current_record.fields[field]] | New: [new_value]")
	current_record.fields[field] = new_value

/datum/c4_file/terminal_program/medtrak/std_in(text)
	. = ..()
	if(.)
		return

	var/datum/c4_file/terminal_program/operating_system/thinkdos/system = get_os()
	var/datum/shell_stdin/parsed_stdin = parse_std_in(text)

	if(awaiting_input)
		var/datum/callback/_awaiting = awaiting_input // Null beforehand incase the awaiting input awaits another input.
		awaiting_input = null
		_awaiting.Invoke(src, parsed_stdin)
		return

	var/lowertext_command = lowertext(parsed_stdin.command)

	switch(current_menu)
		if(MEDTRAK_MENU_HOME)
			for(var/datum/shell_command/command as anything in home_commands)
				if(command.try_exec(lowertext_command, system, src, parsed_stdin.arguments, parsed_stdin.options))
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
				if(command.try_exec(lowertext_command, system, src, parsed_stdin.arguments, parsed_stdin.options))
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
				if(command.try_exec(lowertext_command, system, src, parsed_stdin.arguments, parsed_stdin.options))
					return TRUE

		if(MEDTRAK_MENU_COMMENTS)
			for(var/datum/shell_command/command as anything in comment_commands)
				if(command.try_exec(lowertext_command, system, src, parsed_stdin.arguments, parsed_stdin.options))
					return TRUE

/// Prints the home menu options
/datum/c4_file/terminal_program/medtrak/proc/home_text()
	var/title_text = list(
		@(eol)"<pre style='margin: 0px'> __  __              _    _____                    _</pre>"eol,
		@(eol)"<pre style='margin: 0px'>|  \/  |   ___    __| |  |_   _|    _ _   __ _    | |__</pre>"eol,
		@(eol)"<pre style='margin: 0px'>| |\/| |  / -_)  / _` |    | |     | '_| / _` |   | / /</pre>"eol,
		@(eol)"<pre style='margin: 0px'>|_|__|_|  \___|  \__,_|   _|_|_   _|_|_  \__,_|   |_\_\</pre>"eol,
		@(eol)"<pre style='margin: 0px'>_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|</pre>"eol,
		@(eol)"<pre style='margin: 0px'> `-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'</pre>"eol,
	).Join("")
	current_menu = MEDTRAK_MENU_HOME

	var/list/out = list(
		"[title_text]",
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

	out += "<br>(#) View record | (new) New record | (back) Return to home"
	system.println(jointext(out, "<br>"))

/datum/c4_file/terminal_program/medtrak/proc/view_record(datum/data/record/R)
	if(isnull(R))
		R = current_record
	else
		current_record = R

	current_menu = MEDTRAK_MENU_RECORD

	get_os().clear_screen(TRUE)

	var/list/fields = current_record.fields
	var/list/out = list(
		"<b>Record Data:</b>",
		"\[01\] Name: [fields[DATACORE_NAME]] | ID: [fields[DATACORE_ID]]",
		"\[02\] Sex: [fields[DATACORE_GENDER]]",
		"\[03\] Age: [fields[DATACORE_AGE]]",
		"\[04\] Species: [fields[DATACORE_SPECIES]]",
		"\[05\] Blood Type: [fields[DATACORE_BLOOD_TYPE]]",
		"\[06\] Blood DNA: [fields[DATACORE_BLOOD_DNA]]",
		"\[07\] Disabilities: [fields[DATACORE_DISABILITIES]]",
		"\[08\] Diseases: [fields[DATACORE_DISEASES]]",
		"\[09\] Allergies: [fields[DATACORE_ALLERGIES]]",
		"\[10\] Physical Status: [fields[DATACORE_PHYSICAL_HEALTH]]",
		"\[11\] Mental Status: [fields[DATACORE_MENTAL_HEALTH]]",
		"\[12\] Notes: [fields[DATACORE_NOTES]]",
		"<br>Enter field number to edit a field",
		"(C) Comments | (R) Refresh | (D) Delete | (P) Print | (0) Return to index"
	)

	get_os().println(jointext(out, "<br>"))

/datum/c4_file/terminal_program/medtrak/proc/record_input_num(number)
	switch(number)
		if(1)
			await_input("Enter a new Name (Max Length: [MAX_NAME_LEN])", CALLBACK(src, PROC_REF(edit_name)))
		if(2)
			await_input("Enter a new Sex (Max Length: [MAX_NAME_LEN])", CALLBACK(src, PROC_REF(edit_sex)))
		if(3)
			await_input("Enter a new Age (1-200)", CALLBACK(src, PROC_REF(edit_age)))
		if(4)
			await_input("Enter a new Species (Max Length: [MAX_NAME_LEN])", CALLBACK(src, PROC_REF(edit_species)))
		if(5)
			await_input("Enter a new Blood Type (Max Length: [MAX_NAME_LEN])", CALLBACK(src, PROC_REF(edit_blood_type)))
		if(6)
			await_input("Enter new Blood DNA (Max Length: [MAX_NAME_LEN])", CALLBACK(src, PROC_REF(edit_blood_dna)))
		if(7)
			await_input("Enter new Disabilities (Max Length: [MAX_MESSAGE_LEN])", CALLBACK(src, PROC_REF(edit_disabilities)))
		if(8)
			await_input("Enter new Diseases (Max Length: [MAX_MESSAGE_LEN])", CALLBACK(src, PROC_REF(edit_diseases)))
		if(9)
			await_input("Enter new Allergies (Max Length: [MAX_MESSAGE_LEN])", CALLBACK(src, PROC_REF(edit_allergies)))
		if(10)
			await_input(
				{"Edit Physical Status<br>
				\[1\] [PHYSHEALTH_OK]<br>
				\[2\] [PHYSHEALTH_CARE]<br>
				\[3\] [PHYSHEALTH_DECEASED]
				"},
				CALLBACK(src, PROC_REF(edit_physical_health))
			)
		if(11)
			await_input(
				{"Edit Mental Status<br>
				\[1\] [MENHEALTH_OK]<br>
				\[2\] [MENHEALTH_WATCH]<br>
				\[3\] [MENHEALTH_UNSTABLE]<br>
				\[4\] [MENHEALTH_INSANE]
				"},
				CALLBACK(src, PROC_REF(edit_mental_health))
			)
		if(12)
			await_input("Enter new Notes (Max Length: [MAX_MESSAGE_LEN])", CALLBACK(src, PROC_REF(edit_notes)))

/datum/c4_file/terminal_program/medtrak/proc/view_comments()
	current_menu = MEDTRAK_MENU_COMMENTS

	var/datum/c4_file/terminal_program/operating_system/thinkdos/system = get_os()
	system.clear_screen(TRUE)

	if(!length(current_record.fields[DATACORE_COMMENTS]))
		system.println("No comments to display.")

	else
		var/list/out = list()

		var/count = 0
		for(var/comment in current_record.fields[DATACORE_COMMENTS])
			count++
			out += "\[[fit_with_zeros("[count]", 2)]\] [comment]"

		system.println(jointext(out, "<br>"))

	system.println("(N) New comment  | (0) Return to record")
