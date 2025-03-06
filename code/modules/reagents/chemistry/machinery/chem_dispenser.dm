#define CHEM_DISPENSER_HEATER_COEFFICIENT 0.05
// Soft drinks dispenser is much better at cooling cause of the specific temperature it wants water and ice at.
#define SOFT_DISPENSER_HEATER_COEFFICIENT 0.5

/obj/machinery/chem_dispenser
	name = "chem dispenser"
	desc = "Creates and dispenses chemicals."
	density = TRUE
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dispenser"
	base_icon_state = "dispenser"
	interaction_flags_machine = INTERACT_MACHINE_OPEN | INTERACT_MACHINE_ALLOW_SILICON | INTERACT_MACHINE_OFFLINE
	resistance_flags = FIRE_PROOF | ACID_PROOF
	circuit = /obj/item/circuitboard/machine/chem_dispenser
	processing_flags = NONE
	// This munches power due to it being the chemist's main machine, and chemfactories don't exist.
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 2

	var/powerefficiency = 0.1
	var/amount = 30
	var/recharge_counter = 0
	var/dispensed_temperature = DEFAULT_REAGENT_TEMPERATURE
	var/heater_coefficient = CHEM_DISPENSER_HEATER_COEFFICIENT
	var/mutable_appearance/beaker_overlay
	var/working_state = "dispenser_working"
	var/nopower_state = "dispenser_nopower"
	var/ui_title = "Chem Dispenser"
	var/has_panel_overlay = TRUE
	var/obj/item/reagent_containers/beaker = null
	/// The maximum amount of cartridges the dispenser can contain.
	var/maximum_cartridges = 24
	var/list/spawn_cartridges

	/// Associative, label -> cartridge
	var/list/cartridges = list()

/obj/machinery/chem_dispenser/Initialize(mapload)
	. = ..()
	if(is_operational)
		begin_processing()
	update_appearance()

	set_cart_list()
	if(spawn_cartridges && mapload)
		spawn_cartridges()

//this is just here for subtypes
/obj/machinery/chem_dispenser/proc/set_cart_list()
	spawn_cartridges = GLOB.cartridge_list_chems.Copy()

/// Spawns the cartridges the chem dispenser should have on mapload. Kept as a seperate proc for admin convienience.
/obj/machinery/chem_dispenser/proc/spawn_cartridges()
	for(var/datum/reagent/chem_type as anything in spawn_cartridges)
		var/obj/item/reagent_containers/chem_cartridge/chem_cartridge = spawn_cartridges[chem_type]
		chem_cartridge = new chem_cartridge(src)
		chem_cartridge.reagents.add_reagent(chem_type, chem_cartridge.volume, reagtemp = dispensed_temperature)
		chem_cartridge.setLabel(initial(chem_type.name))
		add_cartridge(chem_cartridge)

/obj/machinery/chem_dispenser/Destroy()
	QDEL_NULL(beaker)
	return ..()

/obj/machinery/chem_dispenser/examine(mob/user)
	. = ..()
	if(panel_open)
		. += span_notice("[src]'s maintenance hatch is open!")
	if(in_range(user, src) || isobserver(user))
		if(length(cartridges))
			. += "It has [length(cartridges)] cartridges installed, and has space for [maximum_cartridges - length(cartridges)] more."
			. += span_notice("It looks like you can <b>pry</b> out one of the cartridges.")
		else
			. += "It has space for [maximum_cartridges] cartridges."

/obj/machinery/chem_dispenser/on_set_is_operational(old_value)
	if(old_value) //Turned off
		end_processing()
	else //Turned on
		begin_processing()

