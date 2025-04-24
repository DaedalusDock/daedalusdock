/datum/shell_command
	/// Command names.
	var/list/aliases

/// Attempt to execute the command. Return TRUE if *any* action is taken.
/datum/shell_command/proc/try_exec(obj/machinery/computer/computer, command_name, list/arguments, list/options)
	if(!(command_name in aliases))
		return FALSE

	exec(computer, arguments, options)
	return TRUE

/// Execute the command.
/datum/shell_command/proc/exec(obj/machinery/computer/computer, list/arguments)
	CRASH("Unimplimented run()")

/// Clear the screen
/datum/shell_command/thinkdos/home
	aliases = list("home", "cls")

/datum/shell_command/thinkdos/home/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, list/arguments, list/options)
	system.clear_screen()

/// Print the contents of the current directory.
/datum/shell_command/thinkdos/dir
	aliases = list("dir", "catalog", "ls")

/datum/shell_command/thinkdos/dir/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, list/arguments, list/options)
	system.println("<b>Current folder: [system.current_directory.path_to_string()]</b>", FALSE)

	var/list/directory_text = list()
	var/list/cache_spaces = new /list(16)

	var/longest_name_length = 0
	for(var/datum/c4_file/file in system.current_directory.contents)
		if(length(file.name) > longest_name_length)
			longest_name_length = length(file.name)

	for(var/datum/c4_file/file in system.current_directory.contents)
		var/str = ""
		if(file == system)
			str = "[file.name] - SYSTEM"
		else if(istype(file, /datum/c4_file/folder))
			str = "[file.name] - FOLDER - \[Size:[file.size]\]"
		else
			str = "[file.name] - [file.extension] - \[Size:[file.size]\]"

		// Big block o' stupid to pad the front end of the strings to line up
		var/name_length = length(file.name)
		if(name_length < longest_name_length)
			if(isnull(cache_spaces[name_length]))
				cache_spaces[name_length] = jointext(new /list(longest_name_length - name_length + 1), "&nbsp")

			str = "[cache_spaces[name_length]][str]"

		directory_text += str

	if(length(directory_text))
		system.println(jointext(directory_text, "<br>"))

/// Change the current directory to the root of the current folder.
/datum/shell_command/thinkdos/root
	aliases = list("root")

/datum/shell_command/thinkdos/root/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, list/arguments, list/options)
	system.change_dir(system.current_directory.drive.root)
	system.println("<b>Current Directory is now [system.current_directory.path_to_string()]</b>")
	return

/// Change directory.
/datum/shell_command/thinkdos/cd
	aliases = list("cd", "chdir")

/datum/shell_command/thinkdos/cd/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, list/arguments, list/options)
	if(!length(arguments))
		system.println("<b>Syntax:</b> \"cd \[directory string\]\" String is relative to current directory.")
		return

	var/target_dir = jointext(arguments, " ")

	if(target_dir == "/")
		system.change_dir(system.drive.root)
		system.println("<b>Current Directory is now [system.current_directory.path_to_string()]</b>")
		return

	var/datum/c4_file/folder/new_dir = system.parse_directory(target_dir, system.current_directory)
	if(!new_dir)
		system.print_error("<b>Error:</b> Invalid directory or path.")
		return

	system.change_dir(new_dir)
	system.println("<b>Current Directory is now [system.current_directory.path_to_string()]</b>")


/// Create a folder.
/datum/shell_command/thinkdos/makedir
	aliases = list("makedir", "mkdir")

/datum/shell_command/thinkdos/makedir/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, list/arguments, list/options)
	if(!length(arguments))
		system.println("<b>Syntax:</b> \"makedir \[new directory name\]\"")
		return

	var/folder_name = ckey(trim(jointext(arguments, ""), 16))

	if(system.resolve_filepath(folder_name))
		system.print_error("<b>Error:</b> File name in use.")
		return

	if(!system.validate_file_name(folder_name))
		system.print_error("<b>Error:</b> Invalid character(s).")
		return

	var/datum/c4_file/folder/new_folder = new
	new_folder.name = folder_name

	if(!system.current_directory.try_add_file(new_folder))
		qdel(new_folder)
		system.print_error("<b>Error:</b> Unable to create new directory.")
		return

	system.println("New directory created.")

/// Rename a file
/datum/shell_command/thinkdos/rename
	aliases = list("rename", "ren", "move")

