
/datum/ai_behavior/resist/perform(delta_time, datum/ai_controller/controller)
	var/mob/living/living_pawn = controller.pawn
	living_pawn.execute_resist()
	return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_SUCCESS

/datum/ai_behavior/battle_screech
	///List of possible screeches the behavior has
	var/list/screeches

/datum/ai_behavior/battle_screech/perform(delta_time, datum/ai_controller/controller)
	var/mob/living/living_pawn = controller.pawn
	INVOKE_ASYNC(living_pawn, TYPE_PROC_REF(/mob, emote), pick(screeches))
	return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_SUCCESS

///Moves to target then finishes
/datum/ai_behavior/move_to_target
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT

/datum/ai_behavior/move_to_target/perform(delta_time, datum/ai_controller/controller)
	return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_SUCCESS

/datum/ai_behavior/break_spine
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT
	action_cooldown = 0.7 SECONDS
	var/give_up_distance = 10

/datum/ai_behavior/break_spine/setup(datum/ai_controller/controller, target_key)
	. = ..()
	controller.set_move_target(controller.blackboard[target_key])

/datum/ai_behavior/break_spine/perform(delta_time, datum/ai_controller/controller, target_key)
	var/mob/living/batman = controller.blackboard[target_key]
	var/mob/living/big_guy = controller.pawn //he was molded by the darkness

	if(batman.stat)
		return BEHAVIOR_PERFORM_FAILURE

	if(get_dist(batman, big_guy) >= give_up_distance)
		return BEHAVIOR_PERFORM_FAILURE

	big_guy.try_make_grab(batman)
	big_guy.setDir(get_dir(big_guy, batman))

	batman.visible_message(span_warning("[batman] gets a slightly too tight hug from [big_guy]!"), span_userdanger("You feel your body break as [big_guy] embraces you!"))

	if(iscarbon(batman))
		var/mob/living/carbon/carbon_batman = batman
		for(var/obj/item/bodypart/bodypart_to_break in carbon_batman.bodyparts)
			if(bodypart_to_break.body_zone == BODY_ZONE_HEAD)
				continue
			bodypart_to_break.receive_damage(brute = 15, modifiers = NONE)
			bodypart_to_break.break_bones()
	else
		batman.adjustBruteLoss(150)

	return BEHAVIOR_PERFORM_SUCCESS

/datum/ai_behavior/break_spine/finish_action(datum/ai_controller/controller, succeeded, target_key)
	if(succeeded)
		controller.blackboard -= target_key
	return ..()

/// Use in hand the currently held item
/datum/ai_behavior/use_in_hand
	behavior_flags = AI_BEHAVIOR_MOVE_AND_PERFORM


/datum/ai_behavior/use_in_hand/perform(delta_time, datum/ai_controller/controller)
	var/mob/living/pawn = controller.pawn
	var/obj/item/held = pawn.get_active_held_item()
	if(!held)
		return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_FAILURE
	pawn.activate_hand()
	return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_SUCCESS

/// Use the currently held item, or unarmed, on a weakref to an object in the world
/datum/ai_behavior/use_on_object
	required_distance = 1
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH

/datum/ai_behavior/use_on_object/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/target = controller.blackboard[target_key]
	if(!target)
		return FALSE
	controller.set_move_target(target)

/datum/ai_behavior/use_on_object/perform(delta_time, datum/ai_controller/controller, target_key)
	. = ..()
	var/mob/living/pawn = controller.pawn
	var/obj/item/held_item = pawn.get_item_by_slot(pawn.get_active_hand())
	var/atom/target = controller.blackboard[target_key]

	if(!target || !target.IsReachableBy(pawn))
		return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_FAILURE

	pawn.set_combat_mode(FALSE)
	if(held_item)
		held_item.melee_attack_chain(pawn, target)
	else
		pawn.UnarmedAttack(target, TRUE)

	return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_SUCCESS

/datum/ai_behavior/give
	required_distance = 1
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH


/datum/ai_behavior/give/setup(datum/ai_controller/controller, target_key)
	. = ..()
	controller.set_move_target(controller.blackboard[target_key])

/datum/ai_behavior/give/perform(delta_time, datum/ai_controller/controller, target_key)
	. = ..()
	var/mob/living/pawn = controller.pawn
	var/obj/item/held_item = pawn.get_item_by_slot(pawn.get_active_hand())
	var/atom/target = controller.blackboard[target_key]

	if(!target || !target.IsReachableBy(pawn) || !isliving(target))
		return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_FAILURE

	var/mob/living/living_target = target
	controller.PauseAi(1.5 SECONDS)
	living_target.visible_message(
		span_info("[pawn] starts trying to give [held_item] to [living_target]!"),
		span_warning("[pawn] tries to give you [held_item]!")
	)
	if(!do_after(pawn, living_target, 1 SECONDS))
		return
	if(QDELETED(held_item) || QDELETED(living_target))
		return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_FAILURE

	var/pocket_choice = prob(50) ? ITEM_SLOT_RPOCKET : ITEM_SLOT_LPOCKET
	if(prob(50) && living_target.can_put_in_hand(held_item))
		living_target.put_in_hand(held_item)
	else if(held_item.mob_can_equip(living_target, pawn, pocket_choice, TRUE))
		living_target.equip_to_slot(held_item, pocket_choice)

	return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_SUCCESS

