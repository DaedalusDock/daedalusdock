/datum/special_attack
	/// Self explanatory
	var/name

	/// changeNext_move() time after use.
	var/click_cooldown = CLICK_CD_MELEE
	/// If TRUE, use the item's click cooldown instead of the attack's.
	var/use_item_click_cooldown = FALSE

	// Stamina consumed on use.
	var/stamina_cost = 0
	// If TRUE, use the item's swing cost instead of the stamina_cost.
	var/use_item_stamina = TRUE

	/// How long to prevent moving away.
	var/mob_hold_duration = 0 SECONDS

/datum/special_attack/proc/try_perform_attack(mob/living/user, obj/item/weapon, atom/clicked_atom, list/modifiers)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	weapon?.add_fingerprint(user)

	var/direction = get_attack_direction(user, weapon, clicked_atom)
	if(!can_use(user, weapon, clicked_atom, modifiers, direction))
		user.changeNext_move(CLICK_CD_RAPID)
		return FALSE

	pre_attack(user, weapon, clicked_atom, modifiers)

	execute_attack(user, weapon, clicked_atom, modifiers, direction)

	post_attack(user, weapon, clicked_atom, modifiers)

/datum/special_attack/proc/can_use(mob/living/user, obj/item/weapon, atom/clicked, list/modifiers, direction)
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		return FALSE

	if(user.stamina.current < stamina_cost)
		return FALSE

	if(!isturf(user.loc))
		return FALSE

	return TRUE

/// Returns the direction of the attack.
/datum/special_attack/proc/get_attack_direction(mob/living/user, obj/item/weapon, atom/clicked_atom)
	return get_cardinal_dir(user, clicked_atom) || user.dir

/datum/special_attack/proc/is_valid_target(mob/living/user, atom/A)
	if(A == user)
		return FALSE

	if(!isliving(A))
		return FALSE

	return TRUE

/// Ensures the attack is able to continue and the weapon wasn't deleted or whatever.
/datum/special_attack/proc/sanity_check(mob/living/user, obj/item/weapon, atom/clicked_atom)
	if(QDELETED(user) || QDELETED(weapon))
		return FALSE

	if(!user.is_holding(weapon))
		return FALSE

	return TRUE

/// Modify an attack's properties.
/datum/special_attack/proc/modifiy_damage_packet(datum/damage_packet/packet, mob/living/victim, mob/living/user)
	return

/// Called before execute_attack.
/datum/special_attack/proc/pre_attack(mob/living/user, obj/item/weapon, atom/clicked_atom, list/modifiers, direction)
	if(mob_hold_duration)
		ADD_TRAIT(user, TRAIT_IMMOBILIZED, ref(src))
		addtimer(CALLBACK(src, PROC_REF(free_mob), WEAKREF(user)), mob_hold_duration)

/// The actual attack effects.
/datum/special_attack/proc/execute_attack(mob/living/user, obj/item/weapon, atom/clicked_atom, list/modifiers, direction)
	return

/// After execute_attack has run.
/datum/special_attack/proc/post_attack(mob/living/user, obj/item/weapon, atom/clicked_atom, list/modifiers, direction)
	if(use_item_stamina)
		user.stamina_swing(-weapon.stamina_cost)
	else
		user.stamina_swing(-stamina_cost)

	user.changeNext_move(use_item_click_cooldown ? weapon.combat_click_delay : click_cooldown)

/datum/special_attack/proc/free_mob(datum/weakref/W)
	var/mob/M = W.resolve()
	if(M)
		REMOVE_TRAIT(M, TRAIT_IMMOBILIZED, ref(src))
