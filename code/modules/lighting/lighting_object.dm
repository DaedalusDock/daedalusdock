/datum/lighting_object
	///the underlay we are currently applying to our turf to apply light
	var/mutable_appearance/current_underlay
	var/mutable_appearance/additive_underlay

	///whether we are already in the SSlighting.objects_queue list
	var/needs_update = FALSE

	///the turf that our light is applied to
	var/turf/affected_turf

/datum/lighting_object/New(turf/source)
	if(!isturf(source))
		qdel(src, force=TRUE)
		stack_trace("a lighting object was assigned to [source], a non turf! ")
		return
	. = ..()

	current_underlay = mutable_appearance(LIGHTING_ICON, (source.lighting_uses_jen ? "wall-jen-[source.smoothing_junction]" : "light"), source.z, LIGHTING_PLANE, 255, RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM)
	additive_underlay = mutable_appearance(LIGHTING_ICON, (source.lighting_uses_jen ? "wall-jen-[source.smoothing_junction]" : "light"), source.z, LIGHTING_PLANE_ADDITIVE, 255, RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM)
	additive_underlay.blend_mode = BLEND_ADD

	affected_turf = source
	if (affected_turf.lighting_object)
		qdel(affected_turf.lighting_object, force = TRUE)
		stack_trace("a lighting object was assigned to a turf that already had a lighting object!")

	affected_turf.lighting_object = src
	affected_turf.luminosity = 0

	if(CONFIG_GET(flag/starlight))
		for(var/turf/open/space/space_tile in RANGE_TURFS(1, affected_turf))
			space_tile.update_starlight()

	needs_update = TRUE
	SSlighting.objects_queue += src

/datum/lighting_object/Destroy(force)
	if (!force)
		return QDEL_HINT_LETMELIVE
	SSlighting.objects_queue -= src
	if (isturf(affected_turf))
		affected_turf.lighting_object = null
		affected_turf.luminosity = 1
		affected_turf.underlays -= current_underlay
		affected_turf.underlays -= additive_underlay
	affected_turf = null
	return ..()

/datum/lighting_object/proc/update()
	var/turf/affected_turf = src.affected_turf
#ifdef VISUALIZE_LIGHT_UPDATES
	affected_turf.add_atom_colour(COLOR_BLUE_LIGHT, ADMIN_COLOUR_PRIORITY)
	animate(affected_turf, 10, color = null)
	addtimer(CALLBACK(affected_turf, /atom/proc/remove_atom_colour, ADMIN_COLOUR_PRIORITY, COLOR_BLUE_LIGHT), 10, TIMER_UNIQUE|TIMER_OVERRIDE)
#endif

	// To the future coder who sees this and thinks
	// "Why didn't he just use a loop?"
	// Well my man, it's because the loop performed like shit.
	// And there's no way to improve it because
	// without a loop you can make the list all at once which is the fastest you're gonna get.
	// Oh it's also shorter line wise.
	// Including with these comments.

	var/static/datum/lighting_corner/dummy/dummy_lighting_corner = new

	var/datum/lighting_corner/red_corner = affected_turf.lighting_corner_SW || dummy_lighting_corner
	var/datum/lighting_corner/green_corner = affected_turf.lighting_corner_SE || dummy_lighting_corner
	var/datum/lighting_corner/blue_corner = affected_turf.lighting_corner_NW || dummy_lighting_corner
	var/datum/lighting_corner/alpha_corner = affected_turf.lighting_corner_NE || dummy_lighting_corner

	var/max = max(red_corner.largest_color_luminosity, green_corner.largest_color_luminosity, blue_corner.largest_color_luminosity, alpha_corner.largest_color_luminosity)

	#if LIGHTING_SOFT_THRESHOLD != 0
	var/set_luminosity = max > LIGHTING_SOFT_THRESHOLD
	#else
	// Because of floating points™?, it won't even be a flat 0.
	// This number is mostly arbitrary.
	var/set_luminosity = max > 1e-6
	#endif

	var/mutable_appearance/current_underlay = src.current_underlay
	affected_turf.underlays -= current_underlay

	if(red_corner.cache_r & green_corner.cache_r & blue_corner.cache_r & alpha_corner.cache_r && \
		(red_corner.cache_g + green_corner.cache_g + blue_corner.cache_g + alpha_corner.cache_g + \
		red_corner.cache_b + green_corner.cache_b + blue_corner.cache_b + alpha_corner.cache_b == 8))

		//anything that passes the first case is very likely to pass the second, and addition is a little faster in this case
		current_underlay.icon_state = "lighting_transparent"
		current_underlay.color = null

	else if(!set_luminosity)
		current_underlay.icon_state = "lighting_dark"
		current_underlay.color = null

	else
		current_underlay.icon_state = affected_turf.lighting_uses_jen ? "wall-jen-[affected_turf.smoothing_junction]" : "light"
		current_underlay.color = list(
			red_corner.cache_r, red_corner.cache_g, red_corner.cache_b, 00,
			green_corner.cache_r, green_corner.cache_g, green_corner.cache_b, 00,
			blue_corner.cache_r, blue_corner.cache_g, blue_corner.cache_b, 00,
			alpha_corner.cache_r, alpha_corner.cache_g, alpha_corner.cache_b, 00,
			00, 00, 00, 01
		)

	if((red_corner.applying_additive || green_corner.applying_additive || blue_corner.applying_additive || alpha_corner.applying_additive) && !(affected_turf.z_flags & Z_MIMIC_OVERWRITE))
		//I'm not ENTIRELY sure why, but turfs of this nature will black out if they get bloom'd
		affected_turf.underlays -= additive_underlay
		additive_underlay.icon_state = affected_turf.lighting_uses_jen ? "wall-jen-[affected_turf.smoothing_junction]" : "light"

		additive_underlay.color = list(
			red_corner.add_r, red_corner.add_g, red_corner.add_b, 00,
			green_corner.add_r, green_corner.add_g, green_corner.add_b, 00,
			blue_corner.add_r, blue_corner.add_g, blue_corner.add_b, 00,
			alpha_corner.add_r, alpha_corner.add_g, alpha_corner.add_b, 00,
			00, 00, 00, 01
		)

		affected_turf.underlays += additive_underlay
	else
		affected_turf.underlays -= additive_underlay

	affected_turf.underlays += current_underlay
	affected_turf.luminosity = set_luminosity || affected_turf.loc:area_has_base_lighting

	if (affected_turf.above)
		if(affected_turf.above.shadower)
			affected_turf.above.shadower.copy_lighting(src)
		else
			affected_turf.above.update_mimic()
