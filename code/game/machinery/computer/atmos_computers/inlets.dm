/obj/machinery/atmospherics/components/unary/outlet_injector/monitored
	on = TRUE
	volume_rate = ATMOS_DEFAULT_VOLUME_PUMP


	network_flags = NETWORK_FLAG_GEN_ID
	net_class = NETCLASS_OUTLET_INJECTOR

	connection_frequency = FREQ_ATMOS_STORAGE

	/// The unique string that represents which atmos chamber to associate with.
	var/chamber_id

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/Initialize(mapload)
	id_tag = chamber_id + "_in"
	return ..()

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/atmos_init()
	. = ..()
	broadcast_status()

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/on_deconstruction()
	. = ..()
	broadcast_destruction()

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/ui_act(action, params)
	. = ..()
	if(.)
		broadcast_status()

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/proc/broadcast_status()
	if(!radio_connection)
		return

	var/datum/signal/signal = create_signal(payload = list(
		"tag" = id_tag,
		"sigtype" = "status",
		"device" = "AO",
		"power" = on,
		"volume_rate" = volume_rate,
		"timestamp" = world.time,
	), transmission_method = TRANSMISSION_RADIO)
	radio_connection.post_signal(signal)

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/proc/broadcast_destruction(frequency)
	var/datum/signal/signal = create_signal(payload = list(
		"sigtype" = "destroyed",
		"tag" = id_tag,
		"timestamp" = world.time,
	), transmission_method = TRANSMISSION_RADIO)

	radio_connection.post_signal(signal, filter = RADIO_ATMOSIA)

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/receive_signal(datum/signal/signal)
	var/list/payload = signal.data[PKT_PAYLOAD]
	if(!payload["tag"] || (payload["tag"] != id_tag) || (payload["sigtype"] != "command"))
		return

	if("power" in payload)
		on = text2num(payload["power"])

	if("power_toggle" in payload)
		on = !on

	if("set_volume_rate" in signal.data)
		var/number = text2num(payload["set_volume_rate"])
		var/datum/gas_mixture/air_contents = airs[1]
		volume_rate = clamp(number, 0, air_contents.volume)

	broadcast_status()
	update_appearance()

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/plasma_input
	name = "plasma tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_PLAS

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/oxygen_input
	name = "oxygen tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_O2

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/nitrogen_input
	name = "nitrogen tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_N2

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/mix_input
	name = "mix tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_MIX

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/nitrous_input
	name = "nitrous oxide tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_N2O

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/air_input
	name = "air mix tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_AIR

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/carbon_input
	name = "carbon dioxide tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_CO2

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/bz_input
	name = "bz tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_BZ

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/freon_input
	name = "freon tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_FREON

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/halon_input
	name = "halon tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_HALON

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/healium_input
	name = "healium tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_HEALIUM

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/hydrogen_input
	name = "hydrogen tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_H2

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/hypernoblium_input
	name = "hypernoblium tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_HYPERNOBLIUM

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/miasma_input
	name = "miasma tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_MIASMA

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/nitrium_input
	name = "nitrium tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_NITRIUM

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/pluoxium_input
	name = "pluoxium tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_PLUOXIUM

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/proto_nitrate_input
	name = "proto-nitrate tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_PROTO_NITRATE

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/tritium_input
	name = "tritium tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_TRITIUM

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/water_vapor_input
	name = "water vapor tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_H2O

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/zauker_input
	name = "zauker tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_ZAUKER

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/helium_input
	name = "helium tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_HELIUM

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/antinoblium_input
	name = "antinoblium tank input injector"
	chamber_id = ATMOS_GAS_MONITOR_ANTINOBLIUM

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/incinerator_input
	name = "incinerator chamber input injector"
	chamber_id = ATMOS_GAS_MONITOR_INCINERATOR

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/ordnance_mixing_input
	name = "ordnance mixing input injector"
	chamber_id = ATMOS_GAS_MONITOR_ORDNANCE_LAB

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/engine_input
	name = "engine input injector"
	chamber_id = ATMOS_GAS_MONITOR_ENGINE
