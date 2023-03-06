///Magic number to boost the power of heating/cooling without touching power consumption
#define THERMOMACHINE_PERF_MULT 2.5

/obj/machinery/atmospherics/components/unary/thermomachine
	icon = 'icons/obj/atmospherics/components/thermomachine.dmi'
	icon_state = "thermo_base"

	name = "Temperature control unit"
	desc = "Heats or cools gas in connected pipes."

	density = TRUE
	max_integrity = 300
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 100, BOMB = 0, BIO = 100, FIRE = 80, ACID = 30)
	layer = OBJ_LAYER
	circuit = /obj/item/circuitboard/machine/thermomachine

	hide = TRUE

	move_resist = MOVE_RESIST_DEFAULT
	vent_movement = NONE
	pipe_flags = PIPING_ONE_PER_TURF

	greyscale_config = /datum/greyscale_config/thermomachine
	greyscale_colors = COLOR_VIBRANT_LIME

	set_dir_on_move = FALSE

	var/min_temperature = 0
	var/max_temperature = T20C + 500

	var/target_temperature = T20C
	var/heatsink_temperature = T20C // The constant temperature reservoir into which the freezer pumps heat. Probably the hull of the station or something.
	///Power rating when the usage is turned up to 100
	var/max_power_rating = 20000
	///Percentage of power rating to use
	var/power_setting = 20 // Start at 20 so we don't obliterate the station power supply.

	var/interactive = TRUE // So mapmakers can disable interaction.
	var/color_index = 1

/obj/machinery/atmospherics/components/unary/thermomachine/Initialize(mapload)
	. = ..()
	RefreshParts()
	update_appearance()

/obj/machinery/atmospherics/components/unary/thermomachine/is_connectable()
	if(!anchored || panel_open)
		return FALSE
	. = ..()

/obj/machinery/atmospherics/components/unary/thermomachine/on_construction(obj_color, set_layer)
	var/obj/item/circuitboard/machine/thermomachine/board = circuit
	if(board)
		piping_layer = board.pipe_layer
		set_layer = piping_layer

	if(check_pipe_on_turf())
		deconstruct(TRUE)
		return
	return..()

/obj/machinery/atmospherics/components/unary/thermomachine/RefreshParts()
	. = ..()
	var/cap_rating = 0
	for(var/obj/item/stock_parts/capacitor/cap in component_parts)
		cap_rating += cap.rating

	var/bin_rating = 0
	for(var/obj/item/stock_parts/matter_bin/bin in component_parts)
		cap_rating += bin.rating

	var/manip_rating = 0
	for(var/obj/item/stock_parts/manipulator/man in component_parts)
		manip_rating += man.rating

	max_power_rating = initial(max_power_rating) * cap_rating / 2 //more powerful
	heatsink_temperature = initial(heatsink_temperature) / ((manip_rating + bin_rating) / 2) //more efficient
	set_power_level(power_setting)

/obj/machinery/atmospherics/components/unary/thermomachine/update_icon_state()
	var/colors_to_use = ""
	switch(target_temperature)
		if(BODYTEMP_HEAT_WARNING_3 to INFINITY)
			colors_to_use = COLOR_RED
		if(BODYTEMP_HEAT_WARNING_2 to BODYTEMP_HEAT_WARNING_3)
			colors_to_use = COLOR_ORANGE
		if(BODYTEMP_HEAT_WARNING_1 to BODYTEMP_HEAT_WARNING_2)
			colors_to_use = COLOR_YELLOW
		if(BODYTEMP_COLD_WARNING_1 to BODYTEMP_HEAT_WARNING_1)
			colors_to_use = COLOR_VIBRANT_LIME
		if(BODYTEMP_COLD_WARNING_2 to BODYTEMP_COLD_WARNING_1)
			colors_to_use = COLOR_CYAN
		if(BODYTEMP_COLD_WARNING_3 to BODYTEMP_COLD_WARNING_2)
			colors_to_use = COLOR_BLUE
		else
			colors_to_use = COLOR_VIOLET

	if(greyscale_colors != colors_to_use)
		set_greyscale(colors=colors_to_use)

	if(panel_open)
		icon_state = "thermo_open"
		return ..()
	if(on && is_operational)
		icon_state = "thermo_1"
		return ..()
	icon_state = "thermo_base"
	return ..()

/obj/machinery/atmospherics/components/unary/thermomachine/update_overlays()
	. = ..()
	if(!initial(icon))
		return
	var/mutable_appearance/thermo_overlay = new(initial(icon))
	. += get_pipe_image(thermo_overlay, "pipe", dir, COLOR_LIME, piping_layer)

