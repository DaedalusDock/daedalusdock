/datum/ai_planning_subtree/scored
	#warn timed behaviors? cooldowns? weirdness
	var/list/possible_behaviors = list()

	var/bb_key

/datum/ai_planning_subtree/scored/New()
	bb_key = "PLANNER: [type]"

/datum/ai_planning_subtree/scored/setup(datum/ai_controller/controller, ...)
	. = ..()
	controller.blackboard[bb_key] = list()
	controller.blackboard[bb_key][BB_PLANNER_BEHAVIORS] = list()
	for(var/behavior_type in possible_behaviors)
		var/datum/ai_behavior/behavior = GET_AI_BEHAVIOR(behavior_type)
		if(isnull(behavior))
			stack_trace("Bad AI behavior: [behavior_type]")
			continue
		controller.blackboard[bb_key][BB_PLANNER_BEHAVIORS][behavior] = possible_behaviors[behavior_type]

/datum/ai_planning_subtree/scored/SelectBehaviors(datum/ai_controller/controller, delta_time)
	var/list/behavior_cache = controller.blackboard[bb_key][BB_PLANNER_BEHAVIORS]
	var/datum/ai_behavior/candidate = behavior_cache[1]
	var/score_to_beat = behavior_cache[candidate]

	for(var/behavior in behavior_cache)
		var/behavior_score = behavior_cache[behavior]
		// Filter out lower scoring behaviors
		if(score_to_beat > behavior_score)
			continue

		// If there's a tie, pick either.
		if((behavior_score == score_to_beat) && prob(50))
			continue

		candidate = behavior
		score_to_beat = behavior_cache[candidate]

	if(candidate)
		controller.queue_behavior(candidate.type)

/datum/ai_planning_subtree/scored/ProcessBehaviorSelection(datum/ai_controller/controller, delta_time)
	var/list/behavior_cache = controller.blackboard[bb_key][BB_PLANNER_BEHAVIORS]
	for(var/datum/ai_behavior/behavior in behavior_cache)
		behavior_cache[behavior] = behavior.score(controller)

	return ..()
