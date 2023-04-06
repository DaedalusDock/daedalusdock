#define TURF_IS_MIMICKING(T) (isturf(T) && (T:z_flags & Z_MIMIC_BELOW))

#define CHECK_OO_EXISTENCE(OO) if (OO && !MOVABLE_IS_ON_ZTURF(OO) && !OO:destruction_timer) { OO:destruction_timer = QDEL_IN(OO, 10 SECONDS); }
#define UPDATE_OO_IF_PRESENT CHECK_OO_EXISTENCE(src:bound_overlay); if (src:bound_overlay) { update_above(); }

// I do not apologize.

// These aren't intended to be used anywhere else, they just can't be undef'd because DM is dum.
#define ZM_INTERNAL_SCAN_LOOKAHEAD(M,VTR,F) ((get_step(M, M:dir)?:VTR & F) || (get_step(M, turn(M:dir, 180))?:VTR & F))
#define ZM_INTERNAL_SCAN_LOOKBESIDE(M,VTR,F) ((get_step(M, turn(M:dir, 90))?:VTR & F) || (get_step(M, turn(M:dir, -90))?:VTR & F))

/// Is this movable visible from a turf that is mimicking below? Note: this does not necessarily mean *directly* below.
#define MOVABLE_IS_BELOW_ZTURF(M) (\
	isturf(loc) && (TURF_IS_MIMICKING(loc:above) \
	|| ((M:zmm_flags & ZMM_LOOKAHEAD) && ZM_INTERNAL_SCAN_LOOKAHEAD(M, above?:z_flags, Z_MIMIC_BELOW))  \
	|| ((M:zmm_flags & ZMM_LOOKBESIDE) && ZM_INTERNAL_SCAN_LOOKBESIDE(M, above?:z_flags, Z_MIMIC_BELOW))) \
)
/// Is this movable located on a turf that is mimicking below? Note: this does not necessarily mean *directly* on.
#define MOVABLE_IS_ON_ZTURF(M) (\
	isturf(loc) && (TURF_IS_MIMICKING(loc:above) \
	|| ((M:zmm_flags & ZMM_LOOKAHEAD) && ZM_INTERNAL_SCAN_LOOKAHEAD(M, z_flags, Z_MIMIC_BELOW)) \
	|| ((M:zmm_flags & ZMM_LOOKBESIDE) && ZM_INTERNAL_SCAN_LOOKBESIDE(M, z_flags, Z_MIMIC_BELOW))) \
)

#define FOR_MIMIC_OF(ORIGIN,MVAR) MVAR = ORIGIN; while ((MVAR = MVAR:bound_overlay) && !MVAR:destruction_timer)
