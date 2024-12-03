/obj/machinery/power/generator
	name = "thermoelectric generator"
	desc = "It's a high efficiency thermoelectric generator."
	icon = 'icons/obj/atmospherics/components/teg.dmi'
	icon_state = "teg"
	density = TRUE
	use_power = NO_POWER_USE
	interaction_flags_atom = INTERACT_ATOM_UI_INTERACT
	zmm_flags = ZMM_MANGLE_PLANES

	var/obj/machinery/atmospherics/components/binary/circulator/circ1
	var/obj/machinery/atmospherics/components/binary/circulator/circ2


	var/max_power = 500000
	var/thermal_efficiency = 0.65

	var/last_circ1_gen = 0
	var/last_circ2_gen = 0
	var/last_thermal_gen = 0
	var/stored_energy = 0
	var/lastgen1 = 0
	var/lastgen2 = 0
	var/effective_gen = 0
	var/lastgenlev = -1
	var/lastcirc = "00"

	var/datum/looping_sound/teg/soundloop

//for cargo crates
/obj/machinery/power/generator/unwrenched
	anchored = FALSE

/obj/machinery/power/generator/Initialize(mapload)
	. = ..()
	find_circs()
	connect_to_network()
	SSairmachines.start_processing_machine(src)
	update_appearance()
	soundloop = new(src, TRUE)
	soundloop.stop()

/obj/machinery/power/generator/Destroy()
	kill_circs()
	SSairmachines.stop_processing_machine(src)
	QDEL_NULL(soundloop)
	return ..()

/obj/machinery/power/generator/update_overlays()
	. = ..()
	if(machine_stat & (NOPOWER|BROKEN))
		return

	var/L = min(round(lastgenlev / 100000), 8)
	if(L != 0)
		. += mutable_appearance(icon, "teg-op[L]")
		. += emissive_appearance(icon, "teg-op[L]", alpha = 90)
	if(circ1 && circ2)
		. += mutable_appearance(icon, "teg-oc[lastcirc]")
		. += emissive_appearance(icon, "teg-oc[lastcirc]", alpha = 90)


#define GENRATE 800 // generator output coefficient from Q

/obj/machinery/power/generator/process_atmos()

	if(!circ1 || !circ2)
		return

	if(powernet)
		var/datum/gas_mixture/air1 = circ1.return_transfer_air()
		var/datum/gas_mixture/air2 = circ2.return_transfer_air()

		lastgen2 = lastgen1
		lastgen1 = 0
		last_thermal_gen = 0
		last_circ1_gen = 0
		last_circ2_gen = 0

		if(air1 && air2)

			var/air1_heat_capacity = air1.getHeatCapacity()
			var/air2_heat_capacity = air2.getHeatCapacity()

			var/delta_temperature = abs(air2.temperature - air1.temperature)


			if(delta_temperature > 0 && air1_heat_capacity > 0 && air2_heat_capacity > 0)
				var/energy_transfer = delta_temperature*air2_heat_capacity*air1_heat_capacity/(air2_heat_capacity+air1_heat_capacity)
				var/heat = energy_transfer*(1-thermal_efficiency)
				last_thermal_gen = energy_transfer*thermal_efficiency

				if(air2.temperature > air1.temperature)
					air2.temperature = air2.temperature - energy_transfer/air2_heat_capacity
					air1.temperature = air1.temperature + heat/air1_heat_capacity
				else
					air2.temperature = air2.temperature + heat/air2_heat_capacity
					air1.temperature = air1.temperature - energy_transfer/air1_heat_capacity

				soundloop.start()
			else
				soundloop.stop()

		if(air1)
			var/datum/gas_mixture/circ_1_out = circ1.airs[1]
			circ_1_out.merge(air1)
			circ1.update_parents()

		if(air2)
			var/datum/gas_mixture/circ_2_out = circ2.airs[1]
			circ_2_out.merge(air2)
			circ2.update_parents()

		update_appearance()

	var/circ = "[circ1?.last_pressure_delta > 0 ? "1" : "0"][circ2?.last_pressure_delta > 0 ? "1" : "0"]"
	if(circ != lastcirc)
		lastcirc = circ
		update_appearance()

	//Power
	last_circ1_gen = circ1.return_stored_energy()
	last_circ2_gen = circ2.return_stored_energy()
	stored_energy += last_thermal_gen + last_circ1_gen + last_circ2_gen
	lastgen1 = stored_energy*0.4 //smoothened power generation to prevent slingshotting as pressure is equalized, then restored by pumps
	stored_energy -= lastgen1
	effective_gen = (lastgen1 + lastgen2) / 2

	// update icon overlays and power usage only when necessary
	var/genlev = max(0, min( round(11*effective_gen / max_power), 11))
	if(effective_gen > 100 && genlev == 0)
		genlev = 1
	if(genlev != lastgenlev)
		lastgenlev = genlev
	add_avail(effective_gen)


