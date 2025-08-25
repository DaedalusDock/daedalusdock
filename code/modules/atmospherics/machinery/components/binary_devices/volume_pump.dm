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

/obj/machinery/atmospherics/components/binary/volume_pump
	icon_state = "volpump_map-3"
	name = "volumetric gas pump"
	desc = "A pump that moves gas by volume."
	can_unwrench = TRUE
	shift_underlay_only = FALSE
	construction_type = /obj/item/pipe/directional
	pipe_state = "volumepump"
	vent_movement = NONE

	power_rating = 15000

	///Transfer rate of the component in L/s
	var/transfer_rate = ATMOS_DEFAULT_VOLUME_PUMP
	///Frequency for radio signaling
	var/frequency = 0
	///ID for radio signaling
	var/id = null
	///Connection to the radio processing
	var/datum/radio_frequency/radio_connection
	//Last power draw, for the progress bar in the UI
	var/last_power_draw = 0

/obj/machinery/atmospherics/components/binary/volume_pump/CtrlClick(mob/user, list/params)
	if(can_interact(user))
		set_on(!on)
		investigate_log("was turned [on ? "on" : "off"] by [key_name(user)]", INVESTIGATE_ATMOS)
		update_appearance()
	return ..()

/obj/machinery/atmospherics/components/binary/volume_pump/AltClick(mob/user)
	if(can_interact(user))
		transfer_rate = ATMOS_DEFAULT_VOLUME_PUMP
		investigate_log("was set to [transfer_rate] L/s by [key_name(user)]", INVESTIGATE_ATMOS)
		balloon_alert(user, "volume output set to [transfer_rate] L/s")
		update_appearance()
	return ..()

/obj/machinery/atmospherics/components/binary/volume_pump/Destroy()
	SSpackets.remove_object(src,frequency)
	return ..()

/obj/machinery/atmospherics/components/binary/volume_pump/update_icon_nopipes()
	icon_state = on && is_operational ? "volpump_on-[set_overlay_offset(piping_layer)]" : "volpump_off-[set_overlay_offset(piping_layer)]"

/obj/machinery/atmospherics/components/binary/volume_pump/process_atmos()
	last_power_draw = 0

	if(!on || !is_operational)
		return

	var/datum/gas_mixture/air1 = airs[1]
	var/datum/gas_mixture/air2 = airs[2]

	//var/input_starting_pressure = air1.returnPressure()
	var/output_starting_pressure = air2.returnPressure()

//The pump will do nothing if the output is past the max pump pressure.
	if(output_starting_pressure > MAX_PUMP_PRESSURE)
		return

	if(!(air1.temperature > 0))
		return
	//copied from air injectors
	var/transfer_moles = (air1.returnPressure() * transfer_rate) / (air1.temperature * R_IDEAL_GAS_EQUATION)

	if(!transfer_moles)
		return

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
/obj/machinery/atmospherics/components/binary/volume_pump/proc/set_frequency(new_frequency)
	SSpackets.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = SSpackets.add_object(src, frequency, filter = RADIO_ATMOSIA)

/**
 * Called in atmos_init(), send the component status to the radio device connected
 */
/obj/machinery/atmospherics/components/binary/volume_pump/proc/broadcast_status()
	if(!radio_connection)
		return

	var/datum/signal/signal = new(src, list(
		"tag" = id,
		"device" = "APV",
		"power" = on,
		"transfer_rate" = transfer_rate,
		"sigtype" = "status"
	))
	radio_connection.post_signal(signal)

/obj/machinery/atmospherics/components/binary/volume_pump/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AtmosPump", name)
		ui.open()

/obj/machinery/atmospherics/components/binary/volume_pump/ui_data()
	var/data = list()
	data["on"] = on
	data["rate"] = round(transfer_rate)
	data["max_rate"] = round(ATMOS_DEFAULT_VOLUME_PUMP)
	data["last_draw"] = last_power_draw
	data["max_power"] = power_rating
	return data

/obj/machinery/atmospherics/components/binary/volume_pump/atmos_init()
	. = ..()

	set_frequency(frequency)

/obj/machinery/atmospherics/components/binary/volume_pump/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("power")
			set_on(!on)
			investigate_log("was turned [on ? "on" : "off"] by [key_name(usr)]", INVESTIGATE_ATMOS)
			. = TRUE
		if("rate")
			var/rate = params["rate"]
			if(rate == "max")
				rate = ATMOS_DEFAULT_VOLUME_PUMP
				. = TRUE
			else if(text2num(rate) != null)
				rate = text2num(rate)
				. = TRUE
			if(.)
				transfer_rate = clamp(rate, 0, ATMOS_DEFAULT_VOLUME_PUMP)
				investigate_log("was set to [transfer_rate] L/s by [key_name(usr)]", INVESTIGATE_ATMOS)
	update_appearance()

/obj/machinery/atmospherics/components/binary/volume_pump/receive_signal(datum/signal/signal)
	if(!signal.data["tag"] || (signal.data["tag"] != id) || (signal.data["sigtype"]!="command"))
		return

	if("status" in signal.data)
		broadcast_status()
		return //do not update_appearance

	var/old_on = on //for logging

	if("power" in signal.data)
		set_on(text2num(signal.data["power"]))

	if("power_toggle" in signal.data)
		set_on(!on)

	if("set_transfer_rate" in signal.data)
		var/datum/gas_mixture/air1 = airs[1]
		transfer_rate = clamp(text2num(signal.data["set_transfer_rate"]),0,air1.volume)

	if(on != old_on)
		investigate_log("was turned [on ? "on" : "off"] by a remote signal", INVESTIGATE_ATMOS)



	broadcast_status()
	update_appearance()

/obj/machinery/atmospherics/components/binary/volume_pump/can_unwrench(mob/user)
	. = ..()
	if(. && on && is_operational)
		to_chat(user, span_warning("You cannot unwrench [src], turn it off first!"))
		return FALSE

// mapping

/obj/machinery/atmospherics/components/binary/volume_pump/layer2
	piping_layer = 2
	icon_state = "volpump_map-2"

/obj/machinery/atmospherics/components/binary/volume_pump/layer2
	piping_layer = 2
	icon_state = "volpump_map-2"

/obj/machinery/atmospherics/components/binary/volume_pump/on
	on = TRUE
	icon_state = "volpump_on_map-3"

/obj/machinery/atmospherics/components/binary/volume_pump/on/layer2
	piping_layer = 2
	icon_state = "volpump_on_map-2"

/obj/machinery/atmospherics/components/binary/volume_pump/on/layer4
	piping_layer = 4
	icon_state = "volpump_on_map-4"
