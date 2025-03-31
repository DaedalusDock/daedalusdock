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
 * * invoker: The movable atom that's trying to find the path
 * * end: What we're trying to path to. It doesn't matter if this is a turf or some other atom, we're gonna just path to the turf it's on anyway
 * * max_distance: The maximum number of steps we can take in a given path to search (default: 30, 0 = infinite)
 * * mintargetdistance: Minimum distance to the target before path returns, could be used to get near a target, but not right to it - for an AI mob with a gun, for example.
 * * access: A list representing what access we have and what doors we can open.
 * * simulated_only: Whether we consider turfs without atmos simulation (AKA do we want to ignore space)
 * * exclude: If we want to avoid a specific turf, like if we're a mulebot who already got blocked by some turf
 * * skip_first: Whether or not to delete the first item in the path. This would be done because the first item is the starting tile, which can break movement for some creatures.
 * * diagonal_handling: defines how we handle diagonal moves. see __DEFINES/path.dm
 */
/proc/jps_path_to(atom/movable/invoker, atom/end, max_distance = 30, mintargetdist, list/access, simulated_only = TRUE, turf/exclude, skip_first=TRUE, diagonal_handling=DIAGONAL_REMOVE_CLUNKY)
	var/datum/pathfind_packet/packet = new
	// We're guarenteed that list will be the first list in pathfinding_finished's argset because of how callback handles the arguments list
	var/datum/callback/await = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(pathfinding_finished), packet)
	if(!SSpathfinder.pathfind(invoker, end, max_distance, mintargetdist, access, simulated_only, exclude, skip_first, diagonal_handling, await))
		return list()

	UNTIL(packet.path)
	return packet.path

/// Uses funny pass by reference bullshit to take the path created by pathfinding, and insert it into a return list
/// We'll be able to use this return list to tell a sleeping proc to continue execution
/proc/pathfinding_finished(datum/pathfind_packet/return_packet, list/path)
	return_packet.path = path || list()

/// Wrapper around the path list since we play with refs.
/datum/pathfind_packet
	/// The unwound path, set when it's finished.
	var/list/path

/datum/pathfind
	/// The turf we started at
	var/turf/start

	// general pathfinding vars/args
	/// Limits how far we can search before giving up on a path
	var/max_distance = 30
	/// Space is big and empty, if this is TRUE then we ignore pathing through unsimulated tiles
	var/simulated_only
	/// A specific turf we're avoiding, like if a mulebot is being blocked by someone t-posing in a doorway we're trying to get through
	var/turf/avoid
	/// The callbacks to invoke when we're done working, passing in the completed product
	/// Invoked in order
	var/datum/callback/on_finish
	/// Datum that holds the canpass info of this pathing attempt. This is what CanAstarPass sees
	var/datum/can_pass_info/pass_info

/datum/pathfind/Destroy(force)
	. = ..()
	SSpathfinder.active_pathing -= src
	SSpathfinder.currentrun -= src
	hand_back(null)
	avoid = null

/**
 * "starts" off the pathfinding, by storing the values this datum will need to work later on
 *  returns FALSE if it fails to setup properly, TRUE otherwise
 */
/datum/pathfind/proc/start()
	if(!start)
		stack_trace("Invalid pathfinding start")
		return FALSE
	return TRUE

/**
 * search_step() is the workhorse of pathfinding. It'll do the searching logic, and will slowly build up a path
 * returns TRUE if everything is stable, FALSE if the pathfinding logic has failed, and we need to abort
 */
/datum/pathfind/proc/search_step()
	return TRUE

/**
 * early_exit() is called when something goes wrong in processing, and we need to halt the pathfinding NOW
 */
/datum/pathfind/proc/early_exit()
	hand_back(null)
	qdel(src)

/**
 * Cleanup pass for the pathfinder. This tidies up the path, and fufills the pathfind's obligations
 */
/datum/pathfind/proc/finished()
	qdel(src)

/**
 * Call to return a value to whoever spawned this pathfinding work
 * Will fail if it's already been called
 */
/datum/pathfind/proc/hand_back(list/value)
	set waitfor = FALSE
	on_finish?.Invoke(value)
	on_finish = null

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
	/// If our mob is flock phasing or can flock phase.
	var/able_to_flockphase = FALSE

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
				grab_infos += new /datum/can_pass_info(grabbed_by, access, no_id, call_depth + 1, ignore_grabs = TRUE)

	if(iscameramob(construct_from))
		src.camera_type = construct_from.type
	src.is_bot = isbot(construct_from)

	if(isflockdrone(construct_from))
		var/mob/living/simple_animal/flock/drone/bird = construct_from
		if(HAS_TRAIT(bird, TRAIT_FLOCKPHASE) || bird.resources.has_points(10))
			able_to_flockphase = TRUE

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
		if(!(vars[comparable_var] ~= check_against.vars[comparable_var]))
			return FALSE
	return TRUE
