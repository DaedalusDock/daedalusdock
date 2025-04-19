/datum/ai_behavior/battle_screech/monkey
	screeches = list("roar","screech")

/datum/ai_behavior/monkey_equip
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH

/datum/ai_behavior/monkey_equip/finish_action(datum/ai_controller/controller, success)
	. = ..()

	if(!success) //Don't try again on this item if we failed
		controller.set_blackboard_key_assoc(BB_MONKEY_BLACKLISTITEMS, controller.blackboard[BB_MONKEY_PICKUPTARGET], TRUE)

	controller.set_blackboard_key(BB_MONKEY_PICKUPTARGET, null)

/datum/ai_behavior/monkey_equip/proc/equip_item(datum/ai_controller/controller)
	var/mob/living/living_pawn = controller.pawn

	var/obj/item/target = controller.blackboard[BB_MONKEY_PICKUPTARGET]
	var/best_force = controller.blackboard[BB_MONKEY_BEST_FORCE_FOUND]

	if(!isturf(living_pawn.loc))
		return FALSE

	if(!target)
		return FALSE

	if(target.anchored) //Can't pick it up, so stop trying.
		return FALSE

	// Strong weapon
	else if(target.force > best_force)
		living_pawn.drop_all_held_items()
		living_pawn.put_in_hands(target)
		controller.set_blackboard_key(BB_MONKEY_BEST_FORCE_FOUND, target.force)
		return TRUE

	else if(target.slot_flags) //Clothing == top priority
		living_pawn.dropItemToGround(target, TRUE)
		living_pawn.update_icons()
		if(!living_pawn.equip_to_appropriate_slot(target))
			return FALSE //Already wearing something, in the future this should probably replace the current item but the code didn't actually do that, and I dont want to support it right now.
		return TRUE

	// EVERYTHING ELSE
	else if(living_pawn.get_empty_held_index_for_side(LEFT_HANDS) || living_pawn.get_empty_held_index_for_side(RIGHT_HANDS))
		living_pawn.put_in_hands(target)
		return TRUE

	return FALSE

/datum/ai_behavior/monkey_equip/ground
	required_distance = 0

/datum/ai_behavior/monkey_equip/ground/perform(delta_time, datum/ai_controller/controller)
	if(equip_item(controller))
		return BEHAVIOR_PERFORM_SUCCESS
	return BEHAVIOR_PERFORM_FAILURE

/datum/ai_behavior/monkey_equip/pickpocket

/datum/ai_behavior/monkey_equip/pickpocket/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	if(controller.blackboard[BB_MONKEY_PICKPOCKETING]) //We are pickpocketing, don't do ANYTHING!!!!
		return
	INVOKE_ASYNC(src, PROC_REF(attempt_pickpocket), controller)

/datum/ai_behavior/monkey_equip/pickpocket/proc/attempt_pickpocket(datum/ai_controller/controller)
	var/obj/item/target = controller.blackboard[BB_MONKEY_PICKUPTARGET]

	var/mob/living/victim = target.loc
	var/mob/living/living_pawn = controller.pawn

	if(!istype(victim) || !victim.IsReachableBy(living_pawn))
		finish_action(controller, FALSE)
		return



	victim.visible_message(span_warning("[living_pawn] starts trying to take [target] from [victim]!"), span_danger("[living_pawn] tries to take [target]!"))

	controller.set_blackboard_key(BB_MONKEY_PICKPOCKETING, TRUE)

	var/success = FALSE

	if(do_after(living_pawn, victim, MONKEY_ITEM_SNATCH_DELAY, DO_PUBLIC, display = image('icons/hud/do_after.dmi', "pickpocket")) && target && victim.IsReachableBy(living_pawn))

		for(var/obj/item/I in victim.held_items)
			if(I == target)
				victim.visible_message(span_danger("[living_pawn] snatches [target] from [victim]."), span_userdanger("[living_pawn] snatched [target]!"))
				if(victim.temporarilyRemoveItemFromInventory(target))
					if(!QDELETED(target) && !equip_item(controller))
						target.forceMove(living_pawn.drop_location())
						success = TRUE
						break
				else
					victim.visible_message(span_danger("[living_pawn] tried to snatch [target] from [victim], but failed!"), span_userdanger("[living_pawn] tried to grab [target]!"))

	finish_action(controller, success) //We either fucked up or got the item.

