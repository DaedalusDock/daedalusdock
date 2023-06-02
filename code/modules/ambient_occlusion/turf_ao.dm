#define AO_TURF_CHECK(T) ((!T.opacity && !(locate(/obj/structure/low_wall) in T)) || !T.permit_ao)
#define AO_SELF_CHECK(T) (!T.opacity || !(locate(/obj/structure/low_wall) in T))

//Redefinitions of the diagonal directions so they can be stored in one var without conflicts
#define N_NORTH     2
#define N_SOUTH     4
#define N_EAST      16
#define N_WEST      256
#define N_NORTHEAST 32
#define N_NORTHWEST 512
#define N_SOUTHEAST 64
#define N_SOUTHWEST 1024
/*
Define for getting a bitfield of adjacent turfs that meet a condition.
ORIGIN is the object to step from, VAR is the var to write the bitfield to
TVAR is the temporary turf variable to use, FUNC is the condition to check.
FUNC generally should reference TVAR.
example:
	var/turf/T
	var/result = 0
	CALCULATE_NEIGHBORS(src, result, T, isopenturf(T))
*/
#define CALCULATE_NEIGHBORS(ORIGIN, VAR, TVAR, FUNC) \
	for (var/_tdir in GLOB.cardinals) {              \
		TVAR = get_step(ORIGIN, _tdir);              \
		if ((TVAR) && (FUNC)) {                      \
			VAR |= 1 << _tdir;                       \
		}                                            \
	}                                                \
	if (VAR & N_NORTH) {                             \
		if (VAR & N_WEST) {                          \
			TVAR = get_step(ORIGIN, NORTHWEST);      \
			if (FUNC) {                              \
				VAR |= N_NORTHWEST;                  \
			}                                        \
		}                                            \
		if (VAR & N_EAST) {                          \
			TVAR = get_step(ORIGIN, NORTHEAST);      \
			if (FUNC) {                              \
				VAR |= N_NORTHEAST;                  \
			}                                        \
		}                                            \
	}                                                \
	if (VAR & N_SOUTH) {                             \
		if (VAR & N_WEST) {                          \
			TVAR = get_step(ORIGIN, SOUTHWEST);      \
			if (FUNC) {                              \
				VAR |= N_SOUTHWEST;                  \
			}                                        \
		}                                            \
		if (VAR & N_EAST) {                          \
			TVAR = get_step(ORIGIN, SOUTHEAST);      \
			if (FUNC) {                              \
				VAR |= N_SOUTHEAST;                  \
			}                                        \
		}                                            \
	}

/turf
	///Turf can contain ao overlays (only false for space, walls are opaque so they dont get them anyway)
	var/permit_ao = TRUE
	/// Current ambient occlusion overlays. Tracked so we can handle them through SSoverlays.
	var/tmp/list/ao_overlays
	var/tmp/ao_neighbors
	var/tmp/list/ao_overlays_mimic
	var/tmp/ao_neighbors_mimic
	var/ao_queued = AO_UPDATE_NONE

/turf/proc/regenerate_ao()
	for (var/turf/T as anything in RANGE_TURFS(1, src))
		if (T.permit_ao)
			T.queue_ao(TRUE)

/turf/proc/calculate_ao_neighbors()
	ao_neighbors = 0
	ao_neighbors_mimic = 0
	if (!permit_ao)
		return

	var/turf/T
	if (z_flags & Z_MIMIC_BELOW)
		CALCULATE_NEIGHBORS(src, ao_neighbors_mimic, T, (T?.z_flags & Z_MIMIC_BELOW))
	if (AO_SELF_CHECK(src) && !(z_flags & Z_MIMIC_NO_AO))
		CALCULATE_NEIGHBORS(src, ao_neighbors, T, AO_TURF_CHECK(T))
		// We don't want shadows on the top of turfs, so pretend that there's always non-opaque neighbors there
		ao_neighbors |= (N_SOUTH | N_SOUTHEAST | N_SOUTHWEST)

/proc/make_ao_image(corner, i, px = 0, py = 0, pz = 0, pw = 0, alpha)
	var/list/cache = SSao.cache
	var/cstr = "[corner]"
	// PROCESS_AO_CORNER below also uses this cache, check it before changing this key.
	var/key = "[cstr]|[i]|[px]/[py]/[pz]/[pw]|[alpha]"

	var/image/I = image('icons/turf/shadows.dmi', cstr, dir = 1 << (i-1))
	I.alpha = alpha
	I.blend_mode = BLEND_OVERLAY
	I.appearance_flags = RESET_ALPHA|RESET_COLOR|TILE_BOUND
	I.layer = AO_LAYER

	// If there's an offset, counteract it.
	if (px || py || pz || pw)
		I.pixel_x = -px
		I.pixel_y = -py
		I.pixel_z = -pz
		I.pixel_w = -pw

	. = cache[key] = I

