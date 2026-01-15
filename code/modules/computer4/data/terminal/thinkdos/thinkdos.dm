/datum/c4_file/terminal_program/operating_system/thinkdos/no_login
	needs_login = FALSE

/datum/c4_file/terminal_program/operating_system/thinkdos
	name = "ThinkDOS"

	var/system_version = "ThinkDOS 0.7.2"

	/// If you need to login to use the computer.
	var/needs_login = TRUE

	/// Shell commmands for std_in, built on new.
	var/static/list/commands

	/// Lazy queue of shell commands. When the system is active, it will try to run these.
	var/list/datum/parsed_cmdline/queued_commands

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
		println("[ANSI_FG_RED]Log system failure.[ANSI_FG_RESET]")

	if(!needs_login)
		println("Account system disabled.")

	else if(!initialize_accounts())
		println("[ANSI_FG_RED]Unable to start account system.[ANSI_FG_RESET]")

	change_dir(containing_folder)

	var/title_text = list(
		"[ANSI_FG_RED]",    @" ___  _    _       _    ___  ___  ___ ", "\n",
		"[ANSI_FG_YELLOW]", @"|_ _|| |_ <_>._ _ | |__| . \| . |/ __>", "\n",
		"[ANSI_FG_BLUE]",   @" | | | . || || ' || / /| | || | |\__ \", "\n",
		"[ANSI_FG_CYAN]",   @" |_| |_|_||_||_|_||_\_\|___/`___'<___/", "[ANSI_FG_RESET]"
	).Join("")
	println(title_text)

	if(needs_login)
		println("Authenticated required. Insert an identification card and type 'login'.")
	else
		println("Type 'help' to get started.")

/datum/c4_file/terminal_program/operating_system/thinkdos/parse_cmdline(text)
	RETURN_TYPE(/list/datum/parsed_cmdline)

	var/list/split_raw = splittext(text, THINKDOS_SYMBOL_SEPARATOR)
	if(length(split_raw) > THINKDOS_MAX_COMMANDS)
		var/excess = length(split_raw) - THINKDOS_MAX_COMMANDS
		split_raw.Cut(THINKDOS_MAX_COMMANDS + 1)
		println("Discarding [excess] excess command\s")

	. = list()
	for(var/raw_command in split_raw)
		. += new /datum/parsed_cmdline(trimtext(raw_command)) //built-in is faster, don't care about right whitespace

/datum/c4_file/terminal_program/operating_system/thinkdos/std_in(text)
	. = ..()
	if(.)
		return

	var/encoded_in = html_encode(text)
	println(encoded_in)
	write_log(encoded_in)

	var/list/datum/parsed_cmdline/parsed_cmdlines = parse_cmdline(text)
	if(!length(parsed_cmdlines)) //okay
		return TRUE

	if(!current_user && needs_login)
		var/datum/parsed_cmdline/login_stdin = parsed_cmdlines[1]
		var/datum/shell_command/thinkdos/login/login_command = locate() in commands
		if(!login_command.try_exec(login_stdin.command, src, src, login_stdin.arguments, login_stdin.options))
			println("Login required. Please login using 'login'.")
		return

	queued_commands = parsed_cmdlines
	handle_command_queue()
	return TRUE

/datum/c4_file/terminal_program/operating_system/thinkdos/unload_program(datum/c4_file/terminal_program/program)
	. = ..()
	if(.)
		handle_command_queue()