/datum/ai_behavior/monkey_equip/pickpocket/finish_action(datum/ai_controller/controller, success)
	. = ..()
	controller.set_blackboard_key(BB_MONKEY_PICKPOCKETING, FALSE)
	controller.set_blackboard_key(BB_MONKEY_PICKUPTARGET, null)

/datum/ai_behavior/monkey_flee

/datum/ai_behavior/monkey_flee/perform(delta_time, datum/ai_controller/controller)
	. = ..()

	var/mob/living/living_pawn = controller.pawn

	if(living_pawn.health >= MONKEY_FLEE_HEALTH)
		return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_SUCCESS

	var/mob/living/target = null

	// flee from anyone who attacked us and we didn't beat down
	for(var/mob/living/L in view(living_pawn, MONKEY_FLEE_VISION))
		if(controller.blackboard[BB_MONKEY_ENEMIES][L] && L.stat == CONSCIOUS)
			target = L
			break

	if(target)
		SSmove_manager.move_away(living_pawn, target, max_dist=MONKEY_ENEMY_VISION, delay=5)
		return BEHAVIOR_PERFORM_COOLDOWN

	return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_SUCCESS

/datum/ai_behavior/monkey_attack_mob
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION //performs to increase frustration

/datum/ai_behavior/monkey_attack_mob/setup(datum/ai_controller/controller, target_key)
	. = ..()
	controller.set_move_target(controller.blackboard[target_key])

/datum/ai_behavior/monkey_attack_mob/perform(delta_time, datum/ai_controller/controller, target_key)
	. = ..()

	var/mob/living/target = controller.blackboard[target_key]
	var/mob/living/living_pawn = controller.pawn
	var/datum/targeting_strategy/strategy = GET_TARGETING_STRATEGY(controller.blackboard[BB_TARGETING_STRATEGY])

	living_pawn.set_combat_mode(TRUE)
	if(QDELETED(target) || !strategy.can_attack(living_pawn, target)) // Check if they're a valid target
		if(target)
			try_lose_anger(delta_time, controller, target, MONKEY_HATRED_REDUCTION_FAILATTACK_PROB)
		living_pawn.set_combat_mode(FALSE)
		return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_SUCCESS

	// check if target has a weapon
	var/obj/item/target_weapon
	for(var/obj/item/I in target.held_items)
		if(!(I.item_flags & ABSTRACT))
			target_weapon = I
			break

	var/attack_result
	// if the target has a weapon, chance to disarm them
	if(target_weapon && DT_PROB(MONKEY_ATTACK_DISARM_PROB, delta_time))
		attack_result = monkey_attack(controller, target, delta_time, TRUE)
	else
		attack_result = monkey_attack(controller, target, delta_time, FALSE)

	if(attack_result && try_lose_anger(delta_time, controller, target, MONKEY_HATRED_REDUCTION_PROB))
		living_pawn.set_combat_mode(FALSE)
		return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_SUCCESS

	return BEHAVIOR_PERFORM_COOLDOWN

/datum/ai_behavior/monkey_attack_mob/finish_action(datum/ai_controller/controller, succeeded, target_key)
	. = ..()
	controller.set_blackboard_key(target_key, null)

