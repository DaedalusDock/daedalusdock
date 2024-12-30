/*
AI controllers are a datumized form of AI that simulates the input a player would otherwise give to a mob. What this means is that these datums
have ways of interacting with a specific mob and control it.
*/
///OOK OOK OOK

/datum/ai_controller/monkey
	planning_subtrees = list(
		/datum/ai_planning_subtree/generic_resist,
		/datum/ai_planning_subtree/monkey_combat,
		/datum/ai_planning_subtree/generic_hunger,
		/datum/ai_planning_subtree/generic_play_instrument,
		/datum/ai_planning_subtree/monkey_shenanigans,
	)
	blackboard = list(
		BB_MONKEY_AGGRESSIVE = FALSE,
		BB_MONKEY_BEST_FORCE_FOUND = 0,
		BB_MONKEY_ENEMIES = list(),
		BB_MONKEY_BLACKLISTITEMS = list(),
		BB_MONKEY_PICKUPTARGET = null,
		BB_MONKEY_PICKPOCKETING = FALSE,
		BB_MONKEY_DISPOSING = FALSE,
		BB_MONKEY_TARGET_DISPOSAL = null,
		BB_MONKEY_CURRENT_ATTACK_TARGET = null,
		BB_MONKEY_GUN_NEURONS_ACTIVATED = FALSE,
		BB_MONKEY_GUN_WORKED = TRUE,
		BB_SONG_LINES = MONKEY_SONG,
	)
	default_behavior = /datum/ai_behavior/idle_monkey

	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_crossed),
	)

/datum/ai_controller/monkey/angry

/datum/ai_controller/monkey/angry/TryPossessPawn(atom/new_pawn)
	. = ..()
	if(. & AI_CONTROLLER_INCOMPATIBLE)
		return
	set_blackboard_key(BB_MONKEY_AGGRESSIVE, TRUE) //Angry cunt

/datum/ai_controller/monkey/TryPossessPawn(atom/new_pawn)
	if(!isliving(new_pawn))
		return AI_CONTROLLER_INCOMPATIBLE

	AddComponent(/datum/component/connect_loc_behalf, new_pawn, loc_connections)
	RegisterSignal(new_pawn, COMSIG_PARENT_ATTACKBY, PROC_REF(on_attackby))
	RegisterSignal(new_pawn, COMSIG_ATOM_ATTACK_HAND, PROC_REF(on_attack_hand))
	RegisterSignal(new_pawn, COMSIG_ATOM_ATTACK_PAW, PROC_REF(on_attack_paw))
	RegisterSignal(new_pawn, COMSIG_ATOM_ATTACK_ANIMAL, PROC_REF(on_attack_animal))
	RegisterSignal(new_pawn, COMSIG_MOB_ATTACK_ALIEN, PROC_REF(on_attack_alien))
	RegisterSignal(new_pawn, COMSIG_ATOM_BULLET_ACT, PROC_REF(on_bullet_act))
	RegisterSignal(new_pawn, COMSIG_ATOM_HITBY, PROC_REF(on_hitby))
	RegisterSignal(new_pawn, COMSIG_ATOM_GET_GRABBED, PROC_REF(on_grabbed))
	RegisterSignal(new_pawn, COMSIG_LIVING_TRY_SYRINGE, PROC_REF(on_try_syringe))
	RegisterSignal(new_pawn, COMSIG_ATOM_HULK_ATTACK, PROC_REF(on_attack_hulk))
	RegisterSignal(new_pawn, COMSIG_CARBON_CUFF_ATTEMPTED, PROC_REF(on_attempt_cuff))
	return ..() //Run parent at end

/datum/ai_controller/monkey/UnpossessPawn(destroy)
	UnregisterSignal(pawn, list(
		COMSIG_PARENT_ATTACKBY,
		COMSIG_ATOM_ATTACK_HAND,
		COMSIG_ATOM_ATTACK_PAW,
		COMSIG_ATOM_BULLET_ACT,
		COMSIG_ATOM_HITBY,
		COMSIG_ATOM_GET_GRABBED,
		COMSIG_LIVING_TRY_SYRINGE,
		COMSIG_ATOM_HULK_ATTACK,
		COMSIG_CARBON_CUFF_ATTEMPTED,
		COMSIG_MOB_MOVESPEED_UPDATED,
		COMSIG_ATOM_ATTACK_ANIMAL,
		COMSIG_MOB_ATTACK_ALIEN,
	))
	return ..() //Run parent at end

// Stops sentient monkeys from being knocked over like weak dunces.
/datum/ai_controller/monkey/on_sentience_gained()
	. = ..()
	qdel(GetComponent(/datum/component/connect_loc_behalf))

/datum/ai_controller/monkey/on_sentience_lost()
	. = ..()
	AddComponent(/datum/component/connect_loc_behalf, pawn, loc_connections)

/datum/ai_controller/monkey/able_to_run()
	. = ..()
	var/mob/living/living_pawn = pawn

	if(IS_DEAD_OR_INCAP(living_pawn))
		return FALSE

