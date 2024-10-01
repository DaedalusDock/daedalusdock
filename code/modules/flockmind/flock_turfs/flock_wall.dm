/turf/closed/wall/flock
	name = "weird wall"
	icon = 'goon/icons/turf/flock.dmi'
	icon_state = "flock0"
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

/turf/closed/wall/flock/atom_break(damage_flag)
	. = ..()
	ScrapeAway()

/turf/closed/wall/flock/attacked_by(obj/item/attacking_item, mob/living/user)
	. = ..()
	if(!.)
		return
	//playsound here?

/turf/closed/wall/flock/CanAStarPass(to_dir, datum/can_pass_info/pass_info)
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

	if(bird.resources.has_points())
		return TRUE

/turf/closed/wall/flock/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()

	if(isnull(old_loc) || !isflockdrone(arrived))
		return

	var/mob/living/simple_animal/flock/drone/bird = arrived
	if(!HAS_TRAIT(bird, TRAIT_FLOCKPHASE) && bird.resources.has_points())
		bird.start_flockphase()

	if(HAS_TRAIT(bird, TRAIT_FLOCKPHASE))
		bird.resources.remove_points(1)
		if(!bird.resources.has_points())
			bird.stop_flockphase()

/turf/closed/wall/flock/Exited(atom/movable/gone, direction)
	. = ..()
	if(!isflockdrone(gone))
		return

	var/mob/living/simple_animal/flock/drone/bird = gone
	if(!HAS_TRAIT(bird, TRAIT_FLOCKPHASE))
		return

	if(!isflockturf(get_step(bird, direction)))
		bird.stop_flockphase()
