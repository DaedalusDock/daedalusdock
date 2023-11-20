/datum/map_generator/cave_generator
	var/name = "Cave Generator"
	///Weighted list of the types that spawns if the turf is open
	var/weighted_open_turf_types = list(/turf/open/misc/asteroid/airless = 1)
	///Expanded list of the types that spawns if the turf is open
	var/open_turf_types
	///Weighted list of the types that spawns if the turf is closed
	var/weighted_closed_turf_types = list(/turf/closed/mineral/random = 1)
	///Expanded list of the types that spawns if the turf is closed
	var/closed_turf_types


	///Weighted list of mobs that can spawn in the area.
	var/list/weighted_mob_spawn_list
	///Expanded list of mobs that can spawn in the area. Reads from the weighted list
	var/list/mob_spawn_list
	///Weighted list of flora that can spawn in the area.
	var/list/weighted_flora_spawn_list
	///Expanded list of flora that can spawn in the area. Reads from the weighted list
	var/list/flora_spawn_list
	///Weighted list of extra features that can spawn in the area, such as geysers.
	var/list/weighted_feature_spawn_list
	///Expanded list of extra features that can spawn in the area. Reads from the weighted list
	var/list/feature_spawn_list


	///Base chance of spawning a mob
	var/mob_spawn_chance = 6
	///Base chance of spawning flora
	var/flora_spawn_chance = 2
	///Base chance of spawning features
	var/feature_spawn_chance = 0.1
	///Unique ID for this spawner
	var/string_gen

	///Chance of cells starting closed
	var/initial_closed_chance = 45
	///Amount of smoothing iterations
	var/smoothing_iterations = 20
	///How much neighbours does a dead cell need to become alive
	var/birth_limit = 4
	///How little neighbours does a alive cell need to die
	var/death_limit = 3

/datum/map_generator/cave_generator/New()
	. = ..()
	if(!weighted_mob_spawn_list)
		weighted_mob_spawn_list = list()
	mob_spawn_list = expand_weights(weighted_mob_spawn_list)
	if(!weighted_flora_spawn_list)
		weighted_flora_spawn_list = list()
	flora_spawn_list = expand_weights(weighted_flora_spawn_list)
	feature_spawn_list = expand_weights(weighted_feature_spawn_list)
	open_turf_types = expand_weights(weighted_open_turf_types)
	closed_turf_types = expand_weights(weighted_closed_turf_types)


/datum/map_generator/cave_generator/generate_terrain(list/turfs, area/generate_in)
	. = ..()
	if(!(generate_in.area_flags & CAVES_ALLOWED))
		return

	var/start_time = REALTIMEOFDAY
	string_gen = rustg_cnoise_generate("[initial_closed_chance]", "[smoothing_iterations]", "[birth_limit]", "[death_limit]", "[world.maxx]", "[world.maxy]") //Generate the raw CA data

	// Area var pullouts to make accessing in the loop faster
	var/flora_allowed = (generate_in.area_flags & FLORA_ALLOWED) && length(flora_spawn_list)
	var/feature_allowed = (generate_in.area_flags & FLORA_ALLOWED) && length(feature_spawn_list)
	var/mobs_allowed = (generate_in.area_flags & MOB_SPAWN_ALLOWED) && length(mob_spawn_list)

	for(var/i in turfs) //Go through all the turfs and generate them
		var/turf/gen_turf = i

		var/closed = string_gen[world.maxx * (gen_turf.y - 1) + gen_turf.x] != "0"
		var/turf/new_turf = pick(closed ? closed_turf_types : open_turf_types)

		// The assumption is this will be faster then changeturf, and changeturf isn't required since by this point
		// The old tile hasn't got the chance to init yet
		new_turf = new new_turf(gen_turf)

		if(gen_turf.turf_flags & NO_RUINS)
			new_turf.flags_1 |= NO_RUINS

		if(closed)//Open turfs have some special behavior related to spawning flora and mobs.
			CHECK_TICK
			continue

		// If we've spawned something yet
		var/spawned_something = FALSE

		///Spawning isn't done in procs to save on overhead on the 60k turfs we're going through.
		//FLORA SPAWNING HERE
		if(flora_allowed && prob(flora_spawn_chance))
			var/flora_type = pick(flora_spawn_list)
			new flora_type(new_turf)
			spawned_something = TRUE

		//FEATURE SPAWNING HERE
		if(feature_allowed && prob(feature_spawn_chance))
			var/can_spawn = TRUE

			var/atom/picked_feature = pick(feature_spawn_list)

			for(var/obj/structure/existing_feature in range(7, new_turf))
				if(istype(existing_feature, picked_feature))
					can_spawn = FALSE
					break

			if(can_spawn)
				new picked_feature(new_turf)
				spawned_something = TRUE

		//MOB SPAWNING HERE
		if(mobs_allowed && !spawned_something && prob(mob_spawn_chance))
			var/atom/picked_mob = pick(mob_spawn_list)
			var/can_spawn = TRUE

			//if the random is a standard mob, avoid spawning if there's another one within 12 tiles
			if(ispath(picked_mob, /mob/living/simple_animal/hostile/asteroid))
				for(var/mob/living/simple_animal/hostile/asteroid/mob_blocker in range(12, new_turf))
					can_spawn = FALSE
					break

			if(can_spawn)
				new picked_mob(new_turf)
				spawned_something = TRUE
		CHECK_TICK

	var/message = "[name] finished in [(REALTIMEOFDAY - start_time)/10]s!"
	to_chat(world, span_boldannounce("[message]"))
	log_world(message)
