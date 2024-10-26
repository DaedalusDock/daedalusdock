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

/obj/structure/window/try_flock_convert(datum/flock/flock, force)
	var/turf/T = loc
	qdel(src)
	if(fulltile)
		return new /obj/structure/window/flock/fulltile(T)

	var/obj/W = new /obj/structure/window/flock(T)
	W.dir = dir
	return W

/obj/machinery/door/try_flock_convert(datum/flock/flock, force)
	var/turf/T = loc
	qdel(src)
	return new /obj/machinery/door/flock(T)

/obj/structure/low_wall/try_flock_convert(datum/flock/flock, force)
	set_material(/datum/material/gnesis, TRUE)
	return src

/obj/machinery/light/try_flock_convert(datum/flock/flock, force)
	var/obj/L = new /obj/machinery/light/flock(loc)
	L.setDir(dir)
	qdel(src)
	return L

/obj/machinery/light/floor/try_flock_convert(datum/flock/flock, force)
	. = new /obj/machinery/light/floor/has_bulb/flock(loc)
	qdel(src)

/turf/proc/can_flock_convert(force)
	return FALSE

/turf/open/floor/can_flock_convert(force)
	return TRUE

/turf/open/floor/flock/can_flock_convert(force)
	return TRUE

/turf/closed/wall/can_flock_convert(force)
	return TRUE
