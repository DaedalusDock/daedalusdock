// This is where the fun begins.
// These are the main datums that emit light.

/datum/light_source
	///The atom we're emitting light from (for example a mob if we're from a flashlight that's being held).
	var/atom/top_atom
	///The atom that we belong to.
	var/atom/source_atom

	///The turf under the source atom.
	var/turf/source_turf
	///The turf the top_atom appears to over.
	var/turf/pixel_turf

	///Intensity of the emitter light.
	var/light_power
	/// The range of the emitted light.
	var/light_inner_range
	/// Range where light begins to taper into darkness in tiles.
	var/light_outer_range
	/// Adjusts curve for falloff gradient
	var/light_falloff_curve = LIGHTING_DEFAULT_FALLOFF_CURVE
	/// The colour of the light, string, decomposed by parse_light_color()
	var/light_color

	// Variables for keeping track of the colour.
	var/lum_r
	var/lum_g
	var/lum_b

	// The lumcount values used to apply the light.
	var/tmp/applied_lum_r
	var/tmp/applied_lum_g
	var/tmp/applied_lum_b

	/// List used to store how much we're affecting corners.
	var/list/datum/lighting_corner/effect_str

	/// Whether we have applied our light yet or not.
	var/applied = FALSE

	/// whether we are to be added to SSlighting's sources_queue list for an update
	var/needs_update = LIGHTING_NO_UPDATE


/datum/light_source/New(atom/owner, atom/top)
	source_atom = owner // Set our new owner.
	add_to_light_sources(source_atom)
	top_atom = top
	if (top_atom != source_atom)
		add_to_light_sources(top_atom)

	source_turf = top_atom
	pixel_turf = get_turf_pixel(top_atom) || source_turf

	light_power = source_atom.light_power
	light_inner_range = source_atom.light_inner_range
	light_outer_range = source_atom.light_outer_range
	light_falloff_curve = source_atom.light_falloff_curve
	light_color = source_atom.light_color

	PARSE_LIGHT_COLOR(src)

	update()

/datum/light_source/Destroy(force)
	remove_lum()
	if (source_atom)
		remove_from_light_sources(source_atom)

	if (top_atom)
		remove_from_light_sources(top_atom)

	if (needs_update)
		SSlighting.sources_queue -= src

	top_atom = null
	source_atom = null
	source_turf = null
	pixel_turf = null

	return ..()

///add this light source to new_atom_host's light_sources list. updating movement registrations as needed
/datum/light_source/proc/add_to_light_sources(atom/new_atom_host)
	if(QDELETED(new_atom_host))
		return FALSE

	LAZYADD(new_atom_host.light_sources, src)
	//yes, we register the signal to the top atom too, this is intentional and ensures contained lighting updates properly
	if(ismovable(new_atom_host))
		RegisterSignal(new_atom_host, COMSIG_MOVABLE_MOVED, PROC_REF(update_host_lights))
	RegisterSignal(new_atom_host, COMSIG_TURF_NO_LONGER_BLOCK_LIGHT, PROC_REF(force_update))
	return TRUE

