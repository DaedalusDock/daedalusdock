/datum/ai_behavior/find_flock_conversion_target

/datum/ai_behavior/find_flock_conversion_target/score(datum/ai_controller/controller)
	return score_distance(controller, get_target(controller))

/datum/ai_behavior/find_flock_conversion_target/score_distance(datum/ai_controller/controller, atom/target)
	. = ..()
	var/mob/living/simple_animal/flock/bird = controller.pawn
	if(bird.flock?.marked_for_deconstruction[target])
	/*
	* because the result of scoring is based on max distance,
	* the score of any given tile is -100 to 0, with 0 being best.
	* Adding 200 basically allows a tile at twice the max distance to be considered.
	*/
		. += 200

/datum/ai_behavior/find_flock_conversion_target/proc/get_target(datum/ai_controller/controller)
	var/mob/living/simple_animal/flock/bird = controller.pawn
	var/datum/flock/bird_flock = bird.flock

	var/list/options = list()
	var/list/priority_turfs = bird_flock?.get_priority_turfs()
	if(length(priority_turfs))
		options += priority_turfs

	var/list/turfs = spiral_range_turfs(controller.target_search_radius, bird) & view(controller.target_search_radius, bird)
	for(var/turf/T in turfs)
		if(is_valid_target(T, bird_flock))
			options += T

	return get_best_target_by_distance_score(controller, options)

/datum/ai_behavior/find_flock_conversion_target/proc/is_valid_target(turf/T, datum/flock/bird_flock)
	if(isflockturf(T))
		return FALSE

	#warn TEMP: NO WALLS YET
	if(!isfloorturf(T))
		return FALSE

	if(isnull(bird_flock))
		return TRUE

	return bird_flock.is_turf_free(T)

/datum/ai_behavior/find_flock_conversion_target/perform(delta_time, datum/ai_controller/controller, ...)
	var/turf/target = get_target(controller)
	if(!target)
		return BEHAVIOR_PERFORM_FAILURE
	controller.set_blackboard_key(BB_FLOCK_CONVERT_TARGET, target)
	controller.set_move_target(target)

	var/mob/living/simple_animal/flock/bird = controller.pawn
	if(bird.flock)
		bird.flock.reserve_turf(bird, target)

	return BEHAVIOR_PERFORM_SUCCESS

/datum/ai_behavior/find_flock_conversion_target/next_behavior(datum/ai_controller/controller, success)
	if(success)
		controller.queue_behavior(/datum/ai_behavior/perform_flock_conversion)

/datum/ai_behavior/perform_flock_conversion
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT

/datum/ai_behavior/perform_flock_conversion/perform(delta_time, datum/ai_controller/controller, ...)
	var/mob/living/simple_animal/flock/bird = controller.pawn
	var/turf/target = controller.blackboard[BB_FLOCK_CONVERT_TARGET]
	if(target)
		controller.clear_blackboard_key(BB_FLOCK_CONVERT_TARGET)
		var/datum/action/cooldown/flock/convert/convert_action = locate() in bird.actions
		spawn(-1)
			convert_action.Trigger(target = target)

	if(DOING_INTERACTION(bird, "flock_convert"))
		return BEHAVIOR_PERFORM_COOLDOWN

	return BEHAVIOR_PERFORM_SUCCESS

/datum/ai_behavior/perform_flock_conversion/finish_action(datum/ai_controller/controller, succeeded, ...)
	. = ..()
	controller.clear_blackboard_key(BB_FLOCK_CONVERT_TARGET)
