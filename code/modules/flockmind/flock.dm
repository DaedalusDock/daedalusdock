/mob/living/simple_animal/flock
	name = "flockdrone"
	icon = 'goon/icons/mob/featherzone.dmi'
	icon_state = "drone"
	icon_living = "drone"
	icon_dead = "drone-dead"

	ai_controller = /datum/ai_controller/flock

	light_system = OVERLAY_LIGHT
	light_color = "#26ffe6"
	light_power = 0.2
	light_outer_range = 2

	stop_automated_movement = TRUE
	movement_type = FLOATING

/mob/living/simple_animal/flock/Initialize(mapload)
	. = ..()
	update_light_state()
	RegisterSignal(ai_controller, COMSIG_AI_STATUS_CHANGE, PROC_REF(on_ai_status_change))

	var/datum/action/innate/flock/convert/convert_action = new
	convert_action.Grant(src)

/mob/living/simple_animal/flock/set_stat(new_stat)
	. = ..()
	switch(stat)
		if(CONSCIOUS)
			REMOVE_TRAIT(src, TRAIT_NO_FLOATING_ANIM, INNATE_TRAIT)
		else
			ADD_TRAIT(src, TRAIT_NO_FLOATING_ANIM, INNATE_TRAIT)

/mob/living/simple_animal/flock/proc/on_ai_status_change(datum/ai_controller/source, ai_status)
	SIGNAL_HANDLER
	update_light_state()

/// Turn the light on or off, based on if the mob is doing shit or not.
/mob/living/simple_animal/flock/proc/update_light_state()
	if(stat == DEAD)
		set_light_on(FALSE)
		return

	if(ai_controller.ai_status == AI_ON || ckey)
		set_light_on(TRUE)
		return

	set_light_on(FALSE)
