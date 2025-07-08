///What percentage of the crew can become traitors.
#define WIZARD_SCALING_COEFF 0.05

/datum/game_mode/one_antag/wizard
	name = "Wizard"
	config_key = "wizard"

	weight = GAMEMODE_WEIGHT_LEGENDARY

	antagonist_pop_ratio = 0.05
	antag_selector = /datum/antagonist_selector/wizard
