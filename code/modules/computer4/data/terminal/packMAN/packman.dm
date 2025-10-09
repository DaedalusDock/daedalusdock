/datum/c4_file/terminal_program/packman
	name = "packMAN"

	var/mode = PACKMAN_MODE_UNDEFINED
	var/datum/pdp_socket/socket

	var/static/list/commands

/datum/c4_file/terminal_program/packman/New()
	if(!commands)
		commands = list()
		for(var/path as anything in subtypesof(/datum/shell_command/packman_cmd))
			commands += new path

/datum/c4_file/terminal_program/packman/execute(datum/c4_file/terminal_program/operating_system/thinkdos/system)
	. = ..()
	if(!.)
		return

	system.println("packMAN V1.01", FALSE)
	system.println("Welcome to packMAN, type 'help' to get started.")

	if(!get_adapter())
		system.println("<b>Error:</b> No network adapter found.")

/datum/c4_file/terminal_program/packman/on_close(datum/c4_file/terminal_program/operating_system/thinkdos/system)
	. = ..()
	mode = PACKMAN_MODE_UNDEFINED
	socket = null

/// Getter for a network adapter.
/datum/c4_file/terminal_program/packman/proc/get_adapter()
	RETURN_TYPE(/obj/item/peripheral/network_card)
	return get_computer().get_peripheral(PERIPHERAL_TYPE_WIRELESS_CARD)

/datum/c4_file/terminal_program/packman/std_in(text)
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

/datum/c4_file/terminal_program/packman/tick(delta_time)
	. = ..()
	if(!socket)
		return

	var/datum/c4_file/terminal_program/operating_system/system = get_os()
	var/datum/signal/packet
	while((packet = socket.pop()))
		system.println(
			html_encode(json_encode(packet.data))
		)
