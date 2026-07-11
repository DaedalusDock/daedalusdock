MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/button/radio, 24)

/obj/machinery/button/radio
	name = "networked button"
	net_class = NETCLASS_BUTTON
	network_flags = NETWORK_FLAG_GEN_ID
	/// Frequency to broadcast on.
	var/frequency = FREQ_SIGNALER

/obj/machinery/button/radio/try_activate_button(mob/living/user)
	. = ..()
	if(!.)
		return

	var/datum/radio_frequency/radio_connection = SSpackets.return_frequency(frequency)
	var/datum/signal/signal = create_signal(payload = list("tag" = id_tag), transmission_method = TRANSMISSION_RADIO)
	radio_connection.post_signal(signal)

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/button/radio/airlock, 26)
/obj/machinery/button/radio/airlock
	frequency = FREQ_AIRLOCK_CONTROL