/obj/machinery/atmospherics/components/unary/thermomachine/examine(mob/user)
	. = ..()
	. += span_notice("With the panel open:")
	. += span_notice(" -Use a wrench with left-click to rotate [src] and right-click to unanchor it.")
	. += span_notice(" -Use a multitool with left-click to change the piping layer and right-click to change the piping color.")
	. += span_notice("The thermostat is set to [target_temperature]K ([(T0C-target_temperature)*-1]C).")

	if(in_range(user, src) || isobserver(user))
		. += span_notice("Heatsink temperature at <b>[heatsink_temperature]K</b>.")
		. += span_notice("Temperature range <b>[min_temperature]K - [max_temperature]K ([(T0C-min_temperature)*-1]C - [(T0C-max_temperature)*-1]C)</b>.")

/obj/machinery/atmospherics/components/unary/thermomachine/AltClick(mob/living/user)
	if(!can_interact(user))
		return
	target_temperature = T20C
	investigate_log("was set to [target_temperature] K by [key_name(user)]", INVESTIGATE_ATMOS)
	balloon_alert(user, "temperature reset to [target_temperature] K")
	update_appearance()

/obj/machinery/atmospherics/components/unary/thermomachine/process_atmos()
	if(!on)
		return

	var/turf/local_turf = get_turf(src)

	if(!is_operational || !local_turf)
		on = FALSE
		update_appearance()
		return

	// The gas we want to cool/heat
	var/datum/gas_mixture/port = airs[1]

	if(!port.total_moles || port.temperature == target_temperature) // Nothing to cool? go home lad
		return
	if(port.temperature > target_temperature) //We chillin'
		var/heat_transfer = max( -port.getThermalEnergyChange(target_temperature - 5), 0 )

		//Assume the heat is being pumped into the hull which is fixed at heatsink_temperature
		//not /really/ proper thermodynamics but whatever
		var/cop = THERMOMACHINE_PERF_MULT * (port.temperature/heatsink_temperature)	//heatpump coefficient of performance from thermodynamics -> power used = heat_transfer/cop
		heat_transfer = min(heat_transfer, cop * power_rating) //limit heat transfer by available power

		port.adjustThermalEnergy(-heat_transfer) //remove the heat

	else //We heatin'
		port.adjustThermalEnergy(power_rating * THERMOMACHINE_PERF_MULT)

	use_power(power_rating)
	update_parents()

/obj/machinery/atmospherics/components/unary/thermomachine/screwdriver_act(mob/living/user, obj/item/tool)
	if(on)
		to_chat(user, span_notice("You can't open [src] while it's on!"))
		return TOOL_ACT_TOOLTYPE_SUCCESS
	if(!anchored)
		to_chat(user, span_notice("Anchor [src] first!"))
		return TOOL_ACT_TOOLTYPE_SUCCESS
	if(default_deconstruction_screwdriver(user, "thermo_open", "thermo_base", tool))
		change_pipe_connection(panel_open)
		return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/atmospherics/components/unary/thermomachine/wrench_act(mob/living/user, obj/item/tool)
	return default_change_direction_wrench(user, tool)

/obj/machinery/atmospherics/components/unary/thermomachine/crowbar_act(mob/living/user, obj/item/tool)
	return default_deconstruction_crowbar(tool)

/obj/machinery/atmospherics/components/unary/thermomachine/multitool_act(mob/living/user, obj/item/multitool/multitool)
	if(!panel_open)
		return
	piping_layer = (piping_layer >= PIPING_LAYER_MAX) ? PIPING_LAYER_MIN : (piping_layer + 1)
	to_chat(user, span_notice("You change the circuitboard to layer [piping_layer]."))
	update_appearance()
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/atmospherics/components/unary/thermomachine/default_change_direction_wrench(mob/user, obj/item/I)
	if(!..())
		return FALSE
	set_init_directions()
	update_appearance()
	return TRUE

/obj/machinery/atmospherics/components/unary/thermomachine/multitool_act_secondary(mob/living/user, obj/item/tool)
	if(!panel_open)
		return
	color_index = (color_index >= GLOB.pipe_paint_colors.len) ? (color_index = 1) : (color_index = 1 + color_index)
	pipe_color = GLOB.pipe_paint_colors[GLOB.pipe_paint_colors[color_index]]
	visible_message("<span class='notice'>You set [src]'s pipe color to [GLOB.pipe_color_name[pipe_color]].")
	update_appearance()
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/atmospherics/components/unary/thermomachine/proc/check_pipe_on_turf()
	for(var/obj/machinery/atmospherics/device in get_turf(src))
		if(device == src)
			continue
		if(device.piping_layer == piping_layer)
			visible_message(span_warning("A pipe is hogging the port, remove the obstruction or change the machine piping layer."))
			return TRUE
	return FALSE

/obj/machinery/atmospherics/components/unary/thermomachine/proc/change_pipe_connection(disconnect)
	if(disconnect)
		disconnect_pipes()
		return
	connect_pipes()

