/datum/flock_unlockable
	abstract_type = /datum/flock_unlockable

	// auto populated field
	var/name
	// auto populated field
	var/purchase_cost

	var/obj/structure/flock/structure_type

	var/unlocked = FALSE

/datum/flock_unlockable/New()
	name = initial(structure_type.flock_id)
	purchase_cost = initial(structure_type.active_compute_cost)

/datum/flock_unlockable/proc/refresh_lock_status(datum/flock/flock, total_compute, available_compute)
	if(is_unlockable())
		if(!unlocked)
			unlock(flock)

	else if(unlocked)
		lock()

/datum/flock_unlockable/proc/is_unlockable(datum/flock/flock, total_compute, available_compute)
	return TRUE

/datum/flock_unlockable/proc/unlock(datum/flock/flock)
	unlocked = TRUE
	flock_talk(null, "New structure devised: [name]", src)

/datum/flock_unlockable/proc/lock(datum/flock/flock)
	unlocked = FALSE
	flock_talk(null, "Alert, structure tealprint disabled: [name]", src)

/datum/flock_unlockable/sentinel
	structure_type = /obj/structure/flock/sentinel
