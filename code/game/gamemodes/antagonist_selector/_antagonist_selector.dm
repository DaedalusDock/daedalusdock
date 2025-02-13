/datum/antagonist_selector

	///Typepath of the antagonist datum to hand out at round start
	var/datum/antagonist/antag_datum

	///A list of jobs cannot physically be this antagonist, typically AI and borgs.
	var/list/restricted_jobs = null
	///A list of jobs that should not be this antagonist
	var/list/protected_jobs = null
	///Jobs required for this round type to function, k:v list of JOB_TITLE : NUM_JOB. list(list(cap=1),list(hos=1,sec=2)) translates to one captain OR one hos and two secmans
	var/list/required_jobs = null
	/// If set, rule will only accept candidates from those roles. If on a roundstart ruleset, requires the player to have the correct antag pref enabled and any of the possible roles enabled.
	var/list/exclusive_roles = null

	///The antagonist flag to check player prefs for, for example ROLE_WIZARD
	var/antag_flag = NONE
	/// If a role is to be considered another for the purpose of banning.
	var/antag_flag_to_ban_check = NONE
	/// If set, will check this preference instead of antag_flag.
	var/antag_preference = null

	/// Minds that may become an antagonist.
	var/list/candidates = list()

	/// Minds selected for antagonist
	var/list/selected_antagonists = list()

	/// Mobs selected for antagonist. Cleared out after the selection process.
	var/list/selected_mobs = list()

/datum/antagonist_selector/Destroy()
	candidates = null
	selected_antagonists = null
	return ..()

/datum/antagonist_selector/proc/setup(num_antagonists, list/player_pool)
	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		restricted_jobs += protected_jobs

	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		restricted_jobs += JOB_ASSISTANT

	// Strip out antag bans/people without this antag as a pref
	candidates = trim_candidates(player_pool)
	if(!length(candidates))
		return FALSE

	decide_antagonists(num_antagonists)
	return TRUE

/// Selects minds to become an antagonist.
/datum/antagonist_selector/proc/decide_antagonists(num_antagonists)
	for(var/i in 1 to num_antagonists)
		if(candidates.len <= 0)
			break

		var/mob/M = pick_n_take(candidates)
		select_antagonist(M)

///Return a list of players that have our antag flag checked in prefs and are not banned, among other criteria.
/datum/antagonist_selector/proc/trim_candidates(list/candidates)
	RETURN_TYPE(/list)
	SHOULD_CALL_PARENT(TRUE)

	for(var/mob/dead/new_player/candidate_player in candidates)
		var/client/candidate_client = GET_CLIENT(candidate_player)
		if (!candidate_client || !candidate_player.mind) // Are they connected?
			candidates.Remove(candidate_player)
			continue

		// Code for age-gating antags.
		/*if(candidate_client.get_remaining_days(minimum_required_age) > 0)
			candidates.Remove(candidate_player)
			continue*/

		if(candidate_player.mind.special_role) // We really don't want to give antag to an antag.
			candidates.Remove(candidate_player)
			continue

		var/list/antag_prefs = candidate_client.prefs.read_preference(/datum/preference/blob/antagonists)
		if(antag_flag || antag_preference)
			if (!antag_prefs[antag_preference || antag_flag])
				candidates.Remove(candidate_player)
				continue

		if(antag_flag || antag_flag_to_ban_check)
			if (is_banned_from(candidate_player.ckey, list(antag_flag_to_ban_check || antag_flag, ROLE_SYNDICATE)))
				candidates.Remove(candidate_player)
				continue

		// If this ruleset has exclusive_roles set, we want to only consider players who have those
		// job prefs enabled and are eligible to play that job. Otherwise, continue as before.
		if(length(exclusive_roles))
			var/exclusive_candidate = FALSE
			for(var/role in exclusive_roles)
				var/datum/job/job = SSjob.GetJob(role)

				if((role in candidate_client.prefs.read_preference(/datum/preference/blob/job_priority)) && SSjob.check_job_eligibility(candidate_player, job, "Gamemode Roundstart TC", add_job_to_log = TRUE)==JOB_AVAILABLE)
					exclusive_candidate = TRUE
					break

			// If they didn't have any of the required job prefs enabled or were banned from all enabled prefs,
			// they're not eligible for this antag type.
			if(!exclusive_candidate)
				candidates.Remove(candidate_player)

	return candidates

///Add a mind to pre_setup_antags and perform any work on it.
/datum/antagonist_selector/proc/select_antagonist(mob/dead/new_player/player)
	var/datum/mind/M = player.mind

	GLOB.pre_setup_antags[M] = antag_datum

	M.restricted_roles = restricted_jobs

	if(initial(antag_datum.job_rank))
		M.special_role = initial(antag_datum.job_rank)

	if(initial(antag_datum.assign_job))
		M.set_assigned_role(SSjob.GetJobType(initial(antag_datum.assign_job)))

	selected_antagonists[M] = antag_datum
	selected_mobs += player

/// Sends out antagonist datums.
/datum/antagonist_selector/proc/give_antag_datums(datum/game_mode/gamemode)
	for(var/datum/mind/M as anything in selected_antagonists)
		M.add_antag_datum(selected_antagonists[M])

/// Called by game_mode/proc/post_setup. Used for cleaning up random garbage.
/datum/antagonist_selector/proc/post_setup()
	SHOULD_CALL_PARENT(TRUE)

	selected_mobs.Cut()
