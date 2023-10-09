/// A step() variant that allows passing z_movement_flags. Normal step() is fine if you do not need special movement flags.
/proc/zstep(atom/movable/mover, dir, z_movement_flags)
	if(!istype(mover))
		return

	var/turf/destination = get_step_multiz(mover, dir)
	if(!mover.can_z_move(dir, z_move_flags = z_movement_flags))
		return FALSE

	if(!destination)
		if(z_movement_flags & ZMOVE_FEEDBACK)
			to_chat(mover, span_warning("There is nothing of interest in that direction."))
			return FALSE
	return mover.Move(destination, dir, null, z_movement_flags)

/atom/movable/proc/onZImpact(turf/impacted_turf, levels, message = TRUE)
	if(message)
		visible_message(
			span_danger("[src] slams into [impacted_turf]!"),
			blind_message = span_hear("You hear something slam into the deck.")
		)

	INVOKE_ASYNC(src, PROC_REF(SpinAnimation), 5, 2)
	return TRUE

/**
 * Checks if the destination turf is elegible for z movement from the start turf to a given direction and returns it if so.
 * Args:
 * * direction: the direction to go, UP or DOWN, only relevant if target is null.
 * * start: Each destination has a starting point on the other end. This is it. Most of the times the location of the source.
 * * z_move_flags: bitflags used for various checks. See __DEFINES/movement.dm.
 * * rider: A living mob in control of the movable. Only non-null when a mob is riding a vehicle through z-levels.
 */
/atom/movable/proc/can_z_move(direction, turf/start, z_move_flags = ZMOVE_FLIGHT_FLAGS, mob/living/rider)
	if(!start)
		start = get_turf(src)
		if(!start)
			CRASH("Something tried to zMove from nullspace.")

	if(!(direction & (UP|DOWN)))
		CRASH("can_z_move() received an invalid direction ([direction || "null"])")

	var/turf/destination = get_step_multiz(start, direction)
	if(!destination)
		if(z_move_flags & ZMOVE_FEEDBACK)
			to_chat(rider || src, span_notice("There is nothing of interest in this direction."))
		return FALSE

	// Check flight
	if(z_move_flags & ZMOVE_CAN_FLY_CHECKS)
		if(!(movement_type & (FLYING|FLOATING)) && has_gravity(start) && (direction == UP))
			if(z_move_flags & ZMOVE_FEEDBACK)
				if(rider)
					to_chat(rider, span_warning("[src] is is not capable of flight."))
				else
					to_chat(src, span_warning("You stare at [destination]."))
			return FALSE

	// Check CanZPass
	if(!(z_move_flags & ZMOVE_IGNORE_OBSTACLES))
		// Check exit
		if(!start.CanZPass(src, direction, z_move_flags))
			if(z_move_flags & ZMOVE_FEEDBACK)
				to_chat(rider || src, span_warning("[start] is in the way."))
			return FALSE

		// Check enter
		if(!destination.CanZPass(src, direction, z_move_flags))
			if(z_move_flags & ZMOVE_FEEDBACK)
				to_chat(rider || src, span_warning("You bump against [destination]."))
			return FALSE

		if(!(z_move_flags & ZMOVE_SKIP_CANMOVEONTO))
			// Check destination movable CanPass
			for(var/atom/movable/A as anything in destination)
				if(!A.CanMoveOnto(src, direction))
					if(z_move_flags & ZMOVE_FEEDBACK)
						to_chat(rider || src, span_warning("You are blocked by [A]."))
					return FALSE

	// Check if we would fall.
	if(z_move_flags & ZMOVE_FALL_CHECKS)
		if((throwing || (movement_type & (FLYING|FLOATING)) || !has_gravity(start)))
			if(z_move_flags & ZMOVE_FEEDBACK)
				to_chat(rider || src, span_warning("You see nothing to hold onto."))
			return FALSE

	return destination //used by some child types checks and zMove()

/// Precipitates a movable (plus whatever buckled to it) to lower z levels if possible and then calls zImpact()
/atom/movable/proc/zFall(levels = 1, force = FALSE)
	if(QDELETED(src))
		return FALSE

	var/direction = DOWN
	if(has_gravity() == NEGATIVE_GRAVITY)
		direction = UP

	var/turf/target = direction == UP ? GetAbove(src) : GetBelow(src)
	if(!target)
		return FALSE

	var/isliving = isliving(src)
	if(!isliving && !isobj(src))
		return

	if(isliving)
		var/mob/living/falling_living = src
		//relay this mess to whatever the mob is buckled to.
		if(falling_living.buckled)
			return falling_living.buckled.zFall(levels, force)

	if(!force && !can_z_move(direction, get_turf(src), direction == DOWN ? ZMOVE_SKIP_CANMOVEONTO|ZMOVE_FALL_FLAGS : ZMOVE_FALL_FLAGS))
		return FALSE

	if(!CanZFall(get_turf(src), direction))
		return FALSE

	. = TRUE

	spawn(0)
		_doZFall(target, get_turf(src), levels)

