/datum/shell_command/probe_cmd/ping
	aliases = list("ping, p")

/datum/shell_command/probe_cmd/ping/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/probe/probe = program
	var/obj/item/peripheral/network_card/wireless/adapter = probe.get_adapter()

	if(!adapter)
		system.println("<b>Error:</b> No network adapter found.")
		return

	if(adapter.ping())
		system.println("Pinging '[format_frequency(adapter.frequency)]'...")

/datum/shell_command/probe_cmd/view
	aliases = list("view, v")

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
