/datum/gas_mixture
	//Associative list of gas moles.
	//Gases with 0 moles are not tracked and are pruned by updateValues()
	var/list/gas
	//Temperature in Kelvin of this gas mix.
	var/temperature = 0

	//Sum of all the gas moles in this mix.  Updated by updateValues()
	var/total_moles = 0
	//Volume of this mix.
	var/volume = CELL_VOLUME
	//Size of the group this gas_mixture is representing. 1 for singular turfs.
	var/group_multiplier = 1

	//Lazy list of active tile overlays for this gas_mixture.  Updated by checkTileGraphic()
	var/list/graphic
	//Cache of gas overlay objects
	var/list/tile_overlay_cache

/datum/gas_mixture/New(_volume = CELL_VOLUME, _temperature = 0, _group_multiplier = 1)
	gas = list()
	volume = _volume
	temperature = _temperature
	group_multiplier = _group_multiplier

///Returns the volume of a specific gas within the entire zone.
/datum/gas_mixture/proc/getGroupGas(gasid)
	if(!length(gas))
		return 0 //if the list is empty BYOND treats it as a non-associative list, which runtimes
	return gas[gasid] * group_multiplier

///Returns the volume of the entire zone's gas contents.
/datum/gas_mixture/proc/getGroupMoles()
	return total_moles * group_multiplier

///Takes a gas string and the amount of moles to adjust by. Calls updateValues() if update isn't 0.
/datum/gas_mixture/proc/adjustGas(gasid, moles, update = TRUE)
	if(moles == 0)
		return

	if (group_multiplier != 1)
		gas[gasid] += QUANTIZE(moles/group_multiplier)
	else
		gas[gasid] += moles

	if(update)
		garbageCollect()

///Sets the given gas id's mole count to the specified amount.
/datum/gas_mixture/proc/setGasMoles(gasid, moles, update = TRUE, divide_among_group = FALSE)
	//Generally setGasMoles actions pre-calculate, just in case.
	if(divide_among_group && group_multiplier != 1 && moles != 0)
		gas[gasid] = moles/group_multiplier
	else
		gas[gasid] = moles

	if(update)
		garbageCollect()

