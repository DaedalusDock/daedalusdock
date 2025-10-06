#define ATURF 1
#define TOTAL_COST_F 2
#define DIST_FROM_START_G 3
#define HEURISTIC_H 4
#define PREV_NODE 5

#define ASTAR_NODE(turf, dist_from_start, heuristic, prev_node) list(turf, dist_from_start + heuristic, dist_from_start, heuristic, prev_node)
#define ASTAR_CLOSE_ENOUGH_TO_END(end, checking_turf) (end == checking_turf || (mintargetdist && (get_dist(checking_turf, end) <= mintargetdist)))

/// TODO: Macro this to reduce proc overhead
/proc/HeapPathAstarWeightCompare(list/a, list/b)
	return b[TOTAL_COST_F] - a[TOTAL_COST_F]

/datum/pathfind/astar
	/// The thing that we're actually trying to path for
	var/atom/movable/invoker
	/// The turf we're trying to path to (note that this won't track a moving target)
	var/turf/end
	/// The list we compile at the end if successful to pass back
	var/list/path

	/// A k:v list of turf -> directions. The directions are directions the pathfinder attempted to step into the turf but failed.
	var/list/closed
	/// The open list/stack we pop nodes out from (TODO: make this a normal list and macro-ize the heap operations to reduce proc overhead)
	var/datum/heap/open_heap
	/// A k:V list of turf -> astar node
	var/list/open_turf_to_node

	/// How far away we have to get to the end target before we can call it quits
	var/mintargetdist = 0
	/// If we should delete the first step in the path or not. Used often because it is just the starting tile
	var/skip_first = FALSE
	/// Defines how we handle diagonal moves. See __DEFINES/path.dm
	var/use_diagonals = TRUE
	/// An optional callback to invoke to return a positive value to add to the path's distance.
	var/datum/callback/heuristic

/datum/pathfind/astar/New(
	atom/movable/invoker,
	atom/goal,
	access,
	max_distance,
	mintargetdist,
	simulated_only,
	avoid,
	skip_first,
	use_diagonals,
	datum/callback/on_finish,
	datum/callback/heuristic,
)
	src.invoker = invoker
	src.pass_info = new(invoker, access)

	end = get_turf(goal)
	open_heap = new /datum/heap(GLOBAL_PROC_REF(HeapPathAstarWeightCompare))
	open_turf_to_node = new()
	closed = new()

	src.max_distance = max_distance
	src.mintargetdist = mintargetdist
	src.simulated_only = simulated_only
	src.avoid = avoid
	src.skip_first = skip_first
	src.use_diagonals = use_diagonals
	src.on_finish = on_finish
	src.heuristic = heuristic || CALLBACK(src, PROC_REF(generic_heuristic))

/datum/pathfind/astar/Destroy(force, ...)
	. = ..()
	invoker = null
	end = null
	open_heap = null
	open_turf_to_node = null
	closed = null

/**
 * "starts" off the pathfinding, by storing the values this datum will need to work later on
 *  returns FALSE if it fails to setup properly, TRUE otherwise
 */
/datum/pathfind/astar/start()
	start ||= get_turf(invoker)
	. = ..()
	if(!.)
		return .

	if(!get_turf(end))
		stack_trace("Invalid A* destination")
		return FALSE

	if(start.z != end.z || start == end ) //no pathfinding between z levels
		return FALSE

	if(max_distance && (max_distance < get_dist_euclidean(start, end))) //if start turf is farther than max_distance from end turf, no need to do anything
		return FALSE

	var/list/start_node = ASTAR_NODE(start, 0, 0, null)
	open_turf_to_node[start] = start_node
	open_heap.insert(start_node)
	return TRUE

/**
 * Cleanup pass for the pathfinder. This tidies up the path, and fufills the pathfind's obligations
 */
/datum/pathfind/astar/finished()
	//we're done! turn our reversed path (end to start) into a path (start to end)
	QDEL_NULL(open_heap)

	var/list/path = src.path || list()
	if(length(path) > 0 && skip_first)
		path.Cut(1,2)

	hand_back(path)
	return ..()

/**
 * search_step() is the workhorse of pathfinding. It'll do the searching logic, and will slowly build up a path
 * returns TRUE if everything is stable, FALSE if the pathfinding logic has failed, and we need to abort
 */
