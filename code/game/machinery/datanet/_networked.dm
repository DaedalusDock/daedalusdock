#define VALIDATE_WIRED_SIGNAL if(!src.signal){return};if(signal.transmission_method != TRANSMISSION_WIRE){CRASH("Received signal with invalid transport mode for this media!")}

/// Set the radio_connection frequency.
/obj/machinery/proc/set_connection_frequency(new_frequency, filter)
	var/join_connection = network_flags & NETWORK_FLAG_JOIN_FREQUENCY
	if(radio_connection && join_connection)
		SSpackets.remove_object(src, radio_connection.frequency)

	connection_frequency = new_frequency

	if(connection_frequency)
		if(join_connection)
			radio_connection = SSpackets.add_object(src, connection_frequency, filter)
		else
			radio_connection = SSpackets.return_frequency(connection_frequency)

/// A wrapper to generate basic, minimally-compliant data packets easily.
/// Returns a `datum/signal` with prefilled `s_addr` and `d_addr` added to `datagram`
/obj/machinery/proc/create_signal(destination_id, list/payload, transmission_method = TRANSMISSION_WIRE) as /datum/signal
	var/list/sig_data = packetv2(net_id, destination_id, payload = payload, net_class = net_class)
	return new /datum/signal(src, sig_data, transmission_method)


/// Send a signal from a ref. Data sent in signals must be dereferenced.
/// If you're sending a forged source address (You should have a good reason for this...) set `preserve_s_addr = TRUE
///
/// NONE OF THE ABOVE IS TRUE IF YOU ARE `machinery/power`, AS THEY DEAL DIRECTLY WITH SSPACKETS INSTEAD OF ABSTRACTED TERMINALS
/obj/machinery/proc/post_signal(datum/signal/sending_signal, preserve_s_addr = FALSE, filter)
	if(isnull(sending_signal))
		return //You need a pipe and something to send down it, though.

	if(!preserve_s_addr)
		sending_signal.data[PKT_HEAD_SOURCE_ADDRESS] = src.net_id

	sending_signal.author = WEAKREF(src) // Override the sending signal author.
	switch(sending_signal.transmission_method)
		if(TRANSMISSION_RADIO)
			radio_connection?.post_signal(sending_signal, filter)

		if(TRANSMISSION_WIRE)
			netjack?.post_signal(sending_signal)

/obj/machinery/receive_signal(datum/signal/signal)
	SHOULD_CALL_PARENT(TRUE)
	. = ..() //Should the subtype *probably* stop caring about this packet?
	if(isnull(signal))
		return

	if(!is_operational)
		return RECEIVE_SIGNAL_FINISHED

	var/list/sigdat = signal.data //cache for sanic speed this joke is getting old.
	if(sigdat[PKT_HEAD_DEST_ADDRESS] != net_id)//This packet doesn't belong to us directly
		if(sigdat[PKT_HEAD_DEST_ADDRESS] == NET_ADDRESS_PING)// But it could be a ping, if so, reply
			handle_ping_signal(signal)
			return RECEIVE_SIGNAL_FINISHED

		return (network_flags & NETWORK_FLAG_NEED_NOT_DEST) ? RECEIVE_SIGNAL_CONTINUE : RECEIVE_SIGNAL_FINISHED

	return RECEIVE_SIGNAL_CONTINUE // We are the designated recipient of this packet, we need to handle it.

/// Wrapper for wireline packets received from data terminals/netjacks, Includes the origin jack as an arg.
/// This allows machines with multiple interfaces to track it's origin.
/obj/machinery/proc/receive_wireline_signal(datum/signal/signal, obj/machinery/power/packet_source)
	//By default this will simply fall through to receive_signal, discarding the extra info.
	return receive_signal(signal)

/// Upon receiving a ping signal, handle it. By default this responds to the ping.
/obj/machinery/proc/handle_ping_signal(datum/signal/signal)
	var/tmp_filter = signal.data[PKT_PAYLOAD]["filter"]
	if(!isnull(tmp_filter) && tmp_filter != net_class)
		return FALSE

	var/datum/signal/reply = create_ping_reply(signal)
	if(reply)
		post_ping_reply_signal(reply)
		return TRUE
	return FALSE

/// Create a response packet to an incoming ping.
/obj/machinery/proc/create_ping_reply(datum/signal/ping_signal) as /datum/signal
	return create_signal(ping_signal.data[PKT_HEAD_SOURCE_ADDRESS], payload = list(PKT_ARG_CMD = NET_COMMAND_PING_REPLY))

/// Post a response to a ping.
/obj/machinery/proc/post_ping_reply_signal(datum/signal/reply)
	return post_signal(reply)

//Handle the network jack

///Attempt to locate a network jack on the same tile and link to it, unlinking from any existing terminal.
/// Passes through the return code from [/obj/machinery/power/data_terminal/proc/connect_machine()]
/obj/machinery/proc/link_to_jack()
	if(!(src.network_flags & NETWORK_FLAG_USE_DATATERMINAL))
		CRASH("Machine that doesn't use data networks attempted to link to network terminal!")

	if(!loc)
		CRASH("Attempted to link to a network jack while in nullspace!")

	var/obj/machinery/power/data_terminal/new_transmission_terminal = locate() in get_turf(src)
	if(netjack == new_transmission_terminal)
		return NETJACK_CONNECT_SUCCESS //Already connected, pretend it's a success.

	unlink_from_jack() //If our new jack is null, then we've somehow lost it? Don't care and just go along with it.
	return new_transmission_terminal?.connect_machine(src)

/// Unlink from a network terminal
/// `ignore_check` is used as part of machinery destroy.
/obj/machinery/proc/unlink_from_jack(ignore_check = FALSE)
	if(!ignore_check && !(src.network_flags & NETWORK_FLAG_USE_DATATERMINAL))
		CRASH("Machine that doesn't use data networks attempted to unlink to network terminal (outside destroy)!")
	if(!netjack)
		return
	netjack.disconnect_machine(src)
