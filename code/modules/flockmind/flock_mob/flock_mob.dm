/mob/living/simple_animal/flock
	name = "flockdrone"
	icon = 'goon/icons/mob/featherzone.dmi'
	icon_state = "drone"
	icon_living = "drone"
	icon_dead = "drone-dead"

	pass_flags_self = parent_type::pass_flags_self | PASSFLOCK

	light_system = OVERLAY_LIGHT
	light_color = "#26ffe6"
	light_power = 0.2
	light_outer_range = 2

	ai_controller = /datum/ai_controller/flock

	initial_language_holder = /datum/language_holder/flock

	minbodytemp = 0
	maxbodytemp = 1000
	atmos_requirements = list(
		"min_oxy" = 0,
		"max_oxy" = 0,
		"min_plas" = 0,
		"max_plas" = 0,
		"min_co2" = 0,
		"max_co2" = 0,
		"min_n2" = 0,
		"max_n2" = 0
	)


	stop_automated_movement = TRUE
	movement_type = FLOATING

	/// Flock datum. Can be null.
	var/datum/flock/flock

/mob/living/simple_animal/flock/Initialize(mapload, join_flock)
	. = ..()
	update_light_state()
	RegisterSignal(ai_controller, COMSIG_AI_STATUS_CHANGE, PROC_REF(on_ai_status_change))

	var/datum/action/cooldown/flock/convert/convert_action = new
	convert_action.Grant(src)
	set_combat_mode(TRUE)
	ADD_TRAIT(src, TRAIT_FREE_FLOAT_MOVEMENT, INNATE_TRAIT)
	flock = join_flock || GLOB.debug_flock

/mob/living/simple_animal/flock/Destroy()
	flock?.free_unit(src)
	flock = null
	return ..()

/mob/living/simple_animal/flock/set_stat(new_stat)
	. = ..()
	switch(stat)
		if(CONSCIOUS)
			ADD_TRAIT(src, TRAIT_MOVE_FLOATING, STAT_TRAIT)
		else
			REMOVE_TRAIT(src, TRAIT_MOVE_FLOATING, STAT_TRAIT)

/mob/living/simple_animal/flock/say(message, bubble_type, list/spans, sanitize, datum/language/language, ignore_spam, forced, filterproof, range)
	. = ..()
	if(!.)
		return

	language = GET_LANGUAGE_DATUM(language) || get_selected_language()
	if(flock && istype(language, /datum/language/flock))
		flock_talk(src, message, flock, forced)

// changing the default arg value here
/mob/living/simple_animal/flock/treat_message(message, correct_grammar = FALSE)
	. = ..()

/mob/living/simple_animal/flock/get_flock_id()
	return real_name

/mob/living/simple_animal/flock/proc/get_flock_data()
	var/list/data = list()
	data["name"] = real_name
	data["health"] = getHealthPercent()

	data["area"] = get_area_name(src, TRUE) || "???"
	return data

/// Turn the light on or off, based on if the mob is doing shit or not.
/mob/living/simple_animal/flock/proc/update_light_state()
	if(stat == DEAD)
		set_light_on(FALSE)
		return

	if(ai_controller.ai_status == AI_ON || ckey)
		set_light_on(TRUE)
		return

	set_light_on(FALSE)

/mob/living/simple_animal/flock/proc/on_ai_status_change(datum/ai_controller/source, ai_status)
	SIGNAL_HANDLER
	update_light_state()
