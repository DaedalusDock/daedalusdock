/// Queues and manages JPS pathfinding steps
SUBSYSTEM_DEF(pathfinder)
	name = "Pathfinder"
	init_order = INIT_ORDER_PATH
	priority = FIRE_PRIORITY_PATHFINDING
	flags = SS_NO_INIT
	wait = 0.5
	/// List of pathfind datums we are currently trying to process
	var/list/datum/pathfind/jps/active_pathing = list()
	/// List of pathfind datums being ACTIVELY processed. exists to make subsystem stats readable
	var/list/datum/pathfind/jps/currentrun = list()

/datum/controller/subsystem/pathfinder/stat_entry(msg)
	msg = "P:[length(active_pathing)]"
	return ..()

// This is another one of those subsystems (hey lighting) in which one "Run" means fully processing a queue
// We'll use a copy for this just to be nice to people reading the mc panel
/datum/controller/subsystem/pathfinder/fire(resumed)
	if(!resumed)
		src.currentrun = active_pathing.Copy()

	// Dies of sonic speed from caching datum var reads
	var/list/currentrun = src.currentrun
	while(length(currentrun))
		var/datum/pathfind/jps/path = currentrun[length(currentrun)]
		if(!path.search_step()) // Something's wrong
			path.early_exit()
			currentrun.len--
			continue
		if(MC_TICK_CHECK)
			return
		path.finished()
		// Next please
		currentrun.len--

/// Initiates a pathfind. Returns true if we're good, FALSE if something's failed
/datum/controller/subsystem/pathfinder/proc/pathfind(atom/movable/invoker, atom/end, max_distance = 30, mintargetdist, list/access=null, simulated_only = TRUE, turf/exclude, skip_first=TRUE, diagonal_handling=DIAGONAL_REMOVE_CLUNKY, datum/callback/on_finish)
	var/datum/pathfind/jps/path = new(invoker, end, access, max_distance, mintargetdist, simulated_only, exclude, skip_first, diagonal_handling, on_finish)
	if(path.start())
		active_pathing += path
		return TRUE
	return FALSE

/// Pathfind RIGHT NOW!! Returns a list of turfs if a path was found, or FALSE if it could not find a path.
/datum/controller/subsystem/pathfinder/proc/pathfind_now(atom/movable/invoker, atom/end, max_distance = 5, mintargetdist, list/access=null, simulated_only = TRUE, turf/exclude, skip_first=TRUE, diagonal_handling=DIAGONAL_REMOVE_CLUNKY)
	var/datum/pathfind/jps/path = new(invoker, end, access, max_distance, mintargetdist, simulated_only, exclude, skip_first, diagonal_handling, null)
	if(!path.start())
		return FALSE

	if(!path.search_step(FALSE))
		path.early_exit()
		return FALSE

	path.finished()
	return path.path
