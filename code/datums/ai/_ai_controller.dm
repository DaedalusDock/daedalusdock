/*
AI controllers are a datumized form of AI that simulates the input a player would otherwise give to a atom. What this means is that these datums
have ways of interacting with a specific atom and control it. They posses a blackboard with the information the AI knows and has, and will plan behaviors it will try to execute through
multiple modular subtrees with behaviors
*/

/datum/ai_controller
	///The atom this controller is controlling
	var/atom/movable/pawn

	///Bitfield of traits for this AI to handle extra behavior
	var/ai_traits
	///Current status of AI (OFF/ON)
	var/ai_status

	/// The default behavior to execute when there's nothing else to do.
	var/datum/ai_behavior/default_behavior

	///Current actions being performed by the AI.
	var/list/current_behaviors
	///Current actions and their respective last time ran as an assoc list.
	var/list/behavior_cooldowns = list()
	///Current movement target of the AI, generally set by decision making.
	var/atom/current_movement_target


	/**
	 * This is a list of variables the AI uses and can be mutated by actions.
	 *
	 * When an action is performed you pass this list and any relevant keys for the variables it can mutate.
	 *
	 * DO NOT set values in the blackboard directly, and especially not if you're adding a datum reference to this!
	 * Use the setters, in _ai_controller_blackboard.dm!!!
	 */
	var/list/blackboard = list()
	///Stored arguments for behaviors given during their initial creation
	var/list/behavior_args = list()

	///Tracks recent pathing attempts, if we fail too many in a row we fail our current plans.
	var/consecutive_pathing_attempts
	///Can the AI remain in control if there is a client?
	var/continue_processing_when_client = FALSE
	///distance to give up on target
	var/max_target_distance = 14
	/// The search radius when looking for interesting things.
	var/target_search_radius = 5

	///Cooldown for new plans, to prevent AI from going nuts if it can't think of new plans and looping on end
	COOLDOWN_DECLARE(failed_planning_cooldown)
	///All subtrees this AI has available, will run them in order, so make sure they're in the order you want them to run. On initialization of this type, it will start as a typepath(s) and get converted to references of ai_subtrees found in SSai_controllers when init_subtrees() is called
	var/list/planning_subtrees

	// Movement related things here
	///Reference to the movement datum we use. Is a type on initialize but becomes a ref afterwards.
	var/datum/ai_movement/ai_movement = /datum/ai_movement/dumb

	///Cooldown until next movement
	COOLDOWN_DECLARE(movement_cooldown)
	/// Movement delay used by NON MOBS, use get_movement_delay()
	var/non_mob_movement_delay = 0.4 SECONDS

	// The variables below are fucking stupid and should be put into the blackboard at some point.
	///AI paused time
	var/paused_until = 0

	#ifdef DEBUG_AI
	var/debug_focus = FALSE
	#endif

/datum/ai_controller/New(atom/new_pawn)
	change_ai_movement_type(ai_movement)
	init_subtrees()

	PossessPawn(new_pawn)

/datum/ai_controller/Destroy(force, ...)
	set_ai_status(AI_STATUS_OFF)
	UnpossessPawn(FALSE)
	return ..()

///Overrides the current ai_movement of this controller with a new one
/datum/ai_controller/proc/change_ai_movement_type(datum/ai_movement/new_movement)
	ai_movement = SSai_movement.movement_types[new_movement]

///Completely replaces the planning_subtrees with a new set based on argument provided, list provided must contain specifically typepaths
/datum/ai_controller/proc/replace_planning_subtrees(list/typepaths_of_new_subtrees)
	planning_subtrees = typepaths_of_new_subtrees
	init_subtrees()

///Loops over the subtrees in planning_subtrees and looks at the ai_controllers to grab a reference, ENSURE planning_subtrees ARE TYPEPATHS AND NOT INSTANCES/REFERENCES BEFORE EXECUTING THIS
/datum/ai_controller/proc/init_subtrees()
	if(!LAZYLEN(planning_subtrees))
		return
	var/list/temp_subtree_list = list()
	for(var/subtree in planning_subtrees)
		var/datum/ai_planning_subtree/subtree_instance = SSai_controllers.ai_subtrees[subtree]
		temp_subtree_list += subtree_instance
		subtree_instance.setup(src)

	planning_subtrees = temp_subtree_list

