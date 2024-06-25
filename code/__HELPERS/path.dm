/**
 * This file contains the stuff you need for using JPS (Jump Point Search) pathing, an alternative to A* that skips
 * over large numbers of uninteresting tiles resulting in much quicker pathfinding solutions. Mind that diagonals
 * cost the same as cardinal moves currently, so paths may look a bit strange, but should still be optimal.
 */

/**
 * This is the proc you use whenever you want to have pathfinding more complex than "try stepping towards the thing".
 * If no path was found, returns an empty list, which is important for bots like medibots who expect an empty list rather than nothing.
 * It will yield until a path is returned, using magic
 *
 * Arguments:
 * * caller: The movable atom that's trying to find the path
 * * end: What we're trying to path to. It doesn't matter if this is a turf or some other atom, we're gonna just path to the turf it's on anyway
 * * max_distance: The maximum number of steps we can take in a given path to search (default: 30, 0 = infinite)
 * * mintargetdistance: Minimum distance to the target before path returns, could be used to get near a target, but not right to it - for an AI mob with a gun, for example.
 * * access: A list representing what access we have and what doors we can open.
 * * simulated_only: Whether we consider turfs without atmos simulation (AKA do we want to ignore space)
 * * exclude: If we want to avoid a specific turf, like if we're a mulebot who already got blocked by some turf
 * * skip_first: Whether or not to delete the first item in the path. This would be done because the first item is the starting tile, which can break movement for some creatures.
 * * diagonal_safety: ensures diagonal moves won't use invalid midstep turfs by splitting them into two orthogonal moves if necessary
 */
/proc/get_path_to(atom/movable/caller, atom/end, max_distance = 30, mintargetdist, list/access, simulated_only = TRUE, turf/exclude, skip_first=TRUE, diagonal_safety=TRUE)
	var/list/path = list()
	// We're guarenteed that list will be the first list in pathfinding_finished's argset because of how callback handles the arguments list
	var/datum/callback/await = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(pathfinding_finished), path)
	if(!SSpathfinder.pathfind(caller, end, max_distance, mintargetdist, access, simulated_only, exclude, skip_first, diagonal_safety, await))
		return list()

	UNTIL(length(path))
	if(length(path) == 1 && path[1] == null || (QDELETED(caller) || QDELETED(end))) // It's trash, just hand back null to make it easy
		return list()
	return path

/// Uses funny pass by reference bullshit to take the path created by pathfinding, and insert it into a return list
/// We'll be able to use this return list to tell a sleeping proc to continue execution
/proc/pathfinding_finished(list/return_list, list/path)
	// We use += here to ensure the list is still pointing at the same thing
	return_list += path

/// The JPS Node datum represents a turf that we find interesting enough to add to the open list and possibly search for new tiles from
/datum/jps_node
	/// The turf associated with this node
	var/turf/tile
	/// The node we just came from
	var/datum/jps_node/previous_node
	/// The A* node weight (f_value = number_of_tiles + heuristic)
	var/f_value
	/// The A* node heuristic (a rough estimate of how far we are from the goal)
	var/heuristic
	/// How many steps it's taken to get here from the start (currently pulling double duty as steps taken & cost to get here, since all moves incl diagonals cost 1 rn)
	var/number_tiles
	/// How many steps it took to get here from the last node
	var/jumps
	/// Nodes store the endgoal so they can process their heuristic without a reference to the pathfind datum
	var/turf/node_goal

/datum/jps_node/New(turf/our_tile, datum/jps_node/incoming_previous_node, jumps_taken, turf/incoming_goal)
	tile = our_tile
	jumps = jumps_taken
	if(incoming_goal) // if we have the goal argument, this must be the first/starting node
		node_goal = incoming_goal
	else if(incoming_previous_node) // if we have the parent, this is from a direct lateral/diagonal scan, we can fill it all out now
		previous_node = incoming_previous_node
		number_tiles = previous_node.number_tiles + jumps
		node_goal = previous_node.node_goal
		heuristic = get_dist(tile, node_goal)
		f_value = number_tiles + heuristic
	// otherwise, no parent node means this is from a subscan lateral scan, so we just need the tile for now until we call [datum/jps/proc/update_parent] on it