/turf/proc/queue_ao(rebuild = TRUE)
	if (!ao_queued)
		SSao.queue += src

	var/new_level = rebuild ? AO_UPDATE_REBUILD : AO_UPDATE_OVERLAY
	if (ao_queued < new_level)
		ao_queued = new_level

#define PROCESS_AO_CORNER(AO_LIST, NEIGHBORS, CORNER_INDEX, CDIR, ALPHA, TARGET) \
	corner = 0; \
	if (NEIGHBORS & (1 << CDIR)) { \
		corner |= 2; \
	} \
	if (NEIGHBORS & (1 << turn(CDIR, 45))) { \
		corner |= 1; \
	} \
	if (NEIGHBORS & (1 << turn(CDIR, -45))) { \
		corner |= 4; \
	} \
	if (corner != 7) {	/* 7 is the 'no shadows' state, no reason to add overlays for it. */ \
		var/image/I = cache["[corner]|[CORNER_INDEX]|[pixel_x]/[pixel_y]/[pixel_z]/[pixel_w]|[ALPHA]"]; \
		if (!I) { \
			I = make_ao_image(corner, CORNER_INDEX, TARGET.pixel_x, TARGET.pixel_y, TARGET.pixel_z, TARGET.pixel_w, ALPHA)	/* this will also add the image to the cache. */ \
		} \
		LAZYADD(AO_LIST, I); \
	}

#define CUT_AO(TARGET, AO_LIST) \
	if (AO_LIST) { \
		TARGET.cut_overlay(AO_LIST); \
		AO_LIST.Cut(); \
	}

#define REGEN_AO(TARGET, AO_LIST, NEIGHBORS, ALPHA) \
	if (permit_ao && NEIGHBORS != AO_ALL_NEIGHBORS) { \
		var/corner;\
		PROCESS_AO_CORNER(AO_LIST, NEIGHBORS, 1, NORTHWEST, ALPHA, TARGET); \
		PROCESS_AO_CORNER(AO_LIST, NEIGHBORS, 2, SOUTHEAST, ALPHA, TARGET); \
		PROCESS_AO_CORNER(AO_LIST, NEIGHBORS, 3, NORTHEAST, ALPHA, TARGET); \
		PROCESS_AO_CORNER(AO_LIST, NEIGHBORS, 4, SOUTHWEST, ALPHA, TARGET); \
	} \
	UNSETEMPTY(AO_LIST); \
	if (AO_LIST) { \
		TARGET.update_appearance(UPDATE_ICON); \
	}

/turf/proc/update_ao()
	var/list/cache = SSao.cache
	CUT_AO(shadower, ao_overlays_mimic)
	CUT_AO(src, ao_overlays)
	if (shadower && (z_flags & Z_MIMIC_BELOW))
		REGEN_AO(shadower, ao_overlays_mimic, ao_neighbors_mimic, Z_AO_ALPHA)
		shadower.update_above()
	if (AO_TURF_CHECK(src) && !(z_flags & Z_MIMIC_NO_AO))
		REGEN_AO(src, ao_overlays, ao_neighbors, WALL_AO_ALPHA)
		update_above()

/turf/update_overlays()
	. = ..()
	if(permit_ao && ao_overlays)
		. += ao_overlays

/atom/movable/openspace/multiplier/update_overlays()
	. = ..()
	var/turf/Tloc = loc
	ASSERT(isturf(Tloc))
	if (Tloc.ao_overlays_mimic)
		.+= Tloc.ao_overlays_mimic

#undef REGEN_AO
#undef PROCESS_AO_CORNER
#undef AO_TURF_CHECK
#undef AO_SELF_CHECK
#undef CALCULATE_NEIGHBORS

#undef N_NORTH
#undef N_SOUTH
#undef N_EAST
#undef N_WEST
#undef N_NORTHEAST
#undef N_NORTHWEST
#undef N_SOUTHEAST
#undef N_SOUTHWEST

/turf/open/space
	permit_ao = FALSE
