/mob/living/simple_animal/attacked_by(obj/item/I, mob/living/user, attackchain_flags = NONE, damage_multiplier = 1)
	.=..()
	if(I.force < force_threshold || I.damtype == STAMINA)
		playsound(src, 'modular_fallout/master_files/sound/weapons/tap.ogg', I.get_clamped_volume(), 1, -1)
	else
		return ..()

/// Like melee_attack_chain but for ranged.
/obj/item/proc/ranged_attack_chain(mob/user, atom/target, params)
	.=..()
	if(isliving(user))
		var/mob/living/L = user
		if(!CHECK_MOBILITY(L, MOBILITY_USE))
			to_chat(L, "<span class='warning'>You are unable to raise [src] right now!</span>")
			return
		if(max_reach >= 2 && has_range_for_melee_attack(target, user))
			return ranged_melee_attack(target, user, params)
	return afterattack(target, user, FALSE, params)
