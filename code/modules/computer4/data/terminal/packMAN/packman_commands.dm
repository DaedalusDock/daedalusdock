/datum/shell_command/packman_cmd/chat
	aliases = list("c", "chat")

/datum/shell_command/packman_cmd/chat/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	if(length(arguments) < 2)
		system.println("<b>Error: Invalid argument count.</b>")
		return

	var/datum/c4_file/terminal_program/packman/packman = program

	var/address = arguments[1]
	var/payload = jointext(arguments.Copy(2), " ")

	packman.socket.send_data(address, PDP_PORT_NETTEST, list(payload))
	system.println(html_encode(payload))

/datum/shell_command/packman_cmd/init
	aliases = list("init")

/datum/shell_command/packman_cmd/init/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	if(!length(arguments))
		system.println("<b>Error: Invalid argument count.</b>")
		return

	if(!(lowertext(arguments[1]) in list("c", "s")))
		system.println("<b>Error: Invalid argument.")
		return

	var/datum/c4_file/terminal_program/packman/packman = program

	if(packman.mode != PACKMAN_MODE_UNDEFINED)
		return

	packman.mode = (lowertext(arguments[1]) == "s") ? PACKMAN_MODE_SERVER : PACKMAN_MODE_CLIENT

	if(packman.mode == PACKMAN_MODE_SERVER)
		packman.socket = system.bind_port(PDP_PORT_NETTEST, FALSE, packman)
		if(!packman.socket)
			system.println("<b>Error: Socket binding failed.")
			return

	else
		packman.socket = system.bind_port(PDP_BIND_EPHEMERAL_PORT, FALSE, packman)
		if(!packman.socket)
			system.println("<b>Error: Socket binding failed.")
			return

	system.println("Bound port to [packman.socket.bound_port] as [packman.mode == PACKMAN_MODE_SERVER ? "SERVER" : "CLIENT"]")

/datum/shell_command/packman_cmd/quit/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	system.println("Quitting...")
	system.unload_program(program)
	return
