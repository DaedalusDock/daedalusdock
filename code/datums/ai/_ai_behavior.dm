///Abstract class for an action an AI can take, can range from movement to grabbing a nearby weapon.
/datum/ai_behavior
	///What distance you need to be from the target to perform the action
	var/required_distance = 1
	///Flags for extra behavior
	var/behavior_flags = NONE
	///Cooldown between actions performances, defaults to the value of CLICK_CD_MELEE because that seemed like a nice standard for the speed of AI behavior
	var/action_cooldown = CLICK_CD_MELEE

	/// Behaviors to add upon a successful setup
	var/list/sub_behaviors

/// Called by the ai controller when first being added. Additional arguments depend on the behavior type.
/// Return FALSE to cancel
/datum/ai_behavior/proc/setup(datum/ai_controller/controller, ...)
	return TRUE

///Called by the AI controller when this action is performed
/datum/ai_behavior/proc/perform(delta_time, datum/ai_controller/controller, ...)
	return NONE

/// Returns a behavior to perform after this one, or null if continuing this one
/datum/ai_behavior/proc/next_behavior(datum/ai_controller/controller, success)
	return null

/// Returns a numerical value that is essentially a priority for planner behaviors.
/datum/ai_behavior/proc/score(datum/ai_controller/controller)
	return BEHAVIOR_SCORE_DEFAULT

/datum/ai_behavior/proc/get_best_target_by_distance_score(datum/ai_controller/controller, list/targets)
	if(!length(targets))
		return null

	var/atom/movable/pawn = controller.pawn
	var/list/access = controller.get_access()

	var/best_score = -INFINITY
	var/atom/ideal_atom = null

	for(var/atom/A as anything in targets)
		var/atom_basic_score = score_distance(controller, A)
		if(atom_basic_score < best_score)
			continue

		if(A.IsReachableBy(pawn))
			best_score = atom_basic_score
			ideal_atom = A
			continue

		var/list/path = SSpathfinder.pathfind_now(
			controller.pawn,
			A,
			controller.max_target_distance,
			required_distance,
			access,
			HAS_TRAIT(controller.pawn, TRAIT_FREE_FLOAT_MOVEMENT),
		)

		if(length(path))
			best_score = atom_basic_score
			ideal_atom = A

	return ideal_atom

/// Helper for scoring something based on the distance between it and the pawn.
/datum/ai_behavior/proc/score_distance(datum/ai_controller/controller, atom/target)
	var/search_radius = controller.target_search_radius
	if(isnull(target))
		return -INFINITY
	return 100 * (search_radius - get_dist_manhattan(get_turf(controller.pawn), get_turf(target))) / search_radius

/// Returns the delay to use for this behavior in the moment
/// Override to return a conditional delay
/datum/ai_behavior/proc/get_cooldown(datum/ai_controller/cooldown_for)
	return action_cooldown

///Called when the action is finished. This needs the same args as perform besides the default ones
/datum/ai_behavior/proc/finish_action(datum/ai_controller/controller, succeeded, ...)
	LAZYREMOVE(controller.current_behaviors, src)
	controller.behavior_args -= type

	if(behavior_flags & AI_BEHAVIOR_REQUIRE_MOVEMENT) //If this was a movement task, reset our movement target if necessary
		if(!(behavior_flags & AI_BEHAVIOR_KEEP_MOVE_TARGET_ON_FINISH))
			controller.set_move_target(null)
		if(!(behavior_flags & AI_BEHAVIOR_KEEP_MOVING_TOWARDS_TARGET_ON_FINISH))
			controller.ai_movement.stop_moving_towards(controller)

	next_behavior(controller, succeeded)
