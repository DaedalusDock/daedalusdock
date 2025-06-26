/mob/living/simple_animal
	var/aggrosound = null
	var/idlesound = null
	var/death_sound = null
	var/pop_required_to_jump_into = 0
	var/extra_projectiles = 0
	var/force_threshold = 0

#warn finish ghost animals sometime

/mob/living/simple_animal/Life()
	. = ..()
	if(stat)
		return
	if (idlesound)
		if (prob(5))
			var/chosen_sound = pick(idlesound)
			playsound(src, chosen_sound, 60, FALSE)

/mob/living/simple_animal/hostile/Aggro()
	.=..()
	if(aggrosound)
		if(prob(90))
			var/chosen_sound = pick(aggrosound)
			playsound(src, chosen_sound, 60, FALSE)

/mob/living/simple_animal/death(gibbed)
	.=..()
	movement_type &= ~FLYING
	if(nest)
		nest.spawned_mobs -= src
		nest = null
	drop_loot()
	if(!gibbed)
		if(death_sound)
			playsound(get_turf(src),death_sound, 200, 1)
		..()

/mob/living/simple_animal/hostile/OpenFire(atom/A)
	.=..()
	if(rapid > 1)
		var/datum/callback/cb = CALLBACK(src, .proc/Shoot, A)
		for(var/i in 1 to rapid)
			addtimer(cb, (i - 1)*rapid_fire_delay)
	else
		Shoot(A)
		for(var/i in 1 to extra_projectiles)
			addtimer(CALLBACK(src, .proc/Shoot, A), i * 2)
	ranged_cooldown = world.time + ranged_cooldown_time

/mob/living/simple_animal/attacked_by(obj/item/I, mob/living/user, attackchain_flags = NONE, damage_multiplier = 1)
	.=..()
	if(I.force < force_threshold && I.armor_penetration < 15)
		playsound(src, 'sound/weapons/tap.ogg', I.get_clamped_volume(), 1, -1)
	else
		return ..()
