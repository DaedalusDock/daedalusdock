///What percentage of the crew can become traitors.
#define WIZARD_SCALING_COEFF 0.05

/datum/game_mode/wizard
	name = "Wizard"

	weight = GAMEMODE_WEIGHT_LEGENDARY

	antag_datum = /datum/antagonist/wizard
	antag_flag = ROLE_WIZARD

/datum/game_mode/wizard/pre_setup()
	. = ..()

	var/num_wizards = max(1, round(length(SSticker.ready_players) * WIZARD_SCALING_COEFF))

	for (var/i in 1 to num_wizards)
		if(possible_antags.len <= 0)
			break

		var/mob/M = pick_n_take(possible_antags)
		select_antagonist(M.mind)
