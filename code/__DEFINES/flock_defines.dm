#define FLOCK_TYPE_OVERMIND "overmind"
#define FLOCK_TYPE_TRACE "trace"
#define FLOCK_TYPE_DRONE "drone"
#define FLOCK_TYPE_BIT "bit"

// Turf reserved by a flockdrone
#define FLOCK_NOTICE_RESERVED "reserved"
// Turf marked for conversion
#define FLOCK_NOTICE_PRIORITY "priority"
// Mob marked as enemy
#define FLOCK_NOTICE_ENEMY "enemy"
// Mob marked as ignored
#define FLOCK_NOTICE_IGNORE "ignore"
// Flockdrone under flocktrace control
#define FLOCK_NOTICE_FLOCKTRACE_CONTROL "flocktrace_control"
// Flockdrone under overmind control
#define FLOCK_NOTICE_FLOCKMIND_CONTROL "flockmind_control"
// Flockdrone health bars
#define FLOCK_NOTICE_HEALTH "flock_health"
// Atom marked for deconstruction
#define FLOCK_NOTICE_DECONSTRUCT "flock_deconstruct"

#define FLOCK_UI_DRONES "drones"
#define FLOCK_UI_TRACES "traces"
#define FLOCK_UI_ENEMIES "enemies"
#define FLOCK_UI_STRUCTURES "structures"

#define FLOCK_COMPUTE_COST_FLOCKTRACE 100
#define FLOCK_COMPUTE_COST_DRONE 10
#define FLOCK_COMPUTE_COST_RELAY 500

/// Amount of substrate to add to a tealprint.
#define FLOCK_SUBSTRATE_COST_DEPOST_TEALPRINT 10
/// Amount to convert a turf and it's contents.
#define FLOCK_SUBSTRATE_COST_CONVERT 20
/// Amount to repair a flock construct.
#define FLOCK_SUBSTRATE_COST_REPAIR 10

#define FLOCK_DRONE_LIMIT 50

#define FLOCK_ENDGAME_LOST 1
#define FLOCK_ENDGAME_RELAY_BUILDING 2
#define FLOCK_ENDGAME_RELAY_ACTIVATING 3
#define FLOCK_ENDGAME_VICTORY 4

// G.O.A.P weights for flock behaviors, for easy comparison/adjustment.
#define FLOCK_BEHAVIOR_WEIGHT_WANDER 1
#define FLOCK_BEHAVIOR_WEIGHT_STARE 1
#define FLOCK_BEHAVIOR_WEIGHT_CONVERT 1
#define FLOCK_BEHAVIOR_WEIGHT_REPAIR 4
#define FLOCK_BEHAVIOR_WEIGHT_DECONSTRUCT 8