/datum/jps_node/Destroy(force, ...)
	previous_node = null
	return ..()

/datum/jps_node/proc/update_parent(datum/jps_node/new_parent)
	previous_node = new_parent
	node_goal = previous_node.node_goal
	jumps = get_dist(tile, previous_node.tile)
	number_tiles = previous_node.number_tiles + jumps
	heuristic = get_dist(tile, node_goal)
	f_value = number_tiles + heuristic

/// TODO: Macro this to reduce proc overhead
/proc/HeapPathWeightCompare(datum/jps_node/a, datum/jps_node/b)
	return b.f_value - a.f_value

/// The datum used to handle the JPS pathfinding, completely self-contained
/datum/pathfind
	/// The thing that we're actually trying to path for
	var/atom/movable/caller
	/// The turf where we started at
	var/turf/start
	/// The turf we're trying to path to (note that this won't track a moving target)
	var/turf/end
	/// The open list/stack we pop nodes out from (TODO: make this a normal list and macro-ize the heap operations to reduce proc overhead)
	var/datum/heap/open
	///An assoc list that serves as the closed list & tracks what turfs came from where. Key is the turf, and the value is what turf it came from
	var/list/sources
	/// The list we compile at the end if successful to pass back
	var/list/path

	// general pathfinding vars/args
	/// A list representing what access we have and what doors we can open.
	var/list/access
	/// How far away we have to get to the end target before we can call it quits
	var/mintargetdist = 0
	/// I don't know what this does vs , but they limit how far we can search before giving up on a path
	var/max_distance = 30
	/// Space is big and empty, if this is TRUE then we ignore pathing through unsimulated tiles
	var/simulated_only
	/// A specific turf we're avoiding, like if a mulebot is being blocked by someone t-posing in a doorway we're trying to get through
	var/turf/avoid
	/// If we should delete the first step in the path or not. Used often because it is just the starting tile
	var/skip_first = FALSE
	/// Ensures diagonal moves won't use invalid midstep turfs by splitting them into two orthogonal moves if necessary
	var/diagonal_safety = TRUE
	/// The callback to invoke when we're done working, passing in the completed var/list/path
	var/datum/callback/on_finish

	/// Datum that holds the canpass info of this pathing attempt. This is what CanAstarPass sees
	var/datum/can_pass_info/pass_info

	var/time_spent_pathfinding

/datum/pathfind/New(atom/movable/caller, atom/goal, access, max_distance, mintargetdist, simulated_only, avoid, skip_first, diagonal_safety, datum/callback/on_finish)
	src.caller = caller
	src.pass_info = new(caller, access)
	end = get_turf(goal)
	open = new /datum/heap(GLOBAL_PROC_REF(HeapPathWeightCompare))
	sources = new()
	src.access = access
	src.max_distance = max_distance
	src.mintargetdist = mintargetdist
	src.simulated_only = simulated_only
	src.avoid = avoid
	src.skip_first = skip_first
	src.diagonal_safety = diagonal_safety
	src.on_finish = on_finish

/datum/pathfind/Destroy(force, ...)
	. = ..()
	SSpathfinder.active_pathing -= src
	SSpathfinder.currentrun -= src
	if(on_finish)
		on_finish.Invoke(null)

/**
 * "starts" off the pathfinding, by storing the values this datum will need to work later on
 *  returns FALSE if it fails to setup properly, TRUE otherwise
 */
