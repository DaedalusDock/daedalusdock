/mob/camera/z_eye
	sight = NONE
	var/mob/living/parent

/mob/camera/z_eye/Initialize(mapload, mob/living/user)
	. = ..()
	if(!istype(user))
		return INITIALIZE_HINT_QDEL

	parent = user
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(try_follow))
	RegisterSignal(parent, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(kill))
	try_follow(parent)

/mob/camera/z_eye/Destroy()
	if(parent)
		UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
		parent.reset_perspective(null)
		parent.z_eye = null
	parent = null
	return ..()

/mob/camera/z_eye/can_z_move(direction, turf/start, z_move_flags, mob/living/rider)
	return FALSE

/mob/camera/z_eye/proc/kill()
	qdel(src)

/mob/camera/z_eye/proc/try_follow(mob/source, atom/old_loc, dir, forced, old_locs)
	SIGNAL_HANDLER
	if(!source?.z) //wtf happened
		qdel(src)
		return
	if(abs(src.z - source.z) != 1)
		qdel(src)
		return

	var/is_below = src.z < source.z


	var/turf/T
	if(is_below)
		T = get_turf(source)
	else
		T = GetAbove(source)

	if(is_below)
		abstract_move(GetBelow(source))
	else
		abstract_move(GetAbove(source))

	if(!TURF_IS_MIMICKING(T))
		if(parent.client?.eye == src)
			parent.reset_perspective(null)

	else if(parent.client?.eye != src)
		parent.reset_perspective(src)
