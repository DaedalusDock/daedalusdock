/turf/closed/wall/flock
	name = "weird wall"
	icon = 'goon/icons/turf/flock.dmi'
	icon_state = "flock-0"
	base_icon_state = "flock"

	pathing_pass_method = TURF_PATHING_PASS_PROC

	light_color = "#19b299"
	light_power = 0.5
	light_inner_range = 0.1
	light_outer_range = 0.8
	light_on = FALSE

	plating_material = /datum/material/gnesis
	use_matset_name = FALSE

	uses_integrity = TRUE
	max_integrity = 250

/turf/closed/wall/flock/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_FLOCK_THING, INNATE_TRAIT)
	AddComponent(/datum/component/flock_protection, FALSE, TRUE, FALSE, FALSE)

/turf/closed/wall/flock/Destroy(force)
	REMOVE_TRAIT(src, TRAIT_FLOCK_THING, INNATE_TRAIT) // Turfs are persistent refs
	qdel(GetComponent(/datum/component/flock_protection))
	return ..()

/turf/closed/wall/flock/atom_break(damage_flag)
	. = ..()
	ScrapeAway()

/turf/closed/wall/flock/attacked_by(obj/item/attacking_item, mob/living/user)
	. = ..()
	if(!.)
		return
	//playsound here?

/turf/closed/wall/flock/CanAStarPass(to_dir, datum/can_pass_info/pass_info, leaving)
	. = ..()
	if(.)
		return

	return pass_info.able_to_flockphase

/turf/closed/wall/flock/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(.)
		return

	if(!isflockdrone(mover))
		return

	var/mob/living/simple_animal/flock/drone/bird = mover
	if(HAS_TRAIT(bird, TRAIT_FLOCKPHASE))
		return TRUE

	if(bird.can_flockphase())
		return TRUE
