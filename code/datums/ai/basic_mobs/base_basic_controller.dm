/datum/ai_controller/basic_controller
	non_mob_movement_delay = 0.4 SECONDS

/datum/ai_controller/basic_controller/TryPossessPawn(atom/new_pawn)
	if(!isbasicmob(new_pawn))
		return AI_CONTROLLER_INCOMPATIBLE
	return ..() //Run parent at end


/datum/ai_controller/basic_controller/able_to_run()
	. = ..()
	if(isliving(pawn))
		var/mob/living/living_pawn = pawn
		if(IS_DEAD_OR_INCAP(living_pawn))
			return FALSE
	return TRUE
