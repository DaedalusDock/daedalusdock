/// Returns the data field for a packet.
/proc/packetv2(source_addr, dest_addr, source_port, dest_port, net_class, protocol = PKT_PROTOCOL_VEIP, list/payload = list()) as /list
	. = list(
		PKT_HEAD_VERSION = 2,
		PKT_HEAD_SOURCE_ADDRESS = source_addr,
		PKT_HEAD_DEST_ADDRESS = dest_addr,
		PKT_HEAD_SOURCE_PORT = source_port,
		PKT_HEAD_DEST_PORT = dest_port,
		PKT_HEAD_NETCLASS = net_class,
		PKT_HEAD_PROTOCOL = protocol,
		PKT_PAYLOAD = payload,
	)

	#ifdef DEBUG_PACKETS
	if(islist(source_addr))
		stack_trace("Packetv2 called with a list as a source addr, did you mean payload?")
		.[PKT_HEAD_SOURCE_ADDRESS] = null
		.[PKT_PAYLOAD] = source_addr
	#endif

