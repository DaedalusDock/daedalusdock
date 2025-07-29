/**
 * This is the proc that handles the order of an item_attack.
 *
 * The order of procs called is:
 * * [/atom/proc/tool_act] on the target. If it returns ITEM_INTERACT_SUCCESS or ITEM_INTERACT_BLOCKING, the chain will be stopped.
 * * [/obj/item/proc/pre_attack] on src. If this returns TRUE, the chain will be stopped.
 * * [/atom/proc/attackby] on the target. If it returns TRUE, the chain will be stopped.
 * * [/obj/item/proc/afterattack]. The return value does not matter.
 */
/obj/item/proc/melee_attack_chain(mob/user, atom/target, params)
	var/list/modifiers = params2list(params)
	var/is_right_clicking = LAZYACCESS(modifiers, RIGHT_CLICK)

	var/item_interact_result = target.base_item_interaction(user, src, modifiers)
	if(item_interact_result & ITEM_INTERACT_SUCCESS)
		return TRUE
	if(item_interact_result & ITEM_INTERACT_BLOCKING)
		return FALSE

	var/pre_attack_result
	if (is_right_clicking)
		if(try_special_attack(user, target, modifiers))
			return TRUE

		switch (pre_attack_secondary(target, user, params))
			if (SECONDARY_ATTACK_CALL_NORMAL)
				pre_attack_result = pre_attack(target, user, params)
			if (SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
				return TRUE
			if (SECONDARY_ATTACK_CONTINUE_CHAIN)
				// Normal behavior
			else
				CRASH("pre_attack_secondary must return an SECONDARY_ATTACK_* define, please consult code/__DEFINES/combat.dm")
	else
		pre_attack_result = pre_attack(target, user, params)

	if(pre_attack_result)
		return TRUE

	var/attackby_result

	if (is_right_clicking)
		switch (target.attackby_secondary(src, user, params))
			if (SECONDARY_ATTACK_CALL_NORMAL)
				attackby_result = target.attackby(src, user, params)
			if (SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
				return TRUE
			if (SECONDARY_ATTACK_CONTINUE_CHAIN)
				// Normal behavior
			else
				CRASH("attackby_secondary must return an SECONDARY_ATTACK_* define, please consult code/__DEFINES/combat.dm")

	else
		attackby_result = target.attackby(src, user, params)

	return attackby_result

/// Called when clicking on something outside of reach.
/obj/item/proc/ranged_attack_chain(mob/user, atom/target, modifiers)
	var/item_interact_result = target.base_ranged_item_interaction(user, src, modifiers)
	if(item_interact_result & ITEM_INTERACT_SUCCESS)
		return TRUE

	if(item_interact_result & ITEM_INTERACT_BLOCKING)
		return FALSE

	if(modifiers?[RIGHT_CLICK])
		. =  try_special_attack(user, target, modifiers)

	else
		var/datum/special_attack/basic_attack = GLOB.special_attacks[/datum/special_attack/basic]
		. =  try_special_attack(user, target, modifiers, basic_attack)
	return .

/// Attempt to perform a special attack.
/obj/item/proc/try_special_attack(mob/living/user, atom/target, modifiers, datum/special_attack/forced_attack)
	if(!user.combat_mode)
		return FALSE

	var/datum/special_attack/spec_attack = forced_attack || get_special_attack()
	if(!spec_attack)
		return FALSE

	spec_attack.try_perform_attack(user, src, target, modifiers)
	return TRUE

/// Called when the item is in the active hand, and clicked; alternately, there is an 'activate held object' verb or you can hit pagedown.
/obj/item/proc/attack_self(mob/user, modifiers)
	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_SELF, user) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	interact(user)

/// Called when the item is in the active hand, and right-clicked. Intended for alternate or opposite functions, such as lowering reagent transfer amount. At the moment, there is no verb or hotkey.
/obj/item/proc/attack_self_secondary(mob/user, modifiers)
	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_SELF_SECONDARY, user) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE

