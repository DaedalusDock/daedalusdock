/mob/living/proc/should_strip(mob/user)
	. = TRUE

	if(user.pulling == src && isliving(user))
		var/mob/living/living_user = user
		if(mob_size < living_user.mob_size) // If we're smaller than user
			return !mob_pickup_checks(user, FALSE)
