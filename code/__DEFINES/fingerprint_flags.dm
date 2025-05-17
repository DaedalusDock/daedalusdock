/// The item will have the user's fingerprints added if ITEM_INTERACT_SUCCESS is returned.
#define FINGERPRINT_ITEM_SUCCESS (1<<0)
/// The item will have the user's fingerprints added if ITEM_INTERACT_BLOCKING is returned.
#define FINGERPRINT_ITEM_FAILURE (1<<1)
/// The target atom will have the user's fingerprints added if ITEM_INTERACT_SUCCESS is returned.
#define FINGERPRINT_OBJECT_SUCCESS (1<<2)
/// The target atom will have the user's fingerprints added if ITEM_INTERACT_BLOCKING is returned.
#define FINGERPRINT_OBJECT_FAILURE (1<<3)
