/datum/ai_planning_subtree/scored/flockdrone
	possible_behaviors = list(
		/datum/ai_behavior/flock_stare,
		/datum/ai_behavior/flock_wander,
		/datum/ai_behavior/find_flock_conversion_target,
		/datum/ai_behavior/flock_find_heal_target,
	)

/datum/ai_planning_subtree/scored/flock
	possible_behaviors = list(
		/datum/ai_behavior/flock_stare,
		/datum/ai_behavior/flock_wander,
		/datum/ai_behavior/find_flock_conversion_target,
	)
