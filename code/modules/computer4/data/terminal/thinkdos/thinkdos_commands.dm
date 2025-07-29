/datum/shell_command
	/// Command names.
	var/list/aliases

	/// How to use this command, usually printed by a "help" command.
	var/help_text = "N/A"

/// Attempt to execute the command. Return TRUE if *any* action is taken.
/datum/shell_command/proc/try_exec(command_name, datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	if(!(lowertext(command_name) in aliases))
		return FALSE

	exec(system, program, arguments, options)
	return TRUE

/// Execute the command.
/datum/shell_command/proc/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	CRASH("Unimplimented run()")

/datum/shell_command/thinkdos/help
	aliases = list("help")
	help_text = "Lists all available commands. Use help \[command\] to view information about a specific command."

/datum/shell_command/thinkdos/help/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/list/output = list()

	if(length(arguments))
		var/found = FALSE
		var/searching_for = jointext(arguments, "")
		for(var/datum/shell_command/command_iter as anything in system.commands)
			if(searching_for in command_iter.aliases)
				found = TRUE
				output += "Displaying information for '[command_iter.aliases[1]]':"
				output += command_iter.help_text
				break

		if(!found)
			system.print_error("This command is not supported by the help utility. To see a list of commands, type help.")
			return

	else
		for(var/datum/shell_command/command_iter as anything in system.commands)
			if(length(command_iter.aliases) == 1)
				output += command_iter.aliases[1]
				continue

			output += "[command_iter.aliases[1]] ([jointext(command_iter.aliases.Copy(2), ", ")])"

		sortTim(output, GLOBAL_PROC_REF(cmp_text_asc))
		output.Insert(1, "Use help \[command\] to see specific information about a command.", "List of available commands:")


	system.println(jointext(output, "<br>"))

/// Clear the screen
/datum/shell_command/thinkdos/home
	aliases = list("home", "cls")
	help_text = "Clears the screen of all text."

/datum/shell_command/thinkdos/home/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	system.clear_screen()

/// Print the contents of the current directory.
/datum/shell_command/thinkdos/dir
	aliases = list("dir", "catalog", "ls")
	help_text = "Prints the contents of a directory.<br>Usage: 'dir \[directory?\]'"

/datum/shell_command/thinkdos/dir/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/inputted_path = jointext(arguments, " ")
	var/datum/c4_file/folder/targeted_dir = system.parse_directory(inputted_path, system.current_directory)
	if(!targeted_dir)
		system.print_error("<b>Error:</b> Invalid directory or path.")
		return

	system.println("<b>Contents of [targeted_dir.path_to_string()]:</b>", FALSE)

	var/list/directory_text = list()
	var/list/cache_spaces = new /list(16)

	var/longest_name_length = 0
	for(var/datum/c4_file/file in targeted_dir.contents)
		if(length(file.name) > longest_name_length)
			longest_name_length = length(file.name)

	for(var/datum/c4_file/file in targeted_dir.contents)
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
	help_text = "Changes the current directory to the root of the file system."

/datum/shell_command/thinkdos/root/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	system.change_dir(system.current_directory.drive.root)
	system.println("<b>Current Directory is now [system.current_directory.path_to_string()]</b>")
	return

/// Change directory.
/datum/shell_command/thinkdos/cd
	aliases = list("cd", "chdir")
	help_text = "Changes the current directory.<br>Usage: 'cd \[directory\]'<br><br>'.' refers to the current directory.<br>'../' refers to the parent directory."

/datum/shell_command/thinkdos/cd/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	if(!length(arguments))
		system.println("<b>Syntax:</b> \"cd \[directory string\]\".")
		return

	var/target_dir = jointext(arguments, " ")

	var/datum/c4_file/folder/new_dir = system.parse_directory(target_dir, system.current_directory)
	if(!new_dir)
		system.print_error("<b>Error:</b> Invalid directory or path.")
		return

	system.change_dir(new_dir)
	system.println("<b>Current Directory is now [system.current_directory.path_to_string()]</b>")


/// Create a folder.
/datum/shell_command/thinkdos/makedir
	aliases = list("makedir", "mkdir")
	help_text = "Creates a new folder.<br>Usage: 'makedir \[directory\]'<br><br>See 'cd' for more information."

/datum/shell_command/thinkdos/makedir/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	if(!length(arguments))
		system.println("<b>Syntax:</b> \"makedir \[new directory name\]\"")
		return

	var/folder_name = trim(jointext(arguments, ""), 16)

	if(system.resolve_filepath(folder_name))
		system.print_error("<b>Error:</b> File name in use.")
		return

	if(!system.validate_file_name(folder_name))
		system.print_error("<b>Error:</b> Invalid character(s).")
		return

	var/datum/c4_file/folder/new_folder = new
	new_folder.set_name(folder_name)

	if(!system.current_directory.try_add_file(new_folder))
		qdel(new_folder)
		system.print_error("<b>Error:</b> Unable to create new directory.")
		return

	system.println("New directory created.")

/// Rename a file
/datum/shell_command/thinkdos/rename
	aliases = list("move","mv", "rename", "ren")
	help_text = "Moves or renames a file or folder.<br>Usage: 'move \[options?\] \[path\] \[destination path\]'<br><br>See 'cd' for more information.<br>-f, --force &nbsp&nbsp&nbsp&nbsp&nbsp&nbspOverwrite any existing files in the destination location."

/datum/shell_command/thinkdos/rename/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	if(length(arguments) != 2)
		system.println("<b>Syntax:</b> \"rename \[name of target] \[new name]\"")
		return

	var/old_path = arguments[1]
	var/new_path = arguments[2]

	var/overwrite = !!length(options & list("f", "force"))

	var/datum/c4_file/file = system.resolve_filepath(old_path)
	if(!file)
		system.print_error("<b>Error:</b> Source file not found.")
		return

	var/datum/file_path/destination_info = system.text_to_filepath(new_path)
	var/desired_name = destination_info.file_name

	var/datum/c4_file/folder/destination_folder = system.parse_directory(destination_info.directory, system.current_directory)
	if(!destination_folder)
		system.print_error("<b>Error:</b> Target directory not found.")
		return

	if(desired_name && !system.validate_file_name(desired_name))
		system.print_error("<b>Error:</b> Invalid character in name.")
		return

	var/old_name = file.name

	// Preserve the existing file name if we didn't specify a new name.
	desired_name ||= file.name

	if((destination_folder != file.containing_folder))
		var/err
		if(system.move_file(file, destination_folder, &err, overwrite, new_name = desired_name))
			system.println("Moved [old_name] to [file.path_to_string()].")
			return

		if(err == "Target in use.")
			err += " Use -f to overwrite."

		system.print_error("<b>Error:</b> [err]")
		return

	var/datum/c4_file/shares_name = destination_folder.get_file(desired_name)
	if(shares_name)
		if(!overwrite)
			system.print_error("<b>Error:</b> Target in use. Use -f to overwrite.")
			return

		if(!destination_folder.try_delete_file(shares_name))
			system.print_error("<b>Error:</b> Unable to delete target.")
			return

	file.set_name(desired_name)
	system.println("Moved [old_name] to [file.path_to_string()].")

/// Copy a file (opens can of worms and begins eating them).
/datum/shell_command/thinkdos/copy
	aliases = list("copy","cp")
	help_text = "Copies a file to another location.<br>Usage: 'move \[options?\] \[path\] \[destination path\]'<br><br>See 'cd' for more information.<br>-f, --force &nbsp&nbsp&nbsp&nbsp&nbsp&nbspOverwrite any existing files in the destination location."

/datum/shell_command/thinkdos/copy/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	if(length(arguments) != 2)
		system.println("<b>Syntax:</b> \"copy \[name of target] \[new location]\"")
		return

	var/old_path = arguments[1]
	var/new_path = arguments[2]

	var/overwrite = !!length(options & list("f", "force"))

	var/datum/c4_file/to_copy = system.resolve_filepath(old_path)
	if(!to_copy)
		system.print_error("<b>Error:</b> Source file not found.")
		return

	if(to_copy.size + system.drive.root.size > system.drive.disk_capacity)
		system.print_error("<b>Error:</b> Copy operation would exceed disk storage.")
		return

	var/datum/file_path/destination_info = system.text_to_filepath(new_path)
	var/desired_name = destination_info.file_name

	var/datum/c4_file/folder/destination_folder = system.parse_directory(destination_info.directory, system.current_directory)
	if(!destination_folder)
		system.print_error("<b>Error:</b> Target directory not found.")
		return

	if(desired_name && !system.validate_file_name(desired_name))
		system.print_error("<b>Error:</b> Invalid character in name.")
		return

	// Preserve the existing file name if we didn't specify a new name.
	desired_name ||= to_copy.name

	var/datum/c4_file/shares_name = destination_folder.get_file(desired_name)
	if(shares_name)
		if(shares_name == to_copy)
			system.print_error("<b>Error:</b> Cannot copy in-place.")
			return

		if(!overwrite)
			system.print_error("<b>Error:</b> Target in use. Use -f to overwrite.")
			return

		if(!destination_folder.try_delete_file(shares_name))
			system.print_error("<b>Error:</b> Unable to delete target.")
			return

	var/datum/c4_file/copy = to_copy.copy()
	copy?.set_name(desired_name)

	if(isnull(copy))
		system.print_error("<b>Error:</b> Unable to copy file.")
		return

	if(!destination_folder.try_add_file(copy))
		qdel(copy)
		system.print_error("<b>Error:</b> Unable to copy file.")
		return

	system.println("Copied [to_copy.name] to [copy.path_to_string()].")

/// Delete a file
/datum/shell_command/thinkdos/delete
	aliases = list("delete", "del", "era", "erase", "rm")

/datum/shell_command/thinkdos/delete/New()
	..()
	var/list/help_list = list(
		"Deletes the specified file from the drive.",
		"Usage: 'delete \[options?\] \[path\]'",
		"<br>See 'cd' for more information.",
	)
	help_list += "[fit_with("-f, --force", 20, "&nbsp", TRUE)]Overwrite any existing files in the destination location."
	help_list += "[fit_with("-r, -R, --recursive", 20, "&nbsp", TRUE)]Allow deletion of folders."
	help_text = jointext(help_list, "<br>")

/datum/shell_command/thinkdos/delete/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	if(!length(arguments))
		system.println("<b>Syntax:</b> \"del \[-f\] \[file name].\"")
		return

	var/force = !!length(options & list("f", "force"))
	var/recursive = !!length(options & list("r", "R", "recursive"))

	var/datum/c4_file/file = system.resolve_filepath(jointext(arguments, ""))

	if(!file)
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

	if(!file.containing_folder) // is root
		var/datum/c4_file/folder/root_dir = file
		for(var/datum/c4_file/file_iter as anything in root_dir.contents)
			root_dir.try_delete_file(file_iter)

		if(!QDELETED(system))
			system.println("File deleted.")
		return

	if(file.containing_folder.try_delete_file(file))
		system.println("File deleted.")
	else
		system.print_error("<b>Error:</b> Unable to delete file.")

/datum/shell_command/thinkdos/initlogs
	aliases = list("initlogs")
	help_text = "Creates the system log file."

/datum/shell_command/thinkdos/initlogs/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	if(system.command_log)
		system.print_error("<b>Error:</b> File already exists.")
		return

	if(!system.initialize_logs())
		system.print_error("<b>Error:</b> File already exists.")
		return

	system.println("Logging re-initialized.")

/datum/shell_command/thinkdos/print
	aliases = list("print", "echo")
	help_text = "Displays the specified text."

/datum/shell_command/thinkdos/print/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	if(!length(arguments))
		system.println("<b>Syntax:</b> \"print \[text to be printed]\"")
		return

	var/text = html_encode(jointext(arguments, " "))
	system.println(text)

/datum/shell_command/thinkdos/read
	aliases = list("read", "type")
	help_text = "Displays the contents of a file.<br>Usage: 'read \[directory\]'"

/datum/shell_command/thinkdos/read/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	if(!length(arguments))
		system.println("<b>Syntax:</b> \"read \[file name].\"")
		return

	var/datum/c4_file/file = system.resolve_filepath(jointext(arguments, ""))
	if(!file)
		system.println("<b>Error</b>: No file found.")
		return

	system.println(html_encode(file.to_string()))

/datum/shell_command/thinkdos/version
	aliases = list("version", "ver")
	help_text = "Displays the version of the operating system."

/datum/shell_command/thinkdos/version/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	system.println("[system.system_version]<br>Copyright Thinktronic Systems, LTD.")

/datum/shell_command/thinkdos/time
	aliases = list("time")
	help_text = "Displays the current time."

/datum/shell_command/thinkdos/time/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	system.println("[stationtime2text()], [stationdate2text()]")

/datum/shell_command/thinkdos/sizeof
	aliases = list("sizeof", "du")
	help_text = "Displays the size of a file on disk.<br>Usage: 'sizeof \[directory\]'"

/datum/shell_command/thinkdos/sizeof/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	if(!length(arguments))
		system.println("<b>Syntax:</b> \"sizeof \[file path].\"")
		return

	var/datum/c4_file/file = system.resolve_filepath(jointext(arguments, ""))
	if(!file)
		system.print_error("<b>Error:</b> File does not exist.")
		return

	system.println(file.size)

/// Renames the drive title
/datum/shell_command/thinkdos/title
	aliases = list("title")
	help_text = "Changes the name of the current .<br>Usage: 'title \[new name\]'"

/datum/shell_command/thinkdos/title/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	if(!length(arguments))
		system.println("<b>Syntax:</b> \"title \[title name]\" Set name of active drive to given title.")
		return

	if(system.drive.read_only)
		system.print_error("<b>Error:</b> Unable to set title string.")
		return

	var/new_title = sanitize(trim(jointext(arguments, ""), 8))
	system.drive.title = new_title
	system.println("Drive title set to <b>[new_title]</b>.")

/datum/shell_command/thinkdos/run_prog
	aliases = list("run")
	help_text = "Runs an executable file.<br>Usage: 'run \[file\]'"

/datum/shell_command/thinkdos/run_prog/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	if(!length(arguments))
		system.println("<b>Syntax:</b> \"run \[program filepath].\"")
		return

	var/file_path = jointext(arguments, "")

	var/datum/c4_file/terminal_program/program_to_run = system.resolve_filepath(file_path, system.current_directory)
	if(!istype(program_to_run) || istype(program_to_run, /datum/c4_file/terminal_program/operating_system))
		system.print_error("<b>Error: Cannot find executable.")
		return

	system.execute_program(program_to_run)

/datum/shell_command/thinkdos/tree
	aliases = list("tree")
	help_text = "Displays the file system structure relative to a directory.<br>Usage: 'tree \[options?\] \[directory?\]'<br><br>-f, --file &nbsp&nbsp&nbsp&nbsp&nbsp&nbspDisplay files."

/datum/shell_command/thinkdos/tree/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/folder/targeted_dir = system.parse_directory(jointext(arguments, " "), system.current_directory)
	if(!targeted_dir)
		system.print_error("<b>Error:</b> Invalid directory or path.")
		return

	var/show_files = !!length(options & list("f", "files"))

	var/list/output = list((targeted_dir == system.drive.root) ? system.drive.title : targeted_dir.name)

	search_dir(targeted_dir, output, show_files, 1)

	system.println(jointext(output, "<br>"))

/datum/shell_command/thinkdos/tree/proc/search_dir(datum/c4_file/folder/folder, list/output, show_files, depth)
	var/spaces = jointext(new /list((depth * 2) + 1), "&nbsp")

	for(var/datum/c4_file/file as anything in folder.contents)
		var/is_folder = istype(file, /datum/c4_file/folder)
		if(!is_folder && !show_files)
			continue

		output += "[spaces]↳ [file.name]"
		if(is_folder)
			search_dir(file, output, show_files, depth + 1)

/datum/shell_command/thinkdos/backprog
	aliases = list("backprog", "bp")

	var/list/sub_commands = list()

/datum/shell_command/thinkdos/backprog/New()
	..()
	for(var/path in subtypesof(/datum/shell_command/thinkdos_backprog))
		sub_commands += new path

	var/list/help_list = list(
		"Manage background processes.",
		"Usage: 'backprog \[argument 1\] \[argument 2?\]'",
	)
	help_list += "[fit_with("k, kill", 20, "&nbsp", TRUE)]Terminate a background process."
	help_list += "[fit_with("s, switch", 20, "&nbsp", TRUE)]Focus a background process."
	help_list += "[fit_with("v, view", 20, "&nbsp", TRUE)]Display background processes."
	help_text = jointext(help_list, "<br>")

/datum/shell_command/thinkdos/backprog/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	if(!length(arguments))
		system.println("<b>Syntax:</b> backprog \[argument\]<br><b>Valid arguments:</b> view, kill, switch")
		return

	var/sub_name = arguments[1]
	var/list/inner_arguments = arguments.Copy()
	inner_arguments.Cut(1,2)

	for(var/datum/shell_command/sub_command as anything in sub_commands)
		if(sub_command.try_exec(sub_name, system, program, inner_arguments, null))
			return

	system.println("<b>Syntax:</b> backprog \[argument\]<br><b>Valid arguments:</b> view, kill, switch")

/datum/shell_command/thinkdos_backprog/view
	aliases = list("view", "v")

/datum/shell_command/thinkdos_backprog/view/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/list/out = list("<b>Current programs in memory:</b>")

	var/count = 0
	for(var/datum/c4_file/terminal_program/running_program as anything in system.processing_programs)
		count++
		out += "<b>ID: [count]</b> [running_program == system ? "SYSTEM" : running_program.name]"

	system.println(jointext(out, "<br>"))

/datum/shell_command/thinkdos_backprog/kill
	aliases = list("kill", "k")

/datum/shell_command/thinkdos_backprog/kill/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/id = text2num(jointext(arguments, ""))
	if(isnull(id))
		system.println("<b>Syntax:</b> backprog kill \[program id\]")
		return

	if(!(id in 1 to length(system.processing_programs)))
		system.print_error("<b>Error:</b> Array index out of bounds.")
		return

	var/datum/c4_file/terminal_program/to_kill = system.processing_programs[id]
	if(to_kill == system)
		system.print_error("<b>Error:</b> Unable to terminate process.")
		return

	system.unload_program(to_kill)
	system.println("Terminated [to_kill.name].")

/datum/shell_command/thinkdos_backprog/switch_prog
	aliases = list("switch", "s")

/datum/shell_command/thinkdos_backprog/switch_prog/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/id = text2num(jointext(arguments, ""))
	if(isnull(id))
		system.println("<b>Syntax:</b> backprog switch \[program id\]")
		return

	if(!(id in 1 to length(system.processing_programs)))
		system.print_error("<b>Error:</b> Array index out of bounds.")
		return

	var/datum/c4_file/terminal_program/to_run = system.processing_programs[id]
	if(to_run == system)
		system.print_error("<b>Error:</b> Process already focused.")
		return

	system.execute_program(to_run)

/datum/shell_command/thinkdos/login
	aliases = list("login", "logon")

/datum/shell_command/thinkdos/login/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	if(usr?.has_unlimited_silicon_privilege)
		system.login("AIUSR", "Colony Intelligence")
		return

	var/obj/item/peripheral/card_reader/reader = system.get_computer().get_peripheral(PERIPHERAL_TYPE_CARD_READER)
	if(!reader)
		system.println("<b>Error:</b> No card reader detected.")
		return

	var/datum/signal/login_packet = reader.scan_card()
	if(istype(login_packet))
		system.login(login_packet.data["name"], login_packet.data["job"], login_packet.data["access"])

	else if(login_packet == "nocard")
		system.print_error("<b>Error:</b> No ID card inserted.")

/datum/shell_command/thinkdos/logout
	aliases = list("logout", "logoff")

/datum/shell_command/thinkdos/logout/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	system.logout()
	system.println("Logout complete. Have a secure day.<br><br>Authentication required.<br>Please insert card and 'login'.")
