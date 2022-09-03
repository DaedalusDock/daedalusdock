/proc/get_step_multiz(ref, dir)
	if(dir & UP)
		dir &= ~UP
		return get_step(SSmapping.get_turf_above(get_turf(ref)), dir)
	if(dir & DOWN)
		dir &= ~DOWN
		return get_step(SSmapping.get_turf_below(get_turf(ref)), dir)
	return get_step(ref, dir)

/proc/get_dir_multiz(turf/us, turf/them)
	us = get_turf(us)
	them = get_turf(them)
	if(!us || !them)
		return NONE
	if(us.z == them.z)
		return get_dir(us, them)
	else
		var/turf/T = us.above()
		var/dir = NONE
		if(T && (T.z == them.z))
			dir = UP
		else
			T = us.below()
			if(T && (T.z == them.z))
				dir = DOWN
			else
				return get_dir(us, them)
		return (dir | get_dir(us, them))

/turf/proc/above()
	return get_step_multiz(src, UP)

/turf/proc/below()
	return get_step_multiz(src, DOWN)

///A fast version that has no safeties and assumes both turfs exist on different, valid Z levels.
/proc/get_dir_multiz_fast(turf/us, turf/them)
	var/turf/T = SSmapping.get_turf_above(us)
	if(T == them)
		return UP

	return SSmapping.get_turf_below(us) ? DOWN : null
