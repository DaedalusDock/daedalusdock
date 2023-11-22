/mob/living/proc/should_strip(mob/living/user)
	. = TRUE

	if(user.is_grabbing(src) && !user.combat_mode && isliving(user))
		var/mob/living/living_user = user
		if(mob_size < living_user.mob_size) // If we're smaller than user
			return !mob_pickup_checks(user, FALSE)
