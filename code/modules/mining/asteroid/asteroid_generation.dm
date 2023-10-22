/datum/controller/subsystem/mapping/proc/generate_asteroid(datum/mining_template/template, datum/callback/asteroid_generator, datum/callback/after_load)
	Master.StartLoadingMap()

	SSatoms.map_loader_begin(REF(template))
	var/list/atoms = asteroid_generator.Invoke()
	SSatoms.map_loader_stop(REF(template))

	// Initialize all of the atoms in the asteroid
	SSatoms.InitializeAtoms(atoms)
	for(var/turf/T as turf in atoms)
		T.AfterChange(CHANGETURF_IGNORE_AIR)
	Master.StopLoadingMap()

	if(after_load)
		after_load.Invoke()

/// Cleanup our currently loaded mining template
/proc/CleanupAsteroidMagnet(turf/center, size)
	var/list/turfs_to_destroy = ReserveTurfsForAsteroidGeneration(center, size)
	for(var/turf/T as anything in turfs_to_destroy)
		CHECK_TICK

		for(var/atom/movable/AM as anything in turfs_to_destroy)
			CHECK_TICK
			if(isdead(AM) || iscameramob(AM) || iseffect(AM) || istype(AM, /atom/movable/openspace))
				continue
			qdel(AM)

		T.ChangeTurf(/turf/baseturf_bottom)

/// Sanitizes a block of turfs to prevent writing over undesired locations
/proc/ReserveTurfsForAsteroidGeneration(turf/center, size)
	. = list()

	for(var/turf/open/space/S in RANGE_TURFS(size, center))
		if(!(istype(S.loc, /area/station/cargo/mining/asteroid_magnet)))
			continue
		. += S
		CHECK_TICK

/proc/GenerateRoundAsteroid(datum/mining_template/template, turf/center, initial_turf_path = /turf/closed/mineral/asteroid/tospace, size = 7, list/turfs, hollow = FALSE)
	. = list()
	if(!length(turfs))
		return list()

	if (hollow)
		center = center.ChangeTurf(/turf/open/misc/asteroid/airless/tospace, flags = CHANGETURF_DEFER_CHANGE)
	else
		center = center.ChangeTurf(initial_turf_path, flags = CHANGETURF_DEFER_CHANGE)

	. += center

	var/corner_range = round(size * 1.5)
	var/total_distance = 0
	var/current_dist_from_center = 0

	for (var/turf/open/space/current_turf in turfs)
		GENERATOR_CHECK_TICK

		current_dist_from_center = get_dist(center, current_turf)
		total_distance = abs(center.x - current_turf.x) + abs(center.y - current_turf.y) + (current_dist_from_center / 2)
		// Keep us round
		if (total_distance > corner_range)
			continue

		if (hollow && total_distance < size / 2)
			var/turf/open/misc/asteroid/airless/floor = locate(current_turf.x, current_turf.y, current_turf.z)
			floor = floor.ChangeTurf(/turf/open/misc/asteroid/airless/tospace, flags = CHANGETURF_DEFER_CHANGE)
			. += floor

		else
			var/turf/T = locate(current_turf.x, current_turf.y, current_turf.z)
			// I don't like needing to specify the baseturf here, this may cause issues
			T = T.ChangeTurf(initial_turf_path, /turf/open/misc/asteroid/airless/tospace, flags = CHANGETURF_DEFER_CHANGE)
			. += T

	return template.Generate(center, .)
