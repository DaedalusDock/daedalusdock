/atom/movable/proc/can_be_grabbed(mob/living/grabber, target_zone, use_offhand)
	if(!istype(grabber) || !isturf(loc) || !isturf(grabber.loc))
		return FALSE
	if(SEND_SIGNAL(src, COMSIG_ATOM_CAN_BE_GRABBED, grabber) & COMSIG_ATOM_NO_GRAB)
		return FALSE
	if(!grabber.canUseTopic(src, USE_CLOSE|USE_IGNORE_TK))
		return FALSE
	if(!buckled_grab_check(grabber))
		return FALSE
	if(anchored)
		return FALSE
	if(throwing)
		return FALSE
	if(pull_force < (move_resist * MOVE_FORCE_PULL_RATIO))
		to_chat(grabber, span_warning("You aren't strong enough to move [src]!"))
		return FALSE
	return TRUE

/atom/movable/proc/buckled_grab_check(mob/grabber)
	if(grabber.buckled == src && (grabber in buckled_mobs))
		return TRUE
	if(grabber.anchored)
		return FALSE
	if(grabber.buckled)
		return FALSE
	return TRUE

/**
 * Checks if the pulling and pulledby should be stopped because they're out of reach.
 * If z_allowed is TRUE, the z level of the pulling will be ignored.This is to allow things to be dragged up and down stairs.
 */
/atom/movable/proc/recheck_grabs(only_pulling = FALSE, only_pulled = FALSE, z_allowed = FALSE)
	if(only_pulling)
		return

	for(var/obj/item/hand_item/grab/G in grabbed_by)
		if(moving_diagonally != FIRST_DIAG_STEP && !MultiZAdjacent(G.assailant)) //separated from our puller and not in the middle of a diagonal move.
			qdel(G)

/// Move grabbed atoms towards a destination
/mob/living/proc/move_grabbed_atoms_towards(atom/destination)
	for(var/obj/item/hand_item/grab/G in active_grabs)
		G.move_victim_towards(destination)

/**
 * Updates the mob's pixel position according to the offsets.
 *
 * * animate: If TRUE, the mob will animate to the new position. If FALSE, it will instantly move.
 *
 * Returns TRUE if the mob's position has changed, FALSE otherwise.
 */
/atom/movable/proc/update_offsets(animate = TRUE)
	var/list/sum_offsets = get_offsets()
	var/new_x = base_pixel_x + sum_offsets[PIXEL_X_OFFSET]
	var/new_y = base_pixel_y + sum_offsets[PIXEL_Y_OFFSET]

	if(length(buckled_mobs))
		for(var/mob/M as anything in buckled_mobs)
			M.update_offsets(animate)

	if(new_x == pixel_x && new_y == pixel_y)
		return FALSE

	if(!animate)
		pixel_x = new_x
		pixel_y = new_y
		UPDATE_OO_IF_PRESENT
		return TRUE

	// ensures the floating animation doesn't mess with our animation
	if(HAS_TRAIT(src, TRAIT_MOVE_FLOATING))
		ADD_TRAIT(src, TRAIT_NO_FLOATING_ANIM, UPDATE_OFFSET_TRAIT)
		addtimer(TRAIT_CALLBACK_REMOVE(src, TRAIT_NO_FLOATING_ANIM, UPDATE_OFFSET_TRAIT), 0.3 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)

	z_animate(src, pixel_x = new_x, pixel_y = new_y, flags = ANIMATION_PARALLEL, time = 0.3 SECONDS)
	return TRUE

/atom/movable/proc/get_offsets() as /list
	. = list(
		(PIXEL_X_OFFSET) = 0,
		(PIXEL_Y_OFFSET) = 0,
	)

	var/list/grabbed_by = list()

	grabbed_by += src.grabbed_by

	if(length(buckled_mobs))
		for(var/mob/M as anything in buckled_mobs)
			M.update_offsets()

	if(isliving(src))
		var/mob/living/L = src
		if(L.buckled)
			grabbed_by += L.buckled.grabbed_by

	if(isturf(loc) && length(grabbed_by))
		for(var/obj/item/hand_item/grab/G in grabbed_by)
			G.current_grab.get_grab_offsets(G, get_dir(G.assailant, G.affecting), &.[PIXEL_X_OFFSET], &.[PIXEL_Y_OFFSET])
