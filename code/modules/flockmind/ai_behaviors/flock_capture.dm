/datum/ai_behavior/flock/find_capture_target
	name = "capturing"
	goap_weight = FLOCK_BEHAVIOR_WEIGHT_CAPTURE

/datum/ai_behavior/flock/find_capture_target/setup(datum/ai_controller/controller, mob/overmind_target)
	. = ..()
	if(overmind_target)
		var/mob/living/simple_animal/flock/drone/bird = controller.pawn
		if(isturf(overmind_target.loc))
			controller.set_blackboard_key(BB_FLOCK_OVERMIND_CONTROL, TRUE)
			controller.set_blackboard_key(BB_PATH_MAX_LENGTH, 200)
			bird.say("instruction confirmed: capture biological lifeform")
		else
			bird.say("invalid capture target provided by sentient-level instruction")
			return FALSE

/datum/ai_behavior/flock/find_capture_target/goap_precondition(datum/ai_controller/controller)
	var/mob/living/simple_animal/flock/drone/bird = controller.pawn
	return length(bird.flock?.enemies)

/datum/ai_behavior/flock/find_capture_target/goap_score(datum/ai_controller/controller)
	return score_distance(controller, get_target(controller))

/datum/ai_behavior/flock/find_capture_target/proc/get_target(datum/ai_controller/controller, path_to = FALSE)
	var/mob/living/simple_animal/flock/bird = controller.pawn

	var/list/options = list()
	for(var/mob/living/enemy in bird.flock.enemies)
		if(is_valid_target(enemy))
			options += enemy

	return get_best_target_by_distance_score(controller, options, path_to)

/datum/ai_behavior/flock/find_capture_target/proc/is_valid_target(mob/living/target)
	return target.incapacitated(IGNORE_STASIS | IGNORE_GRAB | IGNORE_RESTRAINTS) && isturf(target.loc)

/datum/ai_behavior/flock/find_capture_target/perform(delta_time, datum/ai_controller/controller, mob/overmind_target)
	..()
	var/atom/target = overmind_target || get_target(controller, TRUE)
	if(!target)
		return BEHAVIOR_PERFORM_FAILURE

	controller.set_blackboard_key(BB_FLOCK_CAPTURE_TARGET, target)
	controller.set_move_target(target)
	return BEHAVIOR_PERFORM_SUCCESS

/datum/ai_behavior/flock/find_capture_target/finish_action(datum/ai_controller/controller, succeeded, obj/item/overmind_target)
	. = ..()
	controller.clear_blackboard_key(BB_PATH_TO_USE)

	if(!succeeded && overmind_target)
		controller.clear_blackboard_key(BB_PATH_MAX_LENGTH)
		controller.clear_blackboard_key(BB_FLOCK_OVERMIND_CONTROL)

/datum/ai_behavior/flock/find_capture_target/next_behavior(datum/ai_controller/controller, success)
	if(success)
		controller.queue_behavior(/datum/ai_behavior/flock/perform_capture)

/datum/ai_behavior/flock/perform_capture
	name = "capturing"
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH

/datum/ai_behavior/flock/perform_capture/perform(delta_time, datum/ai_controller/controller, ...)
	..()
	var/mob/living/simple_animal/flock/drone/bird = controller.pawn
	var/mob/living/target = controller.blackboard[BB_FLOCK_CAPTURE_TARGET]
	if(!isturf(target?.loc) || !target.incapacitated(IGNORE_GRAB | IGNORE_RESTRAINTS | IGNORE_STASIS))
		return BEHAVIOR_PERFORM_FAILURE

	controller.clear_blackboard_key(BB_FLOCK_CAPTURE_TARGET)
	var/datum/action/cooldown/flock/cage_mob/cage_action = locate() in bird.actions
	spawn(-1)
		cage_action.Trigger(target = target)

	if(DOING_INTERACTION(bird, "flock_cage"))
		return BEHAVIOR_PERFORM_COOLDOWN

	return BEHAVIOR_PERFORM_SUCCESS

/datum/ai_behavior/flock/perform_capture/finish_action(datum/ai_controller/controller, succeeded, ...)
	. = ..()
	controller.clear_blackboard_key(BB_FLOCK_CAPTURE_TARGET)


	if(!succeeded && controller.blackboard[BB_FLOCK_OVERMIND_CONTROL] && !QDELETED(controller.pawn))
		var/mob/living/simple_animal/flock/bird = controller.pawn
		bird.say("unable to reach target provided by sentient level instruction, aborting subroutine", forced = "overmind control action cancelled")

	controller.clear_blackboard_key(BB_PATH_MAX_LENGTH)
	controller.clear_blackboard_key(BB_FLOCK_OVERMIND_CONTROL)