/atom/movable/proc/_doZFall(turf/destination, turf/prev_turf, levels)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(QDELETED(src))
		return

	forceMoveWithGroup(destination, z_movement = ZMOVING_VERTICAL)
	destination.zImpact(src, levels, prev_turf)

/atom/movable/proc/CanZFall(turf/from, direction, anchor_bypass)
	if(anchored && !anchor_bypass)
		return FALSE

	if(from)
		for(var/obj/O in from)
			if(O.obj_flags & BLOCK_Z_FALL)
				return FALSE

		var/turf/other = direction == UP ? GetAbove(from) : GetBelow(from)
		if(!from.CanZPass(from, direction) || !other?.CanZPass(from, direction)) //Kinda hacky but it does work.
			return FALSE

	return TRUE

/// Returns an object we can climb onto
/atom/movable/proc/check_zclimb()
	var/turf/above = GetAbove(src)
	if(!above?.CanZPass(src, UP))
		return

	var/list/all_turfs_above = get_adjacent_open_turfs(above)

	//Check directly above first
	. = get_climbable_surface(above)
	if(.)
		return

	//Next, try the direction the mob is facing
	. = get_climbable_surface(get_step(above, dir))
	if(.)
		return

	for(var/turf/T as turf in all_turfs_above)
		. = get_climbable_surface(T)
		if(.)
			return

/atom/movable/proc/get_climbable_surface(turf/T)
	var/climb_target
	if(!T.Enter(src))
		return
	if(!isopenspaceturf(T) && isfloorturf(T))
		climb_target = T
	else
		for(var/obj/I in T)
			if(I.obj_flags & BLOCK_Z_FALL)
				climb_target = I
				break

	if(climb_target)
		return climb_target

/atom/movable/proc/ClimbUp(atom/onto)
	if(!isturf(loc))
		return FALSE

	var/turf/above = GetAbove(src)
	var/turf/destination = get_turf(onto)
	if(!above || !above.Adjacent(destination, mover = src))
		return FALSE

	if(has_gravity() > 0)
		var/can_overcome
		for(var/atom/A in loc)
			if(HAS_TRAIT(A, TRAIT_CLIMBABLE))
				can_overcome = TRUE
				break;

		if(!can_overcome)
			var/list/objects_to_stand_on = list(
				/obj/structure/chair,
				/obj/structure/bed,
				/obj/structure/lattice
			)
			for(var/path in objects_to_stand_on)
				if(locate(path) in loc)
					can_overcome = TRUE
					break;
		if(!can_overcome)
			to_chat(src, span_warning("You cannot reach [onto] from here!"))
			return FALSE

	visible_message(
		span_notice("[src] starts climbing onto \the [onto]."),
		span_notice("You start climbing onto \the [onto].")
	)

	if(!do_after(src, time = 5 SECONDS, timed_action_flags = DO_PUBLIC, display = image('icons/hud/do_after.dmi', "help")))
		return FALSE

	visible_message(
		span_notice("[src] climbs onto \the [onto]."),
		span_notice("You climb onto \the [onto].")
	)

	var/oldloc = loc
	setDir(get_dir(above, destination))
	. = Move(destination, null, null, ZMOVE_INCAPACITATED_CHECKS)
	if(.)
		playsound(oldloc, 'sound/effects/stairs_step.ogg', 50)
		playsound(destination, 'sound/effects/stairs_step.ogg', 50)

/// Returns a list of movables that should also be affected when calling forceMoveWithGroup()
/atom/movable/proc/get_move_group()
	SHOULD_CALL_PARENT(TRUE)
	RETURN_TYPE(/list)
	. = list(src)
	if(length(buckled_mobs))
		. |= buckled_mobs

/// forceMove() wrapper to include things like buckled mobs.
/atom/movable/proc/forceMoveWithGroup(destination, z_movement)
	var/list/movers = get_move_group()
	for(var/atom/movable/AM as anything in movers)
		if(z_movement)
			AM.set_currently_z_moving(z_movement)
		AM.forceMove(destination)
		if(z_movement)
			AM.set_currently_z_moving(FALSE)
/*
/**
 * We want to relay the zmovement to the buckled atom when possible
 * and only run what we can't have on buckled.zMove() or buckled.can_z_move() here.
 * This way we can avoid esoteric bugs, copypasta and inconsistencies.
 */
/mob/living/zMove(dir, turf/target, z_move_flags = ZMOVE_FLIGHT_FLAGS)
	if(buckled)
		if(buckled.currently_z_moving)
			return FALSE
		if(!(z_move_flags & ZMOVE_ALLOW_BUCKLED))
			buckled.unbuckle_mob(src, force = TRUE, can_fall = FALSE)
		else
			if(!target)
				target = can_z_move(dir, get_turf(src), z_move_flags, src)
				if(!target)
					return FALSE
			return buckled.zMove(dir, target, z_move_flags) // Return value is a loc.
	return ..()
*/
