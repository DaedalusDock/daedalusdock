//node2, air2, network2 correspond to input
//node1, air1, network1 correspond to output
#define CIRCULATOR_HOT 0
#define CIRCULATOR_COLD 1

/obj/machinery/atmospherics/components/binary/circulator
	name = "TEG circulator"
	desc = "A gas circulator pump and heat exchanger for a thermoelectric generator."
	icon = 'icons/obj/atmospherics/components/teg.dmi'
	icon_state = "circ-off-0"

	pipe_flags = PIPING_ONE_PER_TURF | PIPING_DEFAULT_LAYER_ONLY

	density = TRUE
	move_resist = MOVE_RESIST_DEFAULT

	initial_volume = 200

	var/flipped = 0
	var/mode = CIRCULATOR_HOT
	var/obj/machinery/power/generator/generator
	var/color_index = 1

	var/kinetic_efficiency = 0.04 //combined kinetic and kinetic-to-electric efficiency
	var/volume_ratio = 0.2

	var/stored_energy = 0
	var/last_stored_energy_transferred = 0
	var/last_pressure_delta = 0
	var/recent_moles_transferred = 0
	var/volume_capacity_used = 0

	var/active = FALSE

/obj/machinery/atmospherics/components/binary/circulator/New()
	. = ..()
	airs[2].volume = 400 //The input has a larger volume than the output

/obj/machinery/atmospherics/components/binary/circulator/is_connectable()
	if(!anchored)
		return FALSE
	return ..()

//default cold circ for mappers
/obj/machinery/atmospherics/components/binary/circulator/cold
	mode = CIRCULATOR_COLD

//for cargo crates
/obj/machinery/atmospherics/components/binary/circulator/unwrenched
	anchored = FALSE

/obj/machinery/atmospherics/components/binary/circulator/Destroy()
	if(generator)
		disconnectFromGenerator()
	return ..()

/obj/machinery/atmospherics/components/binary/circulator/proc/return_transfer_air()
	var/datum/gas_mixture/removed
	var/datum/gas_mixture/air1 = airs[1]
	var/datum/gas_mixture/air2 = airs[2]
	var/datum/pipeline/input_pipeline = parents[2]
	if(!input_pipeline)
		return

	var/input_starting_pressure = air2.returnPressure()
	var/output_starting_pressure = air1.returnPressure()
	last_pressure_delta = max(input_starting_pressure - output_starting_pressure - 5, 0)

	//only circulate air if there is a pressure difference (plus 5kPa kinetic, 10kPa static friction)
	if(air1.temperature > 0 && last_pressure_delta > 5)

		//Calculate necessary moles to transfer using PV = nRT
		recent_moles_transferred = (last_pressure_delta*input_pipeline.combined_volume/(air2.temperature * R_IDEAL_GAS_EQUATION))/3 //uses the volume of the whole network, not just itself
		volume_capacity_used = min( (last_pressure_delta*input_pipeline.combined_volume/3)/(input_starting_pressure*air2.volume) , 1) //how much of the gas in the input air volume is consumed

		//Calculate energy generated from kinetic turbine
		stored_energy += 1/ADIABATIC_EXPONENT * min(last_pressure_delta * input_pipeline.combined_volume , input_starting_pressure*air2.volume) * (1 - volume_ratio**ADIABATIC_EXPONENT) * kinetic_efficiency

		//Actually transfer the gas
		removed = air2.remove(recent_moles_transferred)

		// NOTE: Typically you'd update parents here, but its all handled by the generator itself.

	else
		last_pressure_delta = 0

	return removed

/obj/machinery/atmospherics/components/binary/circulator/proc/return_stored_energy()
	last_stored_energy_transferred = stored_energy
	stored_energy = 0
	return last_stored_energy_transferred

/obj/machinery/atmospherics/components/binary/circulator/process_atmos()
	..()
	update_appearance(UPDATE_OVERLAYS|UPDATE_ICON_STATE)

/obj/machinery/atmospherics/components/binary/circulator/update_icon_state()
	if(!is_operational)
		icon_state = "circ-p-[flipped]"
		return ..()
	if(last_pressure_delta > 0)
		if(last_pressure_delta > ONE_ATMOSPHERE)
			icon_state = "circ-run-[flipped]"
		else
			icon_state = "circ-slow-[flipped]"
		return ..()

	icon_state = "circ-off-[flipped]"
	return ..()

/obj/machinery/atmospherics/components/binary/circulator/update_overlays()
	. = ..()
	if(!initial(icon))
		return
	var/mutable_appearance/circ_overlay = new(initial(icon))
	. += get_pipe_image(circ_overlay, "pipe", turn(dir, 90), pipe_color, piping_layer)
	. += mutable_appearance(icon, (mode ? "circ-ocold" : "circ-ohot"))

/obj/machinery/atmospherics/components/binary/circulator/wrench_act(mob/living/user, obj/item/I)
	. = ..()
	I.play_tool_sound(src)
	setDir(turn(dir,-90))
	to_chat(user, span_notice("You rotate [src]."))
	reset_connections()
	return TRUE

