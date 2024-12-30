/datum/ai_planning_subtree/scored/flockdrone
	possible_behaviors = list(
		/datum/ai_behavior/flock/stare,
		/datum/ai_behavior/flock/wander,
		/datum/ai_behavior/flock/find_conversion_target,
		/datum/ai_behavior/flock/find_heal_target,
	)

/datum/ai_planning_subtree/scored/flock
	possible_behaviors = list(
		/datum/ai_behavior/flock/stare,
		/datum/ai_behavior/flock/wander,
		/datum/ai_behavior/flock/find_conversion_target,
	)
