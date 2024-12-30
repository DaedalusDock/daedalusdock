/*

Overview:
	Each zone is a self-contained area where gas values would be the same if tile-based equalization were run indefinitely.
	If you're unfamiliar with ZAS, FEA's air groups would have similar functionality if they didn't break in a stiff breeze.

Class Vars:
	name - A name of the format "Zone [#]", used for debugging.
	invalid - True if the zone has been erased and is no longer eligible for processing.
	needs_update - True if the zone has been added to the update list.
	edges - A list of edges that connect to this zone.
	air - The gas mixture that any turfs in this zone will return. Values are per-tile with a group multiplier.

Class Procs:
	add_turf(turf/T)
		Adds a turf to the contents, sets its zone and merges its air.

	remove_turf(turf/T)
		Removes a turf, sets its zone to null and erases any gas graphics.
		Invalidates the zone if it has no more tiles.

	merge_into(zone/into)
		Invalidates this zone and adds all its former contents to into.

	invalidate()
		Marks this zone as invalid and removes it from processing.

	rebuild()
		Invalidates the zone and marks all its former tiles for updates.

	add_tile_air(turf/simulated/T)
		Adds the air contained in T.air to the zone's air supply. Called when adding a turf.

	tick()
		Called only when the gas content is changed. Archives values and changes gas graphics.

	dbg_data(mob/M)
		Sends M a printout of important figures for the zone.

*/


/zone
	///A simple numerical value
	var/name
	///If a zone is "invalid" it will not process
	var/invalid = 0
	var/list/contents = list()
	///Does SSzas need to update this zone? (SSzas.mark_zone_update(zone))
	var/needs_update = 0
	///An associative list of edge_source = edge. Will contain instantiated turfs and zones.
	var/list/edges = list()
	///Lazylist of atmos sensitive contents
	var/atmos_sensitive_contents
	///The zone's gas contents
	var/datum/gas_mixture/air = new
	///The air temperature of the last tick()
	var/last_air_temperature = null
	///The air list of last tick()
	VAR_PRIVATE/last_gas_list
	/// An incrementing counter that keeps track of which air graphic cycle any sleeping procs may be in.
	VAR_PRIVATE/processing_graphic_cycle = 0

/zone/New()
	SSzas.add_zone(src)
	air.temperature = TCMB
	air.group_multiplier = 1
	air.volume = CELL_VOLUME

///Adds the given turf to the zone
/zone/proc/add_turf(turf/T)
#ifdef ZASDBG
	ASSERT(!invalid)
	ASSERT(istype(T))
	ASSERT(!TURF_HAS_VALID_ZONE(T))

	T.maptext = name
#endif

	var/datum/gas_mixture/turf_air = T.return_air()
	add_tile_air(turf_air)
	T.zone = src
	contents.Add(T)

	if(air.graphic)
		T.add_viscontents(air.graphic)

	if(T.atmos_sensitive_contents)
		if(isnull(atmos_sensitive_contents))
			SSzas.zones_with_sensitive_contents += src
		LAZYDISTINCTADD(atmos_sensitive_contents, T.atmos_sensitive_contents)

///Removes the given turf from the zone. Will invalidate the zone if it was the last turf.
/zone/proc/remove_turf(turf/T)
#ifdef ZASDBG
	ASSERT(!invalid)
	ASSERT(istype(T))
	ASSERT(T.zone == src)
	soft_assert(T in contents, "Lists are weird broseph")

	T.maptext = null
#endif
	if(!T.can_safely_remove_from_zone())
		rebuild()
		return

	LAZYREMOVE(atmos_sensitive_contents, T.atmos_sensitive_contents)
	if(isnull(atmos_sensitive_contents))
		SSzas.zones_with_sensitive_contents -= src

	T.take_zone_air_share()

	for(var/d in GLOB.cardinals)
		var/turf/other = get_step(T, d)
		other?.open_directions &= ~reverse_dir[d]

	contents.Remove(T)

	T.zone = null

	if(air.graphic)
		T.remove_viscontents(air.graphic)

	if(length(contents))
		air.group_multiplier = length(contents)
	else
		invalidate()

///Merges src into the given zone
/zone/proc/merge_into(zone/into)
#ifdef ZASDBG
	ASSERT(!invalid)
	ASSERT(istype(into))
	ASSERT(into != src)
	ASSERT(!into.invalid)
#endif
	invalidate()

	var/list/air_graphic = air.graphic // cache for sanic speed
	for(var/turf/T as anything in contents)
		if(!T.simulated)
			continue

		into.add_turf(T)
		// Remove old graphic
		if(air_graphic)
			T.remove_viscontents(air_graphic)

		#ifdef ZASDBG
		T.dbg(zasdbgovl_merged)
		#endif

	//rebuild the old zone's edges so that they will be possessed by the new zone
	for(var/edge_source in edges)
		var/connection_edge/E = edges[edge_source]
		if(E.contains_zone(into))
			continue //don't need to rebuild this edge, it will destroy itself.

		for(var/turf/T as anything in E.connecting_turfs)
			SSzas.mark_for_update(T)

