/turf
	///The turf's current zone parent.
	var/zone/zone
	///All directions in which a turf that can contain air is present.
	var/open_directions = NONE
	///Can atmos pass down through this turf?
	var/z_flags = NONE
	///Does this turf need to be ran through SSzas? (SSzas.mark_for_update(turf) OR turf.zas_update_loc())
	var/needs_air_update = 0
	///The local gas mixture of this turf. Use return_air(). This will always exist even if not in use, because GCing air contents would be too expensive.
	var/datum/gas_mixture/air
	///A gas_mixture gas list to be used as the initial value. Ex: list(GAS_OXYGEN = 50)
	var/list/initial_gas
	var/temperature = T20C
	var/heat_capacity = INFINITY

#ifdef ZASDBG
	///Set to TRUE during debugging to get chat output on the atmos status of this turf
	var/tmp/verbose = FALSE
#endif

///Updates the turf's air source properties, breaking or creating zone connections as necessary.
/turf/proc/update_air_properties()
	var/self_block
	ATMOS_CANPASS_TURF(self_block, src, src)
	if(self_block & AIR_BLOCKED)
		#ifdef ZASDBG
		src.dbg(zasdbgovl_blocked)
		#endif
		return TRUE

	///EXPERIMENTAL
	open_directions = NONE

	#ifdef MULTIZAS
	for(var/d = 1, d < 64, d *= 2)
	#else
	for(var/d = 1, d < 16, d *= 2)
	#endif

		var/turf/target = get_step(src, d)

		if(isnull(target) || !target.simulated)
			continue
		var/us_blocks_target
		ATMOS_CANPASS_TURF(us_blocks_target, src, target)

		if(us_blocks_target & AIR_BLOCKED)
			continue

		var/target_blocks_us
		ATMOS_CANPASS_TURF(target_blocks_us, target, src)
		if(target_blocks_us & AIR_BLOCKED)
			#ifdef ZASDBG
			//target.dbg(ZAS_DIRECTIONAL_BLOCKER(turn(d, 180)))
			#endif
			continue

		open_directions |= d

		if(TURF_HAS_VALID_ZONE(target))
			SSzas.connect(target, src)

// Helper for can_safely_remove_from_zone().
#define GET_ZONE_NEIGHBOURS(T, ret) \
	ret = 0; \
	if (T.zone) { \
		for (var/_gzn_dir in gzn_check) { \
			var/turf/other = get_step(T, _gzn_dir); \
			if (other && other.simulated && other.zone == T.zone) { \
				var/block; \
				ATMOS_CANPASS_TURF(block, other, T); \
				if (!(block & AIR_BLOCKED)) { \
					ret |= _gzn_dir; \
				} \
			} \
		} \
	}

/*
	Simple heuristic for determining if removing the turf from it's zone will not partition the zone (A very bad thing).
	Instead of analyzing the entire zone, we only check the nearest 3x3 turfs surrounding the src turf.
	This implementation may produce false negatives but it (hopefully) will not produce any false postiives.
*/
///Simple heuristic for determining if removing the turf from it's zone will not partition the zone (A very bad thing).
/turf/proc/can_safely_remove_from_zone()
	if(isnull(zone))
		return TRUE

	var/check_dirs
	GET_ZONE_NEIGHBOURS(src, check_dirs)

	. = check_dirs

	//src is only connected to the zone by a single direction, this is a safe removal.
	if (!(. & (. - 1))) //if(IsInteger(log(2, .)))
		return TRUE

	for(var/dir in csrfz_check)
		//for each pair of "adjacent" cardinals (e.g. NORTH and WEST, but not NORTH and SOUTH)
		if(((check_dirs & dir) == dir))
			//check that they are connected by the corner turf
			var/turf/T = get_step(src, dir)
			if (!T?.simulated)
				. &= ~dir
				continue

			var/connected_dirs
			GET_ZONE_NEIGHBOURS(T, connected_dirs)
			if(connected_dirs && (dir & reverse_dir[connected_dirs]) == dir)
				. &= ~dir //they are, so unflag the cardinals in question

	//it is safe to remove src from the zone if all cardinals are connected by corner turfs
	. = !.

