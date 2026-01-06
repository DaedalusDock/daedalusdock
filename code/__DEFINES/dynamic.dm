/// This is the only ruleset that should be picked this round, used by admins and should not be on rulesets in code.
#define ONLY_RULESET (1 << 0)

/// Only one ruleset with this flag will be picked.
#define HIGH_IMPACT_RULESET (1 << 1)

/// This ruleset can only be picked once. Anything that does not have a scaling_cost MUST have this.
#define LONE_RULESET (1 << 2)

/// No round event was hijacked this cycle
#define HIJACKED_NOTHING "HIJACKED_NOTHING"

/// This cycle, a round event was hijacked when the last midround event was too recent.
#define HIJACKED_TOO_RECENT "HIJACKED_TOO_RECENT"

/// This cycle, a round event was hijacked when the next midround event is too soon.
#define HIJACKED_TOO_SOON "HIJACKED_TOO_SOON"

#define GAMEMODE_WAS_DYNAMIC (istype(SSticker.mode, /datum/game_mode/dynamic))

#define GAMEMODE_WAS_MALF_AI (istype(SSticker.mode, /datum/game_mode/one_antag/malf) || (GAMEMODE_WAS_DYNAMIC && locate(/datum/dynamic_ruleset/roundstart/malf_ai) in SSticker.mode:executed_rules))

#define GAMEMODE_WAS_REVS (istype(SSticker.mode, /datum/game_mode/one_antag/revolution) || (GAMEMODE_WAS_DYNAMIC && ((locate(/datum/dynamic_ruleset/roundstart/revs) in SSticker.mode:executed_rules) || locate(/datum/dynamic_ruleset/latejoin/provocateur) in SSticker.mode:executed_rules)))

#define GAMEMODE_WAS_NUCLEAR_EMERGENCY (istype(SSticker.mode, /datum/game_mode/one_antag/nuclear_emergency) || (GAMEMODE_WAS_DYNAMIC && ((locate(/datum/dynamic_ruleset/roundstart/nuclear) in SSticker.mode:executed_rules) || (locate(/datum/dynamic_ruleset/midround/from_ghosts/nuclear) in SSticker.mode:executed_rules))))
