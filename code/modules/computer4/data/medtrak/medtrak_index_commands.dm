/datum/shell_command/medtrak/index/quit
	aliases = list("quit", "q", "exit")

/datum/shell_command/medtrak/index/quit/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	system.println("Quitting...")
	program.get_computer().unload_program(program)
