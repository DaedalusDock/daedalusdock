/datum/action/innate/flock


/datum/action/innate/flock/convert
	name = "Convert"
	click_action = TRUE
	check_flags = AB_CHECK_CONSCIOUS

	var/obj/effect/abstract/turf_effect

/datum/action/innate/flock/convert/New(Target)
	. = ..()
	turf_effect = new(null)
	turf_effect.vis_flags |= VIS_INHERIT_LAYER
	turf_effect.icon = 'goon/icons/mob/featherzone.dmi'
	turf_effect.icon_state = "blank"
	turf_effect.mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/datum/action/innate/flock/convert/Destroy()
	QDEL_NULL(turf_effect)
	return ..()

/datum/action/innate/flock/convert/do_ability(mob/living/caller, atom/clicked_on, list/params)
	var/static/list/flock_ok_types = typecacheof(list(
		/turf/closed/wall,
		/turf/open/floor,
		/obj/structure/lattice,
	))

	if(params?[RIGHT_CLICK])
		unset_ranged_ability(caller)
		return TRUE

	var/turf/clicked_atom_turf = get_turf(clicked_on)
	if(!clicked_atom_turf)
		return FALSE

	if(!flock_ok_types[clicked_on.type])
		return FALSE

	playsound(caller, 'goon/sounds/flockmind/flockdrone_convert.ogg', 30, TRUE, extrarange = SILENCED_SOUND_EXTRARANGE)
	unset_ranged_ability(caller)

	if(istype(clicked_on, /turf/open/floor))
		clicked_atom_turf.vis_contents += turf_effect
		turf_effect.icon_state = "spawn-floor-loop"
		flick("spawn-floor", turf_effect)
		caller.face_atom(clicked_atom_turf)
		if(!do_after(caller, clicked_on, 4.5 SECONDS, DO_PUBLIC, interaction_key = "flock_convert"))
			clicked_atom_turf.vis_contents -= turf_effect
			return FALSE

		clicked_atom_turf.vis_contents -= turf_effect
		var/turf/new_turf = clicked_atom_turf.ScrapeAway(1)
		new_turf.PlaceOnTop(/turf/open/floor/flock)
		return TRUE

	return FALSE
