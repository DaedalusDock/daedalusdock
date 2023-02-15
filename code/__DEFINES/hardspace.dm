///Adds the associated defines for Hardspace

//Salvage tool defines.

#define TOOL_SALVAGECUTTER "salvagecutter"
#define TOOL_SALVAGEBOLTGUN "salvageboltgun"
#define TOOL_SALVAGESAW "salvagesaw"
#define TOOL_SALVAGEWIRETAP "salvagewiretap"

//Salvage Difficulty defines and guidelines:
//Anything below SALVAGE_DIFFICULTY_MEDIUM is intended for use on comparatively simple machines. Nothing on the salvage platform should be higher than Medium at the most, with the occasional Hard thrown in for flavor.
//Anything above SALVAGE_DIFFICULTY_MEDIUM is reserved for the Space Hulk, as 80% of salvage onboard will require specific steps rather than random ones.
//Anything above SALVAGE_DIFFICULTY_HARD is reserved for specialist equipment that has an associated hazard. I.e, an unstable reactor, a ruptured fuel tank, etc, for the sake of player fairness.

#define SALVAGE_DIFFICULTY_EFFORTLESS 1 ///Base modifier, should only be used on abstracts and junk machinery.
#define SALVAGE_DIFFICULTY_EASY 0.9 ///90% -Found on Salvage Platform, T1-T2 Hulks
#define SALVAGE_DIFFICULTY_MODERATE 0.8 ///80% -Found on Salvage Platform, T1-T2 Hulks
#define SALVAGE_DIFFICULTY_MEDIUM 0.6 ///60% -Found on Salvage Platform, T1-T3 Hulks
#define SALVAGE_DIFFICULTY_HARD 0.5 ///50% -Found on T1-T3 Hulks
#define SALVAGE_DIFFICULTY_EXTREME 0.4 ///40% -Found on T2-T3 Hulks
#define SALVAGE_DIFFICULTY_IMPOSSIBLE 0.3 ///30% -Found on T3 Hulks only