/// Returns TRUE if the target is removed from the enemies list
/datum/ai_behavior/monkey_attack_mob/proc/try_lose_anger(delta_time, datum/ai_controller/controller, mob/living/target, probability)
	//check if we can de-aggro on the enemy...
	var/hatred_value = controller.blackboard[BB_MONKEY_ENEMIES][target]

	if(isnull(hatred_value))
		hatred_value = 1
		controller.set_blackboard_key_assoc(BB_MONKEY_ENEMIES, target, hatred_value)

	if(!DT_PROB(probability, delta_time))
		return FALSE

	//we decrease our hatred value to them by 1
	hatred_value--
	if(hatred_value <= 0)
		controller.remove_thing_from_blackboard_key(BB_MONKEY_ENEMIES, target)
		return TRUE

	controller.set_blackboard_key_assoc(BB_MONKEY_ENEMIES, target, hatred_value)
	return FALSE

/// attack using a held weapon otherwise bite the enemy, then if we are angry there is a chance we might calm down a little
/datum/ai_behavior/monkey_attack_mob/proc/monkey_attack(datum/ai_controller/controller, mob/living/target, delta_time, disarm, obj/item/target_weapon)
	var/mob/living/living_pawn = controller.pawn

	if(living_pawn.next_move > world.time)
		return FALSE

	//are we holding a gun? can we shoot it? if so, FIRE
	var/obj/item/gun/gun_to_shoot = locate() in living_pawn.held_items
	if(gun_to_shoot?.can_fire())
		if(gun_to_shoot != living_pawn.get_active_held_item())
			living_pawn.try_swap_hand(living_pawn.get_inactive_hand_index())

		controller.PawnClick(
			target = target,
			combat_mode = TRUE
		)
		return TRUE

	//look for any potential weapons we're holding
	var/obj/item/potential_weapon = locate() in living_pawn.held_items
	if(!target.IsReachableBy(living_pawn, potential_weapon?.reach))
		return FALSE

	if(isnull(potential_weapon))
		controller.PawnClick(
			target = target,
			modifiers = disarm ? list(RIGHT_CLICK = TRUE) : null,
			combat_mode = TRUE
		)

		if(disarm && !isnull(target_weapon) && controller.blackboard[BB_MONKEY_BLACKLISTITEMS][target_weapon])
			controller.remove_thing_from_blackboard_key(BB_MONKEY_BLACKLISTITEMS, target_weapon) //lets try to pickpocket it again!
		return TRUE

	if(potential_weapon != living_pawn.get_active_held_item())
		living_pawn.try_swap_hand(living_pawn.get_inactive_hand_index())

	controller.PawnClick(
		target = target,
		combat_mode = TRUE
	)
	return TRUE

/datum/ai_behavior/disposal_mob
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM //performs to increase frustration

/datum/ai_behavior/disposal_mob/setup(datum/ai_controller/controller, attack_target_key, disposal_target_key)
	. = ..()
	controller.set_move_target(controller.blackboard[attack_target_key])

/datum/ai_behavior/disposal_mob/finish_action(datum/ai_controller/controller, succeeded, attack_target_key, disposal_target_key)
	. = ..()
	controller.set_blackboard_key(attack_target_key, null) //Reset attack target)
	controller.set_blackboard_key(BB_MONKEY_DISPOSING, FALSE) //No longer disposing)
	controller.set_blackboard_key(disposal_target_key, null) //No target disposal)

/datum/ai_behavior/disposal_mob/perform(delta_time, datum/ai_controller/controller, attack_target_key, disposal_target_key)
	if(controller.blackboard[BB_MONKEY_DISPOSING]) //We are disposing, don't do ANYTHING!!!!
		return BEHAVIOR_PERFORM_COOLDOWN

	var/mob/living/target = controller.blackboard[attack_target_key]
	var/mob/living/living_pawn = controller.pawn

	controller.set_move_target(target)

	if(isnull(target))
		return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_FAILURE

	var/monkey_is_grabbing_target = FALSE
	for(var/obj/item/hand_item/grab/G as anything in target.grabbed_by)
		if(HAS_AI_CONTROLLER_TYPE(G.assailant, /datum/ai_controller/monkey))
			return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_SUCCESS

	if(!living_pawn.is_grabbing(target) && !monkey_is_grabbing_target) //Dont steal from my fellow monkeys.
		if(living_pawn.Adjacent(target) && isturf(target.loc))
			living_pawn.try_make_grab(target)
		return BEHAVIOR_PERFORM_COOLDOWN

	var/obj/machinery/disposal/disposal = controller.blackboard[disposal_target_key]
	controller.set_move_target(disposal)

	if(isnull(disposal))
		return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_FAILURE

	if(living_pawn.Adjacent(disposal))
		INVOKE_ASYNC(src, PROC_REF(try_disposal_mob), controller, attack_target_key, disposal_target_key) //put him in!
		return BEHAVIOR_PERFORM_COOLDOWN

	//This means we might be getting pissed!
	return BEHAVIOR_PERFORM_COOLDOWN

