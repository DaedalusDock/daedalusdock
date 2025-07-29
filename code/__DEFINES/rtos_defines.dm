// Defines for C4 Embedded Controllers

#define RTOS_OUTPUT_ROWS 3
#define RTOS_OUTPUT_COLS 20

#define RTOS_CONFIG_FILE "config"
#define RTOS_ACCESS_FILE "access"

#define RTOS_CONFIG_ID_TAG_GENERIC "id_tag" //! Generic ID Tag. Usually used for single-target controllers.

#define RTOS_CONFIG_PINCODE "pincode" //! Yes, this IS frightfully insecure.

#define RTOS_CONFIG_AIRLOCK_ID "airlock_id"
#define RTOS_CONFIG_REQUEST_EXIT_ID "rexit_id"
#define RTOS_CONFIG_ALLOW_HOLD_OPEN "allow_doorstop"
#define RTOS_CONFIG_HOLD_OPEN_TIME "doorstop_time"
#define RTOS_CONFIG_SLAVE_ID "tag_slave" //! Slaved pinpad ID. Mirrors the UI/stdin to a secona pad. Can be null.

#define RTOS_CONFIG_CMODE "control_mode"
	#define RTOS_CMODE_SECURE "secure"
	#define RTOS_CMODE_BOLTS "bolt"


#define RTOS_ACCESS_LIST "access"
#define RTOS_ACCESS_MODE "acc_mode"
	#define RTOS_ACCESS_CALC_MODE_ALL 1
	#define RTOS_ACCESS_CALC_MODE_ANY 2

#define RTOS_RED (1 << 0)
#define RTOS_YELLOW (1 << 1)
#define RTOS_GREEN (1 << 2)

// Generic halt codes

#define RTOS_HALT_GENERIC_BAD_DATA 1000
	#define RTOS_HALT_NO_CONFIG 1001
	#define RTOS_HALT_NO_ACCESS 1002
	#define RTOS_HALT_BAD_CONFIG 1003
	#define RTOS_HALT_DATA_TOO_LONG 1901
#define RTOS_HALT_GENERIC_HARDWARE_FAULT 2000
	#define RTOS_HALT_MISSING_NETWORK_CARD 2001
	#define RTOS_HALT_MISSING_CARD_READER 2002
	#define RTOS_HALT_WRONG_COMPUTER_TYPE 2999
#define RTOS_HALT_GENERIC_SOFTWARE_EXCEPTION 3000
	#define RTOS_HALT_STATE_VIOLATION 3001