//TGUI interaction
/obj/machinery/power/generator/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Teg")
		ui.open()

/obj/machinery/power/generator/ui_data(mob/user)
	var/datum/gas_mixture/cold_circ_air1 = circ1.airs[1]
	var/datum/gas_mixture/cold_circ_air2 = circ1.airs[2]
	var/datum/gas_mixture/hot_circ_air1 = circ2.airs[1]
	var/datum/gas_mixture/hot_circ_air2 = circ2.airs[2]

	var/list/data = list()
	data["has_hot_circ"] = circ2
	data["has_cold_circ"] = circ1
	data["has_powernet"] = powernet
	data["power_output"] = display_power(lastgen1)
	data["cold_temp_in"] = round(cold_circ_air2.temperature, 0.1)
	data["cold_pressure_in"] = round(cold_circ_air2.returnPressure(), 0.1)
	data["cold_temp_out"] = round(cold_circ_air1.temperature, 0.1)
	data["cold_pressure_out"] = round(cold_circ_air1.returnPressure(), 0.1)
	data["hot_temp_in"] = round(hot_circ_air2.temperature, 0.1)
	data["hot_pressure_in"] = round(hot_circ_air2.returnPressure(), 0.1)
	data["hot_temp_out"] = round(hot_circ_air1.temperature, 0.1)
	data["hot_pressure_out"] = round(hot_circ_air1.returnPressure(), 0.1)

	return data

/obj/machinery/power/generator/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(action == "refresh_parts")
		link_parts(usr)

/obj/machinery/power/generator/proc/link_parts(mob/user)
	if(!anchored)
		to_chat(user, span_notice("Secure [src] first!"))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 30, TRUE)
		return
	find_circs()
	if(!circ2)
		to_chat(user, span_notice("Could not find hot circulator!"))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 30, TRUE)
		return
	if(!circ1)
		to_chat(user, span_notice("Could not find cold circulator!"))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 30, TRUE)
		return
	playsound(src, 'sound/machines/ping.ogg', 30, TRUE)

/obj/machinery/power/generator/proc/find_circs()
	kill_circs()
	var/list/circs = list()
	var/obj/machinery/atmospherics/components/binary/circulator/C
	var/circpath = /obj/machinery/atmospherics/components/binary/circulator
	if(dir == NORTH || dir == SOUTH)
		C = locate(circpath) in get_step(src, EAST)
		if(C && C.dir == WEST)
			circs += C

		C = locate(circpath) in get_step(src, WEST)
		if(C && C.dir == EAST)
			circs += C

	else
		C = locate(circpath) in get_step(src, NORTH)
		if(C && C.dir == SOUTH)
			circs += C

		C = locate(circpath) in get_step(src, SOUTH)
		if(C && C.dir == NORTH)
			circs += C

	if(circs.len)
		for(C in circs)
			if(C.mode == CIRCULATOR_COLD && !circ1)
				circ1 = C
				C.generator = src
			else if(C.mode == CIRCULATOR_HOT && !circ2)
				circ2 = C
				C.generator = src

/obj/machinery/power/generator/attack_hand(mob/user, list/modifiers)
	. = ..()
	ui_interact(user)

/obj/machinery/power/generator/wrench_act(mob/living/user, obj/item/I)
	. = ..()
	. = ..()
	I.play_tool_sound(src)
	setDir(turn(dir,-90))
	to_chat(user, span_notice("You rotate [src]."))
	return TRUE

/obj/machinery/power/generator/wrench_act_secondary(mob/living/user, obj/item/I)
	. = ..()
	set_anchored(!anchored)
	I.play_tool_sound(src)
	if(!anchored)
		kill_circs()
	connect_to_network()
	to_chat(user, span_notice("You [anchored?"secure":"unsecure"] [src]."))
	return TRUE

/obj/machinery/power/generator/welder_act(mob/living/user, obj/item/I)
	if(atom_integrity >= max_integrity)
		to_chat(user, span_notice("The [src] does not need any repairs."))
		return TRUE
	if(!I.use_tool(src, user, 0, volume=50, amount=1))
		return TRUE
	user.visible_message(span_notice("[user] repairs some damage to [src]."), span_notice("You repair some damage to [src]."))
	atom_integrity += min(10, max_integrity-atom_integrity)
	if(atom_integrity == max_integrity)
		to_chat(user, span_notice("The [src] is fully repaired."))
	return TRUE

/obj/machinery/power/generator/proc/kill_circs()
	if(circ1)
		circ1.generator = null
		circ1 = null
	if(circ2)
		circ2.generator = null
		circ2 = null

/obj/machinery/power/generator/examine(mob/user)
	. = ..()
	. += span_notice("Use a wrench with left-click to rotate it and right-click to unanchor it.")
