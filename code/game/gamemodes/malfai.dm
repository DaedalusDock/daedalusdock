/datum/game_mode/one_antag/malf
	name = "Malfunctioning AI"
	config_key = "malfai"

	weight = GAMEMODE_WEIGHT_EPIC
	antag_selector = /datum/antagonist_selector/malfai

/datum/game_mode/one_antag/malf/check_for_errors()
	var/datum/job/ai_job = SSjob.GetJobType(/datum/job/ai)

	// If we're not forced, we're going to make sure we can actually have an AI in this shift,
	if(min(ai_job.total_positions - ai_job.current_positions, ai_job.spawn_positions) <= 0)
		return "No AI position available."

	return ..()

/datum/game_mode/one_antag/malf/get_antag_count()
	return 1
