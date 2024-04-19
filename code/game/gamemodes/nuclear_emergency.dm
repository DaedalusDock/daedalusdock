///What percentage of the crew can become traitors.
#define NUKIE_SCALING_COEFF 0.0555 // About 1 in 18 crew

/datum/game_mode/nuclear_emergency
	name = "Nuclear Emergency"

	weight = GAMEMODE_WEIGHT_EPIC
	restricted_jobs = list(
		JOB_CAPTAIN,
		JOB_SECURITY_MARSHAL,
	)// Just to be sure that a nukie getting picked won't ever imply a Captain or HoS not getting drafted

	required_enemies = 5
	min_pop = 25

	antag_datum = /datum/antagonist/nukeop
	antag_flag = ROLE_OPERATIVE

	var/datum/antagonist/antag_leader_datum = /datum/antagonist/nukeop/leader
	var/datum/team/nuclear/nuke_team

/datum/game_mode/nuclear_emergency/pre_setup()
	. = ..()

	var/num_nukies = max(required_enemies, round(length(SSticker.ready_players) * NUKIE_SCALING_COEFF))


	for(var/i in 1 to num_nukies)
		if(possible_antags.len <= 0)
			break

		var/mob/M = pick_n_take(possible_antags)
		select_antagonist(M.mind)

/datum/game_mode/nuclear_emergency/give_antag_datums()
	var/chosen_leader = FALSE
	for(var/datum/mind/M as anything in shuffle(antagonists))
		if (!chosen_leader)
			chosen_leader = TRUE
			var/datum/antagonist/nukeop/leader/new_op = M.add_antag_datum(antag_leader_datum)
			nuke_team = new_op.nuke_team
		else
			var/datum/antagonist/nukeop/new_op = new antag_datum()
			M.add_antag_datum(new_op)

/datum/game_mode/nuclear_emergency/set_round_result()
	. = ..()
	var/result = nuke_team.get_result()
	switch(result)
		if(NUKE_RESULT_FLUKE)
			SSticker.mode_result = "loss - syndicate nuked - disk secured"
			SSticker.news_report = NUKE_SYNDICATE_BASE
		if(NUKE_RESULT_NUKE_WIN)
			SSticker.mode_result = "win - syndicate nuke"
			SSticker.news_report = STATION_NUKED
		if(NUKE_RESULT_NOSURVIVORS)
			SSticker.mode_result = "halfwin - syndicate nuke - did not evacuate in time"
			SSticker.news_report = STATION_NUKED
		if(NUKE_RESULT_WRONG_STATION)
			SSticker.mode_result = "halfwin - blew wrong station"
			SSticker.news_report = NUKE_MISS
		if(NUKE_RESULT_WRONG_STATION_DEAD)
			SSticker.mode_result = "halfwin - blew wrong station - did not evacuate in time"
			SSticker.news_report = NUKE_MISS
		if(NUKE_RESULT_CREW_WIN_SYNDIES_DEAD)
			SSticker.mode_result = "loss - evacuation - disk secured - syndi team dead"
			SSticker.news_report = OPERATIVES_KILLED
		if(NUKE_RESULT_CREW_WIN)
			SSticker.mode_result = "loss - evacuation - disk secured"
			SSticker.news_report = OPERATIVES_KILLED
		if(NUKE_RESULT_DISK_LOST)
			SSticker.mode_result = "halfwin - evacuation - disk not secured"
			SSticker.news_report = OPERATIVE_SKIRMISH
		if(NUKE_RESULT_DISK_STOLEN)
			SSticker.mode_result = "halfwin - detonation averted"
			SSticker.news_report = OPERATIVE_SKIRMISH
		else
			SSticker.mode_result = "halfwin - interrupted"
			SSticker.news_report = OPERATIVE_SKIRMISH

