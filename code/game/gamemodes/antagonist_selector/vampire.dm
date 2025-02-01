/datum/antagonist_selector/vampire
	restricted_jobs = list(JOB_CYBORG, JOB_AI)
	protected_jobs = list(
		JOB_WARDEN,
		JOB_SECURITY_MARSHAL,
		JOB_CAPTAIN,
		JOB_CHIEF_ENGINEER,
		JOB_MEDICAL_DIRECTOR
	)

	antag_datum = /datum/antagonist/vampire
	antag_flag = ROLE_VAMPIRE

/datum/antagonist_selector/vampire/trim_candidates(list/candidates)
	. = ..()
	for(var/mob/dead/new_player/candidate_player in candidates)
		var/client/candidate_client = GET_CLIENT(candidate_player)
		if (!candidate_client || !candidate_player.mind) // Are they connected?
			candidates.Remove(candidate_player)
			continue

		var/datum/preferences/prefs = candidate_client.prefs
		var/species_type = prefs.read_preference(/datum/preference/choiced/species)
		if(ispath(species_type, /datum/species/ipc))
			candidates.Remove(candidate_player)
			continue
