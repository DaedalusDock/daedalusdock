/proc/get_step_multiz(ref, dir)
	if(dir & UP)
		dir &= ~UP
		return get_step(GetAbove(ref), dir)
	if(dir & DOWN)
		dir &= ~DOWN
		return get_step(GetBelow(ref), dir)
	return get_step(ref, dir)

/proc/get_dir_multiz(turf/us, turf/them)
	us = get_turf(us)
	them = get_turf(them)
	if(!us || !them)
		return NONE
	if(us.z == them.z)
		return get_dir(us, them)

	var/turf/T = GetAbove(us)
	var/dir = NONE
	if(T && (T.z == them.z))
		dir = UP
	else
		T = GetBelow(us)
		if(T && (T.z == them.z))
			dir = DOWN
		else
			return get_dir(us, them)
	return (dir | get_dir(us, them))

///Checks if 2 levels are in the same Z-stack.
/datum/controller/subsystem/mapping/proc/are_same_zstack(zA, zB, include_lateral)
	if (zA <= 0 || zB <= 0 || zA > world.maxz || zB > world.maxz)
		return FALSE
	if (zA == zB)
		return TRUE

	if(include_lateral)
		if (length(laterally_linked_zlevels) >= zA && length(laterally_linked_zlevels[zA]) >= zB)
			return laterally_linked_zlevels[zA][zB]

	else if (length(linked_zlevels) >= zA && length(linked_zlevels[zA]) >= zB)
		return linked_zlevels[zA][zB]

	var/list/levels = get_zstack(zA, include_lateral)

	var/list/new_entry = new(world.maxz)

	for (var/entry in levels)
		new_entry[entry] = TRUE

	if (length(linked_zlevels) < zA)
		linked_zlevels.len = zA

	if(include_lateral)
		laterally_linked_zlevels[zA] = new_entry
	else
		linked_zlevels[zA] = new_entry
	return new_entry[zB]

///Get a list of Z levels that are in zA's Z-stack.
/datum/controller/subsystem/mapping/proc/get_zstack(zA, include_lateral)
	var/static/list/lateral_zstack_cache[world.maxz]
	var/static/list/zstack_cache[world.maxz]
	if(isturf(zA))
		zA = zA:z

	if(length(zstack_cache) < world.maxz)
		zstack_cache.len = world.maxz
		lateral_zstack_cache.len = world.maxz

	if(include_lateral)
		. = lateral_zstack_cache[zA]
	else
		. = zstack_cache[zA]

	if(islist(.))
		return .

	. = list(zA)
	// Traverse up and down to get the multiz stack.
	for(var/level = zA, HasAbove(level), level--)
		. |= level-1
	for(var/level = zA, HasBelow(level), level++)
		. |= level+1

	if(!include_lateral)
		zstack_cache[zA] = .
		return .

	// Check stack for any laterally connected neighbors.
	for(var/i = 1, i <= length(.), i++)
		var/datum/space_level/checking = z_list[.[i]]
		for(var/neighbor_key in checking.neigbours)
			var/datum/space_level/neighbor = checking.neigbours[neighbor_key]
			. |= neighbor.z_value

	lateral_zstack_cache[zA] = .


