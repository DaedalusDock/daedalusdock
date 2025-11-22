/datum/game_mode/one_antag/flock
	name = "Divine Flock"
	config_key = "divine_flock"

	weight = GAMEMODE_WEIGHT_NEVER

	antag_selector = /datum/antagonist_selector/flock
	//min_pop = 30

/datum/game_mode/one_antag/flock/get_antag_count()
	return 1

/datum/game_mode/one_antag/flock/check_finished()
	. = ..()
	if(.)
		return

	return get_default_flock()?.consider_game_over()
