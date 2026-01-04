/datum/shell_command/probe_cmd/help
	aliases = list("help")
	help_text = "Lists all available commands. Use help \[command\] to view information about a specific command."

/datum/shell_command/probe_cmd/help/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/list/output = list()

	if(generate_help_list(output, arguments, astype(program, /datum/c4_file/terminal_program/probe).commands, system) != SHELL_CMD_HELP_ERROR)
		system.println(jointext(output, "<br>"))

/datum/shell_command/probe_cmd/ping
	aliases = list("ping", "p")
	help_text = "Pings the radio frequency the network card is tuned to."

/datum/shell_command/probe_cmd/ping/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/probe/probe = program
	var/obj/item/peripheral/network_card/wireless/adapter = probe.get_adapter()

	if(!adapter)
		system.println("<b>Error:</b> No network adapter found.")
		return

	if(adapter.ping())
		probe.ping_replies.Cut()
		system.println("Pinging '[format_frequency(adapter.frequency)]'...")

/datum/shell_command/probe_cmd/view
	aliases = list("view", "v")
	help_text = "Lists all ping responses since the last ping."

/datum/shell_command/probe_cmd/view/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/probe/probe = program
	if(!length(probe.ping_replies))
		system.println("<b>Error:</b> No replies found.")
		return

	var/list/out = list("Reply list:")

	for(var/index in 1 to length(probe.ping_replies))
		var/reply_id = probe.ping_replies[index]
		var/reply_netclass = probe.ping_replies[reply_id]

		out += "\[[reply_netclass]\]-TYPE: [reply_id]"

	system.println(jointext(out, "<br>"))

/datum/shell_command/probe_cmd/quit
	aliases = list("quit", "q")

/datum/shell_command/probe_cmd/quit/generate_help_text()
	return jointext(list(
		"Exits the program, moving it to the background.",
		"Usage: 'quit'",
		"",
		"-f, --force [FOURSPACES]Exits the program without moving it to background.",
	), "<br>")

/datum/shell_command/probe_cmd/quit/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/force = !!length(options & list("f", "force"))

	if(force)
		system.println("Quitting...")
		system.unload_program(program)
		return

	if(system.try_background_program(program))
		system.println("Moved [program.name] to background processes.")
	else
		system.println("<b>Error: RAM is full.</b>")