/datum/ai_behavior/consume
	required_distance = 1
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH
	action_cooldown = 2 SECONDS

/datum/ai_behavior/consume/setup(datum/ai_controller/controller, target_key)
	. = ..()
	controller.set_move_target(controller.blackboard[target_key])

/datum/ai_behavior/consume/perform(delta_time, datum/ai_controller/controller, target_key, hunger_timer_key)
	. = ..()
	var/mob/living/living_pawn = controller.pawn
	var/obj/item/target = controller.blackboard[target_key]

	if(QDELETED(target))
		return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_FAILURE

	if(!(living_pawn.is_holding(target)))
		if(!living_pawn.put_in_hands(target))
			return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_FAILURE

	target.melee_attack_chain(living_pawn, living_pawn)

	if(QDELETED(target) || prob(10)) // Even if we don't finish it all we can randomly decide to be done
		return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_SUCCESS

	return BEHAVIOR_PERFORM_COOLDOWN

/datum/ai_behavior/consume/finish_action(datum/ai_controller/controller, succeeded, target_key, hunger_timer_key)
	. = ..()
	if(succeeded)
		controller.set_blackboard_key(hunger_timer_key, world.time + rand(12 SECONDS, 60 SECONDS))

/**find and set
 * Finds an item near themselves, sets a blackboard key as it. Very useful for ais that need to use machines or something.
 * if you want to do something more complicated than find a single atom, change the search_tactic() proc
 * cool tip: search_tactic() can set lists
 */
/datum/ai_behavior/find_and_set
	action_cooldown = 5 SECONDS

/datum/ai_behavior/find_and_set/perform(delta_time, datum/ai_controller/controller, set_key, locate_path, search_range)
	if(QDELETED(controller.pawn))
		return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_SUCCESS

	// if(controller.blackboard_key_exists(set_key))
	// 	return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_SUCCESS

	var/find_this_thing = search_tactic(controller, locate_path, search_range)
	if(isnull(find_this_thing))
		return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_FAILURE

	controller.set_blackboard_key(set_key, find_this_thing)
	return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_SUCCESS

/datum/ai_behavior/find_and_set/proc/search_tactic(datum/ai_controller/controller, locate_path, search_range)
	for(var/atom/A as anything in oview(search_range, controller.target_search_radius))
		if(!istype(A, locate_path))
			continue

		if(isitem(A))
			var/obj/item/I = A
			if(I.item_flags & ABSTRACT)
				continue

		return A

/**
 * Variant of find and set that fails if the living pawn doesn't hold something
 */
/datum/ai_behavior/find_and_set/pawn_must_hold_item

/datum/ai_behavior/find_and_set/pawn_must_hold_item/search_tactic(datum/ai_controller/controller)
	var/mob/living/living_pawn = controller.pawn
	if(!living_pawn.get_num_held_items())
		return //we want to fail the search if we don't have something held
	. = ..()

/**
 * Variant of find and set that also requires the item to be edible. checks hands too
 */
/datum/ai_behavior/find_and_set/edible

/datum/ai_behavior/find_and_set/edible/search_tactic(datum/ai_controller/controller, locate_path, search_range)
	var/mob/living/living_pawn = controller.pawn
	var/list/food_candidates = list()
	for(var/held_candidate as anything in living_pawn.held_items)
		if(!held_candidate || !IsEdible(held_candidate))
			continue
		food_candidates += held_candidate

	for(var/obj/item/I in oview(search_range, controller.pawn))
		if(!IsEdible(I))
			continue

		food_candidates += I

	if(food_candidates.len)
		return pick(food_candidates)

/**
 * Variant of find and set that only checks in hands, search range should be excluded for this
 */
/datum/ai_behavior/find_and_set/in_hands

/datum/ai_behavior/find_and_set/in_hands/search_tactic(datum/ai_controller/controller, locate_path)
	var/mob/living/living_pawn = controller.pawn
	return locate(locate_path) in living_pawn.held_items

/**
 * Drops items in hands, very important for future behaviors that require the pawn to grab stuff
 */
/datum/ai_behavior/drop_item

/datum/ai_behavior/drop_item/perform(delta_time, datum/ai_controller/controller)
	var/mob/living/living_pawn = controller.pawn
	var/obj/item/best_held = GetBestWeapon(controller, null, living_pawn.held_items)
	for(var/obj/item/held as anything in living_pawn.held_items)
		if(!held || held == best_held)
			continue
		living_pawn.dropItemToGround(held)

	return BEHAVIOR_PERFORM_SUCCESS

/// This behavior involves attacking a target.
/datum/ai_behavior/attack
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM | AI_BEHAVIOR_REQUIRE_REACH
	required_distance = 1

