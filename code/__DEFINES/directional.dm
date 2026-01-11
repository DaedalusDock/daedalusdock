// Byond direction defines, because I want to put them somewhere.
// #define NORTH 1
// #define SOUTH 2
// #define EAST 4
// #define WEST 8

/// North direction as a string "[1]"
#define TEXT_NORTH "[NORTH]"
/// South direction as a string "[2]"
#define TEXT_SOUTH "[SOUTH]"
/// East direction as a string "[4]"
#define TEXT_EAST "[EAST]"
/// West direction as a string "[8]"
#define TEXT_WEST "[WEST]"

/// Inverse direction, taking into account UP|DOWN if necessary.
#define REVERSE_DIR(dir) ( ((dir & 85) << 1) | ((dir & 170) >> 1) )

/// Create directional subtypes for a path to simplify mapping.
#define MAPPING_DIRECTIONAL_HELPERS(path, offset) ##path/directional/north {\
	dir = NORTH; \
	pixel_y = offset; \
} \
##path/directional/south {\
	dir = SOUTH; \
	pixel_y = -offset; \
} \
##path/directional/east {\
	dir = EAST; \
	pixel_x = offset; \
} \
##path/directional/west {\
	dir = WEST; \
	pixel_x = -offset; \
}

/// When you need to prescribe very specific offsets, use this over MAPPING_DIRECTIONAL_HELPERS
#define MAPPING_DIRECTIONAL_HELPERS_ROBUST(path, n_offset, s_offset, e_offset, w_offset) ##path/directional/north {\
	dir = NORTH; \
	pixel_y = n_offset; \
} \
##path/directional/south {\
	dir = SOUTH; \
	pixel_y = s_offset; \
} \
##path/directional/east {\
	dir = EAST; \
	pixel_x = e_offset; \
} \
##path/directional/west {\
	dir = WEST; \
	pixel_x = w_offset; \
}

/// Like the above, but the atom's DIR value will be the opposite of it's offset. i.e the /north type will have dir = SOUTH.
#define MAPPING_DIRECTIONAL_HELPERS_ROBUST_INVERSE_DIR(path, n_offset, s_offset, e_offset, w_offset) ##path/directional/north {\
	dir = SOUTH; \
	pixel_y = n_offset; \
} \
##path/directional/south {\
	dir = NORTH; \
	pixel_y = s_offset; \
} \
##path/directional/east {\
	dir = WEST; \
	pixel_x = e_offset; \
} \
##path/directional/west {\
	dir = EAST; \
	pixel_x = w_offset; \
}