// Tries to keep the chem temperature at the dispense temperature
/obj/machinery/chem_dispenser/process(delta_time)
	if(machine_stat & NOPOWER)
		return

	var/power_to_use = active_power_usage

	for(var/obj/item/reagent_containers/chem_cartridge/cartridge as anything in cartridges)
		cartridge = cartridges[cartridge]
		if(cartridge.reagents.total_volume)
			if(cartridge.reagents.is_reacting)//on_reaction_step() handles this
				continue
			var/thermal_energy_to_provide = (dispensed_temperature - cartridge.reagents.chem_temp) * (heater_coefficient * powerefficiency) * delta_time * SPECIFIC_HEAT_DEFAULT * cartridge.reagents.total_volume
			// Okay, hear me out, one cartridge, when heated from default (room) temp to the magic water/ice temperature, provides about 255000 thermal energy (drinks dispenser, divide that by 10 for chem) a tick. Let's take that number, kneecap it down by a sizeable chunk, and use it as power consumption, yea?
			power_to_use += abs(thermal_energy_to_provide) / 1000
			cartridge.reagents.adjust_thermal_energy(thermal_energy_to_provide)
			cartridge.reagents.handle_reactions()

	use_power(active_power_usage)

/obj/machinery/chem_dispenser/proc/display_beaker()
	var/mutable_appearance/b_o = beaker_overlay || mutable_appearance(icon, "disp_beaker")
	b_o.pixel_y = -4
	b_o.pixel_x = -7
	return b_o

/obj/machinery/chem_dispenser/proc/work_animation()
	if(working_state)
		flick(working_state,src)

/obj/machinery/chem_dispenser/update_icon_state()
	icon_state = "[(nopower_state && !powered()) ? nopower_state : base_icon_state]"
	return ..()

/obj/machinery/chem_dispenser/update_overlays()
	. = ..()
	if(has_panel_overlay && panel_open)
		. += mutable_appearance(icon, "[base_icon_state]_panel-o")

	if(beaker)
		beaker_overlay = display_beaker()
		. += beaker_overlay


/obj/machinery/chem_dispenser/emag_act(mob/user)
	to_chat(user, span_warning("[src] has no safeties to emag!"))

/obj/machinery/chem_dispenser/ex_act(severity, target)
	if(severity <= EXPLODE_LIGHT)
		return FALSE
	return ..()

/obj/machinery/chem_dispenser/contents_explosion(severity, target)
	..()
	if(!beaker)
		return

	switch(severity)
		if(EXPLODE_DEVASTATE)
			EX_ACT(beaker, EXPLODE_DEVASTATE)
		if(EXPLODE_HEAVY)
			EX_ACT(beaker, EXPLODE_HEAVY)
		if(EXPLODE_LIGHT)
			EX_ACT(beaker, EXPLODE_LIGHT)

/obj/machinery/chem_dispenser/handle_atom_del(atom/A)
	..()
	if(A == beaker)
		beaker = null
		cut_overlays()

/obj/machinery/chem_dispenser/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemDispenser", ui_title)

		if(user.hallucinating())
			ui.set_autoupdate(FALSE) //to not ruin the immersion by constantly changing the fake chemicals
		ui.open()

/obj/machinery/chem_dispenser/ui_data(mob/user)
	var/data = list()
	data["amount"] = amount
	data["cartAmount"] = length(cartridges)
	data["maxCarts"] = maximum_cartridges
	data["isBeakerLoaded"] = !!beaker
	data["beakerName"] = "[beaker?.name]"

	var/beakerContents[0]
	var/beakerCurrentVolume = 0
	if(beaker && beaker.reagents && beaker.reagents.reagent_list.len)
		for(var/datum/reagent/R in beaker.reagents.reagent_list)
			beakerContents.Add(list(list("name" = R.name, "volume" = round(R.volume, CHEMICAL_VOLUME_ROUNDING)))) // list in a list because Byond merges the first list...
			beakerCurrentVolume += R.volume
	data["beakerContents"] = beakerContents

	if (beaker)
		data["beakerCurrentVolume"] = round(beakerCurrentVolume, CHEMICAL_VOLUME_ROUNDING)
		data["beakerMaxVolume"] = beaker.volume
		data["beakerTransferAmounts"] = beaker.possible_transfer_amounts
	else
		data["beakerCurrentVolume"] = null
		data["beakerMaxVolume"] = null
		data["beakerTransferAmounts"] = null

	var/chemicals[0]
	var/is_hallucinating = FALSE
	if(user.hallucinating())
		is_hallucinating = TRUE

	for(var/re in cartridges)
		var/obj/item/reagent_containers/chem_cartridge/temp = cartridges[re]
		if(temp)
			var/chemname = temp.label
			if(is_hallucinating && prob(5))
				chemname = "[pick_list_replacements("hallucination.json", "chemicals")]"
			chemicals.Add(list(list("title" = chemname, "id" = temp.label, "amount" = temp.reagents.total_volume, "max" = temp.volume)))
	data["chemicals"] = chemicals

	data["recipeReagents"] = list()
	if(beaker?.reagents.ui_reaction_id)
		var/datum/chemical_reaction/reaction = get_chemical_reaction(beaker.reagents.ui_reaction_id)
		for(var/_reagent in reaction.required_reagents)
			var/datum/reagent/reagent = find_reagent_object_from_type(_reagent)
			data["recipeReagents"] += ckey(reagent.name)
	return data

