/datum/shell_command/directman/main/quit
	aliases = list("quit", "q", "exit")

/datum/shell_command/directman/main/quit/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	system.println("Quitting...")
	system.unload_program(program)

/datum/shell_command/directman/home
	aliases = list("home", "h")

/datum/shell_command/directman/home/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/directman/directman = program
	system.clear_screen(TRUE)
	directman.view_home()

/datum/shell_command/directman/main/refresh
	aliases = list("r", "R")

/datum/shell_command/directman/main/refresh/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/directman/directman = program
	system.clear_screen(TRUE)
	directman.view_home()

/datum/shell_command/directman/main/show_current
	aliases = list("1")

/datum/shell_command/directman/main/show_current/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/directman/directman = program
	system.clear_screen(TRUE)
	if(!system.get_computer().get_peripheral(PERIPHERAL_TYPE_WIRELESS_CARD))
		directman.view_home()
		system.println("<b>Error:</b> Unable to locate wireless adapter.")
		return

	directman.view_current()

/datum/shell_command/directman/main/show_new
	aliases = list("2")

/datum/shell_command/directman/main/show_new/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/directman/directman = program
	system.clear_screen(TRUE)
	if(!system.get_computer().get_peripheral(PERIPHERAL_TYPE_WIRELESS_CARD))
		directman.view_home()
		system.println("<b>Error:</b> Unable to locate wireless adapter.")
		return

	directman.view_new()


