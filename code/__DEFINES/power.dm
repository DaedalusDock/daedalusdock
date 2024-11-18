#define SOLAR_TRACK_OFF     0
#define SOLAR_TRACK_TIMED   1
#define SOLAR_TRACK_AUTO    2

///conversion ratio from joules to watts
#define WATTS / 0.002
///conversion ratio from watts to joules
#define JOULES * 0.002

GLOBAL_VAR_INIT(CHARGELEVEL, 0.001) // Cap for how fast cells charge, as a percentage-per-tick (.001 means cellcharge is capped to 1% per second)

GLOBAL_LIST_EMPTY(powernets)

// These are used by supermatter and supermatter monitor program, mostly for UI updating purposes. Higher should always be worse!
#define SUPERMATTER_ERROR -1		// Unknown status, shouldn't happen but just in case.
#define SUPERMATTER_INACTIVE 0		// No or minimal energy
#define SUPERMATTER_NORMAL 1		// Normal operation
#define SUPERMATTER_WARNING 2		// Ambient temp > CRITICAL_TEMPERATURE OR integrity damaged
#define SUPERMATTER_DANGER 3		// Integrity < 50%
#define SUPERMATTER_EMERGENCY 4		// Integrity < 25%
#define SUPERMATTER_DELAMINATING 5	// Pretty obvious.

#define SUPERMATTER_DATA_EER         "Relative EER"
#define SUPERMATTER_DATA_TEMPERATURE "Temperature"
#define SUPERMATTER_DATA_PRESSURE    "Pressure"
#define SUPERMATTER_DATA_EPR         "Chamber EPR"

/// How much the bullets damage should be multiplied by when it is added to the internal variables
#define SUPERMATTER_BULLET_ENERGY 10 //This is 5x greater than Baystation's to account for emitters doing about 5x less damage

#define ARC_DAMAGE_TO_POWER(desired_damage) (desired_damage * 25000)