/datum/shell_command/thinkdos/rename/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, list/arguments, list/options)
	if(length(arguments) != 2)
		system.println("<b>Syntax:</b> \"rename \[name of target] \[new name]\"")
		return

	var/old_path = arguments[1]
	var/new_path = arguments[2]

	var/datum/c4_file/file = system.resolve_filepath(old_path)
	if(!file)
		system.print_error("<b>Error:</b> File not found.")
		return

	if(system.resolve_filepath(new_path))
		system.print_error("<b>Error:</b> Name in use.")
		return

	var/datum/file_path/info = system.text_to_filepath(new_path)
	var/datum/c4_file/folder/destination_folder = system.parse_directory(info.directory, system.current_directory)
	if(!destination_folder)
		system.print_error("<b>Error:</b> Directory does not exist.")
		return

	if(!system.validate_file_name(info.file_name))
		system.print_error("<b>Error:</b> Invalid character in name.")
		return

	if((destination_folder != file.containing_folder) && !system.move_file(file, destination_folder))
		system.print_error("<b>Error:</b> AAAAAAAAAAAAAAAAAAAAAA.")
		return

	file.name = info.file_name
	system.println("Done.")


/// Delete a file
/datum/shell_command/thinkdos/delete
	aliases = list("delete", "del", "era", "erase", "rm")

/datum/shell_command/thinkdos/delete/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, list/arguments, list/options)
	if(!length(arguments))
		system.println("<b>Syntax:</b> \"del \[-f\] \[file name].\"")
		return

	var/force = !!length(options & list("f", "force"))
	var/recursive = !!length(options & list("r", "R", "recursive"))

	var/file_name = ckey(jointext(arguments, ""))

	var/datum/c4_file/file = system.resolve_filepath(file_name)
	if(!file)
		if(!force)
			system.print_error("<b>Error:</b> File not found.")
		return

	if(istype(file, /datum/c4_file/folder))
		if(!recursive)
			system.print_error("<b>Error: Use -r option to delete folders.")
			return

		var/datum/c4_file/folder/to_delete = file
		if(length(to_delete.contents) && !force)
			system.print_error("<b>Error:</b> Folder is not empty. Use -f to delete anyway.")
			return

	if(file == system && !force)
		system.print_error("<b>Error:</b> Access denied.")
		return

	if(file.containing_folder.try_delete_file(file))
		system.println("File deleted.")
	else
		system.print_error("<b>Error:</b> Unable to delete file.")

/datum/shell_command/thinkdos/initlogs
	aliases = list("initlogs")

/datum/shell_command/thinkdos/initlogs/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, list/arguments, list/options)
	if(system.command_log)
		system.print_error("<b>Error:</b> File already exists.")
		return

	if(!system.initialize_logs())
		system.print_error("<b>Error:</b> File already exists.")
		return

	system.println("Logging re-initialized.")

/datum/shell_command/thinkdos/print
	aliases = list("print", "echo")

/datum/shell_command/thinkdos/print/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, list/arguments, list/options)
	if(!length(arguments))
		system.println("<b>Syntax:</b> \"print \[text to be printed]\"")
		return

	var/text = html_encode(jointext(arguments, " "))
	system.println(text)

/datum/shell_command/thinkdos/read
	aliases = list("read", "type")

/datum/shell_command/thinkdos/read/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, list/arguments, list/options)
	if(!length(arguments))
		system.println("<b>Syntax:</b> \"read \[file name].\"")
		return

	var/datum/c4_file/file = system.resolve_filepath(ckey(jointext(arguments, "")))
	if(!file)
		system.println("<b>Error</b>: No file found.")
		return

	system.println(file.to_string())

/datum/shell_command/thinkdos/version
	aliases = list("version", "ver")

/datum/shell_command/thinkdos/version/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, list/arguments, list/options)
	system.println("[system.system_version]<br>Copyright Thinktronic Systems, LTD.")

/datum/shell_command/thinkdos/time
	aliases = list("time")

/datum/shell_command/thinkdos/time/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, list/arguments, list/options)
	system.println("[stationtime2text()], [stationdate2text()]")

/datum/shell_command/thinkdos/sizeof
	aliases = list("sizeof", "du")

/datum/shell_command/thinkdos/sizeof/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, list/arguments, list/options)
	if(!length(arguments))
		system.println("<b>Syntax:</b> \"sizeof \[file path].\"")
		return

	var/datum/c4_file/file = system.resolve_filepath(ckey(jointext(arguments, "")))
	if(!file)
		system.print_error("<b>Error:</b> File does not exist.")
		return

	system.println(file.size)

/// Renames the drive title
/datum/shell_command/thinkdos/title
	aliases = list("title")

/datum/shell_command/thinkdos/title/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, list/arguments, list/options)
	if(!length(arguments))
		system.println("<b>Syntax:</b> \"title \[title name]\" Set name of active drive to given title.")
		return

	if(system.drive.read_only)
		system.print_error("<b>Error:</b> Unable to set title string.")
		return

	var/new_title = sanitize(trim(jointext(arguments, ""), 8))
	system.drive.title = new_title
	system.println("Drive title set to <b>[new_title]</b>.")
