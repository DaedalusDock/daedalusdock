/datum/shell_command/medtrak/home/quit
	aliases = list("quit", "0", "q", "exit")

/datum/shell_command/medtrak/home/quit/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	system.println("Quitting...")
	program.get_computer().unload_program(program)

/datum/shell_command/medtrak/home/index
	aliases = list("records", "1", "index", "view")

/datum/shell_command/medtrak/home/index/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/medtrak/medtrak = program
	medtrak.view_index()
