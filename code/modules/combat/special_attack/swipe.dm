/// Swipe attack. Hits a mob on every turf infront of the user. Prioritizes standing opponents.
/datum/special_attack/swipe
	name = "Swipe"

	click_cooldown = CLICK_CD_MELEE * 1.5

	mob_hold_duration = 0.3 SECONDS

/datum/special_attack/swipe/can_use(mob/living/user, obj/item/weapon, atom/clicked, list/modifiers, direction)
	. = ..()
	if(!.)
		return

	var/turf/T = get_step(user, direction)
	return T?.IsReachableBy(user)

/datum/special_attack/swipe/execute_attack(mob/living/user, obj/item/weapon, atom/clicked_atom, list/modifiers, direction)
	. = ..()
	if(!iscardinaldir(direction))
		direction = turn(direction, pick(45, -45))

	var/turf/one = get_step(user, direction)
	var/turf/two = get_step(one, turn(direction, 90))
	var/turf/three = get_step(one, turn(direction, -90))

	var/obj/effect/temp_visual/special_attack/swipe/visual = new(get_step(one, direction))
	visual.setDir(direction)

	if(istype(weapon, /obj/item/melee/energy/sword/saber))
		var/obj/item/melee/energy/sword/saber/sword = weapon
		visual.color = sword.possible_colors[sword.sword_color_icon]

	user.do_attack_animation(one, no_effect = TRUE)

	var/params = list2params(modifiers)

	var/interacted_with_anything = FALSE
	for(var/turf/T in list(one, two, three))
		if(!T.IsReachableBy(user))
			continue

		if(!sanity_check(user, weapon, clicked_atom))
			break

		var/list/mobs_in_turf = list()
		for(var/mob/living/L in T)
			mobs_in_turf += L

		var/mob/living/target_in_turf
		switch(length(mobs_in_turf))
			if(0)
				continue
			if(1)
				target_in_turf = mobs_in_turf[1]
			else
				// Filter the list to prioritize a standing mob.
				for(var/mob/living/L as anything in mobs_in_turf)
					if(!target_in_turf)
						target_in_turf = L

					if(target_in_turf.body_position == STANDING_UP)
						break

		if(target_in_turf)
			weapon.attack(target_in_turf, user, params, src)
			interacted_with_anything = TRUE

	if(!interacted_with_anything)
		weapon.play_combat_sound(MOB_ATTACKEDBY_MISS)
