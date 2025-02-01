/datum/antagonist_selector/revolutionary
	//Atleast 1 of any head.
	required_jobs = list(
		list(JOB_CAPTAIN = 1),
		list(JOB_HEAD_OF_PERSONNEL = 1),
		list(JOB_SECURITY_MARSHAL = 1),
		list(JOB_CHIEF_ENGINEER = 1),
		list(JOB_MEDICAL_DIRECTOR = 1),
		list(JOB_RESEARCH_DIRECTOR = 1)
	)

	restricted_jobs = list(
		JOB_CAPTAIN,
		JOB_HEAD_OF_PERSONNEL,
		JOB_AI,
		JOB_CYBORG,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
	)

	antag_flag = ROLE_REV_HEAD
	antag_datum = /datum/antagonist/rev/head

/datum/antagonist_selector/revolutionary/give_antag_datums(datum/game_mode/gamemode)
	var/datum/game_mode/one_antag/revolution/rev_gamemode = gamemode

	for(var/datum/mind/M in selected_antagonists)
		if(!rev_gamemode.check_eligible(M))
			selected_antagonists -= M
			log_game("Revolution: discarded [M.name] from head revolutionary due to ineligibility.")
			continue

		var/datum/antagonist/rev/head/new_head = new antag_datum()
		new_head.give_flash = TRUE
		new_head.remove_clumsy = TRUE
		M.add_antag_datum(new_head, rev_gamemode.revolution)