/obj/machinery/chem_dispenser/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("amount")
			if(!is_operational || QDELETED(beaker))
				return
			var/target = text2num(params["target"])
			if(target in beaker.possible_transfer_amounts)
				amount = target
				work_animation()
				. = TRUE
		if("dispense")
			if(!is_operational)
				return
			var/reagent_name = params["reagent"]
			var/obj/item/reagent_containers/cartridge = cartridges[reagent_name]
			if(beaker && cartridge)
				var/datum/reagents/holder = beaker.reagents
				var/to_dispense = max(0, min(amount, holder.maximum_volume - holder.total_volume))
				cartridge.reagents.trans_to(holder, to_dispense)

				work_animation()
			. = TRUE
		if("remove")
			if(!is_operational)
				return
			var/amount = text2num(params["amount"])
			if(beaker && (amount in beaker.possible_transfer_amounts))
				beaker.reagents.remove_all(amount)
				work_animation()
				. = TRUE
		if("eject")
			replace_beaker(usr)
			. = TRUE
		if("reaction_lookup")
			if(beaker)
				beaker.reagents.ui_interact(usr)

/obj/machinery/chem_dispenser/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/chem_dispenser/attackby(obj/item/I, mob/living/user, params)
	if(default_deconstruction_screwdriver(user, icon_state, icon_state, I))
		update_appearance()
		return
	if(default_deconstruction_crowbar(I))
		return
	if(I.tool_behaviour == TOOL_CROWBAR && length(cartridges))
		. = TRUE
		var/label = tgui_input_list(user, "Which cartridge would you like to remove?", "Chemical Dispenser", cartridges)
		if(!label)
			return
		var/obj/item/reagent_containers/chem_cartridge/cartidge = remove_cartridge(label)
		if(cartidge)
			to_chat(user, span_notice("You remove \the [cartidge] from \the [src]."))
			cartidge.forceMove(loc)
			return
	if(istype(I, /obj/item/reagent_containers/chem_cartridge))
		add_cartridge(I, user)
	else if(is_reagent_container(I) && !(I.item_flags & ABSTRACT) && I.is_open_container())
		var/obj/item/reagent_containers/B = I
		. = TRUE //no afterattack
		if(!user.transferItemToLoc(B, src))
			return
		replace_beaker(user, B)
		to_chat(user, span_notice("You add [B] to [src]."))
		cartridges = sortTim(cartridges, GLOBAL_PROC_REF(cmp_text_asc))
	else if(!user.combat_mode && !istype(I, /obj/item/card/emag))
		to_chat(user, span_warning("You can't load [I] into [src]!"))
		return ..()
	else
		return ..()

/obj/machinery/chem_dispenser/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	var/list/datum/reagents/R = list()
	var/total = min(rand(7,15), powerefficiency)
	var/datum/reagents/Q = new(total*10)
	if(beaker?.reagents)
		R += beaker.reagents
	for(var/i in 1 to total)
		var/obj/item/reagent_containers/chem_cartridge = cartridges[pick(cartridges)]
		chem_cartridge.reagents.trans_to(Q, 10)
	R += Q
	chem_splash(get_turf(src), null, 3, R)
	if(beaker?.reagents)
		beaker.reagents.remove_all()
	work_animation()
	visible_message(span_danger("[src] malfunctions, spraying chemicals everywhere!"))