/datum/ai_behavior/disposal_mob/proc/try_disposal_mob(datum/ai_controller/controller, attack_target_key, disposal_target_key)
	var/mob/living/living_pawn = controller.pawn
	var/mob/living/target = controller.blackboard[attack_target_key]
	var/obj/machinery/disposal/disposal = controller.blackboard[disposal_target_key]

	controller.set_blackboard_key(BB_MONKEY_DISPOSING, TRUE)

	if(target && disposal?.stuff_mob_in(target, living_pawn))
		disposal.flush()
	finish_action(controller, TRUE, attack_target_key, disposal_target_key)


/datum/ai_behavior/recruit_monkeys/perform(delta_time, datum/ai_controller/controller)
	. = ..()

	controller.set_blackboard_key(BB_MONKEY_RECRUIT_COOLDOWN, world.time + MONKEY_RECRUIT_COOLDOWN)
	var/mob/living/living_pawn = controller.pawn

	for(var/mob/living/L in view(living_pawn, MONKEY_ENEMY_VISION))
		if(!HAS_AI_CONTROLLER_TYPE(L, /datum/ai_controller/monkey))
			continue

		if(!DT_PROB(MONKEY_RECRUIT_PROB, delta_time))
			continue

		// Recruited a monkey to our side
		controller.set_blackboard_key(BB_MONKEY_RECRUIT_COOLDOWN, world.time + MONKEY_RECRUIT_COOLDOWN)
		// Other monkeys now also hate the guy we're currently targeting
		L.ai_controller.add_blackboard_key_assoc(BB_MONKEY_ENEMIES, controller.blackboard[BB_MONKEY_CURRENT_ATTACK_TARGET], MONKEY_RECRUIT_HATED_AMOUNT)

	return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_SUCCESS

/datum/ai_behavior/monkey_set_combat_target/perform(delta_time, datum/ai_controller/controller, set_key, enemies_key)
	var/list/enemies = controller.blackboard[enemies_key]
	var/list/valids = list()
	for(var/mob/living/possible_enemy in view(MONKEY_ENEMY_VISION, controller.pawn))
		if(possible_enemy == controller.pawn) // Don't hit yourself idiot.
			continue

		if(!enemies[possible_enemy]) // This mob is not an enemy, but we might be in monke mode and attack it anyway.
			if(!controller.blackboard[BB_MONKEY_AGGRESSIVE]) // We are NOT monke mode, do not engage!!!
				continue
			if(HAS_AI_CONTROLLER_TYPE(possible_enemy, /datum/ai_controller/monkey)) // Do not attack fellow monke
				continue

		// Weighted list, so the closer they are the more likely they are to be chosen as the enemy
		valids[possible_enemy] = CEILING(100 / (get_dist(controller.pawn, possible_enemy) || 1), 1)

	if(!length(valids))
		return BEHAVIOR_PERFORM_INSTANT | BEHAVIOR_PERFORM_FAILURE

	controller.set_blackboard_key(set_key, pick_weight(valids))
	return BEHAVIOR_PERFORM_INSTANT |BEHAVIOR_PERFORM_SUCCESS
