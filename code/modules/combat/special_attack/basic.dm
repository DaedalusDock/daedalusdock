/// Attack in a direction.
/datum/special_attack/basic
	use_item_click_cooldown = TRUE

	var/effect_type = /obj/effect/temp_visual/special_attack/simple

/datum/special_attack/basic/can_use(mob/living/user, obj/item/weapon, atom/clicked, list/modifiers, direction)
	. = ..()
	if(!.)
		return

	var/turf/T = get_step(user, direction)
	return T?.IsReachableBy(user) && !isclosedturf(T)

/datum/special_attack/basic/execute_attack(mob/living/user, obj/item/weapon, atom/clicked_atom, list/modifiers, direction)
	. = ..()
	var/turf/T = get_step(user, direction)

	user.do_attack_animation(T, no_effect = TRUE)

	var/obj/effect/visual_effect = new effect_type(T)
	visual_effect.setDir(direction)

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
	else
		weapon.play_combat_sound(MOB_ATTACKEDBY_MISS)


/datum/special_attack/basic/stab
	name = "Stab"

	effect_type = /obj/effect/temp_visual/special_attack/stab

/datum/special_attack/basic/stab/modifiy_damage_packet(datum/damage_packet/packet, mob/living/victim, mob/living/user)
	packet.sharpness = SHARP_POINTY
