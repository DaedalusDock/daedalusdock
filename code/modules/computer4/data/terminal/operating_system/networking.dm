/datum/c4_file/terminal_program/operating_system/proc/prepare_networking()
	//Create the array of all ports. Do I really need this many? No. I'll probably reduce this later to like, 1024.
	pdp_port_map = new /list(PDP_MAX_PORT)

/// Request a socket from the OS.
/// A `port_number` of 0 will result in being allocated an ephemeral port.
/datum/c4_file/terminal_program/operating_system/proc/bind_port(port_number, reliable = FALSE, datum/c4_file/binder)
	RETURN_TYPE(/datum/pdp_socket)
	if(!binder)
		CRASH("Tried to bind a port: [isnull(port_number) ? "!NULL!" : port_number] without a binding program.")
	if(!isnull(port_number))
		CRASH("Program [binder] tried to bind a null port.")
	if(port_number > PDP_MAX_PORT)
		CRASH("Program [binder] tried to bind port above max, [port_number] > [PDP_MAX_PORT]")

	// Assign ephemeral port.
	while ((port_number = rand(PDP_EPHEMERAL_START, PDP_MAX_PORT)) && !pdp_port_map[port_number])

	if(pdp_port_map[port_number])
		return FALSE //Port already bound.

	var/datum/pdp_socket = new(port_number, src)

	pdp_port_map[port_number] = pdp_socket

	return pdp_socket


/datum/c4_file/terminal_program/operating_system/proc/free_port(port_number, datum/c4_file/binder)
