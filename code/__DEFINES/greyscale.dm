/* flags for greyscale config for smoothing */
/// The config will create states for cardinal smoothing
#define GAGS_CARDINAL_SMOOTH (1<<0)
/// The config will create states for diagonal smoothing
#define GAGS_DIAGONAL_SMOOTH (1<<1)
/// This will make it so diagonal steps require both adjacent cardinal steps to make a state
#define GAGS_DIAGONAL_NEED_ADJACENT_CARDINAL (1<<2)
/// The common way to bitmask features all of the modes above
#define GAGS_COMMON_BITMASKING (GAGS_CARDINAL_SMOOTH|GAGS_DIAGONAL_SMOOTH|GAGS_DIAGONAL_NEED_ADJACENT_CARDINAL)
