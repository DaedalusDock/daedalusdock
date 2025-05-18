/datum/c4_file/terminal_program/probe
	name = "NetProbe"

	var/static/list/commands

	var/list/ping_replies = list()

/datum/c4_file/terminal_program/probe/New()
	if(!commands)
		commands = list()
		for(var/path as anything in subtypesof(/datum/shell_command/probe_cmd))
			commands += new path

/datum/c4_file/terminal_program/probe/execute(datum/c4_file/terminal_program/operating_system/thinkdos/system)
	. = ..()
	if(!.)
		return

	system.println("NetProbe V2.4", FALSE)
	system.println("Welcome to NetProbe, type 'help' to get started.")

	if(!get_adapter())
		system.println("<b>Error:</b> No network adapter found.")

/// Getter for a network adapter.
/datum/c4_file/terminal_program/probe/proc/get_adapter()
	RETURN_TYPE(/obj/item/peripheral/network_card)
	return get_computer().get_peripheral(PERIPHERAL_TYPE_WIRELESS_CARD)

/datum/c4_file/terminal_program/probe/std_in(text)
	. = ..()
	if(.)
		return

	get_os().println(text)

	var/datum/shell_stdin/parsed_input = parse_std_in(text)

	var/datum/c4_file/terminal_program/operating_system/os = get_os()

	for(var/datum/shell_command/potential_command as anything in commands)
		if(potential_command.try_exec(parsed_input.command, os, src, parsed_input.arguments, parsed_input.options))
			return TRUE

	get_os().println("'[html_encode(parsed_input.raw)]' is not recognized as an internal or external command.")

/datum/c4_file/terminal_program/probe/peripheral_input(obj/item/peripheral/invoker, command, datum/signal/packet)
	if(!packet)
		return

	if(!packet.data[PACKET_NETCLASS] || !packet.data[PACKET_SOURCE_ADDRESS] || (packet.data[PACKET_CMD] != NET_COMMAND_PING_REPLY))
		return

	var/reply_netclass = packet.data[PACKET_NETCLASS]
	var/reply_id = packet.data[PACKET_SOURCE_ADDRESS]

	ping_replies[reply_id] = reply_netclass
	get_os().println("\[[reply_netclass]\]-TYPE: [reply_id]")