/obj/machinery/atmospherics/components/binary/circulator/wrench_act_secondary(mob/living/user, obj/item/I)
	. = ..()
	set_anchored(!anchored)
	I.play_tool_sound(src)
	if(generator)
		disconnectFromGenerator()
	to_chat(user, span_notice("You [anchored ? "secure" : "unsecure"] [src]."))
	reset_connections()
	return TRUE

/obj/machinery/atmospherics/components/binary/circulator/proc/reset_connections()
	var/obj/machinery/atmospherics/node1 = nodes[1]
	var/obj/machinery/atmospherics/node2 = nodes[2]

	if(node1)
		node1.disconnect(src)
		nodes[1] = null
		if(parents[1])
			nullify_pipenet(parents[1])

	if(node2)
		node2.disconnect(src)
		nodes[2] = null
		if(parents[2])
			nullify_pipenet(parents[2])

	if(anchored)
		set_init_directions()
		atmos_init()
		node1 = nodes[1]
		if(node1)
			node1.atmos_init()
			node1.add_member(src)
		node2 = nodes[2]
		if(node2)
			node2.atmos_init()
			node2.add_member(src)
		SSairmachines.add_to_rebuild_queue(src)

	return TRUE

/obj/machinery/atmospherics/components/binary/circulator/set_init_directions()
	switch(dir)
		if(NORTH, SOUTH)
			initialize_directions = EAST|WEST
		if(EAST, WEST)
			initialize_directions = NORTH|SOUTH

/obj/machinery/atmospherics/components/binary/circulator/get_node_connects()
	if(flipped)
		return list(turn(dir, 270), turn(dir, 90))
	return list(turn(dir, 90), turn(dir, 270))

/obj/machinery/atmospherics/components/binary/circulator/can_be_node(obj/machinery/atmospherics/target)
	if(anchored)
		return ..(target)
	return FALSE

/obj/machinery/atmospherics/components/binary/circulator/multitool_act(mob/living/user, obj/item/multitool/I)
	piping_layer = (piping_layer >= PIPING_LAYER_MAX) ? PIPING_LAYER_MIN : (piping_layer + 1)
	to_chat(user, span_notice("You change the circuitboard to layer [piping_layer]."))
	reset_connections()
	update_appearance()
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/atmospherics/components/binary/circulator/multitool_act_secondary(mob/living/user, obj/item/I)
	color_index = (color_index >= GLOB.pipe_paint_colors.len) ? (color_index = 1) : (color_index = 1 + color_index)
	pipe_color = GLOB.pipe_paint_colors[GLOB.pipe_paint_colors[color_index]]
	visible_message("<span class='notice'>You set [src]'s pipe color to [GLOB.pipe_color_name[pipe_color]].")
	reset_connections()
	update_appearance()
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/atmospherics/components/binary/circulator/screwdriver_act(mob/living/user, obj/item/I)
	if(..())
		return TRUE
	if(generator)
		disconnectFromGenerator()
	mode = !mode
	to_chat(user, span_notice("You switch [src] to [mode ? "cold" : "hot"] mode."))
	I.play_tool_sound(src)
	update_appearance()
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/atmospherics/components/binary/circulator/welder_act(mob/living/user, obj/item/I)
	if(atom_integrity >= max_integrity)
		to_chat(user, span_notice("The [src] does not need any repairs."))
		return TRUE
	if(!I.use_tool(src, user, 0, volume = 50, amount = 1))
		return TRUE
	user.visible_message(span_notice("[user] repairs some damage to [src]."), span_notice("You repair some damage to [src]."))
	atom_integrity += min(10, max_integrity - atom_integrity)
	if(atom_integrity == max_integrity)
		to_chat(user, span_notice("The [src] is fully repaired."))
	return TRUE

/obj/machinery/atmospherics/components/binary/circulator/proc/disconnectFromGenerator()
	if(mode)
		generator.circ1 = null
	else
		generator.circ2 = null
	generator.update_appearance()
	generator = null

/obj/machinery/atmospherics/components/binary/circulator/set_piping_layer(new_layer)
	..()
	pixel_x = 0
	pixel_y = 0

/obj/machinery/atmospherics/components/binary/circulator/verb/circulator_flip()
	set name = "Flip"
	set category = "Object"
	set src in oview(1)

	if(!ishuman(usr))
		return

	if(anchored)
		to_chat(usr, span_danger("[src] is anchored!"))
		return

	flipped = !flipped
	to_chat(usr, span_notice("You flip [src]."))
	update_appearance()

/obj/machinery/atmospherics/components/binary/circulator/examine(mob/user)
	. = ..()
	. += span_notice(" -Use a wrench with left-click to rotate it and right-click to unanchor it.")
	. += span_notice(" -Use a screwdriver to toggle hot/cold mode.")
	. += span_notice(" -Use a multitool with left-click to change pipe layer and right-click to change pipe color.")
	. += span_notice("Its outlet port is to the [dir2text(flipped ? (turn(dir, 270)) : (turn(dir, 90)))].")
	. += span_notice("It is on [mode ? "cold" : "hot"] mode.")
