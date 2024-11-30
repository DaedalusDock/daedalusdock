/datum/ai_behavior/flock
	/// The name of the behavior in the UI for flock drones.
	var/name = ""

/datum/ai_behavior/flock/finish_action(datum/ai_controller/controller, succeeded, ...)
	. = ..()
	if(HAS_TRAIT(controller.pawn, TRAIT_FLOCKPHASE))
		var/mob/living/simple_animal/flock/drone/bird = controller.pawn
		bird.stop_flockphase()
