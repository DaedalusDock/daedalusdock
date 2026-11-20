/// Base type for flock tests. Provides a flock that is NOT the default flock, and cleans up turf claims and changes.
/datum/unit_test/flock
	abstract_type = /datum/unit_test/flock

	/// The flock used by the test.
	var/datum/flock/flock
	/// k:v list of turf : original turf type, restored in Destroy().
	var/list/changed_turfs = list()

/datum/unit_test/flock/New()
	. = ..()
	flock = new

/datum/unit_test/flock/Destroy()
	// Stop listening to turfs before they get reverted, or the flock would react to the cleanup.
	for(var/turf/T as anything in flock.turf_reservations.Copy())
		flock.free_turf(override_turf = T)

	for(var/turf/T as anything in flock.claimed_floors + flock.claimed_walls)
		flock.stop_tracking_turf(T)

	for(var/turf/T as anything in changed_turfs)
		T.ChangeTurf(changed_turfs[T])

	changed_turfs = null
	flock = null
	return ..()

/// Remember a turf's type so it can be restored after the test.
/datum/unit_test/flock/proc/remember_turf(turf/T)
	if(!changed_turfs[T])
		changed_turfs[T] = T.type

/// ChangeTurf that is reverted after the test.
/datum/unit_test/flock/proc/change_turf(turf/T, path)
	remember_turf(T)
	return T.ChangeTurf(path)

/// claim_turf() that is reverted after the test.
/datum/unit_test/flock/proc/claim(turf/T)
	remember_turf(T)
	flock.claim_turf(T)

/// Create a drone in the test flock with its AI turned off.
/datum/unit_test/flock/proc/new_drone(turf/T = run_loc_floor_bottom_left)
	var/mob/living/simple_animal/flock/drone/bird = allocate(/mob/living/simple_animal/flock/drone, T, flock)
	bird.ai_controller.set_ai_status(AI_STATUS_OFF)
	bird.ai_controller.CancelActions()
	return bird

/// Returns the handler proc the test flock has registered for a signal on target, as text.
/datum/unit_test/flock/proc/flock_handler(datum/target, signal)
	return flock.signal_procs?[target]?[signal]

/// The wall directly west of the bottom left floor of the test room.
/datum/unit_test/flock/proc/get_room_wall()
	return get_step(run_loc_floor_bottom_left, WEST)
