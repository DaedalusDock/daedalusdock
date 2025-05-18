// Because we can control each corner of every lighting object.
// And corners get shared between multiple turfs (unless you're on the corners of the map, then 1 corner doesn't).
// For the record: these should never ever ever be deleted, even if the turf doesn't have dynamic lighting.

/datum/lighting_corner
	var/list/datum/light_source/affecting // Light sources affecting us.

	var/x = 0
	var/y = 0

	var/turf/master_NE
	var/turf/master_SE
	var/turf/master_SW
	var/turf/master_NW

	//"raw" color values, changed by update_lumcount()
	var/lum_r = 0
	var/lum_g = 0
	var/lum_b = 0

	//true color values, guaranteed to be between 0 and 1
	var/cache_r = LIGHTING_SOFT_THRESHOLD
	var/cache_g = LIGHTING_SOFT_THRESHOLD
	var/cache_b = LIGHTING_SOFT_THRESHOLD

	//additive light values
	var/add_r = 0
	var/add_g = 0
	var/add_b = 0
	var/applying_additive = FALSE

	///the maximum of sum_r, sum_g, and sum_b. if this is > 1 then the three cached color values are divided by this
	var/largest_color_luminosity = 0

	///whether we are to be added to SSlighting's corners_queue list for an update
	var/needs_update = FALSE

/datum/lighting_corner/New(x, y, z)
	. = ..()
	src.x = x + 0.5
	src.y = y + 0.5

	// Alright. We're gonna take a set of coords, and from them do a loop clockwise
	// To build out the turfs adjacent to us. This is pretty fast
	var/turf/process_next = locate(x, y, z)
	if(process_next)
		master_SW = process_next
		process_next.lighting_corner_NE = src
		// Now, we go north!
		process_next = get_step(process_next, NORTH)
	else
		// Yes this is slightly slower then having a guarenteeed turf, but there aren't many null turfs
		// So this is pretty damn fast
		process_next = locate(x, y + 1, z)

	// Ok, if we have a north turf, go there. otherwise, onto the next
	if(process_next)
		master_NW = process_next
		process_next.lighting_corner_SE = src
		// Now, TO THE EAST
		process_next = get_step(process_next, EAST)
	else
		process_next = locate(x + 1, y + 1, z)

	// Etc etc
	if(process_next)
		master_NE = process_next
		process_next.lighting_corner_SW = src
		// Now, TO THE SOUTH AGAIN (SE)
		process_next = get_step(process_next, SOUTH)
	else
		process_next = locate(x + 1, y, z)

	// anddd the last tile
	if(process_next)
		master_SE = process_next
		process_next.lighting_corner_NW = src

/datum/lighting_corner/proc/vis_update()
	for (var/datum/light_source/light_source as anything in affecting)
		light_source.vis_update()

/datum/lighting_corner/proc/full_update()
	for (var/datum/light_source/light_source as anything in affecting)
		light_source.recalc_corner(src)

// God that was a mess, now to do the rest of the corner code! Hooray!
/datum/lighting_corner/proc/update_lumcount(delta_r, delta_g, delta_b)

#ifdef VISUALIZE_LIGHT_UPDATES
	if (!SSlighting.allow_duped_values && !(delta_r || delta_g || delta_b)) // 0 is falsey ok
		return
#else
	if (!(delta_r || delta_g || delta_b)) // 0 is falsey ok
		return
#endif

	lum_r += delta_r
	lum_g += delta_g
	lum_b += delta_b

	if (!needs_update)
		needs_update = TRUE
		SSlighting.corners_queue += src

/datum/lighting_corner/proc/update_objects()
	// Cache these values ahead of time so 4 individual lighting objects don't all calculate them individually.
	var/lum_r = src.lum_r
	var/lum_g = src.lum_g
	var/lum_b = src.lum_b
	var/largest_color_luminosity = max(lum_r, lum_g, lum_b) // Scale it so one of them is the strongest lum, if it is above 1.

	. = 1 // factor
	if (largest_color_luminosity > 1)
		. = 1 / largest_color_luminosity

	var/old_r = cache_r
	var/old_g = cache_g
	var/old_b = cache_b

	var/old_add_r = add_r
	var/old_add_g = add_g
	var/old_add_b = add_b

	#if LIGHTING_SOFT_THRESHOLD != 0
	else if (largest_color_luminosity < LIGHTING_SOFT_THRESHOLD)
		. = 0 // 0 means soft lighting.

	cache_r = round(lum_r * ., LIGHTING_ROUND_VALUE) || LIGHTING_SOFT_THRESHOLD
	cache_g = round(lum_g * ., LIGHTING_ROUND_VALUE) || LIGHTING_SOFT_THRESHOLD
	cache_b = round(lum_b * ., LIGHTING_ROUND_VALUE) || LIGHTING_SOFT_THRESHOLD
	#else
	cache_r = round(lum_r * ., LIGHTING_ROUND_VALUE)
	cache_g = round(lum_g * ., LIGHTING_ROUND_VALUE)
	cache_b = round(lum_b * ., LIGHTING_ROUND_VALUE)
	#endif

	add_r = clamp((lum_r - 1.1) * 0.3, 0, 0.22)
	add_g = clamp((lum_g - 1.1) * 0.3, 0, 0.22)
	add_b = clamp((lum_b - 1.1) * 0.3, 0, 0.22)

	// Client-shredding, does not cull any additive overlays.
	//applying_additive = add_r || add_g || add_b
	// Cull additive overlays that would be below 0.03 alpha in any color.
	applying_additive = max(add_r, add_g, add_b) > 0.03
	// Cull additive overlays whose color alpha sum is lower than 0.03
	//applying_additive = (add_r + add_g + add_b) > 0.03

	src.largest_color_luminosity = round(largest_color_luminosity, LIGHTING_ROUND_VALUE)
#ifdef VISUALIZE_LIGHT_UPDATES
	if(!SSlighting.allow_duped_corners && old_r == cache_r && old_g == cache_g && old_b == cache_b && old_add_r == add_r && old_add_b == add_b && old_add_g == add_g)
		return
#else
	if(old_r == cache_r && old_g == cache_g && old_b == cache_b && old_add_r == add_r && old_add_b == add_b && old_add_g == add_g)
		return
#endif

	var/datum/lighting_object/lighting_object = master_NE?.lighting_object
	if (lighting_object && !lighting_object.needs_update)
		lighting_object.needs_update = TRUE
		SSlighting.objects_queue += lighting_object

	lighting_object = master_SE?.lighting_object
	if (lighting_object && !lighting_object.needs_update)
		lighting_object.needs_update = TRUE
		SSlighting.objects_queue += lighting_object

	lighting_object = master_SW?.lighting_object
	if (lighting_object && !lighting_object.needs_update)
		lighting_object.needs_update = TRUE
		SSlighting.objects_queue += lighting_object

	lighting_object = master_NW?.lighting_object
	if (lighting_object && !lighting_object.needs_update)
		lighting_object.needs_update = TRUE
		SSlighting.objects_queue += lighting_object

/datum/lighting_corner/dummy/New()
	return

/datum/lighting_corner/Destroy(force)
	//Welcome back soulful PJB comment.
	SHOULD_CALL_PARENT(FALSE)
	stack_trace("Ok, Look, TG, I need you to find whatever fucker decided to call qdel on a fucking lighting corner, \
	then tell him very nicely and politely that he is 100% retarded and needs his head checked. Thanks. Send them my regards by the way.")
	return QDEL_HINT_LETMELIVE
