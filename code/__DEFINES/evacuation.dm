// IMO some of these should be renamed to be less ambiguous
#define EVACUATION_IDLE 0
#define EVACUATION_INITIATED 1 // Evacuation has begun, but it can be cancelled
#define EVACUATION_AWAITING 2 // Awaiting players to board the shuttle/pods/etc, can't be cancelled but can be delayed
#define EVACUATION_NO_RETURN 3 // Shuttle/pods/etc have departed, can't be cancelled nor delayed
#define EVACUATION_FINISHED 4
