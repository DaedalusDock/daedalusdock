/// Returns the AI behavior singleton for a type.
/datum/unit_test/flock/proc/get_behavior(behavior_type) as /datum/ai_behavior
	return GET_AI_BEHAVIOR(behavior_type)

/// Returns the types of the controller's current behaviors.
/datum/unit_test/flock/proc/current_behavior_types(datum/ai_controller/controller)
	. = list()
	for(var/datum/ai_behavior/behavior as anything in controller.current_behaviors)
		. += behavior.type

/// Only find_existing_nest should queue perform_replicate on success, not every flock behavior.
/datum/unit_test/flock/rally_does_not_queue_replicate

/datum/unit_test/flock/rally_does_not_queue_replicate/Run()
	var/mob/living/simple_animal/flock/drone/bird = new_drone()
	var/datum/ai_controller/controller = bird.ai_controller

	get_behavior(/datum/ai_behavior/flock/rally).next_behavior(controller, TRUE)
	TEST_ASSERT(!length(controller.current_behaviors), "Successful rally queued [json_encode(current_behavior_types(controller))]")

	get_behavior(/datum/ai_behavior/flock/find_existing_nest).next_behavior(controller, TRUE)
	TEST_ASSERT(/datum/ai_behavior/flock/perform_replicate in current_behavior_types(controller), "Successful find_existing_nest did not queue perform_replicate")
	controller.CancelActions()

/// perform_replicate should clear its target when it finishes.
/datum/unit_test/flock/replicate_clears_target

/datum/unit_test/flock/replicate_clears_target/Run()
	var/mob/living/simple_animal/flock/drone/bird = new_drone()
	var/datum/ai_controller/controller = bird.ai_controller

	controller.set_blackboard_key(BB_FLOCK_REPLICATE_TARGET, run_loc_floor_top_right)
	get_behavior(/datum/ai_behavior/flock/perform_replicate).finish_action(controller, FALSE)

	TEST_ASSERT_NULL(controller.blackboard[BB_FLOCK_REPLICATE_TARGET], "perform_replicate did not clear its target")

/// Nest conversion should chain into the nest perform, and then into finding the nest.
/datum/unit_test/flock/nest_chain

/datum/unit_test/flock/nest_chain/Run()
	var/mob/living/simple_animal/flock/drone/bird = new_drone()
	var/datum/ai_controller/controller = bird.ai_controller

	get_behavior(/datum/ai_behavior/flock/find_conversion_target/nest).next_behavior(controller, TRUE)
	var/list/queued = current_behavior_types(controller)
	TEST_ASSERT_EQUAL(json_encode(queued), json_encode(list(/datum/ai_behavior/flock/perform_conversion/nest)), "Successful nest search queued the wrong behaviors")
	controller.CancelActions()
	controller.current_behaviors = null

	get_behavior(/datum/ai_behavior/flock/perform_conversion/nest).next_behavior(controller, TRUE)
	queued = current_behavior_types(controller)
	TEST_ASSERT_EQUAL(json_encode(queued), json_encode(list(/datum/ai_behavior/flock/find_existing_nest)), "Successful nest conversion queued the wrong behaviors")
	controller.CancelActions()

/// Drones should not try to nest once the flock is at the drone limit.
/datum/unit_test/flock/nest_precondition_limit

/datum/unit_test/flock/nest_precondition_limit/Run()
	var/mob/living/simple_animal/flock/drone/bird = new_drone()
	var/datum/ai_controller/controller = bird.ai_controller
	var/datum/ai_behavior/nest = GET_AI_BEHAVIOR(/datum/ai_behavior/flock/find_conversion_target/nest)

	bird.substrate.add_points(FLOCK_SUBSTRATE_COST_CONVERT + flock.current_egg_cost)

	// Pad the drone list with placeholders, length is all the precondition cares about.
	var/padding = (FLOCK_DRONE_LIMIT - 1) - length(flock.drones)
	for(var/i in 1 to padding)
		flock.drones += "padding"

	var/below_limit = nest.goap_precondition(controller)
	flock.drones += "padding"
	var/at_limit = nest.goap_precondition(controller)
	flock.drones -= "padding"

	TEST_ASSERT(below_limit, "Nesting was not allowed below the drone limit")
	TEST_ASSERT(!at_limit, "Nesting was allowed at the drone limit")

/// An overmind attack order on a valid target should be confirmed, and an invalid target rejected.
/datum/unit_test/flock/attack_overmind_order

/datum/unit_test/flock/attack_overmind_order/Run()
	var/mob/living/simple_animal/flock/drone/bird = new_drone()
	var/datum/ai_controller/controller = bird.ai_controller
	var/datum/ai_behavior/attack = GET_AI_BEHAVIOR(/datum/ai_behavior/flock/attack_target)
	var/mob/living/carbon/human/target = allocate(/mob/living/carbon/human, run_loc_floor_top_right)
	flock.update_enemy(target)

	TEST_ASSERT(attack.setup(controller, target), "Overmind attack order on a standing enemy was rejected")
	TEST_ASSERT(controller.blackboard[BB_FLOCK_OVERMIND_CONTROL], "Confirmed overmind attack order did not set overmind control")
	controller.CancelActions()
	controller.clear_blackboard_key(BB_FLOCK_OVERMIND_CONTROL)

	target.Knockdown(10 SECONDS)
	TEST_ASSERT(!attack.setup(controller, target), "Overmind attack order on a knocked down enemy was accepted")
	TEST_ASSERT(!controller.blackboard[BB_FLOCK_OVERMIND_CONTROL], "Rejected overmind attack order set overmind control")
	controller.CancelActions()

