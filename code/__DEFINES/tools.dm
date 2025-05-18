// Tool types, if you add new ones please add them to /obj/item/debug/omnitool in code/game/objects/items/debug_items.dm
#define TOOL_CROWBAR "crowbar"
#define TOOL_MULTITOOL "multitool"
#define TOOL_SCREWDRIVER "screwdriver"
#define TOOL_WIRECUTTER "wirecutter"
#define TOOL_WRENCH "wrench"
#define TOOL_WELDER "welder"
#define TOOL_ANALYZER "analyzer"
#define TOOL_MINING "mining"
#define TOOL_SHOVEL "shovel"
#define TOOL_RETRACTOR "retractor"
#define TOOL_HEMOSTAT "hemostat"
#define TOOL_CAUTERY "cautery"
#define TOOL_DRILL "drill"
#define TOOL_SCALPEL "scalpel"
#define TOOL_SAW "saw"
#define TOOL_BONESET "bonesetter"
#define TOOL_KNIFE "knife"
#define TOOL_BLOODFILTER "bloodfilter"
#define TOOL_ROLLINGPIN "rollingpin"
/// Can be used to scrape rust off an any atom; which will result in the Rust Component being qdel'd
#define TOOL_RUSTSCRAPER "rustscraper"

// If delay between the start and the end of tool operation is less than MIN_TOOL_SOUND_DELAY,
// tool sound is only played when op is started. If not, it's played twice.
#define MIN_TOOL_SOUND_DELAY 20

/// Return when an item interaction is successful.
/// This cancels the rest of the chain entirely and indicates success.
#define ITEM_INTERACT_SUCCESS (1<<0) // Same as TRUE, as most tool (legacy) tool acts return TRUE on success
/// Return to prevent the rest of the attacck chain from being executed / preventing the item user from thwacking the target.
/// Similar to [ITEM_INTERACT_SUCCESS], but does not necessarily indicate success.
#define ITEM_INTERACT_BLOCKING (1<<1)
/// Return to skip the rest of the interaction chain, going straight to attack.
#define ITEM_INTERACT_ATTACK (1<<2)

/// Combination flag for any item interaction that blocks the rest of the attack chain
#define ITEM_INTERACT_ANY_BLOCKER (ITEM_INTERACT_SUCCESS | ITEM_INTERACT_BLOCKING)

/// Put this in interact_with_atom to just attack instead of interacting if the user has combat mode on.
#define ATTACK_IF_COMBAT_MODE(user, item) if(user.combat_mode && item.combat_mode_force_attack) { return ITEM_INTERACT_ATTACK }

/// Helper for if an atom has a first class interaction like placing onto a table or into storage.
#define ATOM_HAS_FIRST_CLASS_INTERACTION(atom) (istable(atom) || atom.atom_storage)
