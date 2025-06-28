/obj/machinery/button/radio
	network_flags = NETWORK_FLAG_GEN_ID
	/// Frequency to broadcast on.
	var/frequency = FREQ_SIGNALER

/obj/machinery/button/radio/try_activate_button(mob/living/user)
	. = ..()
	if(!.)
		return

	var/datum/radio_frequency/radio_connection = SSpackets.return_frequency(frequency)
	var/datum/signal/signal = new(src, list(
		PACKET_SOURCE_ADDRESS = net_id,
		PACKET_NETCLASS = NETCLASS_BUTTON,
		"tag" = id,
	))
	radio_connection.post_signal(signal)
