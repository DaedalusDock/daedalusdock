// Turf signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

/// from base of turf/ChangeTurf(): (path, list/new_baseturfs, flags, list/post_change_callbacks).
/// `post_change_callbacks` is a list that signal handlers can mutate to append `/datum/callback` objects.
/// They will be called with the new turf after the turf has changed.
#define COMSIG_TURF_CHANGE "turf_change"
///from base of atom/has_gravity(): (atom/asker, list/forced_gravities)
#define COMSIG_TURF_HAS_GRAVITY "turf_has_gravity"
///from base of turf/proc/onShuttleMove(): (turf/new_turf)
#define COMSIG_TURF_ON_SHUTTLE_MOVE "turf_on_shuttle_move"
///from /turf/proc/immediate_calculate_adjacent_turfs()
#define COMSIG_TURF_CALCULATED_ADJACENT_ATMOS "turf_calculated_adjacent_atmos"
///called when an industrial lift enters this turf
#define COMSIG_TURF_INDUSTRIAL_LIFT_ENTER "turf_industrial_life_enter"

///from /datum/element/decal/Detach(): (description, cleanable, directional, mutable_appearance/pic)
#define COMSIG_TURF_DECAL_DETACHED "turf_decal_detached"

#define COMSIG_TURF_EXPOSE "turf_expose"
