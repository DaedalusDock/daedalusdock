// These must always come in groups of 3.
// do NOT assign the same mutant color to multiple organs if they have seperate preferences, it WILL break
// I KNOW YOU
#define MUTCOLORS_KEY_GENERIC "generic"
	#define MUTCOLORS_GENERIC_1 "generic_1"
	#define MUTCOLORS_GENERIC_2 "generic_2"
	#define MUTCOLORS_GENERIC_3 "generic_3"

#define MUTCOLORS_KEY_TESHARI_TAIL "teshari_tail"
	#define MUTCOLORS_TESHARI_TAIL_1 "teshari_tail_1"
	#define MUTCOLORS_TESHARI_TAIL_2 "teshari_tail_2"
	#define MUTCOLORS_TESHARI_TAIL_3 "teshari_tail_3"

#define MUTCOLORS_KEY_TESHARI_BODY_FEATHERS "teshari_bodyfeathers"
	#define MUTCOLORS_TESHARI_BODY_FEATHERS_1 "teshari_bodyfeathers_1"
	#define MUTCOLORS_TESHARI_BODY_FEATHERS_2 "teshari_bodyfeathers_2"
	#define MUTCOLORS_TESHARI_BODY_FEATHERS_3 "teshari_bodyfeathers_3"

#define MUTCOLORS_KEY_IPC_ANTENNA "ipc_antenna"
	#define MUTCOLORS_KEY_IPC_ANTENNA_1 "ipc_antenna_1"
	#define MUTCOLORS_KEY_IPC_ANTENNA_2 "ipc_antenna_2"
	#define MUTCOLORS_KEY_IPC_ANTENNA_3 "ipc_antenna_3"

#define MUTCOLORS_KEY_SAURIAN_SCREEN "saurian_screen"
	#define MUTCOLORS_KEY_SAURIAN_SCREEN_1 "saurian_screen_1"
	#define MUTCOLORS_KEY_SAURIAN_SCREEN_2 "saurian_screen_2"
	#define MUTCOLORS_KEY_SAURIAN_SCREEN_3 "saurian_screen_3"

#define MUTCOLORS_KEY_SAURIAN_ANTENNA "saurian_antenna"
	#define MUTCOLORS_KEY_SAURIAN_ANTENNA_1 "saurian_antenna_1"
	#define MUTCOLORS_KEY_SAURIAN_ANTENNA_2 "saurian_antenna_2"
	#define MUTCOLORS_KEY_SAURIAN_ANTENNA_3 "saurian_antenna_3"

///ADD NEW ONES TO THIS OR SHIT DOESNT WORK
GLOBAL_LIST_INIT(all_mutant_colors_keys, list(
	MUTCOLORS_KEY_GENERIC,
	MUTCOLORS_KEY_TESHARI_TAIL,
	MUTCOLORS_KEY_TESHARI_BODY_FEATHERS,
	MUTCOLORS_KEY_IPC_ANTENNA,
	MUTCOLORS_KEY_SAURIAN_SCREEN,
	MUTCOLORS_KEY_SAURIAN_ANTENNA,
))
