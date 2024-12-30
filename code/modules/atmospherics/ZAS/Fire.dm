/*

Making Bombs with ZAS:
Get gas to react in an air tank so that it gains pressure. If it gains enough pressure, it goes boom.
The more pressure, the more boom.
If it gains pressure too slowly, it may leak or just rupture instead of exploding.
*/

//#define FIREDBG

/turf
	var/obj/effect/hotspot/active_hotspot = null

/turf/proc/hotspot_expose(exposed_temperature, exposed_volume, soh = 0)
	return

/turf/open/hotspot_expose(exposed_temperature, exposed_volume, soh)
	if(!simulated)
		return 0
	if(fire_protection > world.time-300)
		return 0
	if(active_hotspot)
		return 1
	var/datum/gas_mixture/air_contents = unsafe_return_air()
	if(!air_contents || exposed_temperature < 4)
		return 0

	var/igniting = 0
	var/obj/effect/decal/cleanable/oil/liquid = locate() in src

	if(air_contents.check_combustability(liquid))
		igniting = 1

		create_fire(1)
	return igniting

///Creates a fire with firelevel (fl). If create_own_fuel is given, it will create that many units of welding fuel on the turf.
/turf/proc/create_fire(fl, create_own_fuel)
	return

/turf/open/create_fire(fl, create_own_fuel)
	if(!simulated)
		return

	if(active_hotspot)
		active_hotspot.firelevel = max(fl, active_hotspot.firelevel)
		return

	new /obj/effect/hotspot(src, fl)

	if(!active_hotspot) //Could not create a fire on this turf.
		return

	var/obj/effect/decal/cleanable/oil/fuel = locate() in src
	if(create_own_fuel)
		if(!fuel)
			fuel = new /obj/effect/decal/cleanable/oil(src)
			if(QDELETED(fuel))
				qdel(active_hotspot)
				return
			fuel.reagents.add_reagent(/datum/reagent/fuel/oil, create_own_fuel)
		else
			fuel.reagents.add_reagent(/datum/reagent/fuel/oil, create_own_fuel)

	return active_hotspot

/turf/open/space/create_fire()
	return

/obj/effect/hotspot
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	icon = 'modular_pariah/master_files/icons/effects/fire.dmi'
	icon_state = "1"
	layer = GASFIRE_LAYER
	blend_mode = BLEND_ADD
	light_system = OVERLAY_LIGHT
	light_outer_range = LIGHT_RANGE_FIRE
	light_power = 1
	light_color = LIGHT_COLOR_FIRE

	var/firelevel = 1 //Calculated by gas_mixture.calculate_firelevel()
	var/temperature = 0

/obj/effect/hotspot/Initialize(fl)
	. = ..()
	var/turf/open/T = loc
	if(!isopenturf(T))
		return INITIALIZE_HINT_QDEL

	if(T.active_hotspot)
		T.create_fire(fl) //Add the fire level to the existing fire and fuck off
		return INITIALIZE_HINT_QDEL

	T.active_hotspot = src
	SSzas.active_hotspots += src
	setDir(pick(GLOB.cardinals))

	var/datum/gas_mixture/turf_air = T.unsafe_return_air()
	react_with_air(turf_air, locate(/obj/effect/decal/cleanable/oil) in src)
	firelevel = max(fl, firelevel)

	temperature = turf_air.temperature
	color = FIRECOLOR(temperature)

	update_firelight()
	expose_loc(turf_air.returnPressure(), temperature, turf_air.volume)

	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_crossed),
		COMSIG_ATOM_ABSTRACT_ENTERED = PROC_REF(on_crossed),
	)

	AddElement(/datum/element/connect_loc, loc_connections)

/obj/effect/hotspot/Destroy()
	var/turf/T = loc
	if (isturf(T) && T.active_hotspot == src)
		T.active_hotspot = null

	SSzas.active_hotspots -= src
	SSzas.processing_hotspots -= src
	return ..()

/obj/effect/hotspot/process()
	if(QDELETED(src))
		return

	var/turf/my_tile = loc
	if(isspaceturf(my_tile))
		if(my_tile?.active_hotspot == src)
			my_tile.active_hotspot = null
		qdel(src)
		return

	var/obj/effect/decal/cleanable/oil/liquid_fuel = locate() in loc
	var/datum/gas_mixture/turf_air = return_air()

	if(!turf_air.check_recombustability(liquid_fuel))
		qdel(src)
		return

	if(!react_with_air(turf_air, liquid_fuel))
		qdel(src)
		return

	var/pressure = turf_air.returnPressure()
	temperature = turf_air.temperature
	var/volume = turf_air.volume

	expose_loc(pressure, temperature, volume)

	spread_to_adjacent(temperature, volume)

	var/maybe_new_color = FIRECOLOR(temperature)
	if(color != maybe_new_color)
		animate(src, color = maybe_new_color, 5)

	update_firelight()

