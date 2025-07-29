/mob/living/simple_animal/attacked_by(obj/item/I, mob/living/user, attackchain_flags = NONE, damage_multiplier = 1)
	.=..()
	if(I.force < force_threshold || I.damtype == STAMINA)
		playsound(src, 'modular_fallout/master_files/sound/weapons/tap.ogg', I.get_clamped_volume(), 1, -1)
	else
		return ..()

#warn look at original item_attack.dm and ???

/mob/living/attacked_by(obj/item/attacking_item, mob/living/user, list/modifiers, list/attack_modifiers)
	.=..()
	var/damage = attacking_item.force
	if(mob_biotypes & MOB_ROBOTIC)
		damage *= attacking_item.get_demolition_modifier(src)
	return damage

// druggies

/obj/item/attack(mob/living/M, mob/living/user, attackchain_flags = NONE, damage_multiplier = 1)
	.=..()

	var/bigleagues = force*0.45
	var/buffout = force*0.55

	if (force >= 5 && HAS_TRAIT(user, TRAIT_BIG_LEAGUES))
		force += bigleagues

	if (force >= 5 && HAS_TRAIT(user, TRAIT_BUFFOUT_BUFF))
		force += buffout

	return ..()