/obj/machinery/atmospherics/components/unary/thermomachine/proc/connect_pipes()
	var/obj/machinery/atmospherics/node1 = nodes[1]
	atmos_init()
	node1 = nodes[1]
	if(node1)
		node1.atmos_init()
		node1.add_member(src)
	SSairmachines.add_to_rebuild_queue(src)

/obj/machinery/atmospherics/components/unary/thermomachine/proc/disconnect_pipes()
	var/obj/machinery/atmospherics/node1 = nodes[1]
	if(node1)
		if(src in node1.nodes) //Only if it's actually connected. On-pipe version would is one-sided.
			node1.disconnect(src)
		nodes[1] = null
	if(parents[1])
		nullify_pipenet(parents[1])

/obj/machinery/atmospherics/components/unary/thermomachine/wrench_act_secondary(mob/living/user, obj/item/tool)
	if(!panel_open || check_pipe_on_turf())
		return
	if(default_unfasten_wrench(user, tool))
		return TOOL_ACT_TOOLTYPE_SUCCESS
	return

/obj/machinery/atmospherics/components/unary/thermomachine/ui_status(mob/user)
	if(interactive)
		return ..()
	return UI_CLOSE

/obj/machinery/atmospherics/components/unary/thermomachine/ui_interact(mob/user, datum/tgui/ui)
	if(panel_open)
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ThermoMachine", name)
		ui.open()

/obj/machinery/atmospherics/components/unary/thermomachine/ui_data(mob/user)
	var/list/data = list()
	data["on"] = on

	data["min"] = min_temperature
	data["max"] = max_temperature
	data["target"] = target_temperature
	data["initial"] = initial(target_temperature)
	data["min_power"] = 1 //No im not making a var for this
	data["max_power"] = 100 //See above
	data["power"] = power_setting

	var/datum/gas_mixture/port = airs[1]
	data["temperature"] = port.temperature
	data["pressure"] = port.returnPressure()
	return data

/obj/machinery/atmospherics/components/unary/thermomachine/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("power")
			on = !on
			update_use_power(on ? ACTIVE_POWER_USE : IDLE_POWER_USE)
			investigate_log("was turned [on ? "on" : "off"] by [key_name(usr)]", INVESTIGATE_ATMOS)
			. = TRUE
		if("target")
			var/target = params["target"]
			var/adjust = text2num(params["adjust"])
			if(target == "input")
				target = input("Set new target ([min_temperature]-[max_temperature] K):", name, target_temperature) as num|null
				if(!isnull(target))
					. = TRUE
			else if(adjust)
				target = target_temperature + adjust
				. = TRUE
			else if(text2num(target) != null)
				target = text2num(target)
				. = TRUE
			if(.)
				target_temperature = clamp(target, min_temperature, max_temperature)
				investigate_log("was set to [target_temperature] K by [key_name(usr)]", INVESTIGATE_ATMOS)
		if("set_power")
			var/target = params["target"]
			var/adjust = text2num(params["adjust"])
			if(target == "input")
				target = input("Set new target (1-100 Watts):", name, power_setting) as num|null
				if(!isnull(target))
					. = TRUE
			else if(adjust)
				target = power_setting + adjust
				. = TRUE
			else if(text2num(target) != null)
				target = text2num(target)
				. = TRUE
			if(.)
				set_power_level(target)
				investigate_log("was set to [power_setting] watts by [key_name(usr)]", INVESTIGATE_ATMOS)


	update_appearance()

/obj/machinery/atmospherics/components/unary/thermomachine/CtrlClick(mob/living/user)
	if(!panel_open)
		if(!can_interact(user))
			return
		on = !on
		investigate_log("was turned [on ? "on" : "off"] by [key_name(user)]", INVESTIGATE_ATMOS)
		update_appearance()
		return
	. = ..()

/obj/machinery/atmospherics/components/unary/thermomachine/freezer

/obj/machinery/atmospherics/components/unary/thermomachine/freezer/on
	on = TRUE
	icon_state = "thermo_base_1"

/obj/machinery/atmospherics/components/unary/thermomachine/freezer/on/Initialize(mapload)
	. = ..()
	if(target_temperature == initial(target_temperature))
		target_temperature = min_temperature

/obj/machinery/atmospherics/components/unary/thermomachine/freezer/on/coldroom
	name = "Cold room temperature control unit"
	icon_state = "thermo_base_1"
	greyscale_colors = COLOR_CYAN

/obj/machinery/atmospherics/components/unary/thermomachine/freezer/on/coldroom/Initialize(mapload)
	. = ..()
	target_temperature = COLD_ROOM_TEMP

/obj/machinery/atmospherics/components/unary/thermomachine/heater

/obj/machinery/atmospherics/components/unary/thermomachine/heater/on
	on = TRUE
	icon_state = "thermo_base_1"

/obj/machinery/atmospherics/components/unary/thermomachine/proc/set_power_level(new_power_setting)
	power_setting = new_power_setting
	power_rating = round(max_power_rating * (power_setting / 100))
