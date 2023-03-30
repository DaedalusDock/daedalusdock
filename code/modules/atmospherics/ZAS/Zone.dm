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
	///All fire tiles in this zone
	var/list/fire_tiles = list()
	///All physical sources of fire fuel in this zone
	var/list/fuel_objs = list()
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
	if(T.fire)
		var/obj/effect/decal/cleanable/oil/fuel = locate() in T
		fire_tiles.Add(T)
		SSzas.active_fire_zones |= src
		if(fuel)
			fuel_objs += fuel
			RegisterSignal(fuel, COMSIG_PARENT_QDELETING, .proc/handle_fuel_del)
	T.update_graphic(air.graphic)

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

	T.copy_zone_air()

	for(var/d in GLOB.cardinals)
		var/turf/other = get_step(T, d)
		other?.open_directions &= ~reverse_dir[d]

	contents.Remove(T)
	fire_tiles.Remove(T)
	if(T.fire)
		var/obj/effect/decal/cleanable/oil/fuel = locate() in T
		fuel_objs -= fuel
	T.zone = null
	T.update_graphic(graphic_remove = air.graphic)
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

	for(var/turf/T as anything in contents)
		if(!T.simulated)
			continue
		into.add_turf(T)
		T.update_graphic(graphic_remove = air.graphic)
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

	for(var/turf/T as anything in contents)
		if(!T.simulated)
			continue
		T.update_graphic(graphic_remove = air.graphic) //we need to remove the overlays so they're not doubled when the zone is rebuilt
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

	#ifdef ZASDBG
	var/clock = TICK_USAGE
	#endif

	// Update fires.
	if(air.temperature >= PHORON_FLASHPOINT && !length(fire_tiles) && length(contents) && !(src in SSzas.active_fire_zones) && air.check_combustability())
		var/turf/T = pick(contents)
		T.create_fire(zas_settings.fire_firelevel_multiplier)

	#ifdef ZASDBG
	SSzas.zonetime["update fires"] = TICK_USAGE_TO_MS(clock)
	clock = TICK_USAGE
	#endif

	// Anything below this check only needs to be run if the zone's gas composition has changed.


	if(!isnull(last_gas_list) && (last_gas_list ~= air.gas) && (last_air_temperature == air.temperature))
		return

	last_gas_list = air.gas.Copy()
	last_air_temperature = air.temperature

	// Update gas overlays, with some reference passing tomfoolery.
	var/list/graphic_add = list()
	var/list/graphic_remove = list()
	if(air.checkTileGraphic(graphic_add, graphic_remove))
		for(var/turf/T as anything in contents)
			T.update_graphic(graphic_add, graphic_remove)

	#ifdef ZASDBG
	SSzas.zonetime["tile graphic"] = TICK_USAGE_TO_MS(clock)
	clock = TICK_USAGE
	#endif


///Prints debug information to the given mob. Used by the "Zone Info" verb. Does not require ZASDBG compile define.
/zone/proc/dbg_data(mob/M)
	to_chat(M, name)
	for(var/g in air.gas)
		to_chat(M, "[xgm_gas_data.name[g]]: [air.gas[g]]")
	to_chat(M, "P: [air.returnPressure()] kPa V: [air.volume]L T: [air.temperature]°K ([air.temperature - T0C]°C)")
	to_chat(M, "O2 per N2: [(air.gas[GAS_NITROGEN] ? air.gas[GAS_OXYGEN]/air.gas[GAS_NITROGEN] : "N/A")] Moles: [air.total_moles]")
	to_chat(M, "Simulated: [contents.len] ([air.group_multiplier])")
	to_chat(M, "Edges: [edges.len]")
	if(invalid) to_chat(M, "Invalid!")
	var/zone_edges = 0
	var/space_edges = 0
	var/space_coefficient = 0
	for(var/edge_source in edges)
		var/connection_edge/E = edges[edge_source]
		if(E.type == /connection_edge/zone)
			zone_edges++
		else
			space_edges++
			space_coefficient += E.coefficient
			to_chat(M, " - [E:air:returnPressure()]kPa")

	to_chat(M, "Zone Edges: [zone_edges]")
	to_chat(M, "Unsimulated Edges: [space_edges] ([space_coefficient] connections)\n")

///If fuel disappears from anything that isn't a fire burning it out, we gotta clear it's ref
/zone/proc/handle_fuel_del(datum/source)
	fuel_objs -= source
