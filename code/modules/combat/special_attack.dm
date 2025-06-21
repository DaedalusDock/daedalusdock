/datum/special_attack
	/// Self explanatory
	var/name

	/// changeNext_move() time after use.
	var/click_cooldown = CLICK_CD_MELEE

	// Stamina consumed on use.
	var/stamina_cost = 0
	// If TRUE, use the item's swing cost instead of the stamina_cost.
	var/use_item_stamina = TRUE

/datum/special_attack/proc/try_perform_attack(mob/living/user, obj/item/weapon, atom/clicked_atom, list/modifiers)
	weapon?.add_fingerprint(user)

	if(!can_use(user, weapon, clicked_atom, modifiers))
		user.changeNext_move(CLICK_CD_RAPID)
		return FALSE


	. = execute_attack(user, weapon, clicked_atom, modifiers)

	post_attack(user, weapon, clicked_atom, modifiers)

/datum/special_attack/proc/can_use(mob/living/user, obj/item/weapon, atom/clicked, list/modifiers)
	if(user.stamina.current < stamina_cost)
		return FALSE

	if(!isturf(user.loc))
		return FALSE

	return TRUE

/datum/special_attack/proc/is_valid_target(mob/living/user, atom/A)
	if(A == user)
		return FALSE

	if(!isliving(A))
		return FALSE

	return TRUE

/datum/special_attack/proc/execute_attack(mob/living/user, obj/item/weapon, atom/clicked_atom, list/modifiers)
	return TRUE

/datum/special_attack/proc/post_attack(mob/living/user, obj/item/weapon, atom/clicked_atom, list/modifiers)
	if(use_item_stamina)
		user.stamina.adjust(-weapon.stamina_cost)
	else
		user.stamina.adjust(-stamina_cost)

	user.changeNext_move(click_cooldown)

/datum/special_attack/swipe
	name = "Swipe"

	click_cooldown = CLICK_CD_MELEE * 1.5

/datum/special_attack/swipe/execute_attack(mob/living/user, obj/item/weapon, atom/clicked_atom, list/modifiers)
	var/direction = get_dir(user, clicked_atom)

	if(!iscardinaldir(direction))
		direction = turn(direction, pick(45, -45))

	var/turf/one = get_step(user, direction)
	var/turf/two = get_step(one, turn(direction, 90))
	var/turf/three = get_step(one, turn(direction, -90))

	var/obj/effect/temp_visual/special_attack/swipe/visual = new(get_step(one, direction))
	visual.dir = direction

	user.do_attack_animation(one, no_effect = TRUE)

	var/params = list2params(modifiers)

	for(var/turf/T in list(one, two, three))
		for(var/mob/living/L as anything in T)
			weapon.attack_multiple(L, user, params)

