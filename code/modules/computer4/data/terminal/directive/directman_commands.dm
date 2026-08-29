/datum/shell_command/directman/main/quit
	aliases = list("quit", "q", "exit")
	help_text = "Terminates the program.\nUsage: 'quit'"

/datum/shell_command/directman/main/quit/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	system.println("Quitting...")
	system.unload_program(program)

/datum/shell_command/directman/main/help
	aliases = list("help")
	help_text = "Lists all available commands. Use help \[command\] to view information about a specific command."

/datum/shell_command/directman/main/help/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/directman/directman = program
	noop(directman)
	var/list/all_commands = directman.main_commands + directman.home_command
	var/list/output = generate_help(system, program, arguments, all_commands)
	if(output)
		system.println(jointext(output, "\n"))

/datum/shell_command/directman/home
	aliases = list("home", "h")
	help_text = "Return to the home menu.\nUsage: 'home'"

/datum/shell_command/directman/home/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/directman/directman = program
	system.clear_screen(TRUE)
	directman.view_home()

/datum/shell_command/directman/main/refresh
	aliases = list("refresh", "r")
	help_text = "Refresh the screen.\nUsage: 'refresh'"

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
		system.println("[ANSI_WRAP_BOLD("Error:")] Unable to locate wireless adapter.")
		return

	directman.view_current()

/datum/shell_command/directman/main/show_new
	aliases = list("2")

/datum/shell_command/directman/main/show_new/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/directman/directman = program
	system.clear_screen(TRUE)
	if(!system.get_computer().get_peripheral(PERIPHERAL_TYPE_WIRELESS_CARD))
		directman.view_home()
		system.println("[ANSI_WRAP_BOLD("Error:")] Unable to locate wireless adapter.")
		return

	directman.view_new()


