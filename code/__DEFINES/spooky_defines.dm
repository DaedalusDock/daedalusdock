#define SPOOK_LEVEL_OBJECT_ROTATION 10

#define RECORD_GHOST_POWER(power) \
	do {\
		var/area/A = get_area(power.owner); \
		SSblackbox.record_feedback("nested tally", "ghost_power_used", 1, list(A?.name || "NULL", power.name)); \
	} while (FALSE)
