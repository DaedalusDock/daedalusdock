/// Attack in a direction.
/datum/special_attack/ranged_stab
	click_cooldown = CLICK_CD_MELEE * 1.5

/datum/special_attack/ranged_stab/can_use(mob/living/user, obj/item/weapon, atom/clicked, list/modifiers, direction)
	. = ..()
	if(!.)
		return

	var/turf/T = get_step(user, direction)
	return T?.IsReachableBy(user) && !isclosedturf(T)

/datum/special_attack/ranged_stab/modifiy_damage_packet(datum/damage_packet/packet, mob/living/victim, mob/living/user)
	packet.sharpness = SHARP_POINTY

/datum/special_attack/ranged_stab/execute_attack(mob/living/user, obj/item/weapon, atom/clicked_atom, list/modifiers, direction)
	. = ..()
	var/turf/close_turf = get_step(user, direction)
	var/turf/far_turf = get_step(close_turf, direction)

	user.do_attack_animation(close_turf, no_effect = TRUE)

	var/obj/effect/visual_effect
	var/reaches_far = TRUE
	if(far_turf?.IsReachableBy(user, 2) && !isclosedturf(far_turf))
		visual_effect = new /obj/effect/temp_visual/special_attack/spear(far_turf)
	else
		visual_effect = new /obj/effect/temp_visual/special_attack/simple(close_turf)
		reaches_far = FALSE

	visual_effect.setDir(direction)

	var/interacted_with_anything = FALSE
	for(var/turf/T in reaches_far ? list(close_turf, far_turf) : list(close_turf))
		if(!sanity_check(user, weapon, clicked_atom))
			break

		var/list/mobs_in_turf = list()
		for(var/mob/living/L in T)
			mobs_in_turf += L

		var/mob/living/target_in_turf
		switch(length(mobs_in_turf))
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
			weapon.attack(target_in_turf, user, list2params(modifiers), src)
			interacted_with_anything = TRUE

	if(!interacted_with_anything)
		weapon.play_combat_sound(MOB_ATTACKEDBY_MISS)