/datum/pathfind/astar/search_step(tick_check = TRUE)
	. = ..()
	if(!.)
		return .

	if(QDELETED(invoker))
		return FALSE

	var/static/list/search_dirs = list(EAST, WEST, NORTH, SOUTH, NORTHEAST, SOUTHWEST, NORTHWEST, SOUTHEAST)

	while(!open_heap.is_empty() && !path)
		var/list/current_node = open_heap.pop()
		var/turf/current_node_turf = current_node[ATURF]
		closed[current_node[ATURF]] = ALL

		if(max_distance && current_node[DIST_FROM_START_G] > max_distance)
			continue

		// Check to see if we're close enough to the end destination.
		if(ASTAR_CLOSE_ENOUGH_TO_END(end, current_node_turf))
			unwind_path(current_node)
			return TRUE

		// Scan cardinal turfs for valid movements.
		for(var/scan_direction in search_dirs)
			var/turf/searching_turf = get_step(current_node_turf, scan_direction)
			if(closed[searching_turf] & scan_direction)
				continue // Turf is known to be blocked from this direction, skip!

			if(!CAN_STEP(current_node_turf, searching_turf, simulated_only, pass_info, avoid))
				closed[searching_turf] |= scan_direction
				continue // Turf cannot be entered, atleast from this direction. Skip!

			// At this point we consider this turf a valid node.

			var/list/existing_node = open_turf_to_node[searching_turf]

			// Prefer straighter lines for more visual appeal. Penalize changing from cardinal to diagonal, but if you're already diagonal, it's okay.
			var/distance_g = current_node[DIST_FROM_START_G]
			if(ISDIAGONALDIR(scan_direction) && (!current_node[PREV_NODE] || !ISDIAGONALDIR(get_dir(current_node[PREV_NODE][ATURF], current_node_turf))))
				distance_g += 1.4
			else
				distance_g += 1

			// If the node already exists, update it to reflect new information. Maybe we found a shorter path to it, or similar.
			if(existing_node)
				if(distance_g < existing_node[DIST_FROM_START_G])
					existing_node[PREV_NODE] = current_node
					existing_node[DIST_FROM_START_G] = distance_g
					existing_node[TOTAL_COST_F] = distance_g + existing_node[HEURISTIC_H]
					open_heap.resort(existing_node)
				continue

			// The node isn't known to us so we need to check the heuristic.
			var/heuristic_h = heuristic.Invoke(searching_turf, end)
			if(heuristic_h == 0)
				closed[searching_turf] |= scan_direction
				continue

			// Node is not known, create it.
			var/list/new_node = ASTAR_NODE(\
				searching_turf, \
				distance_g, \
				heuristic_h, \
				current_node \
			)
			open_heap.insert(new_node)
			open_turf_to_node[searching_turf] = new_node

			// Check to see if we're close enough to the end destination.
			if(ASTAR_CLOSE_ENOUGH_TO_END(end, new_node))
				unwind_path(new_node)
				return TRUE

		// Stable, we'll just be back later
		if(tick_check && TICK_CHECK)
			return TRUE

	return TRUE

/// The generic heuristic, chebyshev distance.
/datum/pathfind/astar/proc/generic_heuristic(turf/searching_turf, turf/end)
	return get_dist_euclidean(searching_turf, end)

/// Called when we've hit the goal with the node that represents the last tile, then sets the path var to that path so it can be returned by [datum/pathfind/proc/search]
/datum/pathfind/astar/proc/unwind_path(list/unwind_node)
	path = new()
	var/turf/iter_turf = unwind_node[ATURF]
	path += iter_turf

	while((unwind_node = unwind_node[PREV_NODE]))
		var/turf/node_turf = unwind_node[ATURF]
		if(use_diagonals && unwind_node[PREV_NODE])
			var/turf/look_ahead_turf = unwind_node[PREV_NODE][ATURF]
			var/turf/look_behind_turf = path[1]
			if(get_dist(look_ahead_turf, look_behind_turf) == 1 && ISDIAGONALDIR(get_dir(look_ahead_turf, look_behind_turf)))
				continue

		path.Insert(1, node_turf)

#undef ATURF
#undef TOTAL_COST_F
#undef DIST_FROM_START_G
#undef HEURISTIC_H
#undef PREV_NODE

#undef ASTAR_NODE
#undef ASTAR_CLOSE_ENOUGH_TO_END
