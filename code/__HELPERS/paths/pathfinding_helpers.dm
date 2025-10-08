/*
 * This file contains the stuff you need for using advanced pathing, such as A* or JPS.
*/

/**
 * This proc uses JPS to jump over large numbers of uninteresting tiles resulting in much quicker pathfinding solutions, but can "botch" some paths. Mind that diagonals
 * cost the same as cardinal moves currently, so paths may look a bit strange, but should still be optimal.
 * If no path was found, returns an empty list, which is important for bots like medibots who expect an empty list rather than nothing.
 * It will yield until a path is returned, using magic.
 *
 * Arguments:
 * * invoker: The movable atom that's trying to find the path
 * * end: What we're trying to path to. It doesn't matter if this is a turf or some other atom, we're gonna just path to the turf it's on anyway
 * * max_steps: The maximum number of steps we can take in a given path to search (default: 30, 0 = infinite)
 * * mintargetdistance: Minimum distance to the target before path returns, could be used to get near a target, but not right to it - for an AI mob with a gun, for example.
 * * access: A list representing what access we have and what doors we can open.
 * * simulated_only: Whether we consider turfs without atmos simulation (AKA do we want to ignore space)
 * * exclude: If we want to avoid a specific turf, like if we're a mulebot who already got blocked by some turf
 * * skip_first: Whether or not to delete the first item in the path. This would be done because the first item is the starting tile, which can break movement for some creatures.
 * * diagonal_handling: defines how we handle diagonal moves. see __DEFINES/path.dm
 */
/proc/jps_path_to(atom/movable/invoker, atom/end, max_steps = 30, mintargetdist, list/access, simulated_only = TRUE, turf/exclude, skip_first=TRUE, diagonal_handling=DIAGONAL_REMOVE_CLUNKY)
	var/datum/pathfind_packet/packet = new
	// We're guarenteed that list will be the first list in pathfinding_finished's argset because of how callback handles the arguments list
	var/datum/callback/await = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(__pathfinding_finished), packet)
	if(!SSpathfinder.jps_pathfind(invoker, end, max_steps, mintargetdist, access, simulated_only, exclude, skip_first, diagonal_handling, await))
		return list()

	UNTIL(packet.path)
	return packet.path

/**
 * This proc uses A* to find the most optimal path between two turfs. Unlike JPS, it allows using a custom heuristic callback to change the
 * weights of nodes. A* will always return the most optimal path and will not fail to pathfind in cases where JPS will (directional blockers).
 *
 * Arguments:
 * * invoker: The movable atom that's trying to find the path
 * * end: What we're trying to path to. It doesn't matter if this is a turf or some other atom, we're gonna just path to the turf it's on anyway
 * * max_steps: The maximum number of steps we can take in a given path to search (default: 30, 0 = infinite)
 * * mintargetdistance: Minimum distance to the target before path returns, could be used to get near a target, but not right to it - for an AI mob with a gun, for example.
 * * access: A list representing what access we have and what doors we can open.
 * * simulated_only: Whether we consider turfs without atmos simulation (AKA do we want to ignore space)
 * * exclude: If we want to avoid a specific turf, like if we're a mulebot who already got blocked by some turf
 * * skip_first: Whether or not to delete the first item in the path. This would be done because the first item is the starting tile, which can break movement for some creatures.
 * * use_diagonals: If you want the path to include diagonal steps. Set to FALSE for cardinal moves only.
 * * heuristic: A proc to call to determine how nodes are weighted. The higher the returned value, the less likely the pathfinder wants to traverse. 0 means invalid turf.
 */
/proc/astar_path_to(
	atom/movable/invoker,
	atom/end,
	max_steps = 30,
	mintargetdist,
	list/access,
	simulated_only = TRUE,
	turf/exclude,
	skip_first = TRUE,
	use_diagonals = TRUE,
	datum/callback/heuristic,
)
	var/datum/pathfind_packet/packet = new
	// We're guarenteed that list will be the first list in pathfinding_finished's argset because of how callback handles the arguments list
	var/datum/callback/await = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(__pathfinding_finished), packet)
	if(!SSpathfinder.astar_pathfind(invoker, end, max_steps, mintargetdist, access, simulated_only, exclude, skip_first, use_diagonals, await, heuristic))
		return list()

	UNTIL(packet.path)
	return packet.path