/// Update the associated light variables based on firelevel
/obj/effect/hotspot/proc/update_firelight()
	switch(firelevel)
		if(2.5 to 6)
			if(light_power != 2)
				icon_state = "3"
				set_light_power(2)
				set_light_range(7)
		if(6.001 to INFINITY)
			if(light_power != 1.5)
				icon_state = "2"
				set_light_power(1.5)
				set_light_range(5)
		else
			if(light_power != 1)
				icon_state = "1"
				set_light_power(1)
				set_light_range(3)

/// Expose our turf and all atoms inside of it
/obj/effect/hotspot/proc/expose_loc(pressure, temperature, volume)
	loc.fire_act(temperature, volume)
	for(var/atom/movable/AM as anything in loc)
		AM.fire_act(temperature, volume)

/obj/effect/hotspot/proc/react_with_air(datum/gas_mixture/air, obj/effect/decal/cleanable/liquid_fuel)
	var/datum/gas_mixture/burn_gas = air.removeRatio(zas_settings.fire_consumption_rate, air.group_multiplier)

	firelevel = burn_gas.react(force_burn = 1, skip_recombust_check = 1, liquid_fuel = liquid_fuel)

	air.merge(burn_gas)
	return firelevel

/// Potentially spread fire, and attack nearby tiles with adjacent_fire_act()
/obj/effect/hotspot/proc/spread_to_adjacent(temp, volume)
	var/turf/open/my_tile = loc
	for(var/direction in GLOB.cardinals)
		var/turf/enemy_tile = get_step(my_tile, direction)
		if(!enemy_tile || isspaceturf(enemy_tile) || enemy_tile.active_hotspot)
			continue

		if(!(my_tile.open_directions & direction)) //Grab all valid bordering tiles
			enemy_tile.fire_act(temp, volume, my_tile)
			continue

		if(!prob(50 + 50 * (firelevel/zas_settings.fire_firelevel_multiplier)))
			continue

		var/datum/gas_mixture/acs = enemy_tile.unsafe_return_air()
		var/obj/effect/decal/cleanable/oil/liquid = locate() in enemy_tile
		if(!acs?.check_combustability(liquid))
			continue

		//If extinguisher mist passed over the turf it's trying to spread to, don't spread and
		//reduce firelevel.
		if(enemy_tile.fire_protection > world.time-30)
			firelevel -= 1.5
			continue

		//Spread the fire.
		enemy_tile.create_fire(firelevel)