///Proc to move from one pawn to another, this will destroy the target's existing controller.
/datum/ai_controller/proc/PossessPawn(atom/new_pawn)
	if(pawn) //Reset any old signals
		UnpossessPawn(FALSE)

	if(istype(new_pawn.ai_controller)) //Existing AI, kill it.
		QDEL_NULL(new_pawn.ai_controller)

	if(TryPossessPawn(new_pawn) & AI_CONTROLLER_INCOMPATIBLE)
		qdel(src)
		CRASH("[src] attached to [new_pawn] but these are not compatible!")

	pawn = new_pawn
	pawn.ai_controller = src

	if(!continue_processing_when_client && istype(new_pawn, /mob))
		var/mob/possible_client_holder = new_pawn
		if(possible_client_holder.client)
			set_ai_status(AI_STATUS_OFF)
		else
			set_ai_status(AI_STATUS_ON)
	else
		set_ai_status(AI_STATUS_ON)

	RegisterSignal(pawn, COMSIG_MOB_LOGIN, PROC_REF(on_sentience_gained))
	RegisterSignal(pawn, COMSIG_MOB_STATCHANGE, PROC_REF(on_stat_change))

///Abstract proc for initializing the pawn to the new controller
/datum/ai_controller/proc/TryPossessPawn(atom/new_pawn)
	return

///Proc for deinitializing the pawn to the old controller
/datum/ai_controller/proc/UnpossessPawn(destroy)
	UnregisterSignal(pawn, list(COMSIG_MOB_LOGIN, COMSIG_MOB_LOGOUT, COMSIG_MOB_STATCHANGE))
	if(ai_movement.moving_controllers[src])
		ai_movement.stop_moving_towards(src)
	pawn.ai_controller = null
	pawn = null
	if(destroy)
		qdel(src)
	return

///Returns TRUE if the ai controller can actually run at the moment.
/datum/ai_controller/proc/able_to_run()
	if(HAS_TRAIT(pawn, TRAIT_AI_PAUSED))
		return FALSE

	if(world.time < paused_until)
		return FALSE

	if(isliving(pawn))
		var/mob/living/living_pawn = pawn
		if(IS_DEAD_OR_INCAP(living_pawn))
			return FALSE
	return TRUE

/// This is called by SSai_behaviors/fire(). It is the core of mob AI.
/datum/ai_controller/process(delta_time)
	if(!able_to_run())
		SSmove_manager.stop_looping(pawn) //stop moving
		return //this should remove them from processing in the future through event-based stuff.

	for(var/datum/ai_behavior/current_behavior as anything in current_behaviors)

		// Convert the current behaviour action cooldown to realtime seconds from deciseconds.current_behavior
		// Then pick the max of this and the seconds_per_tick passed to ai_controller.process()
		// Action cooldowns cannot happen faster than seconds_per_tick, so seconds_per_tick should be the value used in this scenario.
		var/action_seconds_per_tick = max(current_behavior.get_cooldown(src) * 0.1, delta_time)

		if(!(current_behavior.behavior_flags & AI_BEHAVIOR_REQUIRE_MOVEMENT))
			if(behavior_cooldowns[current_behavior] > world.time) //Still on cooldown
				continue
			ProcessBehavior(action_seconds_per_tick, current_behavior)
			return

		if(isnull(current_movement_target))
			fail_behavior(current_behavior)
			return

		///Stops pawns from performing such actions that should require the target to be adjacent.
		var/atom/movable/moving_pawn = pawn
		var/can_reach = !(current_behavior.behavior_flags & AI_BEHAVIOR_REQUIRE_REACH) || current_movement_target.IsReachableBy(moving_pawn)
		if(can_reach && current_behavior.required_distance >= get_dist(moving_pawn, current_movement_target)) ///Are we close enough to engage?
			if(ai_movement.moving_controllers[src] == current_movement_target) //We are close enough, if we're moving stop.
				ai_movement.stop_moving_towards(src)

			if(behavior_cooldowns[current_behavior] > world.time) //Still on cooldown
				continue
			ProcessBehavior(action_seconds_per_tick, current_behavior)
			return

		if(ai_movement.moving_controllers[src] != current_movement_target) //We're too far, if we're not already moving start doing it.
			ai_movement.start_moving_towards(src, current_movement_target, current_behavior.required_distance) //Then start moving

		if(current_behavior.behavior_flags & AI_BEHAVIOR_MOVE_AND_PERFORM) //If we can move and perform then do so.
			if(behavior_cooldowns[current_behavior] > world.time) //Still on cooldown
				continue
			ProcessBehavior(action_seconds_per_tick, current_behavior)
			return

