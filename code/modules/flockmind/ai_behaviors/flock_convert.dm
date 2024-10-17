/datum/ai_behavior/flock/find_conversion_target
	name = "building"

/datum/ai_behavior/flock/find_conversion_target/setup(datum/ai_controller/controller, turf/overmind_target)
	. = ..()
	if(overmind_target)
		if(is_valid_target(overmind_target))
			controller.set_blackboard_key(BB_FLOCK_OVERMIND_CONTROL, TRUE)
			controller.set_blackboard_key(BB_PATH_MAX_LENGTH, 200)
		else
			var/mob/living/simple_animal/flock/drone/bird = controller.pawn
			bird.say("Invalid conversion target provided by sentient level instruction.")
			return FALSE

/datum/ai_behavior/flock/find_conversion_target/score(datum/ai_controller/controller)
	return score_distance(controller, get_target(controller))

/datum/ai_behavior/flock/find_conversion_target/score_distance(datum/ai_controller/controller, atom/target)
	. = ..()
	var/mob/living/simple_animal/flock/bird = controller.pawn
	if(bird.flock?.marked_for_deconstruction[target])
	/*
	* because the result of scoring is based on max distance,
	* the score of any given tile is -100 to 0, with 0 being best.
	* Adding 200 basically allows a tile at twice the max distance to be considered.
	*/
		. += 200

/datum/ai_behavior/flock/find_conversion_target/proc/get_target(datum/ai_controller/controller)
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

/datum/ai_behavior/flock/find_conversion_target/proc/is_valid_target(turf/T, datum/flock/bird_flock)
	if(isflockturf(T))
		return FALSE

	if(!T.can_flock_convert())
		return FALSE

	if(isnull(bird_flock))
		return TRUE

	return bird_flock.is_turf_free(T)

/datum/ai_behavior/flock/find_conversion_target/perform(delta_time, datum/ai_controller/controller, turf/overmind_target)
	var/turf/target = overmind_target || get_target(controller)
	if(!target)
		return BEHAVIOR_PERFORM_FAILURE

	controller.set_blackboard_key(BB_FLOCK_CONVERT_TARGET, target)
	controller.set_move_target(target)

	var/mob/living/simple_animal/flock/bird = controller.pawn
	if(bird.flock)
		bird.flock.reserve_turf(bird, target)

	return BEHAVIOR_PERFORM_SUCCESS

/datum/ai_behavior/flock/find_conversion_target/finish_action(datum/ai_controller/controller, succeeded, turf/overmind_target)
	. = ..()
	if(!succeeded && overmind_target)
		controller.clear_blackboard_key(BB_PATH_MAX_LENGTH)
		controller.clear_blackboard_key(BB_FLOCK_OVERMIND_CONTROL)

/datum/ai_behavior/flock/find_conversion_target/next_behavior(datum/ai_controller/controller, success)
	if(success)
		controller.queue_behavior(/datum/ai_behavior/flock/perform_conversion)

/datum/ai_behavior/flock/perform_conversion
	name = "building"
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT

/datum/ai_behavior/flock/perform_conversion/perform(delta_time, datum/ai_controller/controller, ...)
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

/datum/ai_behavior/flock/perform_conversion/finish_action(datum/ai_controller/controller, succeeded, ...)
	. = ..()
	var/mob/living/simple_animal/flock/drone/bird = controller.pawn
	bird.flock?.free_turf(bird)

	controller.clear_blackboard_key(BB_FLOCK_CONVERT_TARGET)
	controller.clear_blackboard_key(BB_PATH_MAX_LENGTH)
	controller.clear_blackboard_key(BB_FLOCK_OVERMIND_CONTROL)

	if(!succeeded && controller.blackboard[BB_FLOCK_OVERMIND_CONTROL] && !QDELETED(controller.pawn))
		bird.say("Unable to reach target provided by sentient level instruction, aborting subroutine.", forced = "overmind control action cancelled")

