/datum/game_mode/malf
	name = "Malfunctioning AI"

	weight = GAMEMODE_WEIGHT_EPIC
	exclusive_roles = list(JOB_AI)

	antag_datum = /datum/antagonist/malf_ai
	antag_flag = ROLE_MALF

/datum/game_mode/malf/check_for_errors()
	var/datum/job/ai_job = SSjob.GetJobType(/datum/job/ai)

	// If we're not forced, we're going to make sure we can actually have an AI in this shift,
	if(min(ai_job.total_positions - ai_job.current_positions, ai_job.spawn_positions) <= 0)
		return "No AI position available."

	return ..()

/datum/game_mode/malf/pre_setup()
	. = ..()

	var/mob/M = pick_n_take(possible_antags)
	select_antagonist(M.mind)
