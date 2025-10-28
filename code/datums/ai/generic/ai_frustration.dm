/// A simple frustration behavior to be queued in addition to another behavior. If the given duration ellapses and the frustration key is still
/// present, the ai will cancel all of it's actions.
/datum/ai_behavior/frustration
	action_cooldown = 0.1 SECONDS

/datum/ai_behavior/frustration/setup(datum/ai_controller/controller, frustration_key, duration)
	. = ..()
	controller.set_blackboard_key(frustration_key, world.time)

/datum/ai_behavior/frustration/perform(delta_time, datum/ai_controller/controller, frustration_key, duration)
	if(isnull(controller.blackboard[frustration_key]))
		return BEHAVIOR_PERFORM_SUCCESS

	if(world.time >= duration + controller.blackboard[frustration_key])
		controller.CancelActions()
		DEBUG_AI_LOG(controller, "AI got frustrated and cancelled current actions.")
		return BEHAVIOR_PERFORM_FAILURE

	return BEHAVIOR_PERFORM_COOLDOWN

/datum/ai_behavior/frustration/finish_action(datum/ai_controller/controller, succeeded, frustration_key, duration)
	. = ..()
	controller.clear_blackboard_key(frustration_key)
