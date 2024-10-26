/mob/camera/flock/trace
	name = "Flocktrace"
	desc = "The representation of a partition of the will of the flockmind."
	icon_state = "flocktrace"
	base_icon_state = "flocktrace"

	actions_to_grant = list(
		/datum/action/cooldown/flock/gatecrash,
		/datum/action/cooldown/flock/designate_tile,
		/datum/action/cooldown/flock/designate_enemy,
		/datum/action/cooldown/flock/designate_ignore,
		/datum/action/cooldown/flock/ping,
	)

	var/compute_provided = -FLOCK_COMPUTE_COST_FLOCKTRACE

/mob/camera/flock/trace/Initialize(mapload, join_flock)
	. = ..()
	set_real_name(flock_realname(FLOCK_TYPE_TRACE))
	flock.add_unit(src)
	flock.stat_traces_made++

/mob/camera/flock/trace/Destroy()
	flock?.free_unit(src)
	return ..()

/mob/camera/flock/trace/vv_edit_var(var_name, var_value)
	switch(var_name)
		if(NAMEOF(src, compute_provided))
			flock?.compute.adjust_points(-compute_provided)
			..()
			flock?.compute.adjust_points(compute_provided)
			return TRUE

	return ..()