/datum/pathfind/proc/start()
	start = get_turf(caller)
	if(!start || !get_turf(end))
		stack_trace("Invalid A* start or destination")
		return FALSE
	if(start.z != end.z || start == end ) //no pathfinding between z levels
		return FALSE
	if(max_distance && (max_distance < get_dist(start, end))) //if start turf is farther than max_distance from end turf, no need to do anything
		return FALSE

	var/datum/jps_node/current_processed_node = new (start, -1, 0, end)
	open.insert(current_processed_node)
	sources[start] = start // i'm sure this is fine
	return TRUE

/**
 * search_step() is the workhorse of pathfinding. It'll do the searching logic, and will slowly build up a path
 * returns TRUE if everything is stable, FALSE if the pathfinding logic has failed, and we need to abort
 */
/datum/pathfind/proc/search_step()
	if(QDELETED(caller))
		return FALSE

	var/tick = TICK_USAGE
	while(!open.is_empty() && !path)
		var/datum/jps_node/current_processed_node = open.pop() //get the lower f_value turf in the open list
		if(max_distance && (current_processed_node.number_tiles > max_distance))//if too many steps, don't process that path
			continue

		var/turf/current_turf = current_processed_node.tile
		for(var/scan_direction in list(EAST, WEST, NORTH, SOUTH))
			lateral_scan_spec(current_turf, scan_direction, current_processed_node)

		for(var/scan_direction in list(NORTHEAST, SOUTHEAST, NORTHWEST, SOUTHWEST))
			diag_scan_spec(current_turf, scan_direction, current_processed_node)

		// Stable, we'll just be back later
		if(TICK_CHECK)
			time_spent_pathfinding += TICK_USAGE_TO_MS(tick)
			return TRUE

	time_spent_pathfinding += TICK_USAGE_TO_MS(tick)
	return TRUE

/**
 * early_exit() is called when something goes wrong in processing, and we need to halt the pathfinding NOW
 */
/datum/pathfind/proc/early_exit()
	on_finish.Invoke(null)
	on_finish = null
	qdel(src)

/**
 * Cleanup pass for the pathfinder. This tidies up the path, and fufills the pathfind's obligations
 */
/datum/pathfind/proc/finished()
	//we're done! reverse the path to get it from start to finish
	if(path)
		for(var/i = 1 to round(0.5 * length(path)))
			path.Swap(i, length(path) - i + 1)
	sources = null
	QDEL_NULL(open)

	if(diagonal_safety)
		path = diagonal_movement_safety()
	if(length(path) > 0 && skip_first)
		path.Cut(1,2)
	on_finish.Invoke(path)
	on_finish = null
	to_chat(world, span_debug("JPS took [time_spent_pathfinding / 1000] seconds to find a path [length(path)] tiles long. ([time_spent_pathfinding / length(path)]ms per tile)"))
	qdel(src)

/// Called when we've hit the goal with the node that represents the last tile, then sets the path var to that path so it can be returned by [datum/pathfind/proc/search]
/datum/pathfind/proc/unwind_path(datum/jps_node/unwind_node)
	path = new()
	var/turf/iter_turf = unwind_node.tile
	path.Add(iter_turf)

	while(unwind_node.previous_node)
		var/dir_goal = get_dir(iter_turf, unwind_node.previous_node.tile)
		for(var/i = 1 to unwind_node.jumps)
			iter_turf = get_step(iter_turf,dir_goal)
			path.Add(iter_turf)
		unwind_node = unwind_node.previous_node

/datum/pathfind/proc/diagonal_movement_safety()
	if(length(path) < 2)
		return
	var/list/modified_path = list()
	var/datum/can_pass_info/pass_info = src.pass_info

	for(var/i in 1 to length(path) - 1)
		var/turf/current_turf = path[i]
		var/turf/next_turf = path[i+1]
		var/movement_dir = get_dir(current_turf, next_turf)

		if(!(movement_dir & (movement_dir - 1))) //cardinal movement, no need to verify
			modified_path += current_turf
			continue

		//If default diagonal movement step is invalid, replace with alternative two steps
		if(movement_dir & NORTH)
			if(!CAN_STEP(current_turf,get_step(current_turf, NORTH), simulated_only, pass_info, avoid))
				modified_path += current_turf
				modified_path += get_step(current_turf, movement_dir & ~NORTH)
			else
				modified_path += current_turf

		else
			if(!CAN_STEP(current_turf, get_step(current_turf, SOUTH), simulated_only, pass_info, avoid))
				modified_path += current_turf
				modified_path += get_step(current_turf, movement_dir & ~SOUTH)
			else
				modified_path += current_turf

	modified_path += path[length(path)]

	return modified_path

