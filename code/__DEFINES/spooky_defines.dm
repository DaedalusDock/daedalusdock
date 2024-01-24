#define SPOOK_LEVEL_WEAK_POWERS 10
#define SPOOK_LEVEL_MEDIUM_POWERS 30
#define SPOOK_LEVEL_DESTRUCTIVE_POWERS 50

#define SPOOK_LEVEL_OBJECT_ROTATION SPOOK_LEVEL_WEAK_POWERS

#define RECORD_GHOST_POWER(power) \
	do {\
		var/area/A = get_area(power.owner); \
		SSblackbox.record_feedback("nested tally", "ghost_power_used", 1, list(A?.name || "NULL", power.name)); \
	} while (FALSE)
