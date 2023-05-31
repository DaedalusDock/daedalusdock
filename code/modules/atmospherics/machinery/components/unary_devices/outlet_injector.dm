/obj/machinery/atmospherics/components/unary/outlet_injector
	icon_state = "inje_map-3"

	name = "air injector"
	desc = "Has a valve and pump attached to it."

	use_power = IDLE_POWER_USE
	can_unwrench = TRUE
	shift_underlay_only = FALSE
	hide = TRUE
	layer = GAS_SCRUBBER_LAYER
	pipe_state = "injector"
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF //really helpful in building gas chambers for xenomorphs

	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.25
	initial_volume = ATMOS_DEFAULT_VOLUME_PUMP + 500

	power_rating = 45000

	///Rate of operation of the device
	var/volume_rate = 50

/obj/machinery/atmospherics/components/unary/outlet_injector/CtrlClick(mob/user)
	if(can_interact(user))
		on = !on
		investigate_log("was turned [on ? "on" : "off"] by [key_name(user)]", INVESTIGATE_ATMOS)
		update_appearance()
	return ..()

/obj/machinery/atmospherics/components/unary/outlet_injector/AltClick(mob/user)
	if(can_interact(user))
		volume_rate = ATMOS_DEFAULT_VOLUME_PUMP
		investigate_log("was set to [volume_rate] L/s by [key_name(user)]", INVESTIGATE_ATMOS)
		balloon_alert(user, "volume output set to [volume_rate] L/s")
		update_appearance()
	return ..()

/obj/machinery/atmospherics/components/unary/outlet_injector/update_icon_nopipes()
	cut_overlays()
	if(showpipe)
		// everything is already shifted so don't shift the cap
		add_overlay(get_pipe_image(icon, "inje_cap", initialize_directions, pipe_color))

	if(!nodes[1] || !on || !is_operational)
		icon_state = "inje_off"
	else
		icon_state = "inje_on"

/obj/machinery/atmospherics/components/unary/outlet_injector/process_atmos()
	..()
	if(!on || !is_operational)
		return

	var/turf/location = get_turf(loc)
	if(isclosedturf(location))
		return

	var/datum/gas_mixture/air_contents = airs[1]
	var/datum/gas_mixture/environment = loc.return_air()
	var/draw
	if(environment && air_contents.temperature > 0)
		var/transfer_moles = (volume_rate/air_contents.volume)*air_contents.total_moles //apply flow rate limit
		draw = pump_gas(air_contents, environment, transfer_moles, power_rating)

	if(draw >= 0)
		ATMOS_USE_POWER(draw)
		update_parents()

/obj/machinery/atmospherics/components/unary/outlet_injector/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AtmosPump", name)
		ui.open()

/obj/machinery/atmospherics/components/unary/outlet_injector/ui_data()
	var/data = list()
	data["on"] = on
	data["rate"] = round(volume_rate)
	data["max_rate"] = round(ATMOS_DEFAULT_VOLUME_PUMP)
	return data

/obj/machinery/atmospherics/components/unary/outlet_injector/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("power")
			on = !on
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
				volume_rate = clamp(rate, 0, ATMOS_DEFAULT_VOLUME_PUMP)
				investigate_log("was set to [volume_rate] L/s by [key_name(usr)]", INVESTIGATE_ATMOS)
	update_appearance()

/obj/machinery/atmospherics/components/unary/outlet_injector/can_unwrench(mob/user)
	. = ..()
	if(. && on && is_operational)
		to_chat(user, span_warning("You cannot unwrench [src], turn it off first!"))
		return FALSE

// mapping

/obj/machinery/atmospherics/components/unary/outlet_injector/layer2
	piping_layer = 2
	icon_state = "inje_map-2"

/obj/machinery/atmospherics/components/unary/outlet_injector/layer4
	piping_layer = 4
	icon_state = "inje_map-4"

/obj/machinery/atmospherics/components/unary/outlet_injector/on
	on = TRUE

/obj/machinery/atmospherics/components/unary/outlet_injector/on/layer2
	piping_layer = 2
	icon_state = "inje_map-2"

/obj/machinery/atmospherics/components/unary/outlet_injector/on/layer4
	piping_layer = 4
	icon_state = "inje_map-4"
