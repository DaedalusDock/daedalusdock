/datum/flock
	var/name = "BAD FLOCK"

	/// The master of the flock
	var/mob/camera/flock/overmind/overmind

	/// A k:V list of atoms to be deconstructed, where the value is TRUE.
	var/list/marked_for_deconstruction = list()
	/// A k:V list of reserved_turf = TRUE.
	var/list/turf_reservations = list()
	/// A k:V list of flock mobs to their reserved turf.
	var/list/turf_reservations_by_flock = list()
	/// The drones
	var/list/drones = list()

	/// A k:v list of mob : details, contains enemy mobs.
	var/list/enemies = list()

/datum/flock/proc/reserve_turf(mob/living/simple_animal/flock/user, turf/target)
	if(turf_reservations_by_flock[user])
		return FALSE
	if(turf_reservations[target])
		return FALSE

	turf_reservations_by_flock[user] = target
	turf_reservations[target] = user
	RegisterSignal(target, COMSIG_TURF_CHANGE, PROC_REF(reserved_turf_change))
	return TRUE

/datum/flock/proc/free_turf(mob/living/simple_animal/flock/user, turf/override_turf)
	var/turf/to_free
	if(user)
		to_free = turf_reservations_by_flock[user]
	else
		user = turf_reservations[override_turf]
		if(isnull(user))
			return

		to_free = override_turf

	turf_reservations_by_flock -= user
	turf_reservations -= to_free
	UnregisterSignal(to_free, COMSIG_TURF_CHANGE)

/datum/flock/proc/is_turf_free(turf/T)
	return turf_reservations[T]

/datum/flock/proc/add_unit(mob/unit)
	if(istype(unit, /mob/living/simple_animal/flock/drone))
		drones += unit
		RegisterSignal(unit, list(COMSIG_PARENT_QDELETING, COMSIG_LIVING_DEATH), PROC_REF(on_unit_death))

/datum/flock/proc/register_overmind(mob/camera/flock_overmind)
	overmind = flock_overmind

/datum/flock/proc/update_enemy(mob/living/enemy)
	if(!istype(enemy))
		return FALSE

	// if(is_mob_ignored(enemy))
	// 	return FALSE

	for(var/mob/living/L in enemy.buckled_mobs)
		update_enemy(enemy)

	enemies[enemy] = get_area_name(enemy)
	return TRUE

/datum/flock/proc/reserved_turf_change(datum/source)
	SIGNAL_HANDLER
	free_turf(override_turf = source)

/datum/flock/proc/free_unit(mob/unit)
	if(istype(unit, /mob/living/simple_animal/flock/drone))
		UnregisterSignal(unit, list(COMSIG_PARENT_QDELETING, COMSIG_LIVING_DEATH))
		free_turf(unit)
		drones -= unit

/datum/flock/proc/on_unit_death(datum/source)
	SIGNAL_HANDLER
	free_unit(source)
