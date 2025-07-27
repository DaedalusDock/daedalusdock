/datum/status_effect/noir
	id = "noirmode"
	tick_interval = -1

	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null

/datum/status_effect/noir/on_apply()
	. = ..()
	owner.add_client_colour(/datum/client_colour/monochrome/noir)
	owner.mob_mood.add_mood_event("noir", /datum/mood_event/detective_noir)

/datum/status_effect/noir/on_remove()
	. = ..()
	owner.remove_client_colour(/datum/client_colour/monochrome/noir)
	owner.mob_mood.clear_mood_event("noir")

/// Noir-in-area, removed if the user leaves the given area.
/datum/status_effect/noir_in_area
	id = "noirinarea"
	tick_interval = -1

	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null

	var/area/noir_area

/datum/status_effect/noir_in_area/on_creation(mob/living/new_owner, area/tracked_area)
	. = ..()
	if(!.)
		return

	noir_area = tracked_area

/datum/status_effect/noir_in_area/on_apply()
	. = ..()
	owner.add_client_colour(/datum/client_colour/monochrome/noir)
	owner.mob_mood.add_mood_event("forcednoir", /datum/mood_event/noir_victim)
	RegisterSignal(owner, COMSIG_ENTER_AREA, PROC_REF(owner_entered_area))

	var/datum/roll_result/result = owner.stat_roll(15, /datum/rpg_skill/willpower)
	switch(result.outcome)
		if(FAILURE, CRIT_FAILURE)
			owner.apply_status_effect(/datum/status_effect/skill_mod/intimidated)
			if(istype(owner.buckled, /obj/structure/chair))
				RegisterSignal(owner.buckled, COMSIG_MOVABLE_PRE_UNBUCKLE_MOB, PROC_REF(on_unbuckle_attempt))
				RegisterSignal(owner.buckled, COMSIG_MOVABLE_UNBUCKLE, PROC_REF(on_unbuckle))
				RegisterSignal(owner, list(COMSIG_PARENT_ATTACKBY, COMSIG_ATOM_GET_GRABBED, COMSIG_HUMAN_DISARM_HIT, COMSIG_ATOM_ATTACK_HAND), PROC_REF(on_owner_attack))

			if(owner.stats.cooldown_finished("noir_intimidation"))
				owner.stats.set_cooldown("noir_intimidation", INFINITY)
				result.do_skill_sound(owner)
				to_chat(owner, result.create_tooltip("A heavy fog rolls in, and the shadows grow louder. You have entered the lion's den."))

/datum/status_effect/noir_in_area/on_remove()
	. = ..()
	owner.remove_status_effect(/datum/status_effect/skill_mod/intimidated)
	owner.remove_client_colour(/datum/client_colour/monochrome/noir)
	owner.mob_mood.clear_mood_event("forcednoir")
	clear_intimidation_signals(owner.buckled)

/datum/status_effect/noir_in_area/proc/clear_intimidation_signals(atom/movable/buckled_to)
	if(buckled_to)
		UnregisterSignal(buckled_to, list(COMSIG_MOVABLE_PRE_UNBUCKLE_MOB, COMSIG_MOVABLE_UNBUCKLE))
	UnregisterSignal(owner, list(COMSIG_ENTER_AREA, COMSIG_PARENT_ATTACKBY, COMSIG_ATOM_GET_GRABBED, COMSIG_HUMAN_DISARM_HIT, COMSIG_ATOM_ATTACK_HAND))

/datum/status_effect/noir_in_area/proc/owner_entered_area(datum/source, area/entered)
	SIGNAL_HANDLER

	if(entered != noir_area)
		qdel(src)

/datum/status_effect/noir_in_area/proc/on_unbuckle_attempt(datum/source, mob/buckled)
	SIGNAL_HANDLER
	if(buckled != owner)
		return

	to_chat(buckled, span_statsbad("You are pinned to [source] by the gravitational force of the Detective."))

/datum/status_effect/noir_in_area/proc/on_unbuckle(datum/source, mob/buckled, force)
	SIGNAL_HANDLER
	clear_intimidation_signals(source)

/// If the owner is possibly attacked in anyway, free them from the chair.
/datum/status_effect/noir_in_area/proc/on_owner_attack(datum/source)
	SIGNAL_HANDLER

	clear_intimidation_signals(owner.buckled)
