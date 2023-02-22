/obj/machinery/meter/monitored
	/// The unique string that represents which atmos chamber to associate with.
	var/chamber_id

	var/frequency = FREQ_ATMOS_STORAGE
	var/datum/radio_frequency/radio_connection

/obj/machinery/meter/monitored/Initialize()
	id_tag = chamber_id + "_sensor"
	radio_connection = SSpackets.add_object(src, frequency, RADIO_ATMOSIA)
	return ..()

/obj/machinery/meter/monitored/Destroy()
	SSpackets.remove_object(src, frequency)
	return ..()

/obj/machinery/meter/monitored/on_deconstruction()
	. = ..()
	broadcast_destruction(src.frequency)

/obj/machinery/meter/monitored/proc/broadcast_destruction(frequency)
	var/datum/signal/signal = new(null, list(
		"sigtype" = "destroyed",
		"tag" = id_tag,
		"timestamp" = world.time,
	))
	var/datum/radio_frequency/connection = SSpackets.return_frequency(frequency)
	connection.post_signal(signal, filter = RADIO_ATMOSIA)

/obj/machinery/meter/monitored/process_atmos()
	. = ..()
	if(!radio_connection)
		return

	var/datum/signal/signal = new(src, list(
		"tag" = id_tag,
		"device" = "AM",
		"sigtype" = "status",
		"timestamp" = world.time,
		"gasmix" = gas_mixture_parser(target.unsafe_return_air()),
	))
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
