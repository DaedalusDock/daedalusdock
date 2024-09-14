/datum/ai_planning_subtree/scored/flockdrone
	possible_behaviors = list(
		/datum/ai_behavior/flock_stare,
		/datum/ai_behavior/idle_random_walk,
		/datum/ai_behavior/flock_convert
	)

/datum/ai_behavior/idle_random_walk/flock
	action_cooldown = 1 SECOND
	required_distance = 0

/datum/ai_behavior/idle_random_walk/flock/perform(delta_time, datum/ai_controller/controller, ...)
	if(!controller.blackboard[BB_FLOCK_WANDERING])
		controller.set_blackboard_key(BB_FLOCK_WANDERING,  world.time + (rand(5,7) SECONDS))

	else if(controller.blackboard[BB_FLOCK_WANDERING] <= world.time || (controller.current_movement_target == get_turf(controller.pawn)))
		return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_SUCCESS

	if(isnull(controller.current_movement_target))
		controller.ai_movement.stop_moving_towards(controller)
		var/turf/destination = get_destination(controller)
		if(isnull(destination))
			..()
			return BEHAVIOR_PERFORM_COOLDOWN

		controller.set_move_target(destination)
		controller.ai_movement.start_moving_towards(controller, controller.current_movement_target, required_distance)

	return BEHAVIOR_PERFORM_COOLDOWN

/datum/ai_behavior/idle_random_walk/flock/finish_action(datum/ai_controller/controller, succeeded, ...)
	. = ..()
	controller.set_move_target(null)
	controller.ai_movement.stop_moving_towards(controller)
	controller.clear_blackboard_key(BB_FLOCK_WANDERING)

/datum/ai_behavior/idle_random_walk/flock/proc/get_destination(datum/ai_controller/controller)
	var/datum/can_pass_info/info = new(no_id = TRUE)
	var/turf/start_loc = get_turf(controller.pawn)
	var/list/options = list()

	for(var/turf/T in RANGE_TURFS(2, controller.pawn))
		if(isspaceturf(T))
			continue

		if(T == start_loc)
			continue

		if(start_loc.LinkBlockedWithAccess(T, info))
			options += T

	return length(options) ? pick(options) : null

/datum/ai_behavior/flock_stare

/datum/ai_behavior/flock_stare/score(datum/ai_controller/controller)
	if(controller.behavior_cooldowns[src] > world.time)
		return 0

	return length(get_targets(controller)) > 0

/datum/ai_behavior/flock_stare/get_cooldown(datum/ai_controller/cooldown_for)
	return rand(2, 3) MINUTES

/datum/ai_behavior/flock_stare/proc/get_targets(datum/ai_controller/controller)
	. = list()
	for(var/mob/living/viewer in viewers(controller.pawn, controller.target_search_radius))
		if(isteshari(viewer) || isvox(viewer) || istype(viewer, /mob/living/simple_animal/parrot))
			. += viewer

/datum/ai_behavior/flock_stare/perform(delta_time, datum/ai_controller/controller, ...)
	var/list/targets = get_targets(controller)
	if(length(targets))
		controller.set_blackboard_key(BB_FLOCK_STARE_TARGET, pick(targets))
		return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_SUCCESS

	return BEHAVIOR_PERFORM_FAILURE

/datum/ai_behavior/flock_stare/next_behavior(datum/ai_controller/controller, success)
	if(success)
		return controller.queue_behavior(/datum/ai_behavior/stare_at_bird)

/datum/ai_behavior/stare_at_bird
	action_cooldown = 1 SECOND

/datum/ai_behavior/stare_at_bird/perform(delta_time, datum/ai_controller/controller, ...)
	var/mob/living/living_pawn = controller.pawn
	if(!controller.blackboard[BB_FLOCK_STARING_ACTIVE])
		controller.set_blackboard_key(BB_FLOCK_STARING_ACTIVE, world.time + (10 SECONDS))

		if(prob(30))
			living_pawn.manual_emote("whistles.")

	if(!controller.blackboard[BB_FLOCK_STARE_TARGET])
		return BEHAVIOR_PERFORM_SUCCESS

	if(!can_see(living_pawn,controller.blackboard[BB_FLOCK_STARE_TARGET]))
		return BEHAVIOR_PERFORM_SUCCESS

	if(controller.blackboard[BB_FLOCK_STARING_ACTIVE] <= world.time)
		return BEHAVIOR_PERFORM_SUCCESS

	living_pawn.face_atom(controller.blackboard[BB_FLOCK_STARE_TARGET])
	return BEHAVIOR_PERFORM_COOLDOWN

/datum/ai_behavior/stare_at_bird/finish_action(datum/ai_controller/controller, succeeded, ...)
	. = ..()
	controller.clear_blackboard_key(BB_FLOCK_STARING_ACTIVE)
	controller.clear_blackboard_key(BB_FLOCK_STARE_TARGET)
