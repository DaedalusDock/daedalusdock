/datum/ai_behavior/flock_convert

/datum/ai_behavior/flock_convert/score(datum/ai_controller/controller)
	return score_distance(controller, get_target(controller))

/datum/ai_behavior/flock_convert/proc/get_target(datum/ai_controller/controller)
	for(var/turf/T as anything in spiral_range_turfs(controller.target_search_radius, controller.pawn))
		if(is_flockable(T))
			return T

/datum/ai_behavior/flock_convert/proc/is_flockable(turf/T)
	if(istype(T, /turf/open/floor/flock))
		return FALSE

	return istype(T, /turf/open/floor)

/datum/ai_behavior/flock_convert/perform(delta_time, datum/ai_controller/controller, ...)
	var/turf/target = get_target(controller)
	if(!target)
		return BEHAVIOR_PERFORM_FAILURE

	controller.set_blackboard_key(BB_FLOCK_CONVERT_TARGET, target)
	controller.set_move_target(target)
	return BEHAVIOR_PERFORM_SUCCESS

/datum/ai_behavior/flock_convert/next_behavior(datum/ai_controller/controller, success)
	if(success)
		controller.queue_behavior(/datum/ai_behavior/move_to_target)
		controller.queue_behavior(/datum/ai_behavior/perform_flock_conversion)

/datum/ai_behavior/perform_flock_conversion

/datum/ai_behavior/perform_flock_conversion/perform(delta_time, datum/ai_controller/controller, ...)
	var/mob/living/simple_animal/flock/bird = controller.pawn
	var/turf/target = controller.blackboard[BB_FLOCK_CONVERT_TARGET]
	if(target)
		controller.clear_blackboard_key(BB_FLOCK_CONVERT_TARGET)
		var/datum/action/innate/flock/convert/convert_action = locate() in bird.actions
		spawn(-1)
			convert_action.do_ability(bird, target)

	if(DOING_INTERACTION(bird, "flock_convert"))
		return BEHAVIOR_PERFORM_COOLDOWN

	return BEHAVIOR_PERFORM_SUCCESS

/datum/ai_behavior/perform_flock_conversion/finish_action(datum/ai_controller/controller, succeeded, ...)
	. = ..()
	controller.clear_blackboard_key(BB_FLOCK_CONVERT_TARGET)
