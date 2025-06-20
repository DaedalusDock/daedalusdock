/datum/c4_file/terminal_program/operating_system/thinkdos/no_login
	needs_login = FALSE

/datum/c4_file/terminal_program/operating_system/thinkdos
	name = "ThinkDOS"

	var/system_version = "ThinkDOS 0.7.2"

	/// If you need to login to use the computer.
	var/needs_login = TRUE

	/// Shell commmands for std_in, built on new.
	var/static/list/commands

	/// Boolean, determines if errors are written to the log file.
	var/log_errors = TRUE

	/// Current logged in user, if any.
	var/datum/c4_file/user/current_user

	/// The command log.
	var/datum/c4_file/text/command_log

/datum/c4_file/terminal_program/operating_system/thinkdos/New()
	if(!commands)
		commands = list()
		for(var/datum/shell_command/thinkdos/command_path as anything in subtypesof(/datum/shell_command/thinkdos))
			commands += new command_path

/datum/c4_file/terminal_program/operating_system/thinkdos/execute()
	if(!initialize_logs())
		println("<font color=red>Log system failure.</font>")

	if(!needs_login)
		println("Account system disabled.")

	else if(!initialize_accounts())
		println("<font color=red>Unable to start account system.</font>")

	change_dir(containing_folder)

	var/title_text = list(
		@"<pre style='margin: 0px'> ___  _    _       _    ___  ___  ___</pre>",
		@"<pre style='margin: 0px'>|_ _|| |_ &lt;_&gt;._ _ | |__| . \| . |/ __&gt;</pre>",
		@"<pre style='margin: 0px'> | | | . || || &#39; || / /| | || | |\__ \</pre>",
		@"<pre style='margin: 0px'> |_| |_|_||_||_|_||_\_\|___/`___&#39;&lt;___/</pre>",
	).Join("")
	println(title_text)

	if(needs_login)
		println("Authenticated required. Insert an identification card and type 'login'.")
	else
		println("Type 'help' to get started.")

/datum/c4_file/terminal_program/operating_system/thinkdos/std_in(text)
	. = ..()
	if(.)
		return

	var/encoded_in = html_encode(text)
	println(encoded_in)
	write_log(encoded_in)

	var/datum/shell_stdin/parsed_stdin = parse_std_in(text)
	if(!current_user && needs_login)
		var/datum/shell_command/thinkdos/login/login_command = locate() in commands
		if(!login_command.try_exec(parsed_stdin.command, src, src, parsed_stdin.arguments, parsed_stdin.options))
			println("Login required. Please login using 'login'.")
		return

	for(var/datum/shell_command/potential_command as anything in commands)
		if(potential_command.try_exec(parsed_stdin.command, src, src, parsed_stdin.arguments, parsed_stdin.options))
			return TRUE

	println("'[html_encode(parsed_stdin.raw)]' is not recognized as an internal or external command.")
	return TRUE

/// Write to the command log.
/datum/c4_file/terminal_program/operating_system/thinkdos/proc/write_log(text)
	if(!command_log || drive.read_only)
		return FALSE

	command_log.data += text
	return TRUE

/// Write to the command log if it's enabled, then print to the screen.
/datum/c4_file/terminal_program/operating_system/thinkdos/proc/print_error(text)
	if(log_errors)
		write_log(text)

	return println(text)

/// Schedule a callback for the system to invoke after the specified time if able.
/datum/c4_file/terminal_program/operating_system/thinkdos/proc/schedule_proc(datum/callback/callback, time)
	addtimer(CALLBACK(src, PROC_REF(execute_scheduled_proc)), time)

/// See schedule_proc()
/datum/c4_file/terminal_program/operating_system/thinkdos/proc/execute_scheduled_proc(datum/callback/callback)
	PRIVATE_PROC(TRUE)

	if(!is_operational())
		return

	callback.Invoke()

/datum/c4_file/terminal_program/operating_system/thinkdos/proc/login(account_name, account_occupation, account_access)
	if(!account_name || !account_occupation)
		return FALSE

	if(!initialize_accounts())
		return FALSE

	var/datum/c4_file/user/login_user = resolve_filepath("users/admin", drive.root)

	login_user.registered_name = account_name
	login_user.assignment = account_occupation
	login_user.access = text2access(account_access)
	set_current_user(login_user)

	write_log("<b>LOGIN</b>: [html_encode(account_name)] | [html_encode(account_occupation)]")
	println("Welcome [html_encode(account_name)]!<br><b>Current Directory: [current_directory.path_to_string()]</b>")
	return TRUE

