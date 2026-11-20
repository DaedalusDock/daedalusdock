/datum/ai_controller/flock
	planning_subtrees = list(
		/datum/ai_planning_subtree/goap/flock
	)

	ai_movement = /datum/ai_movement/astar

/datum/ai_controller/flock/on_movement_target_delete(atom/source)
	SIGNAL_HANDLER
	// ChangeTurf() qdels the old turf, but the turf ref stays valid. Converting or deconstructing the turf
	// we're moving to must not drop the move target, or the behavior fails right as it finishes its work.
	if(isturf(source))
		return
	return ..()

/datum/ai_controller/flock/drone
	planning_subtrees = list(
		/datum/ai_planning_subtree/goap/flockdrone
	)