/obj/machinery/chem_dispenser/RefreshParts()
	. = ..()
	heater_coefficient = initial(heater_coefficient)
	var/newpowereff = 0.0666666
	var/parts_rating = 0
	var/bin_ratings = 0
	var/bin_count = 0
	for(var/obj/item/stock_parts/matter_bin/matter_bin in component_parts)
		bin_ratings += matter_bin.rating
		bin_count += 1
		parts_rating += matter_bin.rating
	for(var/obj/item/stock_parts/capacitor/capacitor in component_parts)
		newpowereff += 0.0166666666*capacitor.rating
		parts_rating += capacitor.rating
	for(var/obj/item/stock_parts/manipulator/manipulator in component_parts)
		parts_rating += manipulator.rating
	heater_coefficient = initial(heater_coefficient) * (bin_ratings / bin_count)
	powerefficiency = round(newpowereff, 0.01)

/obj/machinery/chem_dispenser/proc/replace_beaker(mob/living/user, obj/item/reagent_containers/new_beaker)
	if(!user)
		return FALSE
	if(beaker)
		try_put_in_hand(beaker, user)
		beaker = null
	if(new_beaker)
		beaker = new_beaker
	update_appearance()
	return TRUE

/obj/machinery/chem_dispenser/on_deconstruction()
	if(beaker)
		beaker.forceMove(drop_location())
		beaker = null
	for(var/cartridge_name in cartridges)
		var/obj/item/cartridge = cartridges[cartridge_name]
		cartridge.forceMove(drop_location())
		cartridges.Remove(cartridge_name)
	return ..()

/obj/machinery/chem_dispenser/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!can_interact(user) || !user.canUseTopic(src, !issilicon(user), FALSE))
		return
	replace_beaker(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/chem_dispenser/attack_robot_secondary(mob/user, list/modifiers)
	return attack_hand_secondary(user, modifiers)

/obj/machinery/chem_dispenser/attack_ai_secondary(mob/user, list/modifiers)
	return attack_hand_secondary(user, modifiers)

/obj/machinery/chem_dispenser/AltClick(mob/user)
	return ..() // This hotkey is BLACKLISTED since it's used by /datum/component/simple_rotation

/obj/machinery/chem_dispenser/proc/add_cartridge(obj/item/reagent_containers/chem_cartridge/cartidge, mob/user)
	if(!istype(cartidge))
		if(user)
			to_chat(user, span_warning("\The [cartidge] will not fit in \the [src]!"))
		return

	if(length(cartridges) >= maximum_cartridges)
		if(user)
			to_chat(user, span_warning("\The [src] does not have any free slots for \the [cartidge] to fit into!"))
		return

	if(!cartidge.label)
		if(user)
			to_chat(user, span_warning("\The [cartidge] does not have a label!"))
		return

	if(cartridges[cartidge.label])
		if(user)
			to_chat(user, span_warning("\The [src] already contains a cartridge with that label!"))
		return

	if(user)
		if(user.temporarilyRemoveItemFromInventory(cartidge))
			to_chat(user, span_notice("You add \the [cartidge] to \the [src]."))
		else
			return

	cartidge.forceMove(src)
	cartridges[cartidge.label] = cartidge
	cartridges = sortTim(cartridges, GLOBAL_PROC_REF(cmp_text_asc))

/obj/machinery/chem_dispenser/proc/remove_cartridge(label)
	. = cartridges[label]
	cartridges -= label

/obj/machinery/chem_dispenser/mini
	name = "mini chem dispenser"
	icon_state = "minidispenser"
	base_icon_state = "minidispenser"
	maximum_cartridges = 15
	circuit = /obj/item/circuitboard/machine/chem_dispenser/mini

/obj/machinery/chem_dispenser/big
	name = "big chem dispenser"
	icon_state = "bigdispenser"
	base_icon_state = "bigdispenser"
	maximum_cartridges = 35
	circuit = /obj/item/circuitboard/machine/chem_dispenser/big

/obj/machinery/chem_dispenser/abductor
	name = "reagent synthesizer"
	desc = "Synthesizes a variety of reagents using proto-matter."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "chem_dispenser"
	base_icon_state = "chem_dispenser"
	has_panel_overlay = FALSE
	circuit = /obj/item/circuitboard/machine/chem_dispenser/abductor
	working_state = null
	nopower_state = null
	use_power = NO_POWER_USE
