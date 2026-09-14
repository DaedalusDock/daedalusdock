/datum/status_effect/shrouded
	id = "shrouded"
	duration = STATUS_EFFECT_PERMANENT
	tick_interval = 1 SECOND

	alert_type = null

/datum/status_effect/shrouded/on_apply()
	. = ..()
	owner.add_filter("eternity_shadower", 1, color_matrix_filter(rgb(0, 0, 0)))
	owner.add_filter("eternity_gaussian_blur", 1, gauss_blur_filter(2))
	owner.add_filter("eternity_motion_blur", 1, motion_blur_filter(0 , 0))
	ADD_TRAIT(owner, TRAIT_NO_SPRINT, "eternity")
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(on_owner_move))

	to_chat(owner, span_warning("A chill washes over your body as you step into the mist."))

/datum/status_effect/shrouded/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	owner.remove_filter(list("eternity_shadower", "eternity_gaussian_blur", "eternity_motion_blur"))
	REMOVE_TRAIT(owner, TRAIT_NO_SPRINT, "eternity")

/datum/status_effect/shrouded/proc/on_owner_move()
	SIGNAL_HANDLER

	if(!istype(get_turf(owner), /turf/open/indestructible/shroud))
		qdel(src)
