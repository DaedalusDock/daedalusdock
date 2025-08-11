/*
 * A note on how simplemob movespeed works.
 * With a movement_speed_modifier value of 0, simple mobs move at the same speed as a running human.
 * movement_speed_modifier adjusts the number of tiles moved per second.
 * Please use actual movespeed modifiers and not that var.
*/
/mob/living/simple_animal/apply_initial_movespeed()
	. = ..()
	// By default, simple animals should move as fast as players on run intent.
	add_movespeed_modifier(/datum/movespeed_modifier/move_intent/run)

/// Update the simple variable movement delay value
/mob/living/simple_animal/proc/set_simple_movespeed_modifier(var_value)
	movement_speed_modifier = var_value
	update_simple_move_delay()

/mob/living/simple_animal/proc/update_simple_move_delay()
	if(movement_speed_modifier == 0)
		remove_movespeed_modifier(/datum/movespeed_modifier/simplemob_varspeed)
		return

	add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/simplemob_varspeed, modifier = movement_speed_modifier)
