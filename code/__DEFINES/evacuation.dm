// States for the evacuation controller
#define EVACUATION_IDLE 0
#define EVACUATION_INITIATED 1 // Evacuation has begun, but it can be cancelled
#define EVACUATION_AWAITING 2 // Awaiting players to board the shuttle/pods/etc, can't be cancelled but can be delayed
#define EVACUATION_NO_RETURN 3 // Shuttle/pods/etc have departed, can't be cancelled nor delayed
#define EVACUATION_FINISHED 4

// Uniqu ID for the evacuation controllers
#define EVACUATION_CONTROLLER_DEFAULT "evac_controller"

// Reasons for automatic evacuation
#define EVACUATION_REASON_CREW_DEATH "crew_death"
#define EVACUATION_REASON_LONG_ROUND "long_round"
