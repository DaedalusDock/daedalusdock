/// Returns the data field for a packet.
/proc/packetv2(source_addr, dest_addr, source_port, dest_port, netclass, protocol, list/payload) as /list
	. = list(
		PKT_HEAD_VERSION = 2,
		PKT_HEAD_SOURCE_ADDRESS = source_addr,
		PKT_HEAD_DEST_ADDRESS = dest_addr,
		PKT_HEAD_SOURCE_PORT = source_port,
		PKT_HEAD_DEST_PORT = dest_port,
		PKT_HEAD_NETCLASS = netclass,
		PKT_HEAD_PROTOCOL = protocol,
		PKT_PAYLOAD = payload,
	)
