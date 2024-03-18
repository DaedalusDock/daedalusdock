#define ACTIVE_MOVEMENT_OLDLOC 1
#define ACTIVE_MOVEMENT_DIRECTION 2
#define ACTIVE_MOVEMENT_FORCED 3
#define ACTIVE_MOVEMENT_OLDLOCS 4

#define SET_ACTIVE_MOVEMENT(_old_loc, _direction, _forced, _oldlocs) \
	active_movement = list( \
		ACTIVE_MOVEMENT_OLDLOC = _old_loc, \
		ACTIVE_MOVEMENT_DIRECTION = _direction, \
		ACTIVE_MOVEMENT_FORCED = _forced, \
		ACTIVE_MOVEMENT_OLDLOCS = _oldlocs, \
	)

#define RESOLVE_ACTIVE_MOVEMENT \
	if(active_movement) { \
		Moved(arglist(active_movement)); \
		active_movement = null; \
	}
