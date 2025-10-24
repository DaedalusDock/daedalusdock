/datum/timed_action/flock_lay_egg

/datum/timed_action/flock_lay_egg/on_process(delta_time)
	. = ..()
	if(DT_PROB(5, delta_time))
		user.shake_animation()
		playsound(user, pick('goon/sounds/Metal_Clang_1.ogg', 'goon/sounds/mixer.ogg'), 30, TRUE, extrarange = SILENCED_SOUND_EXTRARANGE)
