/datum/c4_file/terminal_program/notepad
	name = "WizWrite"
	size = 2

	var/help_text = {"
		Commands:
		<br> \"!view\" to view note
		<br> \"!del\" to remove current line
		<br> \"!\[integer]" to set current line
		<br> \"!save \[name]\" to save note
		<br> \"!load \[name]\" to load note
		<br> \"!print\" to print current note.
		<br> \"!config\" to configure network printing.
		<br> Anything else to type.
	"}

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

	var/datum/c4_file/terminal_program/operating_system/os = get_os()
	os.println("WizWrite V4.0")
	os.println(help_text)

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

/datum/shell_command/notepad/edit_cmd/quit
	aliases = list("quit", "q", "exit")

/datum/shell_command/notepad/edit_cmd/quit/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	system.println("Quitting...")
	system.containing_folder.computer.unload_program(program)

/datum/shell_command/notepad/edit_cmd/new_note
	aliases = list("new", "n", "clear")

/datum/shell_command/notepad/edit_cmd/new_note/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/notepad/notepad = program
	var/had_note = !length(notepad.note_list)

	notepad.note_list = list()

	if(had_note)
		system.println("Current note cleared.")
	else
		system.println("Initialized new note.")

/datum/shell_command/notepad/edit_cmd/delete
	aliases = list("del", "delete", "d")

/datum/shell_command/notepad/edit_cmd/delete/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/notepad/notepad = program
	if(!length(notepad.note_list))
		system.println("<b>Error:</b> Nothing to delete.")
		return

	if(notepad.working_line == 0)
		notepad.note_list.len--
		system.println("Removed line [length(notepad.note_list)].")
	else
		notepad.note_list.Cut(notepad.working_line, notepad.working_line + 1)
		notepad.working_line = min(length(notepad.note_list), notepad.working_line)
		system.println("Removed line [notepad.working_line].")

/datum/shell_command/notepad/edit_cmd/view
	aliases = list("view", "v")

/datum/shell_command/notepad/edit_cmd/view/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/notepad/notepad = program
	if(!length(notepad.note_list))
		system.println("No document loaded.")
		return

	var/list/print = list()
	for(var/i in 1 to length(notepad.note_list))
		var/note = notepad.note_list[i]
		var/assoc_note = notepad.note_list[note]
		print += "\[[fit_with_zeros("[i]", 3)]\] [note] [assoc_note ? "=[assoc_note]" : ""]"

	system.println(jointext(print, "<br>"))

/datum/shell_command/notepad/edit_cmd/load_note
	aliases = list("load", "l")

/datum/shell_command/notepad/edit_cmd/load_note/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	if(!length(arguments))
		system.println("Syntax: \"!load \[file name]\"")
		return

	var/datum/c4_file/terminal_program/notepad/notepad = program

	var/datum/file_path/path_info = system.text_to_filepath(jointext(arguments, ""))
	var/datum/c4_file/found_file = system.resolve_filepath(path_info.raw)

	if(istype(found_file, /datum/c4_file/record))
		var/datum/c4_file/record/record = found_file
		notepad.note_list = record.stored_record.fields.Copy()

	else if(istype(found_file, /datum/c4_file/text))
		var/datum/c4_file/text/text = found_file
		notepad.note_list = splittext(text.data, "<br>")
	else
		system.println("Error: File not found.")
		return

	notepad.working_line = 0
	system.println("Loaded note from [found_file.path_to_string()].")

/datum/shell_command/notepad/edit_cmd/save_note
	aliases = list("save", "s")

/datum/shell_command/notepad/edit_cmd/save_note/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/notepad/notepad = program
	var/datum/file_path/path_info = system.text_to_filepath(jointext(arguments, ""))
	var/new_name = system.sanitize_filename(path_info?.file_name)

	if(!new_name)
		system.println("Syntax: \"!save \[file name]\"")
		return

	var/datum/c4_file/record/existing_file = system.resolve_filepath(path_info.raw)
	if(existing_file && !istype(existing_file, /datum/c4_file/record))
		system.println("<b>Error:</b> Name in use.")
		return

	if(existing_file)
		if(existing_file.drive.read_only)
			system.println("<b>Error</b>: Cannot open file for write.")
			return

		existing_file.stored_record.fields = notepad.note_list.Copy()
		system.println("File saved to [existing_file.path_to_string()].")
		return

	var/datum/c4_file/folder/dest_folder = system.parse_directory(path_info.directory, system.current_directory)
	if(!dest_folder || dest_folder.drive.read_only)
		system.println("<b>Error</b>: Cannot open directory for write.")
		return

	existing_file = new
	existing_file.name = new_name
	existing_file.stored_record.fields = notepad.note_list.Copy()
	if(dest_folder.try_add_file(existing_file))
		system.println("File saved to [existing_file.path_to_string()].")
	else
		qdel(existing_file)
		system.println("<b>Error</b>: Unable to save to directory.")
