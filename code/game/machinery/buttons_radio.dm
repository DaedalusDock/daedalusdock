MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/button/radio, 24)

/obj/machinery/button/radio
	name = "networked button"
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
		"tag" = id_tag,
	))
	radio_connection.post_signal(signal)

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/button/radio/airlock, 26)
/obj/machinery/button/radio/airlock
	frequency = FREQ_AIRLOCK_CONTROL
