/*
 * A note on how simplemob movespeed works.
 * With a move_delay_modifier value of 0, simple mobs move at the same speed as a running human.
 * move_delay_modifier adds to the delay between steps.
 * Please use actual movespeed modifiers and not that var.
*/
/mob/living/simple_animal/update_config_movespeed()
	. = ..()
	// By default, simple animals should move as fast as players on run intent.
	add_movespeed_modifier(/datum/movespeed_modifier/config_walk_run/run)

/// Update the simple variable movement delay value
/mob/living/simple_animal/proc/set_simple_move_delay(var_value)
	move_delay_modifier = var_value
	update_simple_move_delay()

/mob/living/simple_animal/proc/update_simple_move_delay()
	if(move_delay_modifier == 0)
		remove_movespeed_modifier(/datum/movespeed_modifier/simplemob_varspeed)
		return

	add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/simplemob_varspeed, slowdown = move_delay_modifier)
