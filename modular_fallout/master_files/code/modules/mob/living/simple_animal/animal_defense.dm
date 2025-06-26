/mob/living/simple_animal/proc/attack_threshold_check(damage, damagetype = BRUTE, armorcheck = "melee")
	if(temp_damage >= 0 && temp_damage <= force_threshold)
		visible_message("<span class='warning'>[src] looks unharmed!</span>")
		return FALSE
