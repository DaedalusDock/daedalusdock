/turf/open/indestructible/shroud
	name = "The Shroud"
	icon = MAP_SWITCH('icons/effects/alphacolors.dmi', 'icons/turf/floors/shroud.dmi')
	icon_state = MAP_SWITCH("white", "shroud")
	appearance_flags = parent_type::appearance_flags | NO_CLIENT_COLOR

	opacity = TRUE

	initial_gas = AIRLESS_ATMOS

	light_inner_range = 1
	light_outer_range = 2
	light_power = 1

/turf/open/indestructible/shroud/Initialize(mapload)
	. = ..()
	setDir(pick(GLOB.cardinals))

	// Fog that renders over everything
	var/static/list/add_overlays
	if(!add_overlays)
		var/image/whitifier_overlay
		whitifier_overlay = image('icons/effects/alphacolors.dmi', icon_state = "white")
		whitifier_overlay.plane = GAME_PLANE
		whitifier_overlay.layer = HIGH_EFFECT_LAYER
		whitifier_overlay.blend_mode = BLEND_ADD
		whitifier_overlay.alpha = 100

		var/image/pearlescent_overlay
		pearlescent_overlay = image('icons/turf/floors/shroud.dmi', icon_state = "shroud")
		pearlescent_overlay.plane = GAME_PLANE
		pearlescent_overlay.layer = HIGH_EFFECT_LAYER
		pearlescent_overlay.alpha = 100

		var/image/illumination = create_fullbright_overlay()
		illumination.alpha = 120

		add_overlays = list(whitifier_overlay, pearlescent_overlay, illumination)
	add_overlay(add_overlays)

/turf/open/indestructible/shroud/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	astype(arrived, /mob/living)?.apply_status_effect(/datum/status_effect/shrouded)

	// Dead mobs don't support status effects... I should reconsider using a dead mob for this but oh well!
	if(isghost(arrived) && !HAS_TRAIT(arrived, TRAIT_SHROUDED))
		ADD_TRAIT(arrived, TRAIT_SHROUDED, INNATE_TRAIT)
		arrived.add_filter("eternity_shadower", 1, color_matrix_filter(rgb(0, 0, 0)))
		arrived.add_filter("eternity_gaussian_blur", 1, gauss_blur_filter(2))
		arrived.add_filter("eternity_motion_blur", 1, motion_blur_filter(0, 0))
		RegisterSignal(arrived, COMSIG_MOVABLE_MOVED, PROC_REF(on_ghost_move))
		to_chat(arrived, span_warning("A chill washes over your body as you step into the mist."))

/turf/open/indestructible/shroud/Exited(atom/movable/gone, direction)
	. = ..()
	if(isghost(gone) && HAS_TRAIT(gone, TRAIT_SHROUDED) && !istype(get_turf(gone),  /turf/open/indestructible/shroud))
		REMOVE_TRAIT(gone, TRAIT_SHROUDED, INNATE_TRAIT)
		UnregisterSignal(gone, COMSIG_MOVABLE_MOVED)
		gone.remove_filter(list("eternity_shadower", "eternity_gaussian_blur", "eternity_motion_blur"))

/turf/open/indestructible/shroud/proc/on_ghost_move(datum/source)
	SIGNAL_HANDLER

	if(!istype(get_turf(source), /turf/open/indestructible/shroud))
		qdel(src)

/// Respawns you when you touch it.
/turf/open/indestructible/shroud/deep

/turf/open/indestructible/shroud/deep/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	if(isghost(arrived))
		var/mob/dead/ghost/ghost = arrived
		ghost.notransform = TRUE

		addtimer(CALLBACK(src, PROC_REF(respawn_mob), arrived), 1 SECONDS)

/turf/open/indestructible/shroud/deep/proc/respawn_mob(mob/dead/ghost/ghost)
	if(QDELETED(ghost))
		return

	ghost.respawn(force = TRUE)
