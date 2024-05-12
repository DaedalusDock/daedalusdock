/obj/projectile/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "small1"
	damage = 90
	paralyze = 100
	dismemberment = 90
	armor_penetration = 100
	damage_type = BRUTE
	armor_flag = PUNCTURE

/obj/projectile/meteor/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(. == BULLET_ACT_HIT && isliving(target))
		explosion(target, devastation_range = -1, light_impact_range = 2, flame_range = 0, flash_range = 1, adminlog = FALSE)
		playsound(target.loc, 'sound/effects/meteorimpact.ogg', 40, TRUE)

/obj/projectile/meteor/Bump(atom/hit_target)
	if(hit_target == firer)
		forceMove(hit_target.loc)
		return
	if(isobj(hit_target) || isturf(hit_target))
		EX_ACT(hit_target, EXPLODE_HEAVY)

	playsound(src.loc, 'sound/effects/meteorimpact.ogg', 40, TRUE)
	for(var/mob/onlookers_in_range in urange(10, src))
		if(!onlookers_in_range.stat)
			shake_camera(onlookers_in_range, 3, 1)
	qdel(src)
