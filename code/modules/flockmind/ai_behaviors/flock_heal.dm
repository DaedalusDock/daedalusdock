/datum/ai_behavior/flock/find_heal_target
	name = "repairing"

/datum/ai_behavior/flock/find_heal_target/score(datum/ai_controller/controller)
	var/mob/living/simple_animal/flock/drone/bird = controller.pawn
	if(!bird.flock)
		return -INFINITY
	return 4 * score_distance(controller, get_best_target_by_distance_score(controller, get_targets(controller)))

/datum/ai_behavior/flock/find_heal_target/proc/get_targets(datum/ai_controller/controller)
	. = list()
	var/mob/living/simple_animal/flock/drone/this_bird = controller.pawn
	for(var/mob/living/simple_animal/flock/drone/bird in oview(controller.target_search_radius, controller.pawn))
		if(bird.flock != this_bird.flock)
			continue
		if(bird.stat == DEAD)
			continue

		// Birds at or below 60% health
		if((bird.getBruteLoss() + bird.getFireLoss()) / bird.maxHealth >= 0.4)
			. += bird

/datum/ai_behavior/flock/find_heal_target/perform(delta_time, datum/ai_controller/controller, ...)
	var/target = get_best_target_by_distance_score(controller, get_targets(controller))
	if(!target)
		return BEHAVIOR_PERFORM_FAILURE

	controller.set_blackboard_key(BB_FLOCK_HEAL_TARGET, target)
	controller.set_move_target(target)
	return BEHAVIOR_PERFORM_SUCCESS

/datum/ai_behavior/flock/find_heal_target/next_behavior(datum/ai_controller/controller, success)
	if(success)
		controller.queue_behavior(/datum/ai_behavior/flock/heal)

/datum/ai_behavior/flock/heal
	name = "repairing"
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT

/datum/ai_behavior/flock/heal/perform(delta_time, datum/ai_controller/controller, ...)
	var/mob/living/simple_animal/flock/drone/bird = controller.pawn

	if(isnull(controller.blackboard[BB_FLOCK_HEAL_FRUSTRATION]))
		controller.set_blackboard_key(BB_FLOCK_HEAL_FRUSTRATION, world.time + 3 SECONDS)

	if(DOING_INTERACTION(bird, "flock_repair"))
		return BEHAVIOR_PERFORM_COOLDOWN

	var/datum/action/cooldown/flock/flock_heal/repair = locate() in bird.actions
	spawn(-1)
		repair.Trigger(target = controller.blackboard[BB_FLOCK_HEAL_TARGET])

	if(controller.blackboard[BB_FLOCK_HEAL_FRUSTRATION] >= world.time)
		return BEHAVIOR_PERFORM_COOLDOWN

	return BEHAVIOR_PERFORM_FAILURE

/datum/ai_behavior/flock/heal/finish_action(datum/ai_controller/controller, succeeded, ...)
	. = ..()
	controller.clear_blackboard_key(BB_FLOCK_HEAL_FRUSTRATION)
	controller.clear_blackboard_key(BB_FLOCK_HEAL_TARGET)
