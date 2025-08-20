/datum/game_mode/one_antag/bloodcult
	name = "Blood Cult"
	config_key = "bloodcult"

	weight = GAMEMODE_WEIGHT_EPIC
	min_pop = 30
	required_enemies = 2

	antagonist_pop_ratio = 0.15
	antag_selector = /datum/antagonist_selector/cultist

	///The cult created by the gamemode.
	var/datum/team/cult/main_cult

/datum/game_mode/one_antag/bloodcult/set_round_result()
	. = ..()
	if(main_cult.check_cult_victory())
		SSticker.mode_result = "win - cult win"
		SSticker.news_report = CULT_SUMMON
	else
		SSticker.mode_result = "loss - staff stopped the cult"
		SSticker.news_report = CULT_FAILURE
