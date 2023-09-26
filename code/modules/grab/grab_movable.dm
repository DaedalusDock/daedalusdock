/// Attempt to create a grab, returns TRUE on success
/atom/movable/proc/try_make_grab(atom/movable/target, grab_type)
	return canUseTopic(src, USE_IGNORE_TK|USE_CLOSE) && make_grab(target, grab_type)

/atom/movable/proc/can_be_grabbed(mob/living/grabber, target_zone, force)
	if(!istype(grabber) || !isturf(loc) || !isturf(grabber.loc))
		return FALSE
	if(SEND_SIGNAL(src, COMSIG_ATOM_CAN_BE_GRABBED, grabber) & COMSIG_ATOM_CANT_PULL)
		return FALSE
	if(!grabber.canUseTopic(src, USE_CLOSE|USE_IGNORE_TK))
		return FALSE
	if(!buckled_grab_check(grabber))
		return FALSE
	if(anchored)
		to_chat(grabber, span_warning("\The [src] won't budge!"))
		return FALSE
	if(throwing)
		return FALSE
	if(force < (move_resist * MOVE_FORCE_PULL_RATIO))
		return FALSE
	return TRUE

/atom/movable/proc/buckled_grab_check(var/mob/grabber)
	if(grabber.buckled == src && buckled_mob == grabber)
		return TRUE
	if(grabber.anchored)
		return FALSE
	if(grabber.buckled)
		return FALSE
	return TRUE
