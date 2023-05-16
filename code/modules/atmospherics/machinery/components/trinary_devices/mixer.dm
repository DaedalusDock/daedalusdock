/obj/machinery/atmospherics/components/trinary/mixer
	icon_state = "mixer_off-0"
	density = FALSE

	name = "gas mixer"
	desc = "Very useful for mixing gasses."

	can_unwrench = TRUE
	construction_type = /obj/item/pipe/trinary/flippable
	pipe_state = "mixer"

	power_rating = 15000

	///Output pressure target
	var/target_pressure = ONE_ATMOSPHERE
	///Ratio between the node 1 and 2, determines the amount of gas transfered, sums up to 1
	var/node1_concentration = 0.5
	///Ratio between the node 1 and 2, determines the amount of gas transfered, sums up to 1
	var/node2_concentration = 0.5
	//node 3 is the outlet, nodes 1 & 2 are intakes
	//Last power draw, for the progress bar in the UI
	var/last_power_draw = 0


/obj/machinery/atmospherics/components/trinary/mixer/CtrlClick(mob/user)
	if(can_interact(user))
		on = !on
		investigate_log("was turned [on ? "on" : "off"] by [key_name(user)]", INVESTIGATE_ATMOS)
		update_appearance()
	return ..()

/obj/machinery/atmospherics/components/trinary/mixer/AltClick(mob/user)
	if(can_interact(user))
		target_pressure = MAX_OMNI_PRESSURE
		investigate_log("was set to [target_pressure] kPa by [key_name(user)]", INVESTIGATE_ATMOS)
		balloon_alert(user, "pressure output on set to [target_pressure] kPa")
		update_appearance()
	return ..()

/obj/machinery/atmospherics/components/trinary/mixer/update_overlays()
	. = ..()
	for(var/direction in GLOB.cardinals)
		if(!(direction & initialize_directions))
			continue

		. += get_pipe_image(icon, "cap", direction, pipe_color, piping_layer, TRUE)

/obj/machinery/atmospherics/components/trinary/mixer/update_icon_nopipes()
	var/on_state = on && nodes[1] && nodes[2] && nodes[3] && is_operational
	icon_state = "mixer_[on_state ? "on" : "off"]-[set_overlay_offset(piping_layer)][flipped ? "_f" : ""]"

/obj/machinery/atmospherics/components/trinary/mixer/New()
	..()
	var/datum/gas_mixture/air3 = airs[3]
	air3.volume = 300
	airs[3] = air3

/obj/machinery/atmospherics/components/trinary/mixer/process_atmos()
	..()
	last_power_draw = 0
	if(!on || !(nodes[1] && nodes[2] && nodes[3]) && !is_operational)
		return

	//Get those gases, mah boiiii
	var/datum/gas_mixture/air1 = airs[1]
	var/datum/gas_mixture/air2 = airs[2]

	if(!air1 || !air2)
		return

	var/datum/gas_mixture/air3 = airs[3]

	var/output_starting_pressure = air3.returnPressure()

	if(output_starting_pressure >= target_pressure)
		//No need to mix if target is already full!
		return

	var/delta = clamp((air3 ? (MAX_OMNI_PRESSURE - air3.returnPressure()) : 0), 0, MAX_OMNI_PRESSURE)
	var/transfer_moles_max = INFINITY
	var/transfer_moles = 0
	/// Node 1
	transfer_moles_max = min(transfer_moles_max, calculate_transfer_moles(air1, air3, delta, parents[3]?.combined_volume || 0))
	transfer_moles += (target_pressure*node1_concentration/air1.volume)*air1.total_moles
	// Node 2
	transfer_moles_max = min(transfer_moles_max, calculate_transfer_moles(air2, air3, delta, parents[3]?.combined_volume || 0))
	transfer_moles += (target_pressure*node2_concentration/air2.volume)*air2.total_moles
	// Finalize
	transfer_moles = clamp(transfer_moles, 0, transfer_moles_max)
	if(!transfer_moles)
		return

	var/list/mix_and_conc = list()
	mix_and_conc[air1] = node1_concentration
	mix_and_conc[air2] = node2_concentration
	var/draw = mix_gas(mix_and_conc, air3, transfer_moles, power_rating)
	if(draw > -1)
		ATMOS_USE_POWER(draw)
		last_power_draw = draw

	update_parents()

/obj/machinery/atmospherics/components/trinary/mixer/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AtmosMixer", name)
		ui.open()

