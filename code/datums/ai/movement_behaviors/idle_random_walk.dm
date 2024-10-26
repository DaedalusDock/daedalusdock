/datum/ai_behavior/idle_random_walk
	action_cooldown = 1 SECOND
	///Chance that the mob random walks per second
	var/walk_chance = 25

/datum/ai_behavior/idle_random_walk/perform(delta_time, datum/ai_controller/controller, ...)
	var/mob/living/living_pawn = controller.pawn

	if(DT_PROB(walk_chance, delta_time) && !LAZYLEN(living_pawn.grabbed_by))
		var/move_dir = pick(GLOB.alldirs)
		controller.MovePawn(get_step(living_pawn, move_dir), move_dir)

	return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_SUCCESS

/datum/ai_behavior/idle_random_walk/score(datum/ai_controller/controller)
	return 1
