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

/mob/camera/flock/trace/Initialize(mapload, join_flock)
	. = ..()
	set_real_name(flock_realname(FLOCK_TYPE_TRACE))
	flock.add_unit(src)
	flock.stat_traces_made++
