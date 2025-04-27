/datum/c4_file/terminal_program/notepad
	name = "DocDock"
	size = 2

	/// Commands in edit mode, executed with a ! prefix
	var/static/list/edit_commands

	var/list/note_list = list()
	var/working_line = 0

/datum/c4_file/terminal_program/notepad/New()
	if(!edit_commands)
		edit_commands = list()
		for(var/path as anything in subtypesof(/datum/shell_command/notepad/edit_cmd))
			edit_commands += new path

/datum/c4_file/terminal_program/notepad/execute()
	. = ..()
	if(.)
		return

	// Hope you saved your work motherfucker.
	working_line = 0
	note_list = list()

	var/datum/c4_file/terminal_program/operating_system/os = get_os()
	os.println("DocDock V4.0")
	os.println("Welcome to DocDock, type !help to get started.")

/datum/c4_file/terminal_program/notepad/parse_std_in(text)
	return splittext(text, " ")

/datum/c4_file/terminal_program/notepad/std_in(text)
	. = ..()
	var/list/arguments = parse_std_in(text)
	var/command = arguments[1]
	arguments.Cut(1,2)

	var/datum/c4_file/terminal_program/operating_system/os = get_os()

	if(command[1] == "!")
		command = copytext(command, 2)
		for(var/datum/shell_command/potential_command as anything in edit_commands)
			if(potential_command.try_exec(command, os, src, arguments, null))
				return TRUE

		var/line_number = text2num(command)
		if(!isnum(line_number))
			os.println("Unrecognized command.")
			return

		line_number = floor(line_number)
		if(line_number <= 0)
			working_line = 0
			os.println("Now working from end of document.")
			return

		if(line_number > length(note_list))
			os.println("Line index out of bounds.")
			return

		working_line = line_number
		os.println("\[[fit_with_zeros("[working_line]", 3)]\] [note_list[working_line]]")
		return TRUE

	var/adding_text = html_encode(text)
	var/adding_assoc_text = ""

	os.println("\[[fit_with_zeros("[working_line == 0 ? length(note_list) + 1 : working_line]", 3)]\] [adding_text]")

	var/split_pos = findtext_char(adding_text, "=")
	if(split_pos)
		adding_assoc_text = copytext_char(adding_text, 1, split_pos)
		adding_assoc_text = html_encode(copytext_char(adding_assoc_text, 1, 257))

		adding_text = copytext_char(adding_text, split_pos + 1)
		adding_text = html_encode(copytext_char(adding_text, 1, 257))
	else
		adding_text = html_encode(copytext_char(adding_text, 1, 257))

	if(working_line == 0)
		note_list += adding_text
		if(adding_assoc_text)
			note_list[adding_text] = adding_assoc_text

	else
		note_list[working_line] = adding_text
		if(adding_assoc_text)
			note_list[adding_text] = adding_assoc_text

		working_line += 1
		if(working_line >= length(note_list))
			working_line = 0