///This is where you decide what actions are taken by the AI.
/datum/ai_controller/proc/ProcessBehaviorSelection(delta_time)
	SHOULD_NOT_SLEEP(TRUE) //Fuck you don't sleep in procs like this.
	if(!COOLDOWN_FINISHED(src, failed_planning_cooldown))
		return FALSE
	DEBUG_AI_LOG(src, "Beginning behavior selection")

	LAZYINITLIST(current_behaviors)

	if(LAZYLEN(planning_subtrees))
		for(var/datum/ai_planning_subtree/subtree as anything in planning_subtrees)
			if(subtree.ProcessBehaviorSelection(src, delta_time) == SUBTREE_RETURN_FINISH_PLANNING)
				break

	DEBUG_AI_LOG(src, "Behavior selection concluded")

///Determines whether the AI can currently make a new plan
/datum/ai_controller/proc/able_to_plan()
	. = TRUE
	if(QDELETED(pawn))
		return FALSE

	if(HAS_TRAIT(pawn, TRAIT_AI_DISABLE_PLANNING))
		return FALSE

	for(var/datum/ai_behavior/current_behavior as anything in current_behaviors)
		if(!(current_behavior.behavior_flags & AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION)) //We have a behavior that blocks planning
			. = FALSE
			break

///This proc handles changing ai status, and starts/stops processing if required.
/datum/ai_controller/proc/set_ai_status(new_ai_status)
	if(ai_status == new_ai_status)
		return FALSE //no change

	ai_status = new_ai_status
	switch(ai_status)
		if(AI_STATUS_ON)
			SSai_controllers.active_ai_controllers += src
			START_PROCESSING(SSai_behaviors, src)
			DEBUG_AI_LOG(src, "Processing resumed.")
		if(AI_STATUS_OFF)
			STOP_PROCESSING(SSai_behaviors, src)
			SSai_controllers.active_ai_controllers -= src
			CancelActions()
			DEBUG_AI_LOG(src, "Processing paused.")

	SEND_SIGNAL(src, COMSIG_AI_STATUS_CHANGE, ai_status)

/datum/ai_controller/proc/PauseAi(time)
	paused_until = world.time + time

/datum/ai_controller/proc/set_move_target(atom/thing)
	DEBUG_AI_LOG(src, isnull(thing) ? "Canceled movement plan" : "Moving towards [COORD(thing)]")
	current_movement_target = thing

///Call this to add a behavior to the stack.
/datum/ai_controller/proc/queue_behavior(behavior_type, ...)
	var/datum/ai_behavior/behavior = GET_AI_BEHAVIOR(behavior_type)
	if(!behavior)
		CRASH("Behavior [behavior_type] not found.")

	var/list/arguments = args.Copy()
	arguments[1] = src
	if(!behavior.setup(arglist(arguments)))
		return

	LAZYADD(current_behaviors, behavior)
	arguments.Cut(1, 2)

	if(length(arguments))
		behavior_args[behavior_type] = arguments
	else
		behavior_args -= behavior_type

	DEBUG_AI_LOG(src, "Queued [behavior_type]")

	if(length(behavior.sub_behaviors))
		for(var/sub_behavior_type in behavior.sub_behaviors)
			var/list/sub_args = args.Copy()
			sub_args[1] = sub_behavior_type
			queue_behavior(arglist(sub_args))

