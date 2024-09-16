/datum/atom_hud/alternate_appearance/basic/flock
	var/datum/flock/bound_flock

/datum/atom_hud/alternate_appearance/basic/flock/New(key, image/I, options, flock)
	bound_flock = flock
	. = ..()

/datum/atom_hud/alternate_appearance/basic/flock/mobShouldSee(mob/M)
	if(istype(M, /mob/camera/flock))
		var/mob/camera/flock/bird = M
		if(bird.flock == bound_flock)
			return TRUE
		return FALSE

	if(istype(M, /mob/living/simple_animal/flock))
		var/mob/living/simple_animal/flock/bird = M
		if(bird.flock == bound_flock)
			return TRUE
		return FALSE
	return FALSE