/datum/c4_file/terminal_program/operating_system/thinkdos/proc/handle_command_queue()
	while(LAZYLEN(queued_commands)) //hmm...
		if(active_program != src) //We are now blocking
			break

		var/datum/parsed_cmdline/parsed_cmdline = popleft(queued_commands)
		var/recognized = FALSE
		for(var/datum/shell_command/potential_command as anything in commands)
			if(potential_command.try_exec(parsed_cmdline.command, src, src, parsed_cmdline.arguments, parsed_cmdline.options))
				recognized = TRUE
				break
		// Check if we executed a shell command, if so, break out of the while loop.
		if(recognized)
			continue //We aren't being re-called from unload_program(), so we have to loop back to the start here.
		// Otherwise,  Search the local directory for a matching program
		// Argument passing doesn't exist for programs so we can just ignore it.
		var/datum/c4_file/terminal_program/program_to_run = resolve_filepath(parsed_cmdline.command)
		if(!istype(program_to_run) || istype(program_to_run, /datum/c4_file/terminal_program/operating_system))
			// If that one's not good, Search the bin directory for a matching program
			program_to_run = resolve_filepath(parsed_cmdline.command, get_bin_folder())

		if(istype(program_to_run) && !istype(program_to_run, /datum/c4_file/terminal_program/operating_system))
			execute_program(program_to_run, parsed_cmdline) //This will block command queue execution.
			recognized = TRUE
			break


		if(!recognized)
			println("'[html_encode(parsed_cmdline.raw)]' is not recognized as an internal or external command.")

	UNSETEMPTY(queued_commands)

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

	write_log("[ANSI_WRAP_BOLD("LOGIN")]: [account_name] | [account_occupation]")
	println("Welcome [html_encode(account_name)]!\n[ANSI_WRAP_BOLD("Current Directory: [current_directory.path_to_string()]")]")
	return TRUE

/datum/c4_file/terminal_program/operating_system/thinkdos/proc/logout()
	if(!current_user)
		print_error("[ANSI_WRAP_BOLD("Error")]: Account system inactive.")
		return FALSE

	write_log("[ANSI_WRAP_BOLD("LOGOUT")]: [current_user.registered_name]")
	set_current_user(null)
	return TRUE

/datum/c4_file/terminal_program/operating_system/thinkdos/proc/initialize_accounts()
	var/datum/c4_file/folder/account_dir = parse_directory("users")
	if(!istype(account_dir))
		if(account_dir && !account_dir.containing_folder.try_delete_file(account_dir))
			print_error("[ANSI_WRAP_BOLD("Error")]: Unable to write account folder.")
			return FALSE

		account_dir = new
		account_dir.set_name("users")

		if(!containing_folder.try_add_file(account_dir))
			qdel(account_dir)
			print_error("[ANSI_WRAP_BOLD("Error")]: Unable to write account folder.")
			return FALSE

		RegisterSignal(account_dir, list(COMSIG_COMPUTER4_FILE_RENAMED, COMSIG_COMPUTER4_FILE_ADDED, COMSIG_COMPUTER4_FILE_REMOVED), PROC_REF(user_folder_gone))

	var/datum/c4_file/user/user_data = account_dir.get_file("admin", FALSE)
	if(!istype(user_data))
		if(user_data && !user_data.containing_folder.try_delete_file(user_data))
			print_error("[ANSI_WRAP_BOLD("Error")]: Unable to write account folder.")
			return FALSE

		user_data = new
		user_data.set_name("admin")

		if(!account_dir.try_add_file(user_data))
			qdel(user_data)
			print_error("[ANSI_WRAP_BOLD("Error")]: Unable to write account file.")
			return FALSE

		//set_current_user(user_data)
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

/// Get the bin folder. The bin directory holds normal programs.
/datum/c4_file/terminal_program/operating_system/thinkdos/proc/get_bin_folder()
	//the `/bin` part here is technically supposed to be reading the physical computer's default program dir.
	//But that's dumb and /bin should always be correct.
	return parse_directory(THINKDOS_BIN_DIRECTORY, drive.root, FALSE)


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

	log_file.data += "\n[ANSI_WRAP_BOLD("STARTUP")]: [stationtime2text()], [stationdate2text()]"
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

/datum/c4_file/terminal_program/operating_system/thinkdos/clean_up()
	LAZYNULL(queued_commands)
	. = ..()
