#define CABLE_LAYER_1 1
#define CABLE_LAYER_2 2
#define CABLE_LAYER_3 4

#define MACHINERY_LAYER_1 1

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
