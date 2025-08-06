/*
 * Ported Datagram Protocol Socket
 */

#define PDP_SOCKET_QUEUE_DEPTH 50
/// 'Real' insert position, subject to BYOND Listism.
#define PDP_S_HEAD_REAL (head_pointer+1)
/// 'Real' read position, subject to BYOND Listism.
#define PDP_S_TAIL_REAL (tail_pointer+1)

#if PDP_SOCKET_QUEUE_DEPTH < 3
#error PDP_SOCKET_QUEUE_DEPTH is too short. If you trigger this, good fucking job:tm:
#endif

/datum/pdp_socket
	/// Next Hop datum we send our packets to. Usually a network card.
	var/datum/outgoing_datum
	/// 'Owner' that registered for this socket. Used to assure ownership.
	var/datum/owner
	/// PDP Port the socket is bound to, Packets being sent out of this socket will have their source port set to this.
	var/bound_port


	/// Packet ring buffer
	VAR_PRIVATE/list/packet_buffer
	/// Insertion point, Incremented on packet receive. Will drop instead if =tail_pointer-1
	/// Do not use directly, Must add 1 to account for list jank
	VAR_PRIVATE/head_pointer
	/// Read pointer, Incremented on packet read, Will not increment if there is no packet to read.
	VAR_PRIVATE/tail_pointer

/datum/pdp_socket/New(bound_port, outgoing_datum, owner)
	if(!bound_port)
		stack_trace("Created a PDP socket without a port number?")

	src.bound_port = bound_port
	src.outgoing_datum = outgoing_datum
	src.owner = owner
	packet_buffer = new /list(PDP_SOCKET_QUEUE_DEPTH)
	head_pointer = 0
	tail_pointer = 0

/// Place received packet into ringqueue. Returns TRUE if inserted, FALSE if dropped due to full queue.
// No lohi I am not implimenting DSCP. Right now, at least. Maybe later.
/datum/pdp_socket/proc/enqueue(datum/signal/packet)
	if(((head_pointer + 1) % PDP_SOCKET_QUEUE_DEPTH) == tail_pointer)
		return FALSE //Ring full, Drop the packet.
	packet_buffer[PDP_S_HEAD_REAL] = packet
	head_pointer = (head_pointer+1) % PDP_SOCKET_QUEUE_DEPTH
	return TRUE

/// Get next signal in queue, or null if queue is dry.
/datum/pdp_socket/proc/pop()
	. = packet_buffer[PDP_S_TAIL_REAL]
	if(!.)
		return null
	tail_pointer = (tail_pointer+1) % PDP_SOCKET_QUEUE_DEPTH
	//return .

#undef PDP_SOCKET_QUEUE_DEPTH
#undef PDP_S_HEAD_REAL
#undef PDP_S_TAIL_REAL

/// Send a PDP payload packet to the destionation port and address.
/datum/pdp_socket/proc/send_data(d_address, d_port, list/payload)
	// Packets come out of this preeetty skeletonized, Higher layers above this are expected to fill out some remaining details
	// Such as source address.

	var/list/packet_data = list(
		PACKET_ARG_PROTOCOL = PACKET_ARG_PROTOCOL_PDP,

		PDP_DESTINATION_ADDRESS = d_address,
		PDP_DESTINATION_PORT = d_port,

		//Source address set at NIC
		PDP_SOURCE_PORT = bound_port,

		PDP_PAYLOAD_DATA = payload
	)

	var/datum/signal/packet = new(null, packet_data)

	outgoing_datum.receive_signal()
