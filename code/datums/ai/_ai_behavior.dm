///Abstract class for an action an AI can take, can range from movement to grabbing a nearby weapon.
/datum/ai_behavior
	///What distance you need to be from the target to perform the action
	var/required_distance = 1
	///Flags for extra behavior
	var/behavior_flags = NONE
	///Cooldown between actions performances, defaults to the value of CLICK_CD_MELEE because that seemed like a nice standard for the speed of AI behavior
	var/action_cooldown = CLICK_CD_MELEE

	/// A multiplier applied to the behavior's goap_score().
	var/goap_weight = 1

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

/// Executed before goap_score(), to see if the behavior should even be considered.
/datum/ai_behavior/proc/goap_precondition(datum/ai_controller/controller)
	return TRUE

/// Returns a numerical value that is essentially a priority for planner behaviors.
/datum/ai_behavior/proc/goap_score(datum/ai_controller/controller)
	return BEHAVIOR_SCORE_DEFAULT

#define BINARY_INSERT_TARGET(target_list, target, score) \
	do { \
		var/length = length(target_list); \
		if(!length) { \
			target_list[target] = score; \
		} else { \
			var/left = 1; \
			var/right = length; \
			var/middle = (left + right) >> 1; \
			while(left < right) { \
				if(target_list[target_list[middle]] <= score) { \
					left = middle + 1; \
				} else { \
					right = middle; \
				}; \
				middle = (left + right) >> 1; \
			}; \
			middle = target_list[target_list[middle]] > score ? middle : middle + 1; \
			target_list.Insert(middle, target); \
			target_list[target] = score; \
		}; \
	} while(FALSE)

/// Returns the best target by scoring the distance of each possible target.
/// Takes a list to insert the path into, so it can be handed back and re-used.
/datum/ai_behavior/proc/get_best_target_by_distance_score(datum/ai_controller/controller, list/targets, set_path = FALSE)
	if(!length(targets))
		return null

	var/atom/movable/pawn = controller.pawn
	var/list/access = controller.get_access()

	var/list/targets_by_score = list()
	var/list/reachable_targets = list()

	// Sort targets by their estimated score. The last element in the lists has the highest score.
	while(length(targets))
		var/index = rand(1, length(targets))
		var/atom/A = targets[index]
		targets.Cut(index, index + 1)

		var/score = score_distance(controller, A)

		BINARY_INSERT_TARGET(targets_by_score, A, score)

		// WEE WOO WEE WOO BEHAVIOR-CHANGING MICRO-OPT: we assume turfs further than 1 tile aren't reachable
		// Because this is true in 99.9999999999999999% of cases
		if(get_dist(pawn, A) <= 1 && A.IsReachableBy(pawn))
			BINARY_INSERT_TARGET(reachable_targets, A, score)

	// Go through our sorted target list until we find a path to one.
	// Note: This does mean that the found target might not be the ideal one, as it's operating on the estimate
	// This is a performance thing. We cannot actually use the true best target.
	var/atom/ideal_atom
	var/list/ideal_path
	if(length(reachable_targets))
		ideal_atom = reachable_targets[length(reachable_targets)]
	else
		while(length(targets_by_score))
			var/atom/candidate = targets_by_score[length(targets_by_score)]
			targets_by_score.len--

			var/list/path = SSpathfinder.astar_pathfind_now(
				controller.pawn,
				candidate,
				controller.max_target_distance,
				required_distance,
				access,
				HAS_TRAIT(controller.pawn, TRAIT_FREE_FLOAT_MOVEMENT),
			)

			if(path)
				ideal_atom = candidate
				ideal_path = path
				break

	if(set_path && length(ideal_path))
		controller.set_blackboard_key(BB_PATH_TO_USE, ideal_path)
	return ideal_atom

#undef BINARY_INSERT_TARGET

/// Helper for scoring something based on the distance between it and the pawn.
/// By default, returns a value between 100 and -INFINITY, where 100 is a distance of 0 steps.
/// A distance equal to target_search_radius is zero.
/// A distance greater than target_search_radius is negative.
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
