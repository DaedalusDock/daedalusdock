// Defines for C4 Embedded Controllers

#define RTOS_OUTPUT_ROWS 3
#define RTOS_OUTPUT_COLS 20

#define RTOS_CONFIG_ID_TAG_GENERIC "id_tag" //! Generic ID Tag. Usually used for single-target controllers.

#define RTOS_ACCESS_CALC_MODE_ALL 1
#define RTOS_ACCESS_CALC_MODE_ANY 2

// Generic halt codes

#define RTOS_HALT_GENERIC_MISSING_DATA 1000
	#define RTOS_HALT_NO_CONFIG 1001
#define RTOS_HALT_GENERIC_HARDWARE_FAULT 2000
	#define RTOS_HALT_MISSING_NETWORK_CARD 2001