///Same as adjustGas(), but takes a temperature which is mixed in with the gas.
/datum/gas_mixture/proc/adjustGasWithTemp(gasid, moles, temp, update = 1)
	if(moles == 0)
		return

	if(moles > 0 && abs(temperature - temp) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/self_heat_capacity = getHeatCapacity()
		var/giver_heat_capacity = xgm_gas_data.specific_heat[gasid] * moles
		var/combined_heat_capacity = giver_heat_capacity + self_heat_capacity
		if(combined_heat_capacity != 0)
			temperature = (temp * giver_heat_capacity + temperature * self_heat_capacity) / combined_heat_capacity

	if (group_multiplier != 1)
		gas[gasid] += moles/group_multiplier
	else
		gas[gasid] += moles

	if(update)
		garbageCollect()


///Variadic version of adjustGas().  Takes any number of gas and mole pairs and applies them.
/datum/gas_mixture/proc/adjustMultipleGases()
	ASSERT(!(args.len % 2))

	for(var/i in 1 to args.len-1 step 2)
		adjustGas(args[i], args[i+1], update = 0)

	garbageCollect()


///Variadic version of adjustGasWithTemp().  Takes any number of gas, mole and temperature associations and applies them.
/datum/gas_mixture/proc/adjustMultipleGasesWithTemp()
	ASSERT(!(args.len % 3))

	for(var/i in 1 to args.len-1 step 3)
		adjustGasWithTemp(args[i], args[i + 1], args[i + 2], update = 0)

	garbageCollect()


///Merges all the gas from another mixture into this one.  Respects group_multipliers and adjusts temperature correctly. Does not modify giver in any way.
/datum/gas_mixture/proc/merge(const/datum/gas_mixture/giver)
	if(!giver)
		return

	if(abs(temperature-giver.temperature)>MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/self_heat_capacity = getHeatCapacity()
		var/giver_heat_capacity = giver.getHeatCapacity()
		var/combined_heat_capacity = giver_heat_capacity + self_heat_capacity
		if(combined_heat_capacity != 0)
			temperature = (giver.temperature*giver_heat_capacity + temperature*self_heat_capacity)/combined_heat_capacity

	if((group_multiplier != 1)||(giver.group_multiplier != 1))
		for(var/g in giver.gas)
			gas[g] += giver.gas[g] * giver.group_multiplier / group_multiplier
	else
		for(var/g in giver.gas)
			gas[g] += giver.gas[g]

	garbageCollect()
	SEND_SIGNAL(src, COMSIG_GASMIX_MERGED)

///Used to equalize the mixture between two zones before sleeping an edge.
/datum/gas_mixture/proc/equalize(datum/gas_mixture/sharer)
	var/our_heatcap = getHeatCapacity()
	var/share_heatcap = sharer.getHeatCapacity()

	for(var/g in gas|sharer.gas)
		var/comb = gas[g] + sharer.gas[g]
		comb /= volume + sharer.volume
		gas[g] = comb * volume
		sharer.gas[g] = comb * sharer.volume

	if(our_heatcap + share_heatcap)
		temperature = ((temperature * our_heatcap) + (sharer.temperature * share_heatcap)) / (our_heatcap + share_heatcap)
	sharer.temperature = temperature

	garbageCollect()
	sharer.garbageCollect()

	return 1

#ifndef ZAS_COMPAT_515
///Returns the heat capacity of the gas mix based on the specific heat of the gases.
/datum/gas_mixture/proc/getHeatCapacity()
	return values_dot(xgm_gas_data.specific_heat, gas) * group_multiplier
#else
///Returns the heat capacity of the gas mix based on the specific heat of the gases.
/datum/gas_mixture/proc/getHeatCapacity()
	. = 0
	for(var/g in gas)
		. += xgm_gas_data.specific_heat[g] * gas[g]
	. *= group_multiplier
#endif

///Adds or removes thermal energy. Returns the actual thermal energy change, as in the case of removing energy we can't go below TCMB.
/datum/gas_mixture/proc/adjustThermalEnergy(thermal_energy)

	if (total_moles == 0)
		return 0

	var/heat_capacity = getHeatCapacity()
	if (thermal_energy < 0)
		if (temperature < TCMB)
			return 0
		var/thermal_energy_limit = -(temperature - TCMB)*heat_capacity	//ensure temperature does not go below TCMB
		thermal_energy = max( thermal_energy, thermal_energy_limit )	//thermal_energy and thermal_energy_limit are negative here.
	temperature += thermal_energy/heat_capacity
	return thermal_energy

///Returns the thermal energy change required to get to a new temperature
/datum/gas_mixture/proc/getThermalEnergyChange(new_temperature)
	return getHeatCapacity()*(max(new_temperature, 0) - temperature)


///Technically vacuum doesn't have a specific entropy. Just use a really big number (infinity would be ideal) here so that it's easy to add gas to vacuum and hard to take gas out.
#define SPECIFIC_ENTROPY_VACUUM		150000


///Returns the ideal gas specific entropy of the whole mix. This is the entropy per mole of /mixed/ gas.
/datum/gas_mixture/proc/specificGroupEntropy()
	if (!length(gas) || total_moles == 0)
		return SPECIFIC_ENTROPY_VACUUM

	. = 0
	for(var/g in gas)
		. += gas[g] * specificEntropyGas(g)
	. /= total_moles


/*
	It's arguable whether this should even be called entropy anymore. It's more "based on" entropy than actually entropy now.

	Returns the ideal gas specific entropy of a specific gas in the mix. This is the entropy due to that gas per mole of /that/ gas in the mixture, not the entropy due to that gas per mole of gas mixture.

	For the purposes of SS13, the specific entropy is just a number that tells you how hard it is to move gas. You can replace this with whatever you want.
	Just remember that returning a SMALL number == adding gas to this gas mix is HARD, taking gas away is EASY, and that returning a LARGE number means the opposite (so a vacuum should approach infinity).

	So returning a constant/(partial pressure) would probably do what most players expect. Although the version I have implemented below is a bit more nuanced than simply 1/P in that it scales in a way
	which is bit more realistic (natural log), and returns a fairly accurate entropy around room temperatures and pressures.
*/
/datum/gas_mixture/proc/specificEntropyGas(gasid)
	if (!gas[gasid])
		return SPECIFIC_ENTROPY_VACUUM	//that gas isn't here

	//group_multiplier gets divided out in volume/gas[gasid] - also, V/(m*T) = R/(partial pressure)
	var/molar_mass = xgm_gas_data.molar_mass[gasid]
	var/specific_heat = xgm_gas_data.specific_heat[gasid]
	var/safe_temp = max(temperature, TCMB) // We're about to divide by this.
	return R_IDEAL_GAS_EQUATION * ( log( (IDEAL_GAS_ENTROPY_CONSTANT*volume/(gas[gasid] * safe_temp)) * (molar_mass*specific_heat*safe_temp)**(2/3) + 1 ) +  15 )

#ifndef ZAS_COMPAT_515
///Updates the total_moles count and trims any empty gases.
/datum/gas_mixture/proc/garbageCollect()
	values_cut_under(gas, ATMOS_PRECISION)
	total_moles = values_sum(gas)
#else
///Updates the total_moles count and trims any empty gases.
/datum/gas_mixture/proc/garbageCollect()
	AIR_UPDATE_VALUES(src)
#endif

///Returns the pressure of the gas mix.  Only accurate if there have been no gas modifications since updateValues() has been called.
/datum/gas_mixture/proc/returnPressure()
	if(volume)
		return total_moles * R_IDEAL_GAS_EQUATION * temperature / volume
	return 0


///Removes moles from the gas mixture and returns a gas_mixture containing the removed air.
/datum/gas_mixture/proc/remove(amount)
	RETURN_TYPE(/datum/gas_mixture)

	amount = min(amount, total_moles * group_multiplier) //Can not take more air than the gas mixture has!
	if(amount <= 0)
		return null

	var/datum/gas_mixture/removed = new

	for(var/g in gas)
		removed.gas[g] = QUANTIZE((gas[g] / total_moles) * amount)
		gas[g] -= QUANTIZE(removed.gas[g] / group_multiplier)

	removed.temperature = temperature
	garbageCollect()
	removed.garbageCollect()

	return removed


///Removes a ratio of gas from the mixture and returns a gas_mixture containing the removed air.
/datum/gas_mixture/proc/removeRatio(ratio, out_group_multiplier = 1)
	if(ratio <= 0)
		return null
	out_group_multiplier = clamp(out_group_multiplier, 1, group_multiplier)

	ratio = min(ratio, 1)

	var/datum/gas_mixture/removed = new
	removed.group_multiplier = out_group_multiplier

	for(var/g in gas)
		removed.gas[g] = QUANTIZE((gas[g] * ratio * group_multiplier / out_group_multiplier))
		gas[g] = QUANTIZE(gas[g] * (1 - ratio))

	removed.temperature = temperature
	removed.volume = volume * group_multiplier / out_group_multiplier
	garbageCollect()
	removed.garbageCollect()

	return removed

///Removes a volume of gas from the mixture and returns a gas_mixture containing the removed air with the given volume.
/datum/gas_mixture/proc/removeVolume(removed_volume)
	var/datum/gas_mixture/removed = removeRatio(removed_volume/(volume*group_multiplier), 1)
	removed.volume = removed_volume
	return removed

///Removes moles from the gas mixture, limited by a given flag.  Returns a gax_mixture containing the removed air.
/datum/gas_mixture/proc/removeByFlag(flag, amount)
	var/datum/gas_mixture/removed = new

	if(!flag || amount <= 0)
		return removed

	var/sum = 0
	for(var/g in gas)
		if(xgm_gas_data.flags[g] & flag)
			sum += gas[g]

	for(var/g in gas)
		if(xgm_gas_data.flags[g] & flag)
			removed.gas[g] = QUANTIZE((gas[g] / sum) * amount)
			gas[g] = QUANTIZE(gas[g] - (removed.gas[g] / group_multiplier))

	removed.temperature = temperature
	garbageCollect()
	removed.garbageCollect()

	return removed

///Returns the amount of gas that has the given flag, in moles..
/datum/gas_mixture/proc/getByFlag(flag)
	. = 0
	for(var/g in gas)
		if(xgm_gas_data.flags[g] & flag)
			. += gas[g]

///Copies gas and temperature from another gas_mixture.
/datum/gas_mixture/proc/copyFrom(const/datum/gas_mixture/sample, ratio = 1)
	gas = sample.gas.Copy()
	temperature = sample.temperature
	if(ratio != 1)
		var/list/cached_gas = gas
		for(var/id in cached_gas)
			cached_gas[id] = QUANTIZE(cached_gas[id] * ratio)
		garbageCollect()
	else
		total_moles = sample.total_moles
	return 1


///Checks if we are within acceptable range of another gas_mixture to suspend processing or merge.
/datum/gas_mixture/proc/compare(const/datum/gas_mixture/sample, check_vacuum = TRUE)
	if(!sample)
		return FALSE

	///If check_vacuum is TRUE, if one of the mixtures is a vacuum, return FALSE until both are or neither are.
	if(check_vacuum)
		// Special case - If one of the two is zero pressure, the other must also be zero.
		// This prevents suspending processing when an air-filled room is next to a vacuum,
		// an edge case which is particually obviously wrong to players
		if(!!total_moles != !!sample.total_moles)
			return FALSE

	if(abs(returnPressure() - sample.returnPressure()) > MINIMUM_PRESSURE_DIFFERENCE_TO_SUSPEND)
		return FALSE

	var/list/cached_gas = gas
	var/list/sample_cached_gas = sample.gas
	var/list/marked = list()
	for(var/g in cached_gas)
		if((abs(cached_gas[g] - sample.gas[g]) > MINIMUM_AIR_TO_SUSPEND) && \
		((cached_gas[g] < (1 - MINIMUM_AIR_RATIO_TO_SUSPEND) * sample_cached_gas[g]) || \
		(cached_gas[g] > (1 + MINIMUM_AIR_RATIO_TO_SUSPEND) * sample_cached_gas[g])))
			return FALSE
		marked[g] = 1

	for(var/g in sample_cached_gas)
		if(!marked[g])
			if((abs(cached_gas[g] - sample_cached_gas[g]) > MINIMUM_AIR_TO_SUSPEND) && \
			((cached_gas[g] < (1 - MINIMUM_AIR_RATIO_TO_SUSPEND) * sample_cached_gas[g]) || \
			(cached_gas[g] > (1 + MINIMUM_AIR_RATIO_TO_SUSPEND) * sample_cached_gas[g])))
				return FALSE

	if(total_moles > MINIMUM_AIR_TO_SUSPEND)
		if((abs(temperature - sample.temperature) > MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND) && \
		((temperature < (1 - MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND)*sample.temperature) || \
		(temperature > (1 + MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND)*sample.temperature)))
			return FALSE

	return TRUE

///Rechecks the gas_mixture and adjusts the graphic list if needed. ///Two lists can be passed by reference if you need know specifically which graphics were added and removed.
/datum/gas_mixture/proc/checkTileGraphic(list/graphic_add, list/graphic_remove)
	if(LAZYLEN(graphic))
		for(var/obj/effect/gas_overlay/O as anything in graphic)
			if(O.type == /obj/effect/gas_overlay/heat)
				continue
			if(gas[O.gas_id] <= xgm_gas_data.overlay_limit[O.gas_id])
				LAZYADD(graphic_remove, O)

	var/overlay_limit
	for(var/g in gas)
		overlay_limit = xgm_gas_data.overlay_limit[g]
		//Overlay isn't applied for this gas, check if it's valid and needs to be added.
		if(!isnull(overlay_limit) && gas[g] > overlay_limit)
			///Inlined getTileOverlay(g)
			var/tile_overlay = LAZYACCESS(tile_overlay_cache, g)

			if(isnull(tile_overlay))
				LAZYSET(tile_overlay_cache, g, new/obj/effect/gas_overlay(null, g))
				tile_overlay = tile_overlay_cache[g]

			///End inline
			if(!(tile_overlay in graphic))
				LAZYADD(graphic_add, tile_overlay)

	. = 0

	var/tile_overlay = LAZYACCESS(tile_overlay_cache, "heat")
	//If it's hot add something
	if(temperature >= BODYTEMP_HEAT_DAMAGE_LIMIT)
		if(isnull(tile_overlay))
			LAZYSET(tile_overlay_cache, "heat", new/obj/effect/gas_overlay/heat(null, "heat"))
			tile_overlay = tile_overlay_cache["heat"]
		if(!(tile_overlay in graphic))
			LAZYADD(graphic_add, tile_overlay)

	else if(LAZYLEN(graphic) && (tile_overlay in graphic))
		LAZYADD(graphic_remove, tile_overlay)

	//Apply changes
	if(length(graphic_add))
		LAZYDISTINCTADD(graphic, graphic_add)
		. = 1
	if(length(graphic_remove))
		LAZYREMOVE(graphic, graphic_remove)
		. = 1

	if(LAZYLEN(graphic))
		var/pressure_mod = clamp(returnPressure() / ONE_ATMOSPHERE, 0, 2)
		for(var/obj/effect/gas_overlay/O as anything in graphic)
			if(istype(O, /obj/effect/gas_overlay/heat)) //Heat based
				var/new_alpha = clamp(max(125, 255 * ((temperature - BODYTEMP_HEAT_DAMAGE_LIMIT) / BODYTEMP_HEAT_DAMAGE_LIMIT * 4)), 125, 255)
				if(new_alpha != O.alpha)
					O.update_alpha_animation(new_alpha)
				continue

			var/concentration_mod = clamp(gas[O.gas_id] / total_moles, 0.1, 1)
			var/new_alpha = min(240, round(pressure_mod * concentration_mod * 180, 5))
			if(new_alpha != O.alpha)
				O.update_alpha_animation(new_alpha)

/datum/gas_mixture/proc/getTileOverlay(gas_id)
	if(!LAZYACCESS(tile_overlay_cache, gas_id))
		LAZYSET(tile_overlay_cache, gas_id, new/obj/effect/gas_overlay(null, gas_id))
	return tile_overlay_cache[gas_id]

///Simpler version of merge(), adjusts gas amounts directly and doesn't account for temperature or group_multiplier.
/datum/gas_mixture/proc/add(datum/gas_mixture/right_side)
	for(var/g in right_side.gas)
		gas[g] += right_side.gas[g]

	garbageCollect()
	return 1


///Simpler version of remove(), adjusts gas amounts directly and doesn't account for group_multiplier.
/datum/gas_mixture/proc/subtract(datum/gas_mixture/right_side)
	for(var/g in right_side.gas)
		gas[g] -= right_side.gas[g]

	garbageCollect()
	return 1


///Multiply all gas amounts by a factor.
/datum/gas_mixture/proc/multiply(factor)
	for(var/g in gas)
		gas[g] = QUANTIZE(gas[g] * factor)
	garbageCollect()
	return 1


///Divide all gas amounts by a factor.
/datum/gas_mixture/proc/divide(factor)
	for(var/g in gas)
		gas[g] = QUANTIZE(gas[g] / factor)

	garbageCollect()
	return 1


///Shares gas with another gas_mixture based on the amount of connecting tiles and a fixed lookup table.
/datum/gas_mixture/proc/shareRatio(datum/gas_mixture/other, connecting_tiles, share_size = null, one_way = 0)
	var/static/list/sharing_lookup_table = list(0.30, 0.40, 0.48, 0.54, 0.60, 0.66)
	//Shares a specific ratio of gas between mixtures using simple weighted averages.
	var/ratio = sharing_lookup_table[6]

	var/size = max(1, group_multiplier)
	if(isnull(share_size))
		share_size = max(1, other.group_multiplier)

	var/full_heat_capacity = getHeatCapacity()
	var/s_full_heat_capacity = other.getHeatCapacity()

	var/list/avg_gas = list()

	for(var/g in gas)
		avg_gas[g] += gas[g] * size

	for(var/g in other.gas)
		avg_gas[g] += other.gas[g] * share_size

	for(var/g in avg_gas)
		avg_gas[g] /= size + share_size

	var/temp_avg = 0
	if(full_heat_capacity + s_full_heat_capacity)
		temp_avg = (temperature * full_heat_capacity + other.temperature * s_full_heat_capacity) / (full_heat_capacity + s_full_heat_capacity)

	//WOOT WOOT TOUCH THIS AND YOU ARE A RETARD.
	if(length(sharing_lookup_table) >= connecting_tiles) //6 or more interconnecting tiles will max at 42% of air moved per tick.
		ratio = sharing_lookup_table[connecting_tiles]
	//WOOT WOOT TOUCH THIS AND YOU ARE A RETARD

	for(var/g in avg_gas)
		gas[g] = QUANTIZE(max(0, (gas[g] - avg_gas[g]) * (1 - ratio) + avg_gas[g]))
		if(!one_way)
			other.gas[g] = QUANTIZE(max(0, (other.gas[g] - avg_gas[g]) * (1 - ratio) + avg_gas[g]))

	temperature = max(0, (temperature - temp_avg) * (1-ratio) + temp_avg)
	if(!one_way)
		other.temperature = max(0, (other.temperature - temp_avg) * (1-ratio) + temp_avg)

	garbageCollect()
	other.garbageCollect()

	return compare(other, FALSE)


///A wrapper around share_ratio for spacing gas at the same rate as if it were going into a large airless room.
/datum/gas_mixture/proc/shareSpace(datum/gas_mixture/unsim_air)
	return shareRatio(unsim_air, unsim_air.group_multiplier, max(1, max(group_multiplier + 3, 1) + unsim_air.group_multiplier), one_way = 1)

/datum/gas_mixture/proc/getMass()
	for(var/g in gas)
		. += gas[g] * xgm_gas_data.molar_mass[g] * group_multiplier

/datum/gas_mixture/proc/specificGroupMass()
	var/M = getGroupMoles()
	if(M)
		return getMass()/M

///Compares the contents of two mixtures to see if they are identical.
/datum/gas_mixture/proc/isEqual(datum/gas_mixture/other)
	if(src.total_moles != other.total_moles)
		return FALSE

	if(src.temperature != other.temperature)
		return FALSE

	if(length(src.gas) != length(other.gas))
		return FALSE

	for(var/g in src.gas)
		if(src.gas[g] != other.gas[g])
			return FALSE

	for(var/g in other.gas)
		if(other.gas[g] != src.gas[g])
			return FALSE

	return TRUE

///Returns TRUE if the given gas has a volume equal to or greater than the given amount in one group share of gas.
/datum/gas_mixture/proc/hasGas(gas_id, required_amount)
	var/amt = gas[gas_id]
	return (amt >= required_amount)

////LINDA COMPATABILITY PROCS////
/datum/gas_mixture/proc/get_volume()
	return max(0, volume)

/datum/gas_mixture/proc/returnVisuals()
	garbageCollect()
	checkTileGraphic()
	return graphic

///Returns a gas_mixture datum with identical contents.
/datum/gas_mixture/proc/copy()
	RETURN_TYPE(/datum/gas_mixture)

	var/datum/gas_mixture/new_gas = new(volume)
	new_gas.gas = src.gas.Copy()
	new_gas.temperature = src.temperature
	new_gas.total_moles = src.total_moles
	return new_gas

/turf/open/proc/copy_air_with_tile(turf/open/target_turf)
	if(!istype(target_turf))
		return
	if(TURF_HAS_VALID_ZONE(src))
		zone.remove_turf(src)

	if(isnull(target_turf.air))
		target_turf.make_air()

	if(simulated)
		if(isnull(air))
			make_air()
		air.copyFrom(target_turf.unsafe_return_air())
	else
		initial_gas = target_turf.initial_gas
		make_air()
	SSzas.mark_for_update(src)

/datum/gas_mixture/proc/leak_to_enviroment(datum/gas_mixture/environment)
	pump_gas_passive(src, environment, calculate_transfer_moles(src, environment, src.returnPressure() - environment.returnPressure()))

/**
 * Takes the amount of the gas you want to PP as an argument
 * So I don't have to do some hacky switches/defines/magic strings
 * eg:
 * Plas_PP = get_partial_pressure(gas_mixture.plasma)
 * O2_PP = get_partial_pressure(gas_mixture.oxygen)
 * getBreathPartialPressure(gas_pp) --> gas_pp/get_moles()*breath_pp = pp
 * getTrueBreathPressure(pp) --> gas_pp = pp/breath_pp*get_moles()
 *
 * 10/20*5 = 2.5
 * 10 = 2.5/5*20
 */

/datum/gas_mixture/proc/getBreathPartialPressure(gas_pressure)
	return (gas_pressure * R_IDEAL_GAS_EQUATION * temperature) / BREATH_VOLUME
///inverse
/datum/gas_mixture/proc/getTrueBreathPressure(partial_pressure)
	return (partial_pressure * BREATH_VOLUME) / (R_IDEAL_GAS_EQUATION * temperature)