/datum/ai_behavior/attack/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/mob/living/living_pawn = controller.pawn
	if(!istype(living_pawn) || !isturf(living_pawn.loc))
		return

	var/atom/movable/attack_target = controller.blackboard[BB_ATTACK_TARGET]
	if(!attack_target || !can_see(living_pawn, attack_target, length=controller.blackboard[BB_VISION_RANGE]))
		return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_FAILURE

	var/mob/living/living_target = attack_target
	if(istype(living_target) && (living_target.stat == DEAD))
		return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_SUCCESS

	controller.set_move_target(living_target)
	attack(controller, living_target)
	return BEHAVIOR_PERFORM_COOLDOWN

/datum/ai_behavior/attack/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	controller.set_blackboard_key(BB_ATTACK_TARGET, null)

/// A proc representing when the mob is pushed to actually attack the target. Again, subtypes can be used to represent different attacks from different animals, or it can be some other generic behavior
/datum/ai_behavior/attack/proc/attack(datum/ai_controller/controller, mob/living/living_target)
	var/mob/living/living_pawn = controller.pawn
	if(!istype(living_pawn))
		return
	living_pawn.ClickOn(living_target, list())

/// This behavior involves attacking a target.
/datum/ai_behavior/follow
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM
	required_distance = 1

/datum/ai_behavior/follow/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/mob/living/living_pawn = controller.pawn
	if(!istype(living_pawn) || !isturf(living_pawn.loc))
		return BEHAVIOR_PERFORM_COOLDOWN

	var/atom/movable/follow_target = controller.blackboard[BB_FOLLOW_TARGET]
	if(!follow_target || get_dist(living_pawn, follow_target) > controller.blackboard[BB_VISION_RANGE])
		return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_FAILURE

	var/mob/living/living_target = follow_target
	if(istype(living_target) && (living_target.stat == DEAD))
		return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_SUCCESS

	controller.set_move_target(living_target)
	return BEHAVIOR_PERFORM_COOLDOWN

/datum/ai_behavior/follow/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	controller.set_blackboard_key(BB_FOLLOW_TARGET, null)



/datum/ai_behavior/perform_emote

/datum/ai_behavior/perform_emote/perform(delta_time, datum/ai_controller/controller, emote)
	var/mob/living/living_pawn = controller.pawn
	if(!istype(living_pawn))
		return BEHAVIOR_PERFORM_INSTANT
	living_pawn.manual_emote(emote)
	return BEHAVIOR_PERFORM_SUCCESS

/datum/ai_behavior/perform_speech

/datum/ai_behavior/perform_speech/perform(delta_time, datum/ai_controller/controller, speech)
	var/mob/living/living_pawn = controller.pawn
	if(!istype(living_pawn))
		return BEHAVIOR_PERFORM_INSTANT
	living_pawn.say(speech, forced = "AI Controller")
	return BEHAVIOR_PERFORM_SUCCESS

//song behaviors

/datum/ai_behavior/setup_instrument

/datum/ai_behavior/setup_instrument/perform(delta_time, datum/ai_controller/controller, song_instrument_key, song_lines_key)
	var/obj/item/instrument/song_instrument = controller.blackboard[song_instrument_key]
	var/datum/song/song = song_instrument.song
	var/song_lines = controller.blackboard[song_lines_key]

	//just in case- it won't do anything if the instrument isn't playing
	song.stop_playing()
	song.ParseSong(song_lines)
	song.repeat = 10
	song.volume = song.max_volume - 10
	return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_SUCCESS

/datum/ai_behavior/play_instrument

/datum/ai_behavior/play_instrument/perform(delta_time, datum/ai_controller/controller, song_instrument_key)
	var/obj/item/instrument/song_instrument = controller.blackboard[song_instrument_key]
	var/datum/song/song = song_instrument.song

	song.start_playing(controller.pawn)
	return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_SUCCESS

/datum/ai_behavior/find_nearby

/datum/ai_behavior/find_nearby/perform(delta_time, datum/ai_controller/controller, target_key)
	. = ..()

	var/list/possible_targets = list()
	for(var/atom/thing in view(2, controller.pawn))
		if(!thing.mouse_opacity)
			continue
		if(thing.IsObscured())
			continue
		if(isitem(thing))
			var/obj/item/I = thing
			if(I.item_flags & ABSTRACT)
				continue

		possible_targets += thing
	if(!possible_targets.len)
		return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_FAILURE

	controller.set_blackboard_key(target_key, pick(possible_targets))
	return BEHAVIOR_PERFORM_COOLDOWN | BEHAVIOR_PERFORM_SUCCESS

/datum/ai_behavior/frustration
	action_cooldown = 0.1 SECONDS

/datum/ai_behavior/frustration/setup(datum/ai_controller/controller, frustration_key, duration)
	. = ..()
	controller.set_blackboard_key(frustration_key, world.time)

/datum/ai_behavior/frustration/perform(delta_time, datum/ai_controller/controller, frustration_key, duration)
	if(isnull(controller.blackboard[frustration_key]))
		return BEHAVIOR_PERFORM_SUCCESS

	if(world.time >= duration + controller.blackboard[frustration_key])
		controller.CancelActions()
		DEBUG_AI_LOG(controller, "AI got frustrated and cancelled current actions.")
		return BEHAVIOR_PERFORM_FAILURE