/datum/ai_controller/proc/ProcessBehavior(delta_time, datum/ai_behavior/behavior)
	DEBUG_AI_LOG(src, "Running [behavior]")

	var/list/arguments = list(delta_time, src)
	var/list/stored_arguments = behavior_args[behavior.type]
	if(stored_arguments)
		arguments += stored_arguments

	var/process_result = behavior.perform(arglist(arguments))
	if(process_result & BEHAVIOR_PERFORM_COOLDOWN)
		behavior_cooldowns[behavior] = world.time + behavior.get_cooldown(src)

	arguments[1] = src // finish_action() does not care about delta time
	if(process_result & BEHAVIOR_PERFORM_SUCCESS)
		arguments[2] = TRUE
		behavior.finish_action(arglist(arguments))
		DEBUG_AI_LOG(src, "Succeeded [behavior.type]")

	else if(process_result & BEHAVIOR_PERFORM_FAILURE)
		arguments[2] = FALSE
		behavior.finish_action(arglist(arguments))
		DEBUG_AI_LOG(src, "Failed [behavior.type]")
	else
		DEBUG_AI_LOG(src, "Continuing [behavior.type]")

/datum/ai_controller/proc/CancelActions()
	if(!LAZYLEN(current_behaviors))
		return
	for(var/datum/ai_behavior/current_behavior as anything in current_behaviors)
		fail_behavior(current_behavior)

/datum/ai_controller/proc/fail_behavior(datum/ai_behavior/current_behavior)
	var/list/arguments = list(src, FALSE)
	var/list/stored_arguments = behavior_args[current_behavior.type]
	if(stored_arguments)
		arguments += stored_arguments
	current_behavior.finish_action(arglist(arguments))

/datum/ai_controller/proc/get_movement_delay()
	if(isliving(pawn))
		var/mob/living/living_pawn = pawn
		return living_pawn.movement_delay
	return non_mob_movement_delay

/datum/ai_controller/proc/MovePawn(...)
	if(!isturf(pawn.loc))
		return FALSE

	if(blackboard[BB_NEXT_MOVE_TIME] >= world.time)
		return FALSE

	var/mob/living/living_pawn = pawn
	if(isliving(pawn))
		living_pawn = pawn
		if(!(living_pawn.mobility_flags & MOBILITY_MOVE))
			return FALSE

	. = pawn.Move(arglist(args))

	if(.)
		set_blackboard_key(BB_NEXT_MOVE_TIME, world.time + get_movement_delay())

/datum/ai_controller/proc/on_sentience_gained()
	SIGNAL_HANDLER
	UnregisterSignal(pawn, COMSIG_MOB_LOGIN)
	if(!continue_processing_when_client)
		set_ai_status(AI_STATUS_OFF) //Can't do anything while player is connected
	RegisterSignal(pawn, COMSIG_MOB_LOGOUT, PROC_REF(on_sentience_lost))

/datum/ai_controller/proc/on_sentience_lost()
	SIGNAL_HANDLER
	UnregisterSignal(pawn, COMSIG_MOB_LOGOUT)
	set_ai_status(AI_STATUS_ON) //Can't do anything while player is connected
	RegisterSignal(pawn, COMSIG_MOB_LOGIN, PROC_REF(on_sentience_gained))

/datum/ai_controller/proc/on_stat_change(datum/source, new_stat, old_stat)
	SIGNAL_HANDLER

	switch(new_stat)
		if(CONSCIOUS)
			REMOVE_TRAIT(pawn, TRAIT_AI_PAUSED, STAT_TRAIT)
			REMOVE_TRAIT(pawn, TRAIT_AI_DISABLE_PLANNING, STAT_TRAIT)
		else
			ADD_TRAIT(pawn, TRAIT_AI_PAUSED, STAT_TRAIT)
			ADD_TRAIT(pawn, TRAIT_AI_DISABLE_PLANNING, STAT_TRAIT)

/// Use this proc to define how your controller defines what access the pawn has for the sake of pathfinding, likely pointing to whatever ID slot is relevant
/datum/ai_controller/proc/get_access()
	if(!isliving(pawn))
		return
	var/mob/living/living_pawn = pawn
	return living_pawn.get_idcard()?.GetAccess()

///Returns the minimum required distance to preform one of our current behaviors. Honestly this should just be cached or something but fuck you
/datum/ai_controller/proc/get_minimum_distance()
	var/minimum_distance = max_target_distance
	// right now I'm just taking the shortest minimum distance of our current behaviors, at some point in the future
	// we should let whatever sets the current_movement_target also set the min distance and max path length
	// (or at least cache it on the controller)
	for(var/datum/ai_behavior/iter_behavior as anything in current_behaviors)
		if(iter_behavior.required_distance < minimum_distance)
			minimum_distance = iter_behavior.required_distance
	return minimum_distance
