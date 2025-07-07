/obj
	var/demolition_modifier = 1

/obj/hitby(atom/movable/hit_by, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	.=..()
	var/damage_taken = hit_by.throwforce
	if(isitem(hit_by))
		var/obj/item/as_item = hit_by
		damage_taken *= as_item.get_demolition_modifier(src)
	take_damage(damage_taken, BRUTE, MELEE, 1, get_dir(src, hit_by))
	return ..()

/obj/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit = FALSE)
	. = ..()
	var/damage_sustained = 0
	if(!QDELETED(src)) //Bullet on_hit effect might have already destroyed this object
		damage_sustained = take_damage(
			hitting_projectile.damage * hitting_projectile.get_demolition_modifier(src),
			hitting_projectile.damage_type,
			hitting_projectile.armor_flag,
			FALSE,
			REVERSE_DIR(hitting_projectile.dir),
			hitting_projectile.armor_penetration,
		)

	return ..()

/obj/proc/get_demolition_modifier(obj/target)
	return demolition_mod
