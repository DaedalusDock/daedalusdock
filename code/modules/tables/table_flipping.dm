/obj/structure/table/verb/verbflip()
	set name = "Flip table"
	set desc = "Flips a non-reinforced table"
	set category = "Object"
	set src in oview(1)

	if(!usr.canUseTopic(src, USE_CLOSE|USE_NEED_HANDS))
		return

	flip(usr, get_cardinal_dir(usr, src))

/obj/structure/table/proc/verbunflip()
	set name = "Flip table upright"
	set desc = "Fixes the position of a table"
	set category = "Object"
	set src in oview(1)

	if(!usr.canUseTopic(src, USE_CLOSE|USE_NEED_HANDS))
		return

	unflip(usr)

/obj/structure/table/proc/is_flipped()
	return flipped == 1

/obj/structure/table/proc/flip(user, direction, skip_delay)
	if(flipped == -1)
		to_chat(user, span_warning("[src] won't budge."))
		return FALSE

	if(is_flipped())
		return FALSE

	if(!straight_table_check(turn(direction,90)) || !straight_table_check(turn(direction,-90)) )
		return FALSE

	if(!skip_delay && !do_after(user, src, 1 SECOND, DO_PUBLIC))
		return FALSE


	var/turf/T = get_turf(src)
	var/list/targets = list(
		get_step(src,direction),
		get_step(src,turn(direction, 45)),
		get_step(src,turn(direction, -45)),
	)
	list_clear_nulls(targets)
	for(var/atom/movable/AM as anything in T)
		if(AM == src)
			continue

		if(isliving(AM))
			AM.safe_throw_at(get_edge_target_turf(T, direction), 7, 5) //Trolling
		else if(!AM.anchored)
			AM.safe_throw_at(pick(targets), 1, 1)

	flipped = TRUE
	setDir(direction)

	flags_1 |= ON_BORDER_1
	for(var/D in list(turn(direction, 90), turn(direction, -90)))
		var/obj/structure/table/neighbor = locate() in get_step(src, D)
		if(!neighbor)
			continue
		if(!neighbor.is_flipped() && neighbor.buildstack == buildstack)
			neighbor.flip(user, direction, TRUE)

	smoothing_flags = null
	verbs -= /obj/structure/table/verb/verbflip
	verbs += /obj/structure/table/proc/verbunflip

	update_icon()

/obj/structure/table/proc/unflip(user, skip_delay)
	if(!is_flipped())
		return FALSE
	if(!skip_delay && !do_after(user, src, 1 SECOND, DO_PUBLIC, extra_checks = CALLBACK(src, PROC_REF(unflipping_check), user)))
		return FALSE


	verbs += /obj/structure/table/verb/verbflip
	verbs -= /obj/structure/table/proc/verbunflip

	flipped = 0
	flags_1 &= ~ON_BORDER_1
	setDir(0)

	for(var/D in list(turn(dir, 90), turn(dir, -90)))
		var/obj/structure/table/neighbor = locate() in get_step(src.loc,D)
		if(neighbor && neighbor.is_flipped() && neighbor.dir == src.dir && neighbor.buildstack == buildstack)
			neighbor.unflip(user, TRUE)

	smoothing_flags = initial(smoothing_flags)
	update_icon()

	return TRUE

/obj/structure/table/proc/straight_table_check(direction)
	var/obj/structure/table/T

	for(var/angle in list(-90,90))

		T = locate() in get_step(src.loc,turn(direction,angle))

		if(T && T.flipped == 0 && T.buildstack == buildstack)
			return FALSE

	T = locate() in get_step(src.loc,direction)
	if (!T || T.is_flipped()|| T.buildstack != buildstack)
		return TRUE

	return T.straight_table_check(direction)

/obj/structure/table/proc/unflipping_check(user, direction, silent)
	var/turf/turfloc = get_turf(src)
	var/obj/occupied = turfloc.contains_dense_objects()
	if(occupied)
		if(!silent)
			to_chat(user, span_warning("There's \a [occupied] in the way."))
		return FALSE

	var/list/L = list()
	if(direction)
		L.Add(direction)
	else
		L.Add(turn(src.dir,-90))
		L.Add(turn(src.dir,90))

	for(var/new_dir in L)
		var/obj/structure/table/T = locate() in get_step(src.loc,new_dir)
		if(T && T.buildstack == T.buildstack)
			if(T.is_flipped() && T.dir == src.dir && !T.unflipping_check(user, new_dir, TRUE))
				return FALSE

	return TRUE