/datum/c4_file/terminal_program/operating_system/thinkdos/proc/logout()
	if(!current_user)
		print_error("<b>Error:</b> Account system inactive.")
		return FALSE

	write_log("<b>LOGOUT:</b> [html_encode(current_user.registered_name)]")
	set_current_user(null)
	return TRUE

/// Returns the logging folder, attempting to create it if it doesn't already exist.
/datum/c4_file/terminal_program/operating_system/thinkdos/get_log_folder()
	var/datum/c4_file/folder/log_dir = parse_directory("logs", drive.root)
	if(!log_dir)
		log_dir = new /datum/c4_file/folder
		log_dir.set_name("logs")
		if(!drive.root.try_add_file(log_dir))
			qdel(log_dir)
			return null

	return log_dir

/// Create the log file, or append a startup log.
/datum/c4_file/terminal_program/operating_system/thinkdos/proc/initialize_logs()
	if(command_log)
		return TRUE

	var/datum/c4_file/folder/log_dir = get_log_folder()
	var/datum/c4_file/text/log_file = log_dir.get_file("syslog")
	if(!log_file)
		log_file = new /datum/c4_file/text()
		log_file.set_name("syslog")
		if(!log_dir.try_add_file(log_file))
			qdel(log_file)
			return FALSE

	command_log = log_file
	RegisterSignal(command_log, list(COMSIG_COMPUTER4_FILE_RENAMED, COMSIG_COMPUTER4_FILE_ADDED, COMSIG_PARENT_QDELETING), PROC_REF(log_file_gone))

	log_file.data += "<br><b>STARTUP:</b> [stationtime2text()], [stationdate2text()]"
	return TRUE

/datum/c4_file/terminal_program/operating_system/thinkdos/proc/initialize_accounts()
	var/datum/c4_file/folder/account_dir = parse_directory("users")
	if(!istype(account_dir))
		if(account_dir && !account_dir.containing_folder.try_delete_file(account_dir))
			print_error("<b>Error:</b> Unable to write account folder.")
			return FALSE

		account_dir = new
		account_dir.set_name("users")

		if(!containing_folder.try_add_file(account_dir))
			qdel(account_dir)
			print_error("<b>Error:</b> Unable to write account folder.")
			return FALSE

		RegisterSignal(account_dir, list(COMSIG_COMPUTER4_FILE_RENAMED, COMSIG_COMPUTER4_FILE_ADDED, COMSIG_COMPUTER4_FILE_REMOVED), PROC_REF(user_folder_gone))

	var/datum/c4_file/user/user_data = account_dir.get_file("admin", FALSE)
	if(!istype(user_data))
		if(user_data && !user_data.containing_folder.try_delete_file(user_data))
			print_error("<b>Error:</b> Unable to write account folder.")
			return FALSE

		user_data = new
		user_data.set_name("admin")

		if(!account_dir.try_add_file(user_data))
			qdel(user_data)
			print_error("<b>Error:</b> Unable to write account file.")
			return FALSE

		//set_current_user(user_data)
	return TRUE

/datum/c4_file/terminal_program/operating_system/thinkdos/proc/set_current_user(datum/c4_file/user/new_user)
	if(current_user)
		UnregisterSignal(current_user, list(COMSIG_COMPUTER4_FILE_RENAMED, COMSIG_COMPUTER4_FILE_ADDED, COMSIG_COMPUTER4_FILE_REMOVED))

	current_user = new_user

	if(current_user)
		RegisterSignal(current_user, list(COMSIG_COMPUTER4_FILE_RENAMED, COMSIG_COMPUTER4_FILE_ADDED, COMSIG_COMPUTER4_FILE_REMOVED), PROC_REF(user_file_gone))
	else
		for(var/datum/c4_file/terminal_program/running_program as anything in processing_programs)
			if(running_program == src)
				continue

			unload_program(running_program)

