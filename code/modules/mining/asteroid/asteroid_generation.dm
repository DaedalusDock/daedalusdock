/datum/controller/subsystem/mapping/proc/generate_asteroid(datum/mining_template/template, datum/callback/asteroid_generator)
	Master.StartLoadingMap()

	SSatoms.map_loader_begin(REF(template))
	var/list/turfs = asteroid_generator.Invoke()
	template.Populate(turfs.Copy())
	SSatoms.map_loader_stop(REF(template))

	var/list/atoms = list()
	// Initialize all of the atoms in the asteroid
	for(var/turf/T as anything in turfs)
		atoms += T
		atoms += T.contents

	SSatoms.InitializeAtoms(atoms)
	for(var/turf/T as turf in turfs)
		T.AfterChange(CHANGETURF_IGNORE_AIR)
	Master.StopLoadingMap()

	template.AfterInitialize(atoms)

/// Sanitizes a block of turfs to prevent writing over undesired locations
/proc/ReserveTurfsForAsteroidGeneration(turf/center, size, baseturf_only = TRUE)
	. = list()

	for(var/turf/T as anything in RANGE_TURFS(size, center))
		if(baseturf_only && !islevelbaseturf(T))
			continue
		if(!(istype(T.loc, /area/station/cargo/mining/asteroid_magnet)))
			continue
		. += T
		CHECK_TICK

/// Generates a circular asteroid.
/proc/GenerateRoundAsteroid(datum/mining_template/template, turf/center = template.center, initial_turf_path = /turf/closed/mineral/asteroid/tospace, size = template.size || 6, list/turfs, hollow = FALSE)
	. = list()
	if(!length(turfs))
		return list()

	if(template)
		center = template.center
		size = template.size

	size = size + 2 //This is just for generating "smoother" asteroids, it will not go out of reservation space.

	if (hollow)
		center = center.ChangeTurf(/turf/open/misc/asteroid/airless/tospace, flags = (CHANGETURF_DEFER_CHANGE|CHANGETURF_DEFAULT_BASETURF))
	else
		center = center.ChangeTurf(initial_turf_path, flags = (CHANGETURF_DEFER_CHANGE|CHANGETURF_DEFAULT_BASETURF))
		GENERATOR_CHECK_TICK

	. += center

	var/corner_range = round(size * 1.5)
	var/total_distance = 0
	var/current_dist_from_center = 0

	for (var/turf/current_turf in turfs)
		GENERATOR_CHECK_TICK

		current_dist_from_center = get_dist(center, current_turf)

		total_distance = abs(center.x - current_turf.x) + abs(center.y - current_turf.y) + (current_dist_from_center / 2)
		// Keep us round
		if (total_distance > corner_range)
			continue

		if (hollow && total_distance < size / 2)
			var/turf/T = locate(current_turf.x, current_turf.y, current_turf.z)
			T = T.ChangeTurf(/turf/open/misc/asteroid/airless/tospace, flags = (CHANGETURF_DEFER_CHANGE|CHANGETURF_DEFAULT_BASETURF))
			. += T

		else
			var/turf/T = locate(current_turf.x, current_turf.y, current_turf.z)
			T = T.ChangeTurf(initial_turf_path, flags = (CHANGETURF_DEFER_CHANGE|CHANGETURF_DEFAULT_BASETURF))
			GENERATOR_CHECK_TICK
			. += T

	return .

/proc/InsertAsteroidMaterials(datum/mining_template/template, list/turfs, vein_count, rarity_modifier, list/determined_ore)
	var/list/viable_turfs = list()
	for(var/turf/closed/mineral/asteroid/A in turfs)
		viable_turfs += A

	while(vein_count > 0 && length(viable_turfs))
		vein_count--
		GENERATOR_CHECK_TICK

		var/list/ore_pool
		var/datum/ore/chosen_ore

		if(!length(determined_ore))
			var/rarity = rand(1, 100) + rarity_modifier
			switch(rarity)
				if(90 to 100)
					ore_pool = SSmaterials.rare_ores
				if(50 to 89)
					ore_pool = SSmaterials.uncommon_ores
				else
					ore_pool = SSmaterials.common_ores

			chosen_ore = pick(ore_pool)

		else
			chosen_ore = pick_n_take(determined_ore)

		var/turfs_in_vein = rand(chosen_ore.turfs_per_vein_min, chosen_ore.turfs_per_vein_max)
		var/mats_per_turf = rand(chosen_ore.amount_per_turf_min, chosen_ore.amount_per_turf_max)

		while(turfs_in_vein > 0 && length(viable_turfs))
			GENERATOR_CHECK_TICK
			turfs_in_vein--
			var/turf/closed/mineral/asteroid/A = pick_n_take(viable_turfs)
			// We dont use change_ore() here because the turf isn't initialized and will do it anyway
			A.mineralType = chosen_ore
			A.mineralAmt = mats_per_turf