/obj/effect/hotspot/proc/on_crossed(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER
	if(isliving(arrived) )
		var/mob/living/immolated = arrived
		immolated.fire_act(temperature, CELL_VOLUME)

//Returns the firelevel
/datum/gas_mixture/proc/react(force_burn, skip_recombust_check, obj/effect/decal/cleanable/liquid_fuel)
	. = 0
	if(!((temperature > PHORON_MINIMUM_BURN_TEMPERATURE || force_burn) && (skip_recombust_check || check_recombustability(liquid_fuel))))
		return

	#ifdef FIREDBG
	to_chat(world, "***************** REACT DEBUG *****************")
	#endif

	var/gas_fuel = 0
	var/total_fuel = 0
	var/total_oxidizers = 0
	var/liquid_fuel_amt = LIQUIDFUEL_AMOUNT_TO_MOL(liquid_fuel?.reagents.total_volume) || 0

	//*** Get the fuel and oxidizer amounts
	for(var/g in gas)
		if(xgm_gas_data.flags[g] & XGM_GAS_FUEL)
			gas_fuel += gas[g]
		if(xgm_gas_data.flags[g] & XGM_GAS_OXIDIZER)
			total_oxidizers += gas[g]

	total_fuel = gas_fuel + liquid_fuel_amt
	if(total_fuel <= 0.005)
		return 0

	//*** Determine how fast the fire burns

	//get the current thermal energy of the gas mix
	//this must be taken here to prevent the addition or deletion of energy by a changing heat capacity
	var/starting_energy = temperature * getHeatCapacity()

	//determine how far the reaction can progress
	var/reaction_limit = min(total_oxidizers*(FIRE_REACTION_FUEL_AMOUNT/FIRE_REACTION_OXIDIZER_AMOUNT), total_fuel) //stoichiometric limit

	//vapour fuels are extremely volatile! The reaction progress is a percentage of the total fuel (similar to old zburn).)
	var/gas_firelevel = calculate_firelevel(gas_fuel, total_oxidizers, reaction_limit, volume) / zas_settings.fire_firelevel_multiplier
	var/min_burn = 0.30*volume/CELL_VOLUME //in moles - so that fires with very small gas concentrations burn out fast
	var/gas_reaction_progress = min(max(min_burn, gas_firelevel*gas_fuel)*FIRE_GAS_BURNRATE_MULT, gas_fuel)

	//liquid fuels are not as volatile, and the reaction progress depends on the size of the area that is burning. Limit the burn rate to a certain amount per area.
	var/liquid_firelevel = calculate_firelevel(liquid_fuel_amt, total_oxidizers, reaction_limit, 0) / zas_settings.fire_firelevel_multiplier
	var/liquid_reaction_progress = min((liquid_firelevel*0.2 + 0.05)*FIRE_LIQUID_BURNRATE_MULT, liquid_fuel_amt)

	var/firelevel = (gas_fuel*gas_firelevel + liquid_fuel_amt*liquid_firelevel)/total_fuel

	var/total_reaction_progress = gas_reaction_progress + liquid_reaction_progress
	var/used_fuel = min(total_reaction_progress, reaction_limit)
	var/used_oxidizers = used_fuel * (FIRE_REACTION_OXIDIZER_AMOUNT/FIRE_REACTION_FUEL_AMOUNT)

	#ifdef FIREDBG
	to_chat(world, "gas_fuel = [gas_fuel], liquid_fuel_amt = [liquid_fuel_amt], total_oxidizers = [total_oxidizers]")
	to_chat(world, "firelevel -> [firelevel] (gas: [gas_firelevel], liquid: [liquid_firelevel])")
	to_chat(world, "liquid_reaction_progress = [liquid_reaction_progress]")
	to_chat(world, "gas_reaction_progress = [gas_reaction_progress]")
	to_chat(world, "total_reaction_progress = [total_reaction_progress]")
	to_chat(world, "used_fuel = [used_fuel], used_oxidizers = [used_oxidizers]; ")
	to_chat(world, "used_fuel = [used_fuel], used_oxidizers = [used_oxidizers]; ")
	#endif

	//if the reaction is progressing too slow then it isn't self-sustaining anymore and burns out
	if((!liquid_fuel_amt || used_fuel <= FIRE_LIQUID_MIN_BURNRATE) && (!gas_fuel || used_fuel <= FIRE_GAS_MIN_BURNRATE))
		return 0


	//*** Remove fuel and oxidizer, add carbon dioxide and heat

	//remove and add gasses as calculated
	var/used_gas_fuel = min(max(0.25, used_fuel*(gas_reaction_progress/total_reaction_progress)), gas_fuel) //remove in proportion to the relative reaction progress
	var/used_liquid_fuel = min(max(0.25, used_fuel-used_gas_fuel), liquid_fuel_amt)

	removeByFlag(XGM_GAS_OXIDIZER, used_oxidizers)
	var/datum/gas_mixture/burned_fuel = removeByFlag(XGM_GAS_FUEL, used_gas_fuel)
	for(var/g in burned_fuel.gas)
		adjustGas(xgm_gas_data.burn_product[g], burned_fuel.gas[g], FALSE)

	if(used_liquid_fuel)
		adjustGas(GAS_CO2, firelevel * 0.07, FALSE)

		var/fuel_to_remove = GASFUEL_AMOUNT_TO_LIQUID(used_liquid_fuel) //convert back to liquid volume units

		liquid_fuel.reagents.remove_all(fuel_to_remove)
		if(liquid_fuel.reagents.total_volume <= 0.1) //Precision loss kinda fucks with us here so
			qdel(liquid_fuel)

	//calculate the energy produced by the reaction and then set the new temperature of the mix
	temperature = (starting_energy + zas_settings.fire_fuel_energy_release * (used_gas_fuel + used_liquid_fuel)) / getHeatCapacity()
	garbageCollect()

	#ifdef FIREDBG
	to_chat(world, "used_gas_fuel = [used_gas_fuel]; used_liquid_fuel = [used_liquid_fuel]; total = [used_fuel]")
	to_chat(world, "new temperature = [temperature]; new pressure = [returnPressure()]")
	#endif

	if (temperature<220)
		firelevel = 0

	SEND_SIGNAL(src, COMSIG_GASMIX_REACTED)

	return firelevel

/datum/gas_mixture/proc/check_recombustability(has_liquid_fuel)
	. = 0
	for(var/g in gas)
		if(xgm_gas_data.flags[g] & XGM_GAS_OXIDIZER && gas[g] >= 0.1)
			. = 1
			break

	if(!.)
		return 0

	if(has_liquid_fuel)
		return 1

	. = 0
	for(var/g in gas)
		if(xgm_gas_data.flags[g] & XGM_GAS_FUEL && gas[g] >= 0.1)
			. = 1
			break

/datum/gas_mixture/proc/check_combustability(obj/effect/decal/cleanable/oil/liquid)
	. = 0
	for(var/g in gas)
		if(xgm_gas_data.flags[g] & XGM_GAS_OXIDIZER && QUANTIZE(gas[g] * zas_settings.fire_consumption_rate) >= 0.1)
			. = 1
			break

	if(!.)
		return 0

	if(liquid)
		return 1

	. = 0
	for(var/g in gas)
		if(xgm_gas_data.flags[g] & XGM_GAS_FUEL && QUANTIZE(gas[g] * zas_settings.fire_consumption_rate) >= 0.1)
			. = 1
			break

//returns a value between 0 and zas_settings.fire_firelevel_multiplier
/datum/gas_mixture/proc/calculate_firelevel(total_fuel, total_oxidizers, reaction_limit, gas_volume)
	//Calculates the firelevel based on one equation instead of having to do this multiple times in different areas.
	var/firelevel = 0

	var/total_combustables = (total_fuel + total_oxidizers)
	var/active_combustables = (FIRE_REACTION_OXIDIZER_AMOUNT/FIRE_REACTION_FUEL_AMOUNT + 1)*reaction_limit

	if(total_moles && total_combustables > 0)
		//slows down the burning when the concentration of the reactants is low
		var/damping_multiplier = min(1, active_combustables / total_moles)

		//weight the damping mult so that it only really brings down the firelevel when the ratio is closer to 0
		damping_multiplier = 2*damping_multiplier - (damping_multiplier*damping_multiplier)

		//calculates how close the mixture of the reactants is to the optimum
		//fires burn better when there is more oxidizer -- too much fuel will choke the fire out a bit, reducing firelevel.
		var/mix_multiplier = 1 / (1 + (5 * ((total_fuel / total_combustables) ** 2)))

		#ifdef FIREDBG
		ASSERT(damping_multiplier <= 1)
		ASSERT(mix_multiplier <= 1)
		#endif

		//toss everything together -- should produce a value between 0 and fire_firelevel_multiplier
		firelevel = zas_settings.fire_firelevel_multiplier * mix_multiplier * damping_multiplier

	return max( 0, firelevel)

/turf/proc/burn()
	burn_tile()
	var/chance_of_deletion
	if (heat_capacity) //beware of division by zero
		chance_of_deletion = max_fire_temperature_sustained / heat_capacity * 8 //there is no problem with prob(23456), min() was redundant --rastaf0
	else
		chance_of_deletion = 100
	if(prob(chance_of_deletion))
		Melt()
		max_fire_temperature_sustained = 0
	else
		to_be_destroyed = FALSE


/turf/var/fire_protection = 0
/turf/proc/apply_fire_protection()
	fire_protection = world.time

/turf/open/space/apply_fire_protection()
	return

/turf/fire_act(exposed_temperature, exposed_volume, turf/adjacent)
	return

/turf/open/floor/fire_act(exposed_temperature, exposed_volume, turf/adjacent)
	if(!adjacent)
		return

	var/dir_to = get_dir(src, adjacent)

	for(var/obj/structure/window/W in src)
		if(W.dir == dir_to || W.fulltile) //Same direction or diagonal (full tile)
			W.fire_act(exposed_temperature, exposed_volume, adjacent)

	for(var/obj/machinery/door/window/door in src)
		if(door.dir == dir_to) //Same direction or diagonal (full tile)
			door.fire_act(exposed_temperature, exposed_volume, adjacent)

/turf/closed/wall/fire_act(exposed_temperature, exposed_volume, turf/adjacent)
	if(!uses_integrity)
		burn(exposed_temperature)
	else if (exposed_temperature > heat_capacity)
		take_damage(log(Frand(0.9, 1.1) * (exposed_temperature - heat_capacity)), BURN)
	return ..()

/obj/effect/dummy/lighting_obj/moblight/fire
	name = "fire"
	light_color = LIGHT_COLOR_FIRE
	light_outer_range = LIGHT_RANGE_FIRE
