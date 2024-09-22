/proc/flock_convert_turf(turf/T, datum/flock/flock, force)
	if(!T?.can_flock_convert(force))
		return

	if(iswallturf(T))
		. = T.ChangeTurf(/turf/closed/wall/flock)

	else if(isfloorturf(T))
		. = T.ChangeTurf(/turf/open/floor/flock)

	var/obj/structure/lattice/L = locate() in .
	if(L)
		qdel(L)
		if(istype(L, /obj/structure/lattice/catwalk))
			. = T.ChangeTurf(/turf/open/floor/flock)

	for(var/obj/O in .)
		if(iseffect(O))
			continue

		O.try_flock_convert(flock, force)

/// Attempt to convert an object. Default behavior is to qdel.
/obj/proc/try_flock_convert(datum/flock/flock, force)
	qdel(src)

// No
/obj/effect/try_flock_convert(datum/flock/flock, force)
	return

/obj/machinery/camera/try_flock_convert(datum/flock/flock, force)
	atom_break()

// No
/obj/structure/cable/try_flock_convert(datum/flock/flock, force)
	return

// No
/obj/machinery/atmospherics/try_flock_convert(datum/flock/flock, force)
	return

/obj/machinery/door/try_flock_convert(datum/flock/flock, force)
	var/turf/T = loc
	qdel(src)
	new /obj/machinery/door/flock(T)

/turf/proc/can_flock_convert(force)
	return FALSE

/turf/open/floor/can_flock_convert(force)
	return TRUE

/turf/open/floor/flock/can_flock_convert(force)
	return TRUE
