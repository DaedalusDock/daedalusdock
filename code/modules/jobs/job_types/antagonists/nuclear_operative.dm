/datum/job/nuclear_operative
	title = ROLE_NUCLEAR_OPERATIVE
	spawn_logic = JOBSPAWN_FORCE_FIXED


/datum/job/nuclear_operative/get_roundstart_spawn_point_fixed()
	return get_latejoin_spawn_point()


/datum/job/nuclear_operative/get_latejoin_spawn_point()
	return pick(GLOB.nukeop_start)