/obj/machinery/atmospherics/components/trinary/mixer/ui_data()
	var/data = list()
	data["on"] = on
	data["set_pressure"] = round(target_pressure)
	data["max_pressure"] = round(MAX_OMNI_PRESSURE)
	data["node1_concentration"] = round(node1_concentration*100, 1)
	data["node2_concentration"] = round(node2_concentration*100, 1)
	data["last_draw"] = last_power_draw
	data["max_power"] = power_rating
	return data

/obj/machinery/atmospherics/components/trinary/mixer/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("power")
			on = !on
			investigate_log("was turned [on ? "on" : "off"] by [key_name(usr)]", INVESTIGATE_ATMOS)
			. = TRUE
		if("pressure")
			var/pressure = params["pressure"]
			if(pressure == "max")
				pressure = MAX_OMNI_PRESSURE
				. = TRUE
			else if(text2num(pressure) != null)
				pressure = text2num(pressure)
				. = TRUE
			if(.)
				target_pressure = clamp(pressure, 0, MAX_OMNI_PRESSURE)
				investigate_log("was set to [target_pressure] kPa by [key_name(usr)]", INVESTIGATE_ATMOS)
		if("node1")
			var/value = text2num(params["concentration"])
			adjust_node1_value(value)
			investigate_log("was set to [node1_concentration] % on node 1 by [key_name(usr)]", INVESTIGATE_ATMOS)
			. = TRUE
		if("node2")
			var/value = text2num(params["concentration"])
			adjust_node1_value(100 - value)
			investigate_log("was set to [node2_concentration] % on node 2 by [key_name(usr)]", INVESTIGATE_ATMOS)
			. = TRUE
	update_appearance()

/obj/machinery/atmospherics/components/trinary/mixer/proc/adjust_node1_value(newValue)
	node1_concentration = newValue / 100
	node2_concentration = 1 - node1_concentration

/obj/machinery/atmospherics/components/trinary/mixer/can_unwrench(mob/user)
	. = ..()
	if(. && on && is_operational)
		to_chat(user, span_warning("You cannot unwrench [src], turn it off first!"))
		return FALSE

// mapping

/obj/machinery/atmospherics/components/trinary/mixer/layer2
	piping_layer = 2
	icon_state = "mixer_off_map-2"
/obj/machinery/atmospherics/components/trinary/mixer/layer4
	piping_layer = 4
	icon_state = "mixer_off_map-4"

/obj/machinery/atmospherics/components/trinary/mixer/on
	on = TRUE
	icon_state = "mixer_on-0"

/obj/machinery/atmospherics/components/trinary/mixer/on/layer2
	piping_layer = 2
	icon_state = "mixer_on_map-2"
/obj/machinery/atmospherics/components/trinary/mixer/on/layer4
	piping_layer = 4
	icon_state = "mixer_on_map-4"

/obj/machinery/atmospherics/components/trinary/mixer/flipped
	icon_state = "mixer_off-0_f"
	flipped = TRUE

/obj/machinery/atmospherics/components/trinary/mixer/flipped/layer2
	piping_layer = 2
	icon_state = "mixer_off_f_map-2"
/obj/machinery/atmospherics/components/trinary/mixer/flipped/layer4
	piping_layer = 4
	icon_state = "mixer_off_f_map-4"

/obj/machinery/atmospherics/components/trinary/mixer/flipped/on
	on = TRUE
	icon_state = "mixer_on-0_f"

/obj/machinery/atmospherics/components/trinary/mixer/flipped/on/layer2
	piping_layer = 2
	icon_state = "mixer_on_f_map-2"
/obj/machinery/atmospherics/components/trinary/mixer/flipped/on/layer4
	piping_layer = 4
	icon_state = "mixer_on_f_map-4"

/obj/machinery/atmospherics/components/trinary/mixer/airmix //For standard airmix to distro
	name = "air mixer"
	icon_state = "mixer_on-0"
	node1_concentration = N2STANDARD
	node2_concentration = O2STANDARD
	target_pressure = MAX_OMNI_PRESSURE
	on = TRUE

/obj/machinery/atmospherics/components/trinary/mixer/airmix/inverse
	node1_concentration = O2STANDARD
	node2_concentration = N2STANDARD

/obj/machinery/atmospherics/components/trinary/mixer/airmix/flipped
	icon_state = "mixer_on-0_f"
	flipped = TRUE

/obj/machinery/atmospherics/components/trinary/mixer/airmix/flipped/inverse
	node1_concentration = O2STANDARD
	node2_concentration = N2STANDARD
