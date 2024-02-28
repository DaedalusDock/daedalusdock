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
	return