/turf/open/update_air_properties()
	if(!simulated)
		return ..()

	if(zone?.invalid) //this turf's zone is in the process of being rebuilt
		take_zone_air_share() //not very efficient :(
		zone = null //Easier than iterating through the list at the zone.

	var/self_block
	ATMOS_CANPASS_TURF(self_block, src, src)
	if(self_block & AIR_BLOCKED)
		#ifdef ZASDBG
		if(verbose)
			zas_log("Self-blocked.")
		src.dbg(zasdbgovl_blocked)
		#endif
		if(zone)
			zone.remove_turf(src)
		return 1

	var/previously_open = open_directions
	open_directions = NONE

	var/list/postponed

	#ifdef MULTIZAS
	for(var/d = 1, d < 64, d *= 2)
	#else
	for(var/d = 1, d < 16, d *= 2)
	#endif
		var/turf/target = get_step(src, d)

		if(isnull(target)) //edge of map
			continue

		target.open_directions &= ~reverse_dir[d]

		///The air mobility of src >> target
		var/us_to_target
		ATMOS_CANPASS_TURF(us_to_target, target, src)
		if(us_to_target & AIR_BLOCKED)
			#ifdef ZASDBG
			if(verbose)
				zas_log("[dir2text(d)] is blocked.")
			//src.dbg(ZAS_DIRECTIONAL_BLOCKER(d))
			#endif
			continue

		///The air mobility of target >> src
		var/target_to_us
		ATMOS_CANPASS_TURF(target_to_us, src, target)
		if(target_to_us & AIR_BLOCKED)
			#ifdef ZASDBG
			if(verbose)
				zas_log("[dir2text(d)] is blocked.")
			//target.dbg(ZAS_DIRECTIONAL_BLOCKER(turn(d, 180)))
			#endif
			//Check that our zone hasn't been cut off recently.
			//This happens when windows move or are constructed. We need to rebuild.
			if((previously_open & d) && target.simulated)
				if(zone && target.zone == zone)
					zone.remove_turf(src)
			continue

		open_directions |= d
		target.open_directions |= reverse_dir[d]

		if(target.simulated)

			if(TURF_HAS_VALID_ZONE(target))
				//Might have assigned a zone, since this happens for each direction.
				if(isnull(zone))
					//We do not merge if
					//    they are blocking us and we are not blocking them, or if
					//    we are blocking them and not blocking ourselves - this prevents tiny zones from forming on doorways.
					if(((us_to_target & ZONE_BLOCKED) && !(target_to_us & ZONE_BLOCKED)) || ((target_to_us & ZONE_BLOCKED) && !(self_block & ZONE_BLOCKED)))
						#ifdef ZASDBG
						if(verbose)
							zas_log("[dir2text(d)] is zone blocked.")
						//dbg(ZAS_ZONE_BLOCKER(d))
						#endif

						//Postpone this tile rather than exit, since a connection can still be made.
						LAZYADD(postponed, target)

					else
						target.zone.add_turf(src)

						#ifdef ZASDBG
						dbg(zasdbgovl_assigned)
						if(verbose)
							zas_log("Added to [zone]")
						#endif

				else if(target.zone != zone)
					#ifdef ZASDBG
					if(verbose)
						zas_log("Connecting to [target.zone]")
					#endif

					SSzas.connect(src, target)

			#ifdef ZASDBG
				else if(verbose)
					zas_log("[dir2text(d)] has same zone.")

			else if(verbose)
				zas_log("[dir2text(d)] has an invalid or rebuilding zone.")
			#endif
		else
			//Postponing connections to tiles until a zone is assured.
			LAZYADD(postponed, target)

	if(!TURF_HAS_VALID_ZONE(src)) //Still no zone, make a new one.
		var/zone/newzone = new
		newzone.add_turf(src)

	#ifdef ZASDBG
		dbg(zasdbgovl_created)
		if(verbose)
			zas_log("New zone created for src.")

	ASSERT(zone)
	#endif

	//At this point, a zone should have happened. If it hasn't, don't add more checks, fix the bug.

	//Loop through all previous connection attempts and try again
	for(var/turf/T as anything in postponed)
		if(T.zone == src.zone) //Don't try to connect to yourself
			continue
		SSzas.connect(src, T)


/turf/proc/post_update_air_properties()
	if(connections)
		connections.update_all()

///Currently unused.
/atom/movable/proc/block_superconductivity()
	return

///Wrapper for [/datum/gas_mixture/proc/remove()]
/turf/remove_air(amount as num)
	var/datum/gas_mixture/GM = return_air()
	return GM.remove(amount)

///Merges a given gas mixture with the turf's current air source.
/turf/assume_air(datum/gas_mixture/giver)
	if(!simulated)
		return
	var/datum/gas_mixture/my_air = return_air()
	my_air.merge(giver)
	if(TURF_HAS_VALID_ZONE(src))
		SSzas.mark_zone_update(zone)

