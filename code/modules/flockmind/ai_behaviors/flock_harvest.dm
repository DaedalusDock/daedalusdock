/datum/ai_behavior/flock/find_harvest_target
	name = "harvesting"
	goap_weight = FLOCK_BEHAVIOR_WEIGHT_HARVEST

/datum/ai_behavior/flock/find_harvest_target/goap_precondition(datum/ai_controller/controller)
	var/mob/living/simple_animal/flock/drone/bird = controller.pawn
	var/datum/flockdrone_part/absorber/absorber = locate() in bird.parts
	return !absorber.held_item

/datum/ai_behavior/flock/find_harvest_target/goap_score(datum/ai_controller/controller)
	return score_distance(controller, get_target(controller))

/datum/ai_behavior/flock/find_harvest_target/proc/get_target(datum/ai_controller/controller, path_to = FALSE)
	var/mob/living/simple_animal/flock/bird = controller.pawn

	var/list/options = list()
	for(var/obj/item/I in view(controller.max_target_distance, bird))
		if(isturf(I.loc))
			options += I

	return get_best_target_by_distance_score(controller, options, path_to)

/datum/ai_behavior/flock/find_harvest_target/perform(delta_time, datum/ai_controller/controller)
	..()
	var/atom/target = get_target(controller, TRUE)
	if(!target)
		return BEHAVIOR_PERFORM_FAILURE

	controller.set_blackboard_key(BB_FLOCK_HARVEST_TARGET, target)
	controller.set_move_target(target)
	return BEHAVIOR_PERFORM_SUCCESS

/datum/ai_behavior/flock/find_harvest_target/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	controller.clear_blackboard_key(BB_PATH_TO_USE)

/datum/ai_behavior/flock/find_harvest_target/next_behavior(datum/ai_controller/controller, success)
	if(success)
		controller.queue_behavior(/datum/ai_behavior/flock/perform_harvest)

/datum/ai_behavior/flock/perform_harvest
	name = "harvesting"
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH

/datum/ai_behavior/flock/perform_harvest/perform(delta_time, datum/ai_controller/controller, ...)
	..()
	var/mob/living/simple_animal/flock/drone/bird = controller.pawn
	var/obj/item/target = controller.blackboard[BB_FLOCK_HARVEST_TARGET]
	if(!isturf(target?.loc))
		return BEHAVIOR_PERFORM_FAILURE

	var/datum/flockdrone_part/absorber/absorber = locate() in bird.parts
	if(!absorber.try_pickup_item(target))
		return BEHAVIOR_PERFORM_FAILURE

	return BEHAVIOR_PERFORM_SUCCESS

/datum/ai_behavior/flock/perform_harvest/finish_action(datum/ai_controller/controller, succeeded, ...)
	. = ..()
	controller.clear_blackboard_key(BB_FLOCK_HARVEST_TARGET)