/**
 * For performing lateral scans from a given starting turf.
 *
 * These scans are called from both the main search loop, as well as subscans for diagonal scans, and they treat finding interesting turfs slightly differently.
 * If we're doing a normal lateral scan, we already have a parent node supplied, so we just create the new node and immediately insert it into the heap, ezpz.
 * If we're part of a subscan, we still need for the diagonal scan to generate a parent node, so we return a node datum with just the turf and let the diag scan
 * proc handle transferring the values and inserting them into the heap.
 *
 * Arguments:
 * * original_turf: What turf did we start this scan at?
 * * heading: What direction are we going in? Obviously, should be cardinal
 * * parent_node: Only given for normal lateral scans, if we don't have one, we're a diagonal subscan.
*/
/datum/pathfind/proc/lateral_scan_spec(turf/original_turf, heading, datum/jps_node/parent_node)
	var/steps_taken = 0

	var/turf/current_turf = original_turf
	var/turf/lag_turf = original_turf
	var/datum/can_pass_info/pass_info = src.pass_info

	while(TRUE)
		if(path)
			return
		lag_turf = current_turf
		current_turf = get_step(current_turf, heading)
		steps_taken++
		if(!CAN_STEP(lag_turf, current_turf, simulated_only, pass_info, avoid))
			return

		if(current_turf == end || (mintargetdist && (get_dist(current_turf, end) <= mintargetdist)))
			var/datum/jps_node/final_node = new(current_turf, parent_node, steps_taken)
			sources[current_turf] = original_turf
			if(parent_node) // if this is a direct lateral scan we can wrap up, if it's a subscan from a diag, we need to let the diag make their node first, then finish
				unwind_path(final_node)
			return final_node
		else if(sources[current_turf]) // already visited, essentially in the closed list
			return
		else
			sources[current_turf] = original_turf

		if(parent_node && parent_node.number_tiles + steps_taken > max_distance)
			return

		var/interesting = FALSE // have we found a forced neighbor that would make us add this turf to the open list?

		switch(heading)
			if(NORTH)
				if(STEP_NOT_HERE_BUT_THERE(current_turf, WEST, NORTHWEST) || STEP_NOT_HERE_BUT_THERE(current_turf, EAST, NORTHEAST))
					interesting = TRUE
			if(SOUTH)
				if(STEP_NOT_HERE_BUT_THERE(current_turf, WEST, SOUTHWEST) || STEP_NOT_HERE_BUT_THERE(current_turf, EAST, SOUTHEAST))
					interesting = TRUE
			if(EAST)
				if(STEP_NOT_HERE_BUT_THERE(current_turf, NORTH, NORTHEAST) || STEP_NOT_HERE_BUT_THERE(current_turf, SOUTH, SOUTHEAST))
					interesting = TRUE
			if(WEST)
				if(STEP_NOT_HERE_BUT_THERE(current_turf, NORTH, NORTHWEST) || STEP_NOT_HERE_BUT_THERE(current_turf, SOUTH, SOUTHWEST))
					interesting = TRUE

		if(interesting)
			var/datum/jps_node/newnode = new(current_turf, parent_node, steps_taken)
			if(parent_node) // if we're a diagonal subscan, we'll handle adding ourselves to the heap in the diag
				open.insert(newnode)
			return newnode

