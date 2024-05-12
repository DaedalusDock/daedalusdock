#define STAIR_TERMINATOR_AUTOMATIC 0
#define STAIR_TERMINATOR_NO 1
#define STAIR_TERMINATOR_YES 2

// dir determines the direction of travel to go upwards
// multiple stair objects can be chained together; the Z level transition will happen on the final stair object in the chain

/obj/structure/stairs
	name = "stairs"
	icon = 'icons/obj/stairs.dmi'
	icon_state = "stairs"
	anchored = TRUE

	var/terminator_mode = STAIR_TERMINATOR_AUTOMATIC
	var/turf/listeningTo

/obj/structure/stairs/north
	dir = NORTH

/obj/structure/stairs/south
	dir = SOUTH

/obj/structure/stairs/east
	dir = EAST

/obj/structure/stairs/west
	dir = WEST

/obj/structure/stairs/Initialize(mapload)
	SET_TRACKING(__TYPE__)
	update_surrounding()

	var/static/list/loc_connections = list(
		COMSIG_ATOM_EXIT = PROC_REF(on_exit),
	)

	AddElement(/datum/element/connect_loc, loc_connections)

	return ..()

/obj/structure/stairs/Destroy()
	listeningTo = null
	UNSET_TRACKING(__TYPE__)
	return ..()

/obj/structure/stairs/Move() //Look this should never happen but...
	. = ..()
	update_surrounding()

/obj/structure/stairs/proc/update_surrounding()
	update_appearance()
	for(var/i in GLOB.cardinals)
		var/turf/T = get_step(get_turf(src), i)
		var/obj/structure/stairs/S = locate() in T
		if(S)
			S.update_appearance()

/obj/structure/stairs/proc/on_exit(datum/source, atom/movable/leaving, direction, no_side_effects)
	SIGNAL_HANDLER

	if(leaving == src)
		return //Let's not block ourselves.

	if(!isobserver(leaving) && isTerminator() && direction == dir)
		if(!no_side_effects)
			INVOKE_ASYNC(src, PROC_REF(stair_ascend), leaving)
		leaving.Bump(src)
		return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/stairs/Cross(atom/movable/AM)
	if(isTerminator() && (get_dir(src, AM) == dir))
		return FALSE
	return ..()

/obj/structure/stairs/update_icon_state()
	icon_state = "stairs[isTerminator() ? "_t" : null]"
	return ..()

/obj/structure/stairs/proc/stair_ascend(atom/movable/climber)
	var/turf/my_turf = get_turf(src)
	var/turf/checking = GetAbove(my_turf)
	if(!istype(checking))
		return

	var/turf/target = get_step_multiz(my_turf, (dir|UP))
	if(!target)
		to_chat(climber, span_notice("There is nothing of interest in that direction."))
		return

	if(!checking.CanZPass(climber, UP, ZMOVE_STAIRS_FLAGS))
		to_chat(climber, span_warning("Something blocks the path."))
		return

	if(!target.Enter(climber, FALSE))
		to_chat(climber, span_warning("Something blocks the path."))
		return

	climber.forceMoveWithGroup(target, z_movement = ZMOVING_VERTICAL)

	if(!(climber.throwing || (climber.movement_type & (VENTCRAWLING | FLYING)) || HAS_TRAIT(climber, TRAIT_IMMOBILIZED)))
		playsound(my_turf, 'sound/effects/stairs_step.ogg', 50)
		playsound(my_turf, 'sound/effects/stairs_step.ogg', 50)

	/// Moves anything that's being dragged by src or anything buckled to it to the stairs turf.
	for(var/mob/living/buckled as anything in climber.buckled_mobs)
		buckled.handle_grabs_during_movement(my_turf, get_dir(my_turf, target))

/obj/structure/stairs/intercept_zImpact(list/falling_movables, levels = 1)
	. = ..()
	if(levels == 1 && isTerminator()) // Stairs won't save you from a steep fall.
		. |= FALL_INTERCEPTED | FALL_NO_MESSAGE | FALL_RETAIN_PULL

/obj/structure/stairs/proc/isTerminator() //If this is the last stair in a chain and should move mobs up
	if(terminator_mode != STAIR_TERMINATOR_AUTOMATIC)
		return (terminator_mode == STAIR_TERMINATOR_YES)
	var/turf/T = get_turf(src)
	if(!T)
		return FALSE
	var/turf/them = get_step(T, dir)
	if(!them)
		return FALSE
	for(var/obj/structure/stairs/S in them)
		if(S.dir == dir)
			return FALSE
	return TRUE
