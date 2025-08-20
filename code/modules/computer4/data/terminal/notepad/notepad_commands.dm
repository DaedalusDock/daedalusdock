/datum/shell_command/notepad/edit_cmd/help
	aliases = list("help")
	help_text = "Lists all available commands. Use help \[command\] to view information about a specific command."

/datum/shell_command/notepad/edit_cmd/help/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	// Stupid fucking byond compiler bug
#if !defined(SPACEMAN_DMM) && !defined(OPENDREAM)
#pragma push
#pragma ignore unused_var
#endif
	var/datum/c4_file/terminal_program/notepad/notepad = program
#if !defined(SPACEMAN_DMM) && !defined(OPENDREAM)
#pragma pop
#endif

	var/list/output = list()

	if(length(arguments))
		var/found = FALSE
		var/searching_for = jointext(arguments, "")
		for(var/datum/shell_command/command_iter as anything in notepad.edit_commands)
			if(searching_for in command_iter.aliases)
				found = TRUE
				output += "Displaying information for '[command_iter.aliases[1]]':"
				output += command_iter.help_text
				break

		if(!found)
			system.println("This command is not supported by the help utility. To see a list of commands, type !help.")
			return

	else
		for(var/datum/shell_command/command_iter as anything in notepad.edit_commands)
			if(length(command_iter.aliases) == 1)
				output += command_iter.aliases[1]
				continue

			output += "[command_iter.aliases[1]] ([jointext(command_iter.aliases.Copy(2), ", ")])"

		sortTim(output, GLOBAL_PROC_REF(cmp_text_asc))
		output.Insert(1,
			"Typing text without a '!' prefix will write to the current line.",
			"You can change lines by typing '!\[number\]'. Zero will change to highest line number.<br>",
			"Use help \[command\] to see specific information about a command.",
			"List of available commands:"
		)


	system.println(jointext(output, "<br>"))

/datum/shell_command/notepad/edit_cmd/quit
	aliases = list("quit", "q", "exit")

/datum/shell_command/notepad/edit_cmd/quit/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	system.println("Quitting...")
	system.unload_program(program)

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

	system.clear_screen(TRUE)
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
	existing_file.set_name(new_name)
	existing_file.stored_record.fields = notepad.note_list.Copy()
	if(dest_folder.try_add_file(existing_file))
		system.println("File saved to [existing_file.path_to_string()].")
	else
		qdel(existing_file)
		system.println("<b>Error</b>: Unable to save to directory.")

/datum/shell_command/notepad/edit_cmd/print
	aliases = list("print", "p")
	help_text = "Prints the current note to a local printer. Accepts a title as an argument."

/datum/shell_command/notepad/edit_cmd/print/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/notepad/notepad = program
	var/obj/item/peripheral/printer/printer = system.get_computer().get_peripheral(PERIPHERAL_TYPE_PRINTER)
	if(!printer)
		system.println("<b>Error:</b> Unable to locate printer.")
		return

	if(printer.busy)
		system.println("<b>Error:</b> Printer is busy.")
		return

	printer.print(jointext(notepad.note_list, "<br>"), html_encode(trim(jointext(arguments, ""))) || "printout")
	system.println("Printing...")
