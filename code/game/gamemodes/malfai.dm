/datum/game_mode/malf
	name = "Malfunctioning AI"

	weight = GAMEMODE_WEIGHT_EPIC
	exclusive_roles = list(JOB_AI)

	antag_datum = /datum/antagonist/malf_ai
	antag_flag = ROLE_MALF

	var/datum/weakref/chosen_malf_player

/datum/game_mode/malf/can_run_this_round()
	. = ..()
	if(!.)
		return
	var/datum/job/ai_job = SSjob.GetJobType(/datum/job/ai)

	// If we're not forced, we're going to make sure we can actually have an AI in this shift,
	if(min(ai_job.total_positions - ai_job.current_positions, ai_job.spawn_positions) <= 0)
		return FALSE

/datum/game_mode/malf/pre_setup()
	. = ..()

	var/mob/M = pick_n_take(possible_antags)
	M.mind.special_role = ROLE_MALF
	M.mind.restricted_roles = restricted_jobs
	GLOB.pre_setup_antags += M.mind
	chosen_malf_player = WEAKREF(M)
	LAZYADDASSOC(SSjob.dynamic_forced_occupations, M, JOB_AI)

/datum/game_mode/malf/on_failed_execute()
	. = ..()
	var/mob/M = chosen_malf_player?.resolve()
	if(M)
		LAZYREMOVE(SSjob.dynamic_forced_occupations, M)
