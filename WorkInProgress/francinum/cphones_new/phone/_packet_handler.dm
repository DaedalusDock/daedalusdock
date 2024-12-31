/datum/packet_handler
	/// Who owns us?
	var/obj/machinery/master

/*
 * Handlers are passed signals via receive_signal.
 * If false, the packet is unhandled and should be passed to the next handler.
 *
 * We're just gonna trust this is only ever being called by the master,
 * if it's not, go fuck yourself. seriously.
 */