/**
 * For performing diagonal scans from a given starting turf.
 *
 * Unlike lateral scans, these only are called from the main search loop, so we don't need to worry about returning anything,
 * though we do need to handle the return values of our lateral subscans of course.
 *
 * Arguments:
 * * original_turf: What turf did we start this scan at?
 * * heading: What direction are we going in? Obviously, should be diagonal
 * * parent_node: We should always have a parent node for diagonals
*/
/datum/pathfind/proc/diag_scan_spec(turf/original_turf, heading, datum/jps_node/parent_node)
	var/steps_taken = 0
	var/turf/current_turf = original_turf
	var/turf/lag_turf = original_turf
	var/datum/can_pass_info/pass_info = src.pass_info

	while(TRUE)
		if(path)
			return
		lag_turf = current_turf
		current_turf = get_step(current_turf, heading)
		steps_taken++
		if(!CAN_STEP(lag_turf, current_turf, simulated_only, pass_info, avoid))
			return

		if(current_turf == end || (mintargetdist && (get_dist(current_turf, end) <= mintargetdist)))
			var/datum/jps_node/final_node = new(current_turf, parent_node, steps_taken)
			sources[current_turf] = original_turf
			unwind_path(final_node)
			return
		else if(sources[current_turf]) // already visited, essentially in the closed list
			return
		else
			sources[current_turf] = original_turf

		if(parent_node.number_tiles + steps_taken > max_distance)
			return

		var/interesting = FALSE // have we found a forced neighbor that would make us add this turf to the open list?
		var/datum/jps_node/possible_child_node // otherwise, did one of our lateral subscans turn up something?

		switch(heading)
			if(NORTHWEST)
				if(STEP_NOT_HERE_BUT_THERE(current_turf, EAST, NORTHEAST) || STEP_NOT_HERE_BUT_THERE(current_turf, SOUTH, SOUTHWEST))
					interesting = TRUE
				else
					possible_child_node = (lateral_scan_spec(current_turf, WEST) || lateral_scan_spec(current_turf, NORTH))
			if(NORTHEAST)
				if(STEP_NOT_HERE_BUT_THERE(current_turf, WEST, NORTHWEST) || STEP_NOT_HERE_BUT_THERE(current_turf, SOUTH, SOUTHEAST))
					interesting = TRUE
				else
					possible_child_node = (lateral_scan_spec(current_turf, EAST) || lateral_scan_spec(current_turf, NORTH))
			if(SOUTHWEST)
				if(STEP_NOT_HERE_BUT_THERE(current_turf, EAST, SOUTHEAST) || STEP_NOT_HERE_BUT_THERE(current_turf, NORTH, NORTHWEST))
					interesting = TRUE
				else
					possible_child_node = (lateral_scan_spec(current_turf, SOUTH) || lateral_scan_spec(current_turf, WEST))
			if(SOUTHEAST)
				if(STEP_NOT_HERE_BUT_THERE(current_turf, WEST, SOUTHWEST) || STEP_NOT_HERE_BUT_THERE(current_turf, NORTH, NORTHEAST))
					interesting = TRUE
				else
					possible_child_node = (lateral_scan_spec(current_turf, SOUTH) || lateral_scan_spec(current_turf, EAST))

		if(interesting || possible_child_node)
			var/datum/jps_node/newnode = new(current_turf, parent_node, steps_taken)
			open.insert(newnode)
			if(possible_child_node)
				possible_child_node.update_parent(newnode)
				open.insert(possible_child_node)
				if(possible_child_node.tile == end || (mintargetdist && (get_dist(possible_child_node.tile, end) <= mintargetdist)))
					unwind_path(possible_child_node)
			return

