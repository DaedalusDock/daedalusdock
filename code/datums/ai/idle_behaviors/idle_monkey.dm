/datum/ai_behavior/idle_monkey/perform(delta_time, datum/ai_controller/controller)
	var/mob/living/living_pawn = controller.pawn

	if(DT_PROB(25, delta_time) && !LAZYLEN(living_pawn.grabbed_by))
		var/move_dir = pick(GLOB.alldirs)
		controller.MovePawn(get_step(living_pawn, move_dir), move_dir)

	else if(DT_PROB(5, delta_time))
		INVOKE_ASYNC(living_pawn, TYPE_PROC_REF(/mob, emote), pick("screech"))
	else if(DT_PROB(1, delta_time))
		INVOKE_ASYNC(living_pawn, TYPE_PROC_REF(/mob, emote), pick("scratch","jump","roll","tail"))

	return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_SUCCESS
