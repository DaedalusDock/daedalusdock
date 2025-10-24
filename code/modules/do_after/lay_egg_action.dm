/datum/timed_action/flock_lay_egg

/datum/timed_action/flock_lay_egg/on_process(delta_time)
	. = ..()
	var/mob/living/simple_animal/flock/drone/bird = user
	if(!bird.substrate.has_points(bird.flock?.current_egg_cost || FLOCK_SUBSTRATE_COST_LAY_EGG))
		return FALSE

	if(DT_PROB(5, delta_time))
		user.shake_animation()
		playsound(user, pick('goon/sounds/Metal_Clang_1.ogg', 'goon/sounds/mixer.ogg'), 30, TRUE, extrarange = SILENCED_SOUND_EXTRARANGE)
