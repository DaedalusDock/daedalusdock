/obj/machinery/chem_heater
	name = "chemical heater"
	density = TRUE
	pass_flags_self = PASSMACHINE | LETPASSTHROW
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0b"
	base_icon_state = "mixer"
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.4
	resistance_flags = FIRE_PROOF | ACID_PROOF
	circuit = /obj/item/circuitboard/machine/chem_heater

	var/obj/item/reagent_containers/beaker = null
	var/target_temperature = 300
	var/heater_coefficient = 0.05
	var/on = FALSE
	var/dispense_volume = 1
	//The list of active clients using this heater, so that we can update the UI on a reaction_step. I assume there are multiple clients possible.
	var/list/ui_client_list
	///If the user has the tutorial enabled
	var/tutorial_active = FALSE
	///What state we're at in the tutorial
	var/tutorial_state = 0

/obj/machinery/chem_heater/Initialize(mapload)
	. = ..()
	create_reagents(200, NO_REACT)//Lets save some calculations here

/obj/machinery/chem_heater/deconstruct(disassembled)
	. = ..()
	if(beaker && disassembled)
		beaker.forceMove(drop_location())
		beaker = null

/obj/machinery/chem_heater/Destroy()
	if(beaker)
		QDEL_NULL(beaker)
	return ..()


/obj/machinery/chem_heater/handle_atom_del(atom/A)
	. = ..()
	if(A == beaker)
		beaker = null
		update_appearance()

/obj/machinery/chem_heater/update_icon_state()
	icon_state = "[base_icon_state][beaker ? 1 : 0]b"
	return ..()

/obj/machinery/chem_heater/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!can_interact(user) || !user.canUseTopic(src, USE_CLOSE|USE_SILICON_REACH|USE_IGNORE_TK))
		return
	replace_beaker(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/chem_heater/attack_robot_secondary(mob/user, list/modifiers)
	return attack_hand_secondary(user, modifiers)

/obj/machinery/chem_heater/attack_ai_secondary(mob/user, list/modifiers)
	return attack_hand_secondary(user, modifiers)

/obj/machinery/chem_heater/proc/replace_beaker(mob/living/user, obj/item/reagent_containers/new_beaker)
	if(!user)
		return FALSE
	if(beaker)
		try_put_in_hand(beaker, user)
		beaker = null
	if(new_beaker)
		beaker = new_beaker
	update_appearance()
	return TRUE

/obj/machinery/chem_heater/RefreshParts()
	. = ..()
	heater_coefficient = 0.1
	for(var/obj/item/stock_parts/micro_laser/M in component_parts)
		heater_coefficient *= M.rating

/obj/machinery/chem_heater/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += span_notice("The status display reads: Heating reagents at <b>[heater_coefficient*1000]%</b> speed.")


/obj/machinery/chem_heater/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, "mixer0b", "mixer0b", I))
		return

	if(default_deconstruction_crowbar(I))
		return

	if(istype(I, /obj/item/reagent_containers) && !(I.item_flags & ABSTRACT) && I.is_open_container())
		. = TRUE //no afterattack
		var/obj/item/reagent_containers/B = I
		if(!user.transferItemToLoc(B, src))
			return
		replace_beaker(user, B)
		to_chat(user, span_notice("You add [B] to [src]."))
		ui_interact(user)
		update_appearance()
		return

	if(beaker)
		if(istype(I, /obj/item/reagent_containers/dropper))
			var/obj/item/reagent_containers/dropper/D = I
			D.afterattack(beaker, user, 1)
			return
		if(istype(I, /obj/item/reagent_containers/syringe))
			var/obj/item/reagent_containers/syringe/S = I
			S.afterattack(beaker, user, 1)
			return
	return ..()

/obj/machinery/chem_heater/on_deconstruction()
	replace_beaker()
	return ..()

/obj/machinery/chem_heater/process()
	if(on && beaker)
		beaker.reagents.adjust_thermal_energy((target_temperature - beaker.reagents.chem_temp) * heater_coefficient * SPECIFIC_HEAT_DEFAULT * beaker.reagents.total_volume * (rand(8,11) * 0.1))//Give it a little wiggle room since we're actively reacting

/obj/machinery/chem_heater/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemHeater", name)
		ui.open()
		add_ui_client_list(ui)

/obj/machinery/chem_heater/ui_close(mob/user)
	for(var/ui_client in ui_client_list)
		var/datum/tgui/ui = ui_client
		if(ui.user == user)
			remove_ui_client_list(ui)
	return ..()

