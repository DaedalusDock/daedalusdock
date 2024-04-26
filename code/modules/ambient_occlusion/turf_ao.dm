#define AO_TURF_CHECK(T) ((!T.opacity && !(locate(/obj/structure/low_wall) in T)) || !T.permit_ao)
#define AO_SELF_CHECK(T) (!T.opacity || !(locate(/obj/structure/low_wall) in T))

/**
 * Define for getting a bitfield of adjacent turfs that meet a condition.
 *
 * Arguments:
 * - ORIGIN - The atom to step from,
 * - VAR    - The var to write the bitfield to.
 * - TVAR   - The temporary turf variable to use.
 * - FUNC   - An additional function used to validate the turf found in each direction. Generally should reference TVAR.
 *
 * Example:
 * -  var/our_junction = 0
 * -  var/turf/T
 * -  CALCULATE_JUNCTIONS(src, our_junction, T, isopenturf(T))
 * -  // isopenturf(T) NEEDS to be in the macro call since its nested into for loops.
 *
 * NOTICE:
 * - This macro used to be CALCULATE_NEIGHBORS.
 * - It has been renamed to avoid conflicts and confusions with other codebases.
 */
#define CALCULATE_JUNCTIONS(ORIGIN, VAR, TVAR, FUNC) \
	for (var/_tdir in GLOB.cardinals) {               \
		TVAR = get_step(ORIGIN, _tdir);              \
		if ((TVAR) && (FUNC)) {                      \
			VAR |= _tdir;                            \
		}                                            \
	}                                                \
	if (VAR & NORTH_JUNCTION) {                      \
		if (VAR & WEST_JUNCTION) {                   \
			TVAR = get_step(ORIGIN, NORTHWEST);      \
			if (FUNC) {                              \
				VAR |= NORTHWEST_JUNCTION;           \
			}                                        \
		}                                            \
		if (VAR & EAST_JUNCTION) {                   \
			TVAR = get_step(ORIGIN, NORTHEAST);      \
			if (FUNC) {                              \
				VAR |= NORTHEAST_JUNCTION;           \
			}                                        \
		}                                            \
	}                                                \
	if (VAR & SOUTH_JUNCTION) {                      \
		if (VAR & WEST_JUNCTION) {                   \
			TVAR = get_step(ORIGIN, SOUTHWEST);      \
			if (FUNC) {                              \
				VAR |= SOUTHWEST_JUNCTION;           \
			}                                        \
		}                                            \
		if (VAR & EAST_JUNCTION) {                   \
			TVAR = get_step(ORIGIN, SOUTHEAST);      \
			if (FUNC) {                              \
				VAR |= SOUTHEAST_JUNCTION;           \
			}                                        \
		}                                            \
	}

#define PROCESS_AO(TARGET, AO_VAR, NEIGHBORS, ALPHA, SHADOWER) \
	if (permit_ao && NEIGHBORS != AO_ALL_NEIGHBORS) { \
		var/image/I = cache["ao-[NEIGHBORS]|[pixel_x]/[pixel_y]/[pixel_z]/[pixel_w]|[ALPHA]|[SHADOWER]"]; \
		if (!I) { \
			/* This will also add the image to the cache. */ \
			I = make_ao_image(NEIGHBORS, TARGET.pixel_x, TARGET.pixel_y, TARGET.pixel_z, TARGET.pixel_w, ALPHA, SHADOWER); \
		} \
		AO_VAR = I; \
		TARGET.add_overlay(AO_VAR); \
	}

#define CUT_AO(TARGET, AO_VAR) \
	if (AO_VAR) { \
		TARGET.cut_overlay(AO_VAR); \
		AO_VAR = null; \
	}

