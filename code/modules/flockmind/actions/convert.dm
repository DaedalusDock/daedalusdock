/datum/action/cooldown/flock/convert
	name = "Convert"
	click_to_activate = TRUE
	check_flags = AB_CHECK_CONSCIOUS

	var/obj/effect/abstract/flock_conversion/turf_effect

/datum/action/cooldown/flock/convert/New(Target)
	. = ..()
	turf_effect = new(null)

/datum/action/cooldown/flock/convert/Destroy()
	QDEL_NULL(turf_effect)
	return ..()

/datum/action/cooldown/flock/convert/is_valid_target(atom/cast_on)
	var/turf/clicked_atom_turf = get_turf(cast_on)
	if(!clicked_atom_turf)
		return FALSE

	if(!owner.Adjacent(clicked_atom_turf))
		return FALSE

	if(!clicked_atom_turf.can_flock_convert())
		return FALSE

	return TRUE

/datum/action/cooldown/flock/convert/Activate(atom/target)
	. = ..()
	playsound(owner, 'goon/sounds/flockmind/flockdrone_convert.ogg', 30, TRUE, extrarange = SILENCED_SOUND_EXTRARANGE)

	var/turf/clicked_atom_turf = get_turf(target)
	var/mob/living/simple_animal/flock/bird = owner

	if(istype(clicked_atom_turf, /turf/open/floor))
		clicked_atom_turf.vis_contents += turf_effect
		turf_effect.icon_state = "spawn-floor-loop"
		flick("spawn-floor", turf_effect)
		owner.face_atom(clicked_atom_turf)

		bird.flock?.reserve_turf(bird, clicked_atom_turf)
		if(!do_after(owner, target, 4.5 SECONDS, DO_PUBLIC, interaction_key = "flock_convert"))
			clicked_atom_turf.vis_contents -= turf_effect
			bird.flock?.free_turf(bird)
			return FALSE

		if(!is_valid_target(clicked_atom_turf))
			return FALSE

		bird.flock?.free_turf(bird)
		clicked_atom_turf.vis_contents -= turf_effect
		var/turf/new_turf = clicked_atom_turf.ScrapeAway(1)
		new_turf.PlaceOnTop(/turf/open/floor/flock)
		return TRUE

	return FALSE

/obj/effect/abstract/flock_conversion
	icon = 'goon/icons/mob/featherzone.dmi'
	icon_state = "blank"
	layer = ABOVE_OPEN_TURF_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	vis_flags = parent_type::vis_flags | VIS_INHERIT_LAYER