/// Heal and attack should clear overmind control state when they finish.
/datum/unit_test/flock/overmind_flags_cleared

/datum/unit_test/flock/overmind_flags_cleared/Run()
	var/mob/living/simple_animal/flock/drone/bird = new_drone()
	var/datum/ai_controller/controller = bird.ai_controller

	for(var/behavior_type in list(/datum/ai_behavior/flock/heal, /datum/ai_behavior/flock/attack_target))
		controller.set_blackboard_key(BB_FLOCK_OVERMIND_CONTROL, TRUE)
		controller.set_blackboard_key(BB_PATH_MAX_LENGTH, 200)

		get_behavior(behavior_type).finish_action(controller, TRUE)

		TEST_ASSERT_NULL(controller.blackboard[BB_FLOCK_OVERMIND_CONTROL], "[behavior_type] did not clear overmind control")
		TEST_ASSERT_NULL(controller.blackboard[BB_PATH_MAX_LENGTH], "[behavior_type] did not clear the path length override")

/// Healing should succeed on an undamaged target and fail on a dead one.
/datum/unit_test/flock/heal_result

/datum/unit_test/flock/heal_result/Run()
	var/mob/living/simple_animal/flock/drone/bird = new_drone()
	var/mob/living/simple_animal/flock/drone/patient = new_drone(run_loc_floor_top_right)
	var/datum/ai_controller/controller = bird.ai_controller
	var/datum/ai_behavior/heal = GET_AI_BEHAVIOR(/datum/ai_behavior/flock/heal)
	bird.substrate.add_points(FLOCK_SUBSTRATE_COST_REPAIR * 10)

	controller.set_blackboard_key(BB_FLOCK_HEAL_TARGET, patient)
	TEST_ASSERT(heal.perform(1, controller) & BEHAVIOR_PERFORM_SUCCESS, "Healing an undamaged target did not succeed")

	patient.death()
	controller.set_blackboard_key(BB_FLOCK_HEAL_TARGET, patient)
	TEST_ASSERT(heal.perform(1, controller) & BEHAVIOR_PERFORM_FAILURE, "Healing a dead target did not fail")
	controller.clear_blackboard_key(BB_FLOCK_HEAL_TARGET)
	controller.clear_blackboard_key(BB_FLOCK_HEAL_FRUSTRATION)

/// perform_deposit should wait while the deposit interaction is running.
/datum/unit_test/flock/deposit_interaction_key

/datum/unit_test/flock/deposit_interaction_key/Run()
	var/mob/living/simple_animal/flock/drone/bird = new_drone()
	var/datum/ai_controller/controller = bird.ai_controller

	LAZYSET(bird.do_afters, "flock_deposit", 1)
	var/result = get_behavior(/datum/ai_behavior/flock/perform_deposit).perform(1, controller)
	LAZYREMOVE(bird.do_afters, "flock_deposit")

	TEST_ASSERT(result & BEHAVIOR_PERFORM_COOLDOWN, "perform_deposit did not wait for the deposit interaction")
	TEST_ASSERT(!(result & BEHAVIOR_PERFORM_SUCCESS), "perform_deposit finished while depositing")

/// Conversion targeting should reject unconvertible turfs even without a flock, and not list turfs twice.
/datum/unit_test/flock/convert_target_validity

/datum/unit_test/flock/convert_target_validity/Run()
	var/mob/living/simple_animal/flock/drone/bird = new_drone()
	var/datum/ai_controller/controller = bird.ai_controller
	var/datum/ai_behavior/convert = GET_AI_BEHAVIOR(/datum/ai_behavior/flock/find_conversion_target)

	var/list/potential = convert.goap_get_potential_targets(controller)
	TEST_ASSERT(length(potential), "No potential conversion targets were found")
	TEST_ASSERT_EQUAL(length(potential), length(unique_list(potential)), "Potential conversion targets contained duplicates")

	var/turf/unconvertible = run_loc_floor_top_right
	change_turf(unconvertible, /turf/closed/indestructible)
	TEST_ASSERT(!unconvertible.can_flock_convert(), "Test turf [unconvertible.type] is convertible")

	flock.free_unit(bird)
	TEST_ASSERT_NULL(bird.flock, "free_unit() did not clear the drone's flock")
	TEST_ASSERT(!convert.goap_is_valid_target(controller, unconvertible), "Flockless drone accepted an unconvertible turf")
	TEST_ASSERT(convert.goap_is_valid_target(controller, run_loc_floor_bottom_left), "Flockless drone rejected a convertible turf")

/// Converting the turf a drone is moving to should not drop its move target, or the conversion behavior fails as it completes.
/datum/unit_test/flock/move_target_survives_conversion

/datum/unit_test/flock/move_target_survives_conversion/Run()
	var/mob/living/simple_animal/flock/drone/bird = new_drone()
	var/datum/ai_controller/controller = bird.ai_controller
	var/turf/T = run_loc_floor_top_right

	controller.set_move_target(T)
	claim(T)

	TEST_ASSERT(isflockturf(T), "Test turf was not converted, got [T.type]")
	TEST_ASSERT_EQUAL(controller.current_movement_target, T, "Converting the move target turf cleared the move target")
	controller.set_move_target(null)
