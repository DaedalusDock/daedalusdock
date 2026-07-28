/obj/machinery/meter/monitored
	net_class = NETCLASS_PIPE_METER
	network_flags = NETWORK_FLAG_GEN_ID

	connection_frequency = FREQ_ATMOS_STORAGE

	/// The unique string that represents which atmos chamber to associate with.
	var/chamber_id

/obj/machinery/meter/monitored/Initialize()
	id_tag = chamber_id + "_sensor"
	return ..()

/obj/machinery/meter/monitored/Destroy()
	radio_connection = null
	return ..()

/obj/machinery/meter/monitored/on_deconstruction()
	. = ..()
	broadcast_destruction()

/obj/machinery/meter/monitored/proc/broadcast_destruction()
	var/datum/signal/signal = create_signal(
		payload = list(
			"sigtype" = "destroyed",
			"tag" = id_tag,
			"timestamp" = world.time,
		),
		transmission_method = TRANSMISSION_RADIO
	)

	radio_connection.post_signal(signal, filter = RADIO_ATMOSIA)

/obj/machinery/meter/monitored/process_atmos()
	. = ..()
	if(!radio_connection)
		return

	var/datum/signal/signal = create_signal(null, payload = list(
		"tag" = id_tag,
		"device" = "AM",
		"sigtype" = "status",
		"timestamp" = world.time,
		"gasmix" = gas_mixture_parser(target.unsafe_return_air()),
	), transmission_method = TRANSMISSION_RADIO)

	radio_connection.post_signal(signal)

/obj/machinery/meter/monitored/layer2
	target_layer = 2

/obj/machinery/meter/monitored/layer4
	target_layer = 4

/obj/machinery/meter/monitored/waste_loop
	name = "waste loop gas flow meter"
	chamber_id = ATMOS_GAS_MONITOR_WASTE

/obj/machinery/meter/monitored/distro_loop
	name = "distribution loop gas flow meter"
	chamber_id = ATMOS_GAS_MONITOR_DISTRO
