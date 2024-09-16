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
	var/static/list/flock_ok_types = typecacheof(list(
		/turf/closed/wall,
		/turf/open/floor,
		/obj/structure/lattice,
	))


	var/turf/clicked_atom_turf = get_turf(cast_on)
	if(!clicked_atom_turf)
		return FALSE

	if(!owner.Adjacent(cast_on))
		return FALSE

	if(!flock_ok_types[cast_on.type])
		return FALSE

	return TRUE

/datum/action/cooldown/flock/convert/Activate(atom/target)
	. = ..()
	playsound(owner, 'goon/sounds/flockmind/flockdrone_convert.ogg', 30, TRUE, extrarange = SILENCED_SOUND_EXTRARANGE)

	var/turf/clicked_atom_turf = get_turf(target)
	if(istype(target, /turf/open/floor))
		clicked_atom_turf.vis_contents += turf_effect
		turf_effect.icon_state = "spawn-floor-loop"
		flick("spawn-floor", turf_effect)
		owner.face_atom(clicked_atom_turf)
		if(!do_after(owner, target, 4.5 SECONDS, DO_PUBLIC, interaction_key = "flock_convert"))
			clicked_atom_turf.vis_contents -= turf_effect
			return FALSE

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