/**
 * Called on the item before it hits something
 *
 * Arguments:
 * * atom/A - The atom about to be hit
 * * mob/living/user - The mob doing the htting
 * * params - click params such as alt/shift etc
 *
 * See: [/obj/item/proc/melee_attack_chain]
 */
/obj/item/proc/pre_attack(atom/A, mob/living/user, params) //do stuff before attackby!
	if(SEND_SIGNAL(src, COMSIG_ITEM_PRE_ATTACK, A, user, params) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE

	return FALSE //return TRUE to avoid calling attackby after this proc does stuff

/**
 * Called on the item before it hits something, when right clicking.
 *
 * Arguments:
 * * atom/target - The atom about to be hit
 * * mob/living/user - The mob doing the htting
 * * params - click params such as alt/shift etc
 *
 * See: [/obj/item/proc/melee_attack_chain]
 */
/obj/item/proc/pre_attack_secondary(atom/target, mob/living/user, params)
	var/signal_result = SEND_SIGNAL(src, COMSIG_ITEM_PRE_ATTACK_SECONDARY, target, user, params)

	if(signal_result & COMPONENT_SECONDARY_CANCEL_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(signal_result & COMPONENT_SECONDARY_CONTINUE_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CONTINUE_CHAIN

	return SECONDARY_ATTACK_CALL_NORMAL

/**
 * Called on an object being hit by an item
 *
 * Arguments:
 * * obj/item/attacking_item - The item hitting this atom
 * * mob/user - The wielder of this item
 * * params - click params such as alt/shift etc
 *
 * See: [/obj/item/proc/melee_attack_chain]
 */
/atom/proc/attackby(obj/item/attacking_item, mob/user, params)
	if(SEND_SIGNAL(src, COMSIG_PARENT_ATTACKBY, attacking_item, user, params) & COMPONENT_NO_AFTERATTACK)
		return TRUE
	return FALSE

/**
 * Called on an object being right-clicked on by an item
 *
 * Arguments:
 * * obj/item/weapon - The item hitting this atom
 * * mob/user - The wielder of this item
 * * params - click params such as alt/shift etc
 *
 * See: [/obj/item/proc/melee_attack_chain]
 */
/atom/proc/attackby_secondary(obj/item/weapon, mob/user, params)
	var/signal_result = SEND_SIGNAL(src, COMSIG_PARENT_ATTACKBY_SECONDARY, weapon, user, params)

	if(signal_result & COMPONENT_SECONDARY_CANCEL_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(signal_result & COMPONENT_SECONDARY_CONTINUE_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CONTINUE_CHAIN

	return SECONDARY_ATTACK_CALL_NORMAL

/obj/attackby(obj/item/attacking_item, mob/user, params)
	. = ..()
	if(.)
		return TRUE

	if(!(obj_flags & CAN_BE_HIT))
		return FALSE

	return attacking_item.attack_obj(src, user, params)

/mob/living/attackby(obj/item/attacking_item, mob/living/user, params)
	if(..())
		return TRUE

	return user.attack_with_item(attacking_item, src, params)

/mob/living/attackby_secondary(obj/item/weapon, mob/living/user, params)
	var/result = weapon.attack_secondary(src, user, params)

	// Normal attackby updates click cooldown, so we have to make up for it
	if (result != SECONDARY_ATTACK_CALL_NORMAL)
		user.changeNext_move(CLICK_CD_MELEE)

	return result

/// A helper for striking a mob with an item. Incurs click delay, stamina costs, and animates the attack.
/mob/living/proc/attack_with_item(obj/item/attacking_item, mob/living/target, params)
	// if(!combat_mode) This breaks too much, need more attackby refactors.
	// 	return FALSE

	if(attacking_item.force && HAS_TRAIT(src, TRAIT_PACIFISM))
		to_chat(src, span_warning("You don't want to harm other living beings."))
		return FALSE

	// do_attack_animation(target, attacking_item, do_hurt = FALSE)
	// changeNext_move(attacking_item.combat_click_delay)
	// stamina_swing(attacking_item.stamina_cost)

	return attacking_item.attack(target, src, params)

/**
 * Called from [/mob/living/proc/attackby]
 *
 * Arguments:
 * * mob/living/M - The mob being hit by this item
 * * mob/living/user - The mob hitting with this item
 * * params - Click params of this attack
 * * datum/special_attack/used_special - The special attack instance used, if any.
 */
/obj/item/proc/attack(mob/living/M, mob/living/user, params, datum/special_attack/used_special)
	var/signal_return = SEND_SIGNAL(src, COMSIG_ITEM_ATTACK, M, user, params)
	if(signal_return & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	if(signal_return & COMPONENT_SKIP_ATTACK_STEP)
		return

	SEND_SIGNAL(user, COMSIG_MOB_ITEM_ATTACK, M, user, params)

	if(item_flags & NOBLUDGEON)
		return

	if(!user.combat_mode)
		return

	if(!used_special)
		user.do_attack_animation(M, src, do_hurt = FALSE)
		user.changeNext_move(combat_click_delay)
		user.stamina_swing(stamina_cost)

	M.lastattacker = user.real_name
	M.lastattackerckey = user.ckey

	var/attack_return = M.attacked_by(src, user, used_special)
	play_combat_sound(attack_return)

	var/missed = (attack_return == MOB_ATTACKEDBY_MISS || attack_return == MOB_ATTACKEDBY_FAIL)
	if(!missed)
		M.do_hurt_animation()

	log_combat(user, M, "attacked", src.name, "(COMBAT MODE: [uppertext(user.combat_mode)]) (DAMTYPE: [uppertext(damtype)]) (MISSED: [missed ? "YES" : "NO"])")
	add_fingerprint(user)

	if(!missed)
		var/list/modifiers = params2list(params)
		SEND_SIGNAL(src, COMSIG_ITEM_AFTERATTACK, M, user, modifiers,)
		SEND_SIGNAL(M, COMSIG_ATOM_AFTER_ATTACKEDBY, src, user, modifiers)

		afterattack(M, user, modifiers)

	/// If we missed or the attack failed, interrupt attack chain.
	return missed

/// The equivalent of [/obj/item/proc/attack] but for alternate attacks, AKA right clicking
/obj/item/proc/attack_secondary(mob/living/victim, mob/living/user, params)
	var/signal_result = SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_SECONDARY, victim, user, params)

	if(signal_result & COMPONENT_SECONDARY_CANCEL_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(signal_result & COMPONENT_SECONDARY_CONTINUE_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CONTINUE_CHAIN

	return SECONDARY_ATTACK_CALL_NORMAL

/// The equivalent of the standard version of [/obj/item/proc/attack] but for /obj targets.
/obj/item/proc/attack_obj(obj/attacked_obj, mob/living/user, params)
	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_OBJ, attacked_obj, user) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return

	if(item_flags & NOBLUDGEON)
		return FALSE

	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(attacked_obj)

	if(!attacked_obj.uses_integrity)
		return FALSE

	. = attacked_obj.attacked_by(src, user)

	if(.)
		var/list/modifiers = params2list(params)
		SEND_SIGNAL(src, COMSIG_ITEM_AFTERATTACK, attacked_obj, user, modifiers)
		SEND_SIGNAL(attacked_obj, COMSIG_ATOM_AFTER_ATTACKEDBY, src, user, modifiers)
		afterattack(attacked_obj, user, modifiers)


/// The equivalent of the standard version of [/obj/item/proc/attack] but for /turf targets.
/obj/item/proc/attack_turf(turf/attacked_turf, mob/living/user, params)
	if(item_flags & NOBLUDGEON)
		return FALSE

	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(attacked_turf)

	if(!attacked_turf.uses_integrity)
		return FALSE

	// This probably needs to be changed later on, but it should work for now because only flock walls use integrity.
	. = attacked_turf.attacked_by(src, user)
	if(.)
		var/list/modifiers = params2list(params)
		SEND_SIGNAL(src, COMSIG_ITEM_AFTERATTACK, attacked_turf, user, modifiers)
		SEND_SIGNAL(attacked_turf, COMSIG_ATOM_AFTER_ATTACKEDBY, src, user, modifiers)
		afterattack(attacked_turf, user, modifiers)

/// Called from [/obj/item/proc/attack_atom] and [/obj/item/proc/attack] if the attack succeeds
/atom/proc/attacked_by(obj/item/attacking_item, mob/living/user)
	if(!uses_integrity)
		CRASH("attacked_by() was called on an object that doesnt use integrity!")

	if(!attacking_item.force)
		return

	var/damage = take_damage(attacking_item.force, attacking_item.damtype, BLUNT, 1)

	//only witnesses close by and the victim see a hit message.
	user.visible_message(
		span_danger("[user] hits [src] with [attacking_item][damage ? "." : ", without leaving a mark."]"),
		null,
		COMBAT_MESSAGE_RANGE
	)

	log_combat(user, src, "attacked ([damage] damage)", attacking_item)
	return damage

/area/attacked_by(obj/item/attacking_item, mob/living/user)
	CRASH("areas are NOT supposed to have attacked_by() called on them!")

/**
 * Last proc in the [/obj/item/proc/melee_attack_chain].
 * Returns a bitfield containing AFTERATTACK_PROCESSED_ITEM if the user is likely intending to use this item on another item.
 * Some consumers currently return TRUE to mean "processed". These are not consistent and should be taken with a grain of salt.
 *
 * Arguments:
 * * atom/target - The thing that was hit
 * * mob/user - The mob doing the hitting
 * * modifiers - The list of click parameters
 */
/obj/item/proc/afterattack(atom/target, mob/user, list/modifiers)
	PROTECTED_PROC(TRUE)

/obj/item/proc/get_clamped_volume()
	if(w_class)
		if(force)
			return clamp((force + w_class) * 4, 30, 100)// Add the item's force to its weight class and multiply by 4, then clamp the value between 30 and 100
		else
			return clamp(w_class * 6, 10, 100) // Multiply the item's weight class by 6, then clamp the value between 10 and 100

/mob/living/proc/send_item_attack_message(obj/item/I, mob/living/user, hit_area)
	if(!I.force && !length(I.attack_verb_simple) && !length(I.attack_verb_continuous))
		return

	var/message_verb_continuous = length(I.attack_verb_continuous) ? "[pick(I.attack_verb_continuous)]" : "attacks"
	var/message_verb_simple = length(I.attack_verb_simple) ? "[pick(I.attack_verb_simple)]" : "attack"
	var/message_hit_area = ""
	if(hit_area)
		message_hit_area = " in the [hit_area]"

	var/attack_message_spectator = "<b>[src]</b> [message_verb_continuous][message_hit_area] with [I]!"

	if(user == src)
		attack_message_spectator = "<b>[user]</b> [message_verb_simple] [user.p_them()]self[message_hit_area] with [I]!"
	else if(user in viewers(src))
		attack_message_spectator = "<b>[user]</b> [message_verb_continuous] <b>[src]</b>[message_hit_area] with [I]!"

	visible_message(span_danger("[attack_message_spectator]"), vision_distance = COMBAT_MESSAGE_RANGE)
	return 1

/**
 * Interaction handler for being clicked on with a grab. This is called regardless of user intent.
 *
 * **Parameters**:
 * - `grab` - The grab item being used.
 * - `click_params` - List of click parameters.
 *
 * Returns boolean to indicate whether the attack call was handled or not. If `FALSE`, the next `use_*` proc in the
 * resolve chain will be called.
 */
/atom/proc/attack_grab(mob/living/user, atom/movable/victim, obj/item/hand_item/grab/grab, list/params)
	return FALSE
