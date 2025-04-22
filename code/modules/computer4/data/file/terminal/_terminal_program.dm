/datum/computer4/file/terminal_program
	name = "program"
	extension = "TPROG"

	/// Set to FALSE if the program can't actually be run.
	var/is_executable = TRUE

	/// Behaves identically to req_access on /obj
	var/list/req_access

	/// Gotta be logged in to access anything.
	var/logged_in = FALSE

/datum/computer4/file/terminal_program/operating_system
	name = "operating system"
	extension = "TSYS"

	is_executable = FALSE

/// Wrapper around exec_system_call(), checks first if you can even do it.
/datum/computer4/file/terminal_program/operating_system/proc/try_system_call(datum/computer4/file/invoker)
	if(!computer?.is_operational)
		return null

	exec_system_call()

/// Executes a system call, preferably call try_system_call() instead.
/datum/computer4/file/terminal_program/operating_system/proc/exec_system_call(datum/computer4/file/invoker)
	return