///remove this light source from old_atom_host's light_sources list, unsetting movement registrations
/datum/light_source/proc/remove_from_light_sources(atom/old_atom_host)
	if(QDELETED(old_atom_host))
		return FALSE

	LAZYREMOVE(old_atom_host.light_sources, src)
	if(ismovable(old_atom_host))
		UnregisterSignal(old_atom_host, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(old_atom_host, COMSIG_TURF_NO_LONGER_BLOCK_LIGHT)
	return TRUE

// Yes this doesn't align correctly on anything other than 4 width tabs.
// If you want it to go switch everybody to elastic tab stops.
// Actually that'd be great if you could!
#define EFFECT_UPDATE(level)                \
	if (needs_update == LIGHTING_NO_UPDATE) \
		SSlighting.sources_queue += src; \
	if (needs_update < level)               \
		needs_update = level;    \


/// This proc will cause the light source to update the top atom, and add itself to the update queue.
/datum/light_source/proc/update(atom/new_top_atom)
	// This top atom is different.
	if (new_top_atom && new_top_atom != top_atom)
		if(top_atom != source_atom && top_atom.light_sources) // Remove ourselves from the light sources of that top atom.
			remove_from_light_sources(top_atom)

		top_atom = new_top_atom

		if (top_atom != source_atom)
			add_to_light_sources(top_atom)

	EFFECT_UPDATE(LIGHTING_CHECK_UPDATE)

// Will force an update without checking if it's actually needed.
/datum/light_source/proc/force_update()
	EFFECT_UPDATE(LIGHTING_FORCE_UPDATE)

// Will cause the light source to recalculate turfs that were removed or added to visibility only.
/datum/light_source/proc/vis_update()
	EFFECT_UPDATE(LIGHTING_VIS_UPDATE)

// This is the define used to calculate falloff.
// Assuming a brightness of 1 at range 1, formula should be (brightness = 1 / distance^2)
// However, due to the weird range factor, brightness = (-(distance - full_dark_start) / (full_dark_start - full_light_end)) ^ light_max_bright
//#define LUM_FALLOFF(C, T)(CLAMP01(-((((C.x - T.x) ** 2 +(C.y - T.y) ** 2) ** 0.5 - light_outer_range) / max(light_outer_range - light_inner_range, 1))) ** light_falloff_curve)

#define LUM_FALLOFF(C) (CLAMP01(-((((C.x - _turf_x) ** 2 +(C.y - _turf_y) ** 2) ** 0.5 - light_outer_range) / _range_divisor)) ** light_falloff_curve)

// This exists so we can cache the vars used in this macro, and save MASSIVE time :)
// Most of this is saving off datum var accesses, tho some of it does actually cache computation
// You will NEED to call this before you call APPLY_CORNER
#define SETUP_CORNERS_CACHE(lighting_source) \
	var/_turf_x = lighting_source.pixel_turf.x; \
	var/_turf_y = lighting_source.pixel_turf.y; \
	var/_range_divisor = max(1, lighting_source.light_outer_range - lighting_source.light_inner_range); \
	var/_light_power = lighting_source.light_power; \
	var/_applied_lum_r = lighting_source.applied_lum_r; \
	var/_applied_lum_g = lighting_source.applied_lum_g; \
	var/_applied_lum_b = lighting_source.applied_lum_b; \
	var/_lum_r = lighting_source.lum_r; \
	var/_lum_g = lighting_source.lum_g; \
	var/_lum_b = lighting_source.lum_b; \

#define SETUP_CORNERS_REMOVAL_CACHE(lighting_source) \
	var/_applied_lum_r = lighting_source.applied_lum_r; \
	var/_applied_lum_g = lighting_source.applied_lum_g; \
	var/_applied_lum_b = lighting_source.applied_lum_b;

#define APPLY_CORNER(C)                          \
	. = LUM_FALLOFF(C);              \
	. *= (_light_power ** 2);                \
	. *= _light_power < 0 ? -1:1;            \
	var/OLD = effect_str[C];                     \
	                                             \
	C.update_lumcount                            \
	(                                            \
		(. * _lum_r) - (OLD * _applied_lum_r),     \
		(. * _lum_g) - (OLD * _applied_lum_g),     \
		(. * _lum_b) - (OLD * _applied_lum_b)      \
	);                                           \

#define REMOVE_CORNER(C)                         \
	. = -effect_str[C];                          \
	C.update_lumcount                            \
	(                                            \
		. * _applied_lum_r,                       \
		. * _applied_lum_g,                       \
		. * _applied_lum_b                        \
	);

/// This is the define used to calculate falloff.
/datum/light_source/proc/remove_lum()
	SETUP_CORNERS_REMOVAL_CACHE(src)
	applied = FALSE
	for (var/datum/lighting_corner/corner as anything in effect_str)
		REMOVE_CORNER(corner)
		LAZYREMOVE(corner.affecting, src)

	effect_str = null

/datum/light_source/proc/recalc_corner(datum/lighting_corner/corner)
	SETUP_CORNERS_CACHE(src)
	LAZYINITLIST(effect_str)
	if (effect_str[corner]) // Already have one.
		REMOVE_CORNER(corner)
		effect_str[corner] = 0

	APPLY_CORNER(corner)
	effect_str[corner] = .

// Keep in mind. Lighting corners accept the bottom left (northwest) set of cords to them as input
#define GENERATE_MISSING_CORNERS(gen_for) \
	if (!gen_for.lighting_corner_NE) { \
		gen_for.lighting_corner_NE = new /datum/lighting_corner(gen_for.x, gen_for.y, gen_for.z); \
	} \
	if (!gen_for.lighting_corner_SE) { \
		gen_for.lighting_corner_SE = new /datum/lighting_corner(gen_for.x, gen_for.y - 1, gen_for.z); \
	} \
	if (!gen_for.lighting_corner_SW) { \
		gen_for.lighting_corner_SW = new /datum/lighting_corner(gen_for.x - 1, gen_for.y - 1, gen_for.z); \
	} \
	if (!gen_for.lighting_corner_NW) { \
		gen_for.lighting_corner_NW = new /datum/lighting_corner(gen_for.x - 1, gen_for.y, gen_for.z); \
	} \
	gen_for.lighting_corners_initialised = TRUE;

/datum/light_source/proc/update_corners()
	var/update = FALSE
	var/atom/source_atom = src.source_atom

	if (QDELETED(source_atom))
		qdel(src)
		return

	if (source_atom.light_power != light_power)
		light_power = source_atom.light_power
		update = TRUE

	if (source_atom.light_inner_range != light_inner_range)
		light_inner_range = source_atom.light_inner_range
		update = TRUE

	if (source_atom.light_outer_range != light_outer_range)
		light_outer_range = source_atom.light_outer_range
		update = TRUE

	if (!top_atom)
		top_atom = source_atom
		update = TRUE

	if (!light_outer_range || !light_power)
		qdel(src)
		return

	if (isturf(top_atom))
		if (source_turf != top_atom)
			source_turf = top_atom
			pixel_turf = source_turf
			update = TRUE
	else if (top_atom.loc != source_turf)
		source_turf = top_atom.loc
		pixel_turf = get_turf_pixel(top_atom)
		update = TRUE
	else
		var/pixel_loc = get_turf_pixel(top_atom)
		if (pixel_loc != pixel_turf)
			pixel_turf = pixel_loc
			update = TRUE

	if (!isturf(source_turf))
		if (applied)
			remove_lum()
		return

	if (source_atom.light_falloff_curve != light_falloff_curve)
		light_falloff_curve = source_atom.light_falloff_curve
		update = TRUE

	if (light_outer_range && light_power && !applied)
		update = TRUE

	if (source_atom.light_color != light_color)
		light_color = source_atom.light_color
		PARSE_LIGHT_COLOR(src)
		update = TRUE

	else if (applied_lum_r != lum_r || applied_lum_g != lum_g || applied_lum_b != lum_b)
		update = TRUE

	if (update)
		needs_update = LIGHTING_CHECK_UPDATE
		applied = TRUE
	else if (needs_update == LIGHTING_CHECK_UPDATE)
		return //nothing's changed

	var/list/datum/lighting_corner/corners = list()

	if (source_turf)
		var/oldlum = source_turf.luminosity
		source_turf.luminosity = CEILING(light_outer_range, 1)
		for(var/turf/T in view(CEILING(light_outer_range, 1), source_turf))
			if(IS_OPAQUE_TURF(T))
				continue
			if (!T.lighting_corners_initialised)
				GENERATE_MISSING_CORNERS(T)

			corners[T.lighting_corner_NE] = 0
			corners[T.lighting_corner_SE] = 0
			corners[T.lighting_corner_SW] = 0
			corners[T.lighting_corner_NW] = 0

		source_turf.luminosity = oldlum

	SETUP_CORNERS_CACHE(src)

	var/list/datum/lighting_corner/new_corners = (corners - src.effect_str)
	LAZYINITLIST(src.effect_str)
	var/list/effect_str = src.effect_str

	if (needs_update == LIGHTING_VIS_UPDATE)
		for (var/datum/lighting_corner/corner as anything in new_corners)
			APPLY_CORNER(corner)
			if (. != 0)
				LAZYADD(corner.affecting, src)
				effect_str[corner] = .
	else
		for (var/datum/lighting_corner/corner as anything in new_corners)
			APPLY_CORNER(corner)
			if (. != 0)
				LAZYADD(corner.affecting, src)
				effect_str[corner] = .

		// New corners are a subset of corners. so if they're both the same length, there are NO old corners!
		if(length(corners) != length(new_corners))
			for (var/datum/lighting_corner/corner as anything in corners - new_corners) // Existing corners
				APPLY_CORNER(corner)
				if (. != 0)
					effect_str[corner] = .
				else
					LAZYREMOVE(corner.affecting, src)
					effect_str -= corner

	var/list/datum/lighting_corner/gone_corners = effect_str - corners
	for (var/datum/lighting_corner/corner as anything in gone_corners)
		REMOVE_CORNER(corner)
		LAZYREMOVE(corner.affecting, src)
	effect_str -= gone_corners

	applied_lum_r = lum_r
	applied_lum_g = lum_g
	applied_lum_b = lum_b

	UNSETEMPTY(src.effect_str)

///signal handler for when our host atom moves and we need to update our effects
/datum/light_source/proc/update_host_lights(atom/movable/host)
	SIGNAL_HANDLER
	if(QDELETED(host))
		return

	// If the host is our owner, we want to call their update so they can decide who the top atom should be
	if(host == source_atom)
		host.update_light()
		return

	// Otherwise, our top atom just moved, so we trigger a normal rebuild
	EFFECT_UPDATE(LIGHTING_CHECK_UPDATE)

#undef EFFECT_UPDATE
#undef LUM_FALLOFF
#undef REMOVE_CORNER
#undef APPLY_CORNER
#undef SETUP_CORNERS_REMOVAL_CACHE
#undef SETUP_CORNERS_CACHE
#undef GENERATE_MISSING_CORNERS