/**
 * For seeing if we can actually move between 2 given turfs while accounting for our access and the caller's pass_flags
 *
 * Assumes destinantion turf is non-dense - check and shortcircuit in code invoking this proc to avoid overhead.
 * Makes some other assumptions, such as assuming that unless declared, non dense objects will not block movement.
 * It's fragile, but this is VERY much the most expensive part of JPS, so it'd better be fast
 *
 * Arguments:
 * * caller: The movable, if one exists, being used for mobility checks to see what tiles it can reach
 * * access: A list that decides if we can gain access to doors that would otherwise block a turf
 * * simulated_only: Do we only worry about turfs with simulated atmos, most notably things that aren't space?
 * * no_id: When true, doors with public access will count as impassible
*/
/turf/proc/LinkBlockedWithAccess(turf/destination_turf, datum/can_pass_info/pass_info)
	var/actual_dir = get_dir(src, destination_turf)
	if(actual_dir == 0)
		return FALSE

	var/is_diagonal_movement = ISDIAGONALDIR(actual_dir)

	if(is_diagonal_movement) //diagonal
		var/in_dir = get_dir(destination_turf,src) // eg. northwest (1+8) = 9 (00001001)
		var/first_step_direction_a = in_dir & 3 // eg. north   (1+8)&3 (0000 0011) = 1 (0000 0001)
		var/first_step_direction_b = in_dir & 12 // eg. west   (1+8)&12 (0000 1100) = 8 (0000 1000)

		for(var/first_step_direction in list(first_step_direction_a,first_step_direction_b))
			var/turf/midstep_turf = get_step(destination_turf,first_step_direction)
			var/way_blocked = midstep_turf.density || LinkBlockedWithAccess(midstep_turf, pass_info) || midstep_turf.LinkBlockedWithAccess(destination_turf, pass_info)
			if(!way_blocked)
				return FALSE

		return TRUE

	/// These are generally cheaper than looping contents so they go first
	switch(destination_turf.pathing_pass_method)
		// This is already assumed to be true
		//if(TURF_PATHING_PASS_DENSITY)
		//	if(destination_turf.density)
		//		return TRUE
		if(TURF_PATHING_PASS_PROC)
			if(!destination_turf.CanAStarPass(actual_dir, pass_info))
				return TRUE

		if(TURF_PATHING_PASS_NO)
			return TRUE

	var/static/list/directional_blocker_cache = typecacheof(list(/obj/structure/window, /obj/machinery/door/window, /obj/structure/railing, /obj/machinery/door/firedoor/border_only))
	// Source border object checks
	for(var/obj/border in src)
		if(!directional_blocker_cache[border.type])
			continue
		if(!border.density && border.can_astar_pass == CANASTARPASS_DENSITY)
			continue
		if(!border.CanAStarPass(actual_dir, pass_info))
			return TRUE

	// Destination blockers check
	var/reverse_dir = get_dir(destination_turf, src)
	for(var/obj/iter_object in destination_turf)
		// This is an optimization because of the massive call count of this code
		if(!iter_object.density && iter_object.can_astar_pass == CANASTARPASS_DENSITY)
			continue
		if(!iter_object.CanAStarPass(reverse_dir, pass_info))
			return TRUE
	return FALSE

// Could easily be a struct if/when we get that
/**
 * Holds all information about what an atom can move through
 * Passed into CanAStarPass to provide context for a pathing attempt
 *
 * Also used to check if using a cached path_map is safe
 * There are some vars here that are unused. They exist to cover cases where caller_ref is used
 * They're the properties of caller_ref used in those cases.
 * It's kinda annoying, but there's some proc chains we can't convert to this datum
 */
