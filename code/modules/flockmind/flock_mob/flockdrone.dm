/mob/living/simple_animal/flock/drone

/mob/living/simple_animal/flock/drone/Initialize(mapload)
	. = ..()

	set_real_name(flock_realname(FLOCK_TYPE_DRONE))
	name = flock_name(FLOCK_TYPE_DRONE)

	if(stat == CONSCIOUS)
		INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, say), pick(GLOB.flockdrone_created_phrases))


/mob/living/simple_animal/flock/drone/death(gibbed, cause_of_death)
	deathmessage = pick(GLOB.flockdrone_death_phrases)
	return ..()
