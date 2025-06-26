/mob/living/simple_animal/hostile
	var/decompose = FALSE
	var/emote_taunt_sound = null

/mob/living/simple_animal/hostile/Life(delta_time = SSMOBS_DT, times_fired)
	if(!(. = ..()))
		walk(src, 0) //stops walking
		if(decompose)
			if(prob(1)) // 1% chance every cycle to decompose
				visible_message("<span class='notice'>\The dead body of the [src] decomposes!</span>")
				gib(FALSE, FALSE, FALSE, TRUE)
		CHECK_TICK
		return

/mob/living/simple_animal/hostile/Aggro()
	.=..()
	if(target && LAZYLEN(emote_taunt) && prob(taunt_chance))
		emote("me", EMOTE_VISIBLE, "[pick(emote_taunt)] at [target].")
		taunt_chance = max(taunt_chance-7,2)
	if(LAZYLEN(emote_taunt_sound))
		var/taunt_choice = pick(emote_taunt_sound)
		playsound(loc, taunt_choice, 50, 0)
