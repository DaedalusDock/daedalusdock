///What percentage of the crew can become culists.
#define CULT_SCALING_COEFF 0.15

/datum/game_mode/bloodcult
	name = "Blood Cult"

	weight = GAMEMODE_WEIGHT_EPIC
	min_pop = 30
	required_enemies = 2

	restricted_jobs = list(
		JOB_AI,
		JOB_CAPTAIN,
		JOB_CHAPLAIN,
		JOB_CYBORG,
		JOB_DETECTIVE,
		JOB_HEAD_OF_PERSONNEL,
		JOB_SECURITY_MARSHAL,
		JOB_PRISONER,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
	)

	antag_datum = /datum/antagonist/cult
	antag_flag = ROLE_CULTIST
	///The cult created by the gamemode.
	var/datum/team/cult/main_cult

/datum/game_mode/bloodcult/pre_setup()
	. = ..()

	var/num_cultists = 1

	num_cultists = max(1, round(length(SSticker.ready_players) * CULT_SCALING_COEFF))

	for (var/i in 1 to num_cultists)
		if(possible_antags.len <= 0)
			break
		var/mob/M = pick_n_take(possible_antags)
		select_antagonist(M.mind)

/datum/game_mode/bloodcult/set_round_result()
	. = ..()
	if(main_cult.check_cult_victory())
		SSticker.mode_result = "win - cult win"
		SSticker.news_report = CULT_SUMMON
	else
		SSticker.mode_result = "loss - staff stopped the cult"
		SSticker.news_report = CULT_FAILURE