/proc/make_ao_image(corner, px = 0, py = 0, pz = 0, pw = 0, alpha, shadower)
	var/list/cache = SSao.image_cache
	var/cstr = "ao-[corner]"
	// PROCESS_AO above also uses this cache, check it before changing this key.
	var/key = "[cstr]|[px]/[py]/[pz]/[pw]|[alpha]|[shadower]"

	var/image/I = image(shadower ? 'icons/turf/uncut_shadows.dmi' : 'icons/turf/shadows.dmi', cstr)
	I.alpha = alpha
	I.blend_mode = BLEND_OVERLAY
	I.appearance_flags = RESET_ALPHA | RESET_COLOR | TILE_BOUND
	I.layer = AO_LAYER
	// If there's an offset, counteract it.
	if (px || py || pz || pw)
		I.pixel_x = -px
		I.pixel_y = -py
		I.pixel_z = -pz
		I.pixel_w = -pw

	. = cache[key] = I

/turf
	/**
	 * Whether this turf is allowed to have ambient occlusion.
	 * If FALSE, this turf will not be considered for ambient occlusion.
	 */
	var/permit_ao = TRUE

	/**
	 * Current ambient occlusion overlays.
	 * Tracked here so that they can be reapplied during update_overlays()
	 */
	var/tmp/image/ao_overlay

	/**
	 * What directions this is currently smoothing with.
	 * This starts as null for us to know when it's first set, but after that it will hold a 8-bit mask ranging from 0 to 255.
	 *
	 * IMPORTANT: This uses the smoothing direction flags as defined in icon_smoothing.dm, instead of the BYOND flags.
	 */
	var/tmp/ao_junction

	/// The same as ao_overlay, but for the mimic turf.
	var/tmp/image/ao_overlay_mimic

	/// The same as ao_junction, but for the mimic turf.
	var/tmp/ao_junction_mimic

	/// Whether this turf is currently queued for ambient occlusion.
	var/tmp/ao_queued = AO_UPDATE_NONE

/turf/proc/calculate_ao_junction()
	ao_junction = NONE
	ao_junction_mimic = NONE
	if (!permit_ao)
		return

	var/turf/T
	if (z_flags & Z_MIMIC_BELOW)
		CALCULATE_JUNCTIONS(src, ao_junction_mimic, T, (T.z_flags & Z_MIMIC_BELOW))
	if (AO_SELF_CHECK(src) && !(z_flags & Z_MIMIC_NO_AO))
		CALCULATE_JUNCTIONS(src, ao_junction, T, AO_TURF_CHECK(T))

/turf/proc/regenerate_ao()
	for (var/thing in RANGE_TURFS(1, src))
		var/turf/T = thing
		if (T?.permit_ao)
			T.queue_ao(TRUE)

/turf/proc/queue_ao(rebuild = TRUE)
	if (!ao_queued)
		SSao.queue += src

	var/new_level = rebuild ? AO_UPDATE_REBUILD : AO_UPDATE_OVERLAY
	if (ao_queued < new_level)
		ao_queued = new_level

/turf/proc/update_ao()
	var/list/cache = SSao.image_cache
	CUT_AO(shadower, ao_overlay_mimic)
	CUT_AO(src, ao_overlay)
	if (z_flags & Z_MIMIC_BELOW)
		PROCESS_AO(shadower, ao_overlay_mimic, ao_junction_mimic, Z_AO_ALPHA, TRUE)
	if (AO_TURF_CHECK(src) && !(z_flags & Z_MIMIC_NO_AO))
		PROCESS_AO(src, ao_overlay, ao_junction, WALL_AO_ALPHA, FALSE)

/turf/update_overlays()
	. = ..()
	if(permit_ao && ao_overlay)
		. += ao_overlay

/atom/movable/openspace/multiplier/update_overlays()
	. = ..()
	var/turf/Tloc = loc
	ASSERT(isturf(Tloc))
	if (Tloc.ao_overlay_mimic)
		.+= Tloc.ao_overlay_mimic

#undef PROCESS_AO
#undef CUT_AO
#undef CALCULATE_JUNCTIONS
#undef AO_TURF_CHECK
#undef AO_SELF_CHECK

/turf/open/space
	permit_ao = FALSE