/datum/can_pass_info
	/// If we have no id, public airlocks are walls
	var/no_id = FALSE

	/// What we can pass through. Mirrors /atom/movable/pass_flags
	var/pass_flags = NONE
	/// What access we have, airlocks, windoors, etc
	var/list/access = null
	/// What sort of movement do we have. Mirrors /atom/movable/movement_type
	var/movement_type = NONE
	/// Are we being thrown?
	var/thrown = FALSE
	/// Are we anchored
	var/anchored = FALSE

	/// Are we a ghost? (they have effectively unique pathfinding)
	var/is_observer = FALSE
	/// Are we a living mob?
	var/is_living = FALSE
	/// Are we a bot?
	var/is_bot = FALSE
	/// Can we ventcrawl?
	var/can_ventcrawl = FALSE
	/// What is the size of our mob
	var/mob_size = null
	/// Is our mob incapacitated
	var/incapacitated = FALSE
	/// Is our mob incorporeal
	var/incorporeal_move = FALSE
	/// If our mob has a rider, what does it look like
	var/datum/can_pass_info/rider_info = null
	/// If our mob is buckled to something, what's it like
	var/datum/can_pass_info/buckled_info = null

	/// Do we have gravity
	var/has_gravity = TRUE
	/// Pass information for the object we are pulling, if any
	var/list/grab_infos = null

	/// Cameras have a lot of BS can_z_move overrides
	/// Let's avoid this
	var/camera_type

	/// Weakref to the caller used to generate this info
	/// Should not use this almost ever, it's for context and to allow for proc chains that
	/// Require a movable
	var/datum/weakref/caller_ref = null

/datum/can_pass_info/New(atom/movable/construct_from, list/access, no_id = FALSE, call_depth = 0, ignore_grabs = FALSE)
	// No infiniloops
	if(call_depth > 10)
		return
	if(access)
		src.access = access.Copy()
	src.no_id = no_id

	if(isnull(construct_from))
		return

	src.caller_ref = WEAKREF(construct_from)
	src.pass_flags = construct_from.pass_flags
	src.movement_type = construct_from.movement_type
	src.thrown = !!construct_from.throwing
	src.anchored = construct_from.anchored
	src.has_gravity = construct_from.has_gravity()

	if(ismob(construct_from))
		var/mob/living/mob_construct = construct_from
		src.incapacitated = mob_construct.incapacitated()
		if(mob_construct.buckled)
			src.buckled_info = new(mob_construct.buckled, access, no_id, call_depth + 1)

	if(isobserver(construct_from))
		src.is_observer = TRUE

	if(isliving(construct_from))
		var/mob/living/living_construct = construct_from
		src.is_living = TRUE
		src.can_ventcrawl = HAS_TRAIT(living_construct, TRAIT_VENTCRAWLER_ALWAYS) || HAS_TRAIT(living_construct, TRAIT_VENTCRAWLER_NUDE)
		src.mob_size = living_construct.mob_size
		src.incorporeal_move = living_construct.incorporeal_move
		if(!ignore_grabs && LAZYLEN(living_construct.active_grabs))
			grab_infos = list()
			for(var/atom/movable/grabbed_by in living_construct.recursively_get_all_grabbed_movables())
				grab_infos += new(grabbed_by, access, no_id, call_depth + 1, ignore_grabs = TRUE)

	if(iscameramob(construct_from))
		src.camera_type = construct_from.type
	src.is_bot = isbot(construct_from)

/// List of vars on /datum/can_pass_info to use when checking two instances for equality
GLOBAL_LIST_INIT(can_pass_info_vars, GLOBAL_PROC_REF(can_pass_check_vars))

/proc/can_pass_check_vars()
	var/datum/can_pass_info/lamb = new()
	var/datum/isaac = new()
	var/list/altar = assoc_to_keys(lamb.vars - isaac.vars)
	// Don't compare against calling atom, it's not relevant here
	altar -= "caller_ref"
	if(!("caller_ref" in lamb.vars))
		CRASH("caller_ref var was not found in /datum/can_pass_info, why are we filtering for it?")
	// We will bespoke handle pulling_info
	altar -= "pulling_info"
	if(!("pulling_info" in lamb.vars))
		CRASH("pulling_info var was not found in /datum/can_pass_info, why are we filtering for it?")
	return altar

/datum/can_pass_info/proc/compare_against(datum/can_pass_info/check_against)
	for(var/comparable_var in GLOB.can_pass_info_vars)
		if(!(vars[comparable_var] ~= check_against[comparable_var]))
			return FALSE
	return TRUE