///re-used behavior pattern by monkeys for finding a weapon
/datum/ai_controller/monkey/proc/TryFindWeapon()
	var/mob/living/living_pawn = pawn

	if(!locate(/obj/item) in living_pawn.held_items)
		set_blackboard_key(BB_MONKEY_BEST_FORCE_FOUND, 0)

	if(blackboard[BB_MONKEY_GUN_NEURONS_ACTIVATED] && (locate(/obj/item/gun) in living_pawn.held_items))
		// We have a gun, what could we possibly want?
		return FALSE

	var/obj/item/weapon
	var/list/nearby_items = list()
	for(var/obj/item/item in oview(2, living_pawn))
		nearby_items += item

	weapon = GetBestWeapon(src, nearby_items, living_pawn.held_items)

	var/pickpocket = FALSE
	for(var/mob/living/carbon/human/human in oview(target_search_radius, living_pawn))
		var/obj/item/held_weapon = GetBestWeapon(src, human.held_items + weapon, living_pawn.held_items)
		if(held_weapon == weapon) // It's just the same one, not a held one
			continue
		pickpocket = TRUE
		weapon = held_weapon

	if(!weapon || (weapon in living_pawn.held_items))
		return FALSE

	set_blackboard_key(BB_MONKEY_PICKUPTARGET, weapon)
	set_move_target(weapon)
	if(pickpocket)
		queue_behavior(/datum/ai_behavior/monkey_equip/pickpocket)
	else
		queue_behavior(/datum/ai_behavior/monkey_equip/ground)
	return TRUE

///Reactive events to being hit
/datum/ai_controller/monkey/proc/retaliate(mob/living/L)
	add_blackboard_key_assoc(BB_MONKEY_ENEMIES, L, MONKEY_HATRED_AMOUNT)

/datum/ai_controller/monkey/proc/on_attackby(datum/source, obj/item/I, mob/user)
	SIGNAL_HANDLER
	if(I.force && I.damtype != STAMINA)
		retaliate(user)

/datum/ai_controller/monkey/proc/on_attack_hand(datum/source, mob/living/user, list/modifiers)
	SIGNAL_HANDLER
	if((user.combat_mode || LAZYACCESS(modifiers, RIGHT_CLICK)) && prob(MONKEY_RETALIATE_PROB))
		retaliate(user)

/datum/ai_controller/monkey/proc/on_attack_paw(datum/source, mob/living/user, list/modifiers)
	SIGNAL_HANDLER
	if((user.combat_mode || LAZYACCESS(modifiers, RIGHT_CLICK)) && prob(MONKEY_RETALIATE_PROB))
		retaliate(user)

/datum/ai_controller/monkey/proc/on_attack_animal(datum/source, mob/living/user)
	SIGNAL_HANDLER
	if(user.melee_damage_upper > 0 && prob(MONKEY_RETALIATE_PROB))
		retaliate(user)

/datum/ai_controller/monkey/proc/on_attack_alien(datum/source, mob/living/user, list/modifiers)
	SIGNAL_HANDLER
	if((user.combat_mode || LAZYACCESS(modifiers, RIGHT_CLICK)) && prob(MONKEY_RETALIATE_PROB))
		retaliate(user)

/datum/ai_controller/monkey/proc/on_bullet_act(datum/source, obj/projectile/Proj)
	SIGNAL_HANDLER
	var/mob/living/living_pawn = pawn
	if(istype(Proj , /obj/projectile/beam)||istype(Proj, /obj/projectile/bullet))
		if((Proj.damage_type == BURN) || (Proj.damage_type == BRUTE))
			if(!Proj.nodamage && Proj.damage < living_pawn.health && isliving(Proj.firer))
				retaliate(Proj.firer)

/datum/ai_controller/monkey/proc/on_hitby(datum/source, atom/movable/AM, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	SIGNAL_HANDLER
	if(istype(AM, /obj/item))
		var/mob/living/living_pawn = pawn
		var/obj/item/I = AM
		var/mob/thrown_by = I.thrownby?.resolve()
		if(I.throwforce && I.throwforce < living_pawn.health && ishuman(thrown_by))
			var/mob/living/carbon/human/H = thrown_by
			retaliate(H)

/datum/ai_controller/monkey/proc/on_crossed(datum/source, atom/movable/crossed)
	SIGNAL_HANDLER
	var/mob/living/living_pawn = pawn
	if(!IS_DEAD_OR_INCAP(living_pawn) && isliving(crossed))
		var/mob/living/in_the_way_mob = crossed
		in_the_way_mob.knockOver(living_pawn)
		return

/datum/ai_controller/monkey/proc/on_grabbed(datum/source, atom/movable/puller)
	SIGNAL_HANDLER

	var/mob/living/living_pawn = pawn
	if(!IS_DEAD_OR_INCAP(living_pawn) && prob(MONKEY_PULL_AGGRO_PROB)) // nuh uh you don't pull me!
		retaliate(puller)
		return TRUE

/datum/ai_controller/monkey/proc/on_try_syringe(datum/source, mob/user)
	SIGNAL_HANDLER
	// chance of monkey retaliation
	if(prob(MONKEY_SYRINGE_RETALIATION_PROB))
		retaliate(user)

/datum/ai_controller/monkey/proc/on_attack_hulk(datum/source, mob/user)
	SIGNAL_HANDLER
	retaliate(user)

/datum/ai_controller/monkey/proc/on_attempt_cuff(datum/source, mob/user)
	SIGNAL_HANDLER
	// chance of monkey retaliation
	if(prob(MONKEY_CUFF_RETALIATION_PROB))
		retaliate(user)
