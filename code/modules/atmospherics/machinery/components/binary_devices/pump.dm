// Every cycle, the pump uses the air in air_in to try and make air_out the perfect pressure.
//
// node1, air1, network1 correspond to input
// node2, air2, network2 correspond to output
//
// Thus, the two variables affect pump operation are set in New():
//   air1.volume
//     This is the volume of gas available to the pump that may be transfered to the output
//   air2.volume
//     Higher quantities of this cause more air to be perfected later
//     but overall network volume is also increased as this increases...

/obj/machinery/atmospherics/components/binary/pump
	icon_state = "pump_map-3"
	name = "gas pump"
	desc = "A pump that moves gas by pressure."
	can_unwrench = TRUE
	shift_underlay_only = FALSE
	construction_type = /obj/item/pipe/directional
	pipe_state = "pump"
	vent_movement = NONE

	power_rating = 7500

	///Pressure that the pump will reach when on
	var/target_pressure = ONE_ATMOSPHERE
	///Frequency for radio signaling
	var/frequency = 0
	///ID for radio signaling
	var/id = null
	///Connection to the radio processing
	var/datum/radio_frequency/radio_connection
	//Last power draw, for the progress bar in the UI
	var/last_power_draw = 0

/obj/machinery/atmospherics/components/binary/pump/CtrlClick(mob/user, list/params)
	if(can_interact(user))
		set_on(!on)
		investigate_log("was turned [on ? "on" : "off"] by [key_name(user)]", INVESTIGATE_ATMOS)
		update_appearance()
	return ..()

/obj/machinery/atmospherics/components/binary/pump/AltClick(mob/user)
	if(can_interact(user))
		target_pressure = MAX_PUMP_PRESSURE
		investigate_log("was set to [target_pressure] kPa by [key_name(user)]", INVESTIGATE_ATMOS)
		balloon_alert(user, "pressure output set to [target_pressure] kPa")
		update_appearance()
	return ..()

/obj/machinery/atmospherics/components/binary/pump/Destroy()
	SSpackets.remove_object(src,frequency)
	if(radio_connection)
		radio_connection = null
	return ..()

/obj/machinery/atmospherics/components/binary/pump/update_icon_nopipes()
	icon_state = (on && is_operational) ? "pump_on-[set_overlay_offset(piping_layer)]" : "pump_off-[set_overlay_offset(piping_layer)]"

/obj/machinery/atmospherics/components/binary/pump/process_atmos()
	last_power_draw = 0

	if(!on || !is_operational)
		return

	var/datum/gas_mixture/air1 = airs[1]
	var/datum/gas_mixture/air2 = airs[2]
	//var/transfer_moles = (target_pressure/air1.volume)*air1.total_moles
	var/transfer_moles = calculate_transfer_moles(air1, air2, target_pressure - air2.returnPressure(), parents[2]?.combined_volume || 0)
	var/draw = pump_gas(air1, air2, transfer_moles, power_rating)
	if(draw > -1)
		update_parents()
		ATMOS_USE_POWER(draw)
		last_power_draw = draw


/**
 * Called in atmos_init(), used to change or remove the radio frequency from the component
 * Arguments:
 * * -new_frequency: the frequency that should be used for the radio to attach to the component, use 0 to remove the radio
 */
/obj/machinery/atmospherics/components/binary/pump/proc/set_frequency(new_frequency)
	SSpackets.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = SSpackets.add_object(src, frequency, filter = RADIO_ATMOSIA)

/**
 * Called in atmos_init(), send the component status to the radio device connected
 */
/obj/machinery/atmospherics/components/binary/pump/proc/broadcast_status()
	if(!radio_connection)
		return

	var/datum/signal/signal = new(src, list(
		"tag" = id,
		"device" = "AGP",
		"power" = on,
		"target_output" = target_pressure,
		"sigtype" = "status"
	))
	radio_connection.post_signal(signal, filter = RADIO_ATMOSIA)

/obj/machinery/atmospherics/components/binary/pump/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AtmosPump", name)
		ui.open()

/obj/machinery/atmospherics/components/binary/pump/ui_data()
	var/data = list()
	data["on"] = on
	data["pressure"] = round(target_pressure)
	data["max_pressure"] = round(MAX_PUMP_PRESSURE)
	data["last_draw"] = last_power_draw
	data["max_power"] = power_rating
	return data

/obj/machinery/atmospherics/components/binary/pump/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("power")
			set_on(!on)
			investigate_log("was turned [on ? "on" : "off"] by [key_name(usr)]", INVESTIGATE_ATMOS)
			. = TRUE
		if("pressure")
			var/pressure = params["pressure"]
			if(pressure == "max")
				pressure = MAX_PUMP_PRESSURE
				. = TRUE
			else if(text2num(pressure) != null)
				pressure = text2num(pressure)
				. = TRUE
			if(.)
				target_pressure = clamp(pressure, 0, MAX_PUMP_PRESSURE)
				investigate_log("was set to [target_pressure] kPa by [key_name(usr)]", INVESTIGATE_ATMOS)
	update_appearance()

/obj/machinery/atmospherics/components/binary/pump/atmos_init()
	..()
	if(frequency)
		set_frequency(frequency)

/obj/machinery/atmospherics/components/binary/pump/receive_signal(datum/signal/signal)
	if(!signal.data["tag"] || (signal.data["tag"] != id) || (signal.data["sigtype"]!="command"))
		return

	if("status" in signal.data)
		broadcast_status()
		return

	var/old_on = on //for logging

	if("power" in signal.data)
		set_on(text2num(signal.data["power"]))

	if("power_toggle" in signal.data)
		set_on(!on)

	if("set_output_pressure" in signal.data)
		target_pressure = clamp(text2num(signal.data["set_output_pressure"]),0,ONE_ATMOSPHERE*50)

	if(on != old_on)
		investigate_log("was turned [on ? "on" : "off"] by a remote signal", INVESTIGATE_ATMOS)

	broadcast_status()
	update_appearance()

/obj/machinery/atmospherics/components/binary/pump/can_unwrench(mob/user)
	. = ..()
	if(. && on && is_operational)
		to_chat(user, span_warning("You cannot unwrench [src], turn it off first!"))
		return FALSE

/obj/machinery/atmospherics/components/binary/pump/layer2
	piping_layer = 2
	icon_state= "pump_map-2"

/obj/machinery/atmospherics/components/binary/pump/layer4
	piping_layer = 4
	icon_state= "pump_map-4"

/obj/machinery/atmospherics/components/binary/pump/on
	on = TRUE
	icon_state = "pump_on_map-3"

/obj/machinery/atmospherics/components/binary/pump/on/layer2
	piping_layer = 2
	icon_state= "pump_on_map-2"

/obj/machinery/atmospherics/components/binary/pump/on/layer4
	piping_layer = 4
	icon_state= "pump_on_map-4"