///Marks the zone as invalid, removing it from the SSzas zone list.
/zone/proc/invalidate()
	invalid = 1
	SSzas.remove_zone(src)
	atmos_sensitive_contents = null
	#ifdef ZASDBG
	for(var/turf/T as anything in contents)
		if(!T.simulated)
			T.dbg(zasdbgovl_invalid_zone)
	#endif

///Invalidates the zone and marks all of it's contents for update.
/zone/proc/rebuild()
	set waitfor = FALSE

	if(invalid)
		return //Short circuit for explosions where rebuild is called many times over.

	invalidate()

	var/list/air_graphic = air.graphic // cache for sanic speed
	for(var/turf/T as anything in contents)
		if(!T.simulated)
			continue

		if(air_graphic)
			T.remove_viscontents(air_graphic)

		#ifdef ZASDBG
		//T.dbg(invalid_zone)
		#endif

		T.needs_air_update = 0 //Reset the marker so that it will be added to the list.
		SSzas.mark_for_update(T)

		CHECK_TICK

///Assumes a given gas mixture, dividing it amongst the zone.
/zone/proc/add_tile_air(datum/gas_mixture/tile_air)
	air.group_multiplier = 1
	air.multiply(length(contents))
	air.merge(tile_air)
	air.divide(length(contents)+1)
	air.group_multiplier = length(contents)+1

///Zone's process proc.
/zone/proc/tick()
	// Anything below this check only needs to be run if the zone's gas composition has changed.
	if(!isnull(last_gas_list) && (last_gas_list ~= air.gas) && (last_air_temperature == air.temperature))
		return

	last_gas_list = air.gas.Copy()
	last_air_temperature = air.temperature

	// Update gas overlays, with some reference passing tomfoolery.
	var/list/graphic_add = list()
	var/list/graphic_remove = list()
	if(air.checkTileGraphic(graphic_add, graphic_remove))
		processing_graphic_cycle++
		spawn(-1)
			var/this_cycle = processing_graphic_cycle
			for(var/turf/T as anything in contents)
				if(invalid || this_cycle != processing_graphic_cycle)
					return
				if(!(T.zone == src))
					continue
				if(length(graphic_add))
					T.add_viscontents(graphic_add)
				if(length(graphic_remove))
					T.remove_viscontents(graphic_remove)
				CHECK_TICK

///Prints debug information to the given mob. Used by the "Zone Info" verb. Does not require ZASDBG compile define.
/zone/proc/dbg_data(mob/M)
	. = list()
	. += span_info("[name][invalid ? " ([span_alert("Invalid")])" : ""]")
	if(length(contents) < ZONE_MIN_SIZE)
		. += span_alert("This turf's zone is below the minimum size, and will merge over zone blockers.")
	. += span_info("<br>Moles: [air.total_moles]")
	. += span_info("Pressure: [air.returnPressure()] kPa")
	. += span_info("Temperature: [air.temperature]°K ([air.temperature - T0C]°C)")
	. += span_info("Volume: [air.volume]L")
	. += span_info("Mixture:")
	for(var/g in air.gas)
		. += span_info("[FOURSPACES]- [xgm_gas_data.name[g]]: [air.gas[g]] ([round((air.gas[g] / air.total_moles) * 100, ATMOS_PRECISION)]%)")

	. += span_info("<br>Turfs: [contents.len] (Mult: [air.group_multiplier])")
	. += span_info("All Edges: [edges.len]")

	var/zone_edges = 0
	var/space_edges = 0
	var/space_coefficient = 0
	var/list/unsim_pressures = list()
	var/list/zone_pressures = list()

	for(var/edge_source in edges)
		var/connection_edge/E = edges[edge_source]
		var/turf/jump_target = E.connecting_turfs[1]

		if(E.type == /connection_edge/zone)
			zone_edges++
			var/zone/enemy_zone = edge_source
			zone_pressures += span_info("[FOURSPACES]- [enemy_zone.air.returnPressure()] kPa ([E.excited ? span_alert("Excited") : span_good("Sleeping")]) [ADMIN_JMP(jump_target)]")

		else
			space_edges++
			space_coefficient += E.coefficient
			var/connection_edge/unsimulated/unsim_edge = E
			unsim_pressures += span_info("[FOURSPACES]- [unsim_edge.air.returnPressure()] kPa ([unsim_edge.excited ? span_alert("Excited") : span_good("Sleeping")]) [ADMIN_JMP(jump_target)]")

	. += span_info("Zone Edges: [zone_edges]")
	. += zone_pressures
	. += span_info("Unsimulated Edges: [space_edges] ([space_coefficient] connections)")
	. += unsim_pressures
