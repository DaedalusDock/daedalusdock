/mob/living/proc/can_grab(atom/movable/target, target_zone, defer_hand)
	if(!ismob(target) && target.anchored)
		to_chat(src, span_warning("\The [target] won't budge!"))
		return FALSE

	if(defer_hand)
		if(!get_empty_held_index())
			to_chat(src, span_warning("Your hands are full!"))
			return FALSE

	else if(get_active_held_item())
		to_chat(src, span_warning("Your [get_active_hand().plaintext_zone] is full!"))
		return FALSE

	if(LAZYLEN(grabbed_by))
		to_chat(src, span_warning("You cannot start grappling while already being grappled!"))
		return FALSE

	for(var/obj/item/hand_item/grab/G in target.grabbed_by)
		if(G.assailant != src)
			continue
		if(!target_zone || !ismob(target))
			to_chat(src, span_warning("You already have a grip on \the [target]!"))
			return FALSE
		if(G.target_zone == target_zone)
			var/obj/item/bodypart/BP = G.get_targeted_bodypart()
			if(BP)
				to_chat(src, span_warning("You already have a grip on \the [target]'s [BP.plaintext_zone]."))
				return FALSE
	return TRUE

/mob/living/proc/can_be_grabbed(mob/living/grabber, target_zone, force)
	. = ..()
	if(!.)
		return
	if((buckled?.buckle_prevents_pull))
		return FALSE

/// Attempt to create a grab, returns TRUE on success
/mob/living/proc/try_make_grab(atom/movable/target, grab_type)
	return canUseTopic(src, USE_IGNORE_TK|USE_CLOSE) && make_grab(target, grab_type)

/mob/living/proc/make_grab(atom/movable/target, grab_type = /datum/grab/simple, defer_hand)
	if(SEND_SIGNAL(src, COMSIG_LIVING_TRY_GRAB, target, grab_type) & COMSIG_LIVING_CANCEL_GRAB)
		return

	// Resolve to the 'topmost' atom in the buckle chain, as grabbing someone buckled to something tends to prevent further interaction.
	var/atom/movable/original_target = target
	var/mob/grabbing_mob = (ismob(target) && target)

	while(istype(grabbing_mob) && grabbing_mob.buckled)
		grabbing_mob = grabbing_mob.buckled

	if(grabbing_mob && grabbing_mob != original_target)
		target = grabbing_mob
		to_chat(src, span_warning("As \the [original_target] is buckled to \the [target], you try to grab that instead!"))

	if(!istype(target))
		return

	face_atom(target)

	var/obj/item/hand_item/grab/grab
	if(ispath(grab_type, /datum/grab) && can_grab(target, zone_selected, defer_hand = defer_hand) && target.can_be_grabbed(src, zone_selected, defer_hand))
		grab = new /obj/item/hand_item/grab(src, target, grab_type, defer_hand)


	if(QDELETED(grab))
		if(original_target != src && ismob(original_target))
			to_chat(original_target, span_warning("\The [src] tries to grab you, but fails!"))
		to_chat(src, span_warning("You try to grab \the [target], but fail!"))

		return null

	SEND_SIGNAL(src, COMSIG_LIVING_START_GRAB, target, grab)
	SEND_SIGNAL(target, COMSIG_ATOM_GET_GRABBED, src, grab)

	return grab

/mob/living/add_grab(obj/item/hand_item/grab/grab, defer_hand)
	for(var/obj/item/hand_item/grab/other_grab in contents)
		if(other_grab != grab)
			return FALSE
	grab.forceMove(src)
	return TRUE

/mob/living/ProcessGrabs()
	if(LAZYLEN(grabbed_by))
		resist()

/mob/living/recheck_grabs(only_pulling = FALSE, z_allowed = FALSE)
	for(var/obj/item/hand_item/grab/G in get_active_grabs())
		var/atom/movable/pulling = G.affecting
		if(get_dist(src, pulling) > 1 || (z != pulling.z && !z_allowed))
			qdel(G)
		else if(!isturf(loc))
			qdel(G)
		else if(pulling && !isturf(pulling.loc) && pulling.loc != loc) //to be removed once all code that changes an object's loc uses forceMove().
			log_game("DEBUG:[src]'s pull on [pulling] wasn't broken despite [pulling] being in [pulling.loc]. Pull stopped manually.")
			qdel(G)
		else if(pulling.anchored || pulling.move_resist > move_force)
			qdel(G)

	return ..()