///Basically adjustGasWithTemp() but a turf proc.
/turf/proc/assume_gas(gasid, moles, temp = null)
	if(!simulated)
		return

	var/datum/gas_mixture/my_air = return_air()

	if(isnull(temp))
		my_air.adjustGas(gasid, moles)
	else
		my_air.adjustGasWithTemp(gasid, moles, temp)

	if(TURF_HAS_VALID_ZONE(src))
		SSzas.mark_zone_update(zone)

	return 1

///Return the currently used gas_mixture datum.
/turf/return_air()
	RETURN_TYPE(/datum/gas_mixture)
	if(!simulated)
		if(air)
			return air.copy()
		else
			make_air()
			return air.copy()

	else if(zone)
		if(!zone.invalid)
			SSzas.mark_zone_update(zone)
			return zone.air
		else
			take_zone_air_share()
			zone = null
			return air
	else
		if(isnull(air))
			make_air()
		return air

///Return the currently used gas_mixture datum. DOES NOT MARK ZONE FOR UPDATE.
/turf/unsafe_return_air()
	RETURN_TYPE(/datum/gas_mixture)
	if(!simulated)
		if(air)
			return air.copy()
		else
			make_air()
			return air.copy()

	else if(zone)
		if(!zone.invalid)
			return zone.air
		else
			take_zone_air_share()
			zone = null
			return air
	else
		if(isnull(air))
			make_air()
		return air

///Initializes the turf's "air" datum to it's initial values.
/turf/proc/make_air()
	if(simulated)
		air = new/datum/gas_mixture
		if(initial_gas)
			air.gas = initial_gas.Copy()
			air.temperature = temperature
		air.garbageCollect()

	else
		if(air)
			return air

		// Grab an existing mixture from the cache
		var/gas_key
		if(isnull(initial_gas))
			gas_key = "VACUUM_ATMOS"
		else
			var/list/initial_gas_copy = initial_gas.Copy()
			initial_gas_copy["temperature"] = temperature
			gas_key = json_encode(initial_gas)

		var/datum/gas_mixture/GM = SSzas.unsimulated_gas_cache[gas_key]
		if(GM)
			air = GM
			return

		// No cache? no problem. make one.
		GM = new
		air = GM
		if(!isnull(initial_gas))
			GM.gas = initial_gas.Copy()
			GM.temperature = temperature
		else
			GM.temperature = TCMB

		GM.garbageCollect()
		SSzas.unsimulated_gas_cache[gas_key] = air

///Copies this turf's group share from the zone. Usually used before removing it from the zone.
/turf/proc/take_zone_air_share()
	if(isnull(air))
		air = new/datum/gas_mixture
	air.copyFrom(zone.air)
	air.group_multiplier = 1

///Creates a gas_mixture datum with the given parameters and merges it into the turf's air source.
/turf/proc/atmos_spawn_air(gas_id, amount, initial_temperature = T20C)
	if(!simulated)
		return
	var/datum/gas_mixture/new_gas = new
	var/datum/gas_mixture/existing_gas = return_air()
	if(isnull(initial_temperature))
		new_gas.adjustGas(gas_id, amount)
	else
		new_gas.adjustGasWithTemp(gas_id, amount, initial_temperature)
	existing_gas.merge(new_gas)

/turf/open/space/atmos_spawn_air()
	return

///Checks a turf to see if any of it's contents are dense. Is NOT recursive. See also is_blocked_turf()
/turf/proc/contains_dense_objects()
	if(density)
		return src
	for(var/atom/movable/A as anything in src)
		if(A.density && !(A.flags_1 & ON_BORDER_1))
			return A
	return FALSE

///I literally don't know where this proc came from.
/turf/proc/TryGetNonDenseNeighbour()
	for(var/d in GLOB.cardinals)
		var/turf/T = get_step(src, d)
		if (T && !T.contains_dense_objects())
			return T

///Returns a list of adjacent turfs that can contain air. Returns null if none.
/turf/proc/get_atmos_adjacent_turfs()
	var/list/adjacent_turfs = list()
	for(var/direct in GLOB.cardinals)
		if(open_directions & direct)
			adjacent_turfs += get_step(src, direct)
	return length(adjacent_turfs) ? adjacent_turfs : null

/turf/open/space/get_atmos_adjacent_turfs()
	. = list()
	for(var/direct in GLOB.cardinals)
		var/turf/T = get_step(src, direct)
		var/canpass
		ATMOS_CANPASS_TURF(canpass, T, src)
		if(!(canpass & (AIR_BLOCKED)))
			. += T

/turf/open/return_analyzable_air()
	return unsafe_return_air()
