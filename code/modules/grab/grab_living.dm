/mob/living/proc/can_grab(atom/movable/target, target_zone, defer_hand)
	if(throwing || !(mobility_flags & MOBILITY_PULL))
		return FALSE
	if(!ismob(target) && target.anchored)
		to_chat(src, span_warning("\The [target] won't budge!"))
		return FALSE

	if(defer_hand)
		if(!get_empty_held_index())
			to_chat(src, span_warning("Your hands are full!"))
			return FALSE

	else if(get_active_held_item())
		to_chat(src, span_warning("Your [active_hand_index % 2 ? "right" : "left"] hand is full!"))
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

/mob/living/can_be_grabbed(mob/living/grabber, target_zone, force)
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

/mob/living/proc/add_grab(obj/item/hand_item/grab/grab, defer_hand)
	for(var/obj/item/hand_item/grab/other_grab in contents)
		if(other_grab != grab)
			return FALSE
	grab.forceMove(src)
	return TRUE

/mob/living/recheck_grabs(only_pulling = FALSE, only_pulled = FALSE, z_allowed = FALSE)
	if(only_pulled)
		return ..()

	for(var/obj/item/hand_item/grab/G in get_active_grabs())
		var/atom/movable/pulling = G.affecting
		if(!MultiZAdjacent(src, pulling))
			qdel(G)
		else if(!isturf(loc))
			qdel(G)
		else if(!isturf(pulling.loc)) //to be removed once all code that changes an object's loc uses forceMove().
			qdel(G)
		else if(pulling.anchored || pulling.move_resist > move_force)
			qdel(G)

	return ..()

/// Called by grab objects when a grab has been released
/mob/living/proc/after_grab_release(atom/movable/old_target)
	animate_interact(old_target, INTERACT_UNPULL)
	if(ismob(pulling))
		var/mob/living/L = pulling
		L.reset_pull_offsets()
	update_pull_hud_icon()

/mob/living/proc/handle_grabs_during_movement(turf/old_loc, direction)
	var/list/grabs_in_grab_chain = get_active_grabs() //recursively_get_conga_line()
	if(!LAZYLEN(grabs_in_grab_chain))
		return

	for(var/obj/item/hand_item/grab/G in grabs_in_grab_chain)
		var/atom/movable/pulling = G.affecting
		if(pulling == src || pulling.loc == loc)
			continue
		if(pulling.anchored || !isturf(loc))
			qdel(G)
			continue

		var/pull_dir = get_dir(pulling, src)
		var/target_turf = old_loc

		// Pulling things down/up stairs. zMove() has flags for check_pulling and stop_pulling calls.
		// You may wonder why we're not just forcemoving the pulling movable and regrabbing it.
		// The answer is simple. forcemoving and regrabbing is ugly and breaks conga lines.
		if(pulling.z != z)
			target_turf = get_step(pulling, get_dir(pulling, old_loc))


		if(target_turf != old_loc || (moving_diagonally != SECOND_DIAG_STEP && ISDIAGONALDIR(pull_dir)) || get_dist(src, pulling) > 1)
			pulling.move_from_pull(G.assailant, get_step(pulling, get_dir(pulling, target_turf)), glide_size)
			if(QDELETED(G))
				continue

		if(!pulling.MultiZAdjacent(src))
			qdel(G)
			continue

		if(!QDELETED(G))
			G.update_offsets()
			G.current_grab.moved_effect(G)
			if(G.current_grab.downgrade_on_move)
				G.downgrade()

	var/list/my_grabs = get_active_grabs()
	for(var/obj/item/hand_item/grab/G in my_grabs)
		if(G.current_grab.reverse_facing)
			setDir(global.reverse_dir[direction])


