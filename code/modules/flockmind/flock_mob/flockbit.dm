/mob/living/simple_animal/flock/bit
	name = "flockbit"
	icon_state = "flockbit"
	maxHealth = 10
	density = FALSE
	pass_flags = PASSTABLE

/mob/living/simple_animal/flock/bit/Initialize(mapload)
	. = ..()
	flock?.stat_bits_made++
	AddComponent(/datum/component/flock_protection)
	set_real_name(flock_realname(FLOCK_TYPE_BIT))
	name = flock_name(FLOCK_TYPE_BIT)

/mob/living/simple_animal/flock/bit/proc/i_just_split(turf/avoid)
	ai_controller.PauseAi(0.3 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(step_away_from), avoid), 0.2 SECONDS)

/mob/living/simple_animal/flock/bit/proc/step_away_from(turf/avoid)
	if(avoid == get_turf(src))
		step(src, pick(GLOB.alldirs))
		return

	var/list/turfs = RANGE_TURFS(1, src) - get_turf(src)
	step(src, get_dir(src, pick(turfs)))