/*
*This adds an open ui client to the list - so that it can be force updated from reaction mechanisms.
* After adding it to the list, it enables a signal incase the ui is deleted - which will call a method to remove it from the list
* This is mostly to ensure we don't have defunct ui instances stored from any condition.
*/
/obj/machinery/chem_heater/proc/add_ui_client_list(new_ui)
	LAZYADD(ui_client_list, new_ui)
	RegisterSignal(new_ui, COMSIG_PARENT_QDELETING, PROC_REF(on_ui_deletion))

///This removes an open ui instance from the ui list and deregsiters the signal
/obj/machinery/chem_heater/proc/remove_ui_client_list(old_ui)
	UnregisterSignal(old_ui, COMSIG_PARENT_QDELETING)
	LAZYREMOVE(ui_client_list, old_ui)

///This catches a signal and uses it to delete the ui instance from the list
/obj/machinery/chem_heater/proc/on_ui_deletion(datum/tgui/source, force)
	SIGNAL_HANDLER
	remove_ui_client_list(source)

/obj/machinery/chem_heater/ui_assets()
	. = ..() || list()
	. += get_asset_datum(/datum/asset/simple/tutorial_advisors)

/obj/machinery/chem_heater/ui_data(mob/user)
	var/data = list()
	data["targetTemp"] = target_temperature
	data["isActive"] = on
	data["isBeakerLoaded"] = beaker ? 1 : 0

	data["currentTemp"] = beaker ? beaker.reagents.chem_temp : null
	data["beakerCurrentVolume"] = beaker ? round(beaker.reagents.total_volume, CHEMICAL_VOLUME_ROUNDING) : null
	data["beakerMaxVolume"] = beaker ? beaker.volume : null
	var/upgrade_level = heater_coefficient*10
	data["upgradeLevel"] = upgrade_level

	var/list/beaker_contents = list()
	for(var/r in beaker?.reagents.reagent_list)
		var/datum/reagent/reagent = r
		beaker_contents.len++
		beaker_contents[length(beaker_contents)] = list("name" = reagent.name, "volume" = round(reagent.volume, CHEMICAL_VOLUME_ROUNDING))
	data["beakerContents"] = beaker_contents

	var/list/active_reactions = list()

	for(var/_reaction in beaker?.reagents.reaction_list)
		var/datum/equilibrium/equilibrium = _reaction
		if(!length(beaker.reagents.reaction_list))//I'm not sure why when it explodes it causes the gui to fail (it's missing danger (?) )
			stack_trace("how is this happening??")
			continue
		if(!equilibrium.reaction.results)//Incase of no result reactions
			continue
		var/_reagent = equilibrium.reaction.results[1]
		var/datum/reagent/reagent = beaker?.reagents.get_reagent(_reagent) //Reactions are named after their primary products
		if(!reagent)
			continue
		var/overheat = FALSE
		var/danger = FALSE
		var/purity_alert = 2 //same as flashing
		if(equilibrium.reaction.is_cold_recipe)
			if(equilibrium.reaction.overheat_temp > beaker?.reagents.chem_temp && equilibrium.reaction.overheat_temp != NO_OVERHEAT)
				danger = TRUE
				overheat = TRUE
		else
			if(equilibrium.reaction.overheat_temp < beaker?.reagents.chem_temp)
				danger = TRUE
				overheat = TRUE
		if(equilibrium.reaction.reaction_flags & REACTION_COMPETITIVE) //We have a compeitive reaction - concatenate the results for the different reactions
			for(var/entry in active_reactions)
				if(entry["name"] == reagent.name) //If we have multiple reaction methods for the same result - combine them
					entry["reactedVol"] = equilibrium.reacted_vol
					entry["targetVol"] = round(equilibrium.target_vol, 1)//Use the first result reagent to name the reaction detected
					continue
		active_reactions.len++
		active_reactions[length(active_reactions)] = list("name" = reagent.name, "danger" = danger, "purityAlert" = purity_alert, "overheat" = overheat, "reactedVol" = equilibrium.reacted_vol, "targetVol" = round(equilibrium.target_vol, 1))//Use the first result reagent to name the reaction detected
	data["activeReactions"] = active_reactions
	data["dispenseVolume"] = dispense_volume
	return data

/obj/machinery/chem_heater/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("power")
			on = !on
			. = TRUE
		if("temperature")
			var/target = params["target"]
			if(text2num(target) != null)
				target = text2num(target)
				. = TRUE
			if(.)
				target_temperature = clamp(target, 0, 1000)
		if("eject")
			//Eject doesn't turn it off, so you can preheat for beaker swapping
			replace_beaker(usr)
			. = TRUE
