/mob/living/simple_animal/flock/drone

/mob/living/simple_animal/flock/drone/Initialize(mapload, join_flock)
	. = ..()

	AddComponent(/datum/component/flock_protection, FALSE, TRUE, FALSE, FALSE)
	set_real_name(flock_realname(FLOCK_TYPE_DRONE))
	name = flock_name(FLOCK_TYPE_DRONE)

	if(stat == CONSCIOUS)
		INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, say), pick(GLOB.flockdrone_created_phrases))


/mob/living/simple_animal/flock/drone/death(gibbed, cause_of_death)
	deathmessage = pick(GLOB.flockdrone_death_phrases)
	return ..()

/mob/living/simple_animal/flock/drone/proc/split_into_bits()
	ai_controller.PauseAi(3 SECONDS)
	emote("scream")
	say("\[System notification: drone diffracting.\]")
	flock?.free_unit(src)

	var/turf/T = get_turf(src)
	for(var/i in 1 to 3)
		var/mob/living/simple_animal/flock/bit/bitty_bird = new(T, flock)
		bitty_bird.i_just_split(T)

	var/list/new_color = list(1,0,0, 0,1,0, 0,0,1, 0.15,0.77,0.66)
	color = null
	animate(src, color=new_color, alpha = 0, time = 0.1 SECONDS)

	addtimer(CALLBACK(src, PROC_REF(finish_splitting)), 0.1 SECONDS)

/mob/living/simple_animal/flock/drone/proc/finish_splitting()
	qdel(src)
