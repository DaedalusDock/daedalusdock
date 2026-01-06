/datum/game_mode/one_antag/brothers
	name = "Blood Brothers"
	config_key = "bloodbrothers"

	weight = GAMEMODE_WEIGHT_RARE
	required_enemies = /datum/antagonist_selector/bloodbrother::minimum_team_size

	antagonist_pop_ratio = 0.15
	antag_selector = /datum/antagonist_selector/bloodbrother
