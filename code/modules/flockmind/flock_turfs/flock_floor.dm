/turf/open/floor/flock
	name = "weird floor"
	icon = 'goon/icons/mob/featherzone.dmi'
	icon_state = "floor"
	base_icon_state = "floor"

	light_color = "#19b299"
	light_power = 0.4
	light_outer_range = 4
	light_on = FALSE
	light_system = OVERLAY_LIGHT

	var/health = 50
	var/is_on = FALSE

/turf/open/floor/flock/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/flock_protection, FALSE, TRUE, FALSE, FALSE)

/turf/open/floor/flock/get_flock_id()
	return "Conduit"

/turf/open/floor/flock/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	return FALSE

/turf/open/floor/flock/burn_tile()
	return

/turf/open/floor/flock/update_icon_state()
	if(broken)
		icon_state = "[base_icon_state]-broken"
	else
		if(is_on)
			icon_state = "[base_icon_state]-on"
		else
			icon_state = base_icon_state
	return ..()

/turf/open/floor/flock/break_tile()
	. = ..()
	for(var/mob/living/simple_animal/flock/drone/bird in src)
		if(HAS_TRAIT(bird, TRAIT_FLOCKPHASE))
			bird.stop_flockphase()

/turf/open/floor/flock/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	if(!isflockdrone(arrived))
		return

	var/mob/living/simple_animal/flock/drone/bird = arrived

	if(broken)
		bird.stop_flockphase()
		return

	if(bird.client?.keys_held["Shift"] && bird.can_flockphase())
		bird.start_flockphase()

	if(bird.flockphase_tax() && !is_on)
		turn_on()

/turf/open/floor/flock/Exited(atom/movable/gone, direction)
	. = ..()
	if(!isflockdrone(gone))
		return

	var/mob/living/simple_animal/flock/drone/bird = gone
	if(!HAS_TRAIT(bird, TRAIT_FLOCKPHASE))
		return

	var/have_a_phasing_bird = FALSE
	for(var/mob/living/simple_animal/flock/drone/bird_in_src in src)
		if(HAS_TRAIT(bird_in_src, TRAIT_FLOCKPHASE))
			have_a_phasing_bird = TRUE
			break

	if(!have_a_phasing_bird)
		turn_off()

	if(!isflockturf(bird.loc))
		bird.stop_flockphase()

/turf/open/floor/flock/proc/turn_on()
	if(is_on || broken)
		return

	is_on = TRUE
	set_light_on(FALSE)
	update_appearance(UPDATE_ICON_STATE)

/turf/open/floor/flock/proc/turn_off()
	if(!is_on)
		return

	is_on = FALSE
	set_light_on(TRUE)
	update_appearance(UPDATE_ICON_STATE)
