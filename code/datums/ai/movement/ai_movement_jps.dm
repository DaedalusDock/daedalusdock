/**
 * This movement datum represents smart-pathing
 */
/datum/ai_movement/jps
	max_pathing_attempts = 20

	var/diagonal_handling = DIAGONAL_REMOVE_CLUNKY

/datum/ai_movement/jps/start_moving_towards(datum/ai_controller/controller, atom/current_movement_target, min_distance)
	. = ..()
	var/atom/movable/moving = controller.pawn
	var/delay = controller.get_movement_delay()
	var/max_path_length_override = controller.blackboard[BB_PATH_MAX_LENGTH]
	var/diagonal_handling_override = controller.blackboard[BB_PATH_DIAGONAL_HANDLING]

	var/datum/move_loop/loop = SSmove_manager.jps_move(moving,
		current_movement_target,
		delay,
		repath_delay = 0.5 SECONDS,
		max_path_length = isnull(max_path_length_override) ? max_path_length : max_path_length_override,
		minimum_distance = controller.get_minimum_distance(),
		access = controller.get_access(),
		simulated_only = !HAS_TRAIT(controller.pawn, TRAIT_FREE_FLOAT_MOVEMENT),
		subsystem = SSai_movement,
		extra_info = controller,
		initial_path = controller.blackboard[BB_PATH_TO_USE],
		diagonal_handling = isnull(diagonal_handling_override) ? diagonal_handling : diagonal_handling_override,
		)

	RegisterSignal(loop, COMSIG_MOVELOOP_PREPROCESS_CHECK, PROC_REF(pre_move))
	RegisterSignal(loop, COMSIG_MOVELOOP_POSTPROCESS, PROC_REF(post_move))
	RegisterSignal(loop, COMSIG_MOVELOOP_JPS_REPATH, PROC_REF(repath_incoming))

/datum/ai_movement/jps/proc/repath_incoming(datum/move_loop/has_target/jps/source)
	SIGNAL_HANDLER
	var/datum/ai_controller/controller = source.extra_info

	source.access = controller.get_access()
	source.minimum_distance = controller.get_minimum_distance()

/datum/ai_movement/jps/modsuit
	max_path_length = MOD_AI_RANGE

/datum/ai_movement/jps/modsuit/pre_move(datum/move_loop/source)
	. = ..()
	if(.)
		return
	var/datum/move_loop/has_target/jps/moveloop = source
	if(!length(moveloop.movement_path))
		return

	var/datum/ai_controller/controller = source.extra_info
	var/obj/item/mod = controller.pawn
	var/angle = get_angle(mod, moveloop.movement_path[1])
	mod.transform = matrix().Turn(angle)

