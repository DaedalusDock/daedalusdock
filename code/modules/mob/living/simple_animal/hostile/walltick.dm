#define BURROW_CD 10 SECONDS

/mob/living/simple_animal/hostile/walltick
	name = "walltick"
	desc = "An alien pest that feeds on processed metal. Most have a nasty habit of burrowing into walls. They are known to fling themselves through space until they eventually land on an unsuspecting station."
	icon_state = "walltick"
	icon_living = "walltick"
	icon_dead = "walltick_dead"
	attack_sound = 'sound/weapons/bite.ogg'
	attack_vis_effect = ATTACK_EFFECT_BITE
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_plas" = 0, "max_plas" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	obj_damage = 100 //exceptionally strong against structures, given their burrowing nature.
	maxHealth = 25
	health = 25
	harm_intent_damage = 6
	melee_damage_lower = 10
	melee_damage_upper = 10
	wander = FALSE

	var/burrowed = FALSE
	COOLDOWN_DECLARE(burrow_cooldown)

/mob/living/simple_animal/hostile/walltick/Initialize(mapload)
	attempt_burrow()
	. = ..()

/mob/living/simple_animal/hostile/walltick/LosePatience()
	if(COOLDOWN_FINISHED(src, burrow_cooldown))
		attempt_burrow()
		return ..()
	return ..()

/mob/living/simple_animal/hostile/walltick/handle_automated_action()
	if(burrowed)
		return
	. = ..()

/mob/living/simple_animal/hostile/walltick/Moved()
	if(!burrowed)
		return ..()
	var/turf/T = get_turf(src)
	if(!istype(T, /turf/closed/wall))
		unburrow()
		return ..()
	return ..()

/mob/living/simple_animal/hostile/walltick/attacked_by(obj/item/I, mob/living/user)
	unburrow()
	return ..()

/mob/living/simple_animal/hostile/walltick/proc/attempt_burrow()
	if(burrowed)
		return
	for(var/dir in GLOB.cardinals)
		var/turf/T = get_step(src, dir)
		if(istype(T, /turf/closed/wall))
			var/turf/closed/wall/twall = T
			burrow_into_wall(twall)
			return

/mob/living/simple_animal/hostile/walltick/proc/burrow_into_wall(turf/closed/wall/W)
	W.add_dent(WALL_DENT_HIT)
	visible_message(span_warning("[src] burrows into [W]!"))
	playsound(src, 'sound/weapons/bite.ogg', 50, TRUE)
	alpha = 25 //just barely visible while burrowed
	forceMove(W)
	burrowed = TRUE
	RegisterSignal(W, COMSIG_TURF_CHANGE, .proc/unburrow)

/mob/living/simple_animal/hostile/walltick/proc/unburrow()
	alpha = 255
	burrowed = FALSE
	if(stat == DEAD)
		return
	playsound(src, 'sound/creatures/rattle.ogg', 50, TRUE, null, null, null, null, FALSE)
	COOLDOWN_START(src, burrow_cooldown, BURROW_CD)

#undef BURROW_CD
