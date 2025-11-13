/datum/c4_file/terminal_program/operating_system/proc/prepare_networking()

/// Request a socket from the OS.
/// A `port_number` of `PDP_BIND_EPHEMERAL_PORT` will result in being allocated an ephemeral port.
/datum/c4_file/terminal_program/operating_system/proc/bind_port(port_number, reliable = FALSE, datum/c4_file/binder)
	RETURN_TYPE(/datum/pdp_socket)
	if(!binder)
		CRASH("Tried to bind a port: [isnull(port_number) ? "!NULL!" : port_number] without a binding program.")
	if(isnull(port_number))
		CRASH("Program [binder] tried to bind a null port.")
	if(port_number > PDP_MAX_PORT)
		CRASH("Program [binder] tried to bind port above max, [port_number] > [PDP_MAX_PORT]")

	// Assign ephemeral port.
	if(port_number == PDP_BIND_EPHEMERAL_PORT)
		do
			port_number = rand(PDP_EPHEMERAL_START, PDP_MAX_PORT)
		while(pdp_port_map["[port_number]"])
	else
		if(pdp_port_map["[port_number]"])
			return FALSE //Port already bound.

	var/datum/pdp_socket/socket = new(port_number, src, binder)

	pdp_port_map["[port_number]"] = socket

	return socket

/// Requests the OS to free a socket.
/// A `port_number` of `PDP_FREE_ALL_PORTS` will result in all ports bound by the binder being freed. It is also the default behaviour.
/datum/c4_file/terminal_program/operating_system/proc/free_port(port_number = PDP_FREE_ALL_PORTS, datum/c4_file/binder)
	if(isnull(port_number))
		CRASH("Program [binder] tried to free a null or 0 port.")
	if(port_number > PDP_MAX_PORT)
		CRASH("Program [binder] tried to free port above max, [port_number] > [PDP_MAX_PORT]")
	if(port_number != PDP_FREE_ALL_PORTS)
		// Free by specific port number
		if(pdp_port_map["[port_number]"].owner == binder) //If the binder matches
			pdp_port_map["[port_number]"] = null
			return TRUE
		else
			//This should throw an OS error but we have no concept of stderr.
			return FALSE
	//else: free all ports therein bound.
	var/freed_at_least_one = FALSE
	for(var/port_num, port_socket in pdp_port_map)
		if(astype(port_socket, /datum/pdp_socket).owner == binder)
			pdp_port_map[port_num] = null
			freed_at_least_one = TRUE
	return freed_at_least_one



/// Finish up outgoing program signals.
/// Eventually: Routing table?
/datum/c4_file/terminal_program/operating_system/post_signal(datum/signal/signal)
	if(!signal)
		CRASH("post signal wi no signal")

	var/obj/item/peripheral/network_card/wireless/wcard = get_computer().get_peripheral(PERIPHERAL_TYPE_WIRELESS_CARD)
	if(!wcard)
		return //cry

	wcard.post_signal(signal)

/datum/c4_file/terminal_program/operating_system/proc/pdp_incoming(datum/signal/packet)
	var/list/fields = packet.data
	var/datum/pdp_socket/socket = pdp_port_map["[fields[PKT_HEAD_DEST_PORT]]"]
	socket?.enqueue(packet)

