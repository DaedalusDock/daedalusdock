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

	faction = list(FACTION_FLOCK)
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

	var/datum/point_holder/resources

	var/compute_provided = 0

/mob/living/simple_animal/flock/Initialize(mapload, join_flock)
	. = ..()
	RegisterSignal(ai_controller, COMSIG_AI_STATUS_CHANGE, PROC_REF(on_ai_status_change))

	var/datum/action/cooldown/flock/convert/convert_action = new
	convert_action.Grant(src)

	set_combat_mode(TRUE)

	ADD_TRAIT(src, TRAIT_FREE_FLOAT_MOVEMENT, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_FLOCK_THING, INNATE_TRAIT)

	flock = join_flock || get_default_flock()
	flock?.add_unit(src)

	resources = new
	resources.adjust_points(1000000)

	update_health_notice()
	update_light_state()

/mob/living/simple_animal/flock/Destroy()
	flock?.free_unit(src)
	flock = null
	return ..()

/mob/living/simple_animal/flock/set_stat(new_stat)
	. = ..()
	switch(stat)
		if(CONSCIOUS)
			ADD_TRAIT(src, TRAIT_MOVE_FLOATING, STAT_TRAIT)
			REMOVE_TRAIT(src, TRAIT_NO_FLOATING_ANIM, STAT_TRAIT)
		else
			REMOVE_TRAIT(src, TRAIT_MOVE_FLOATING, STAT_TRAIT)
			ADD_TRAIT(src, TRAIT_NO_FLOATING_ANIM, STAT_TRAIT)

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

/mob/living/simple_animal/flock/updatehealth(cause_of_death)
	. = ..()
	update_health_notice()

/mob/living/simple_animal/flock/death(gibbed, cause_of_death)
	. = ..()
	flock.remove_notice(src, FLOCK_NOTICE_HEALTH)

/mob/living/simple_animal/flock/get_flock_id()
	return real_name

/mob/living/simple_animal/flock/proc/update_health_notice()
	if(!flock)
		return

	var/datum/atom_hud/alternate_appearance/basic/flock/notice = get_alt_appearance(FLOCK_NOTICE_HEALTH)
	if(!notice)
		notice = flock.add_notice(src, FLOCK_NOTICE_HEALTH)

	var/image/I = notice.image
	I.icon_state = "hp-[getHealthPercent()]"

/mob/living/simple_animal/flock/proc/get_flock_data()
	var/list/data = list()
	data["name"] = real_name
	data["health"] = getHealthPercent()
	data["resources"] = resources.has_points()
	data["area"] = get_area_name(src, TRUE) || "???"
	data["ref"] = REF(src)
	return data

/mob/living/simple_animal/flock/proc/rally(turf/location)
	if(!isturf(location))
		return

	if(ai_controller.ai_status == AI_OFF || ckey)
		return

	ai_controller.CancelActions()
	ai_controller.queue_behavior(/datum/ai_behavior/flock/rally, location)

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

/mob/living/simple_animal/flock/vv_edit_var(var_name, var_value)
	switch(var_name)
		if(NAMEOF(src, compute_provided))
			flock?.compute.adjust_points(-compute_provided)
			..()
			flock?.compute.adjust_points(compute_provided)
			return TRUE

	return ..()
