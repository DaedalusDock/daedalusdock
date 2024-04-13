//Medical Categories for quirks
#define CAT_QUIRK_ALL 0
#define CAT_QUIRK_NOTES 1
#define CAT_QUIRK_DISABILITIES 2

#define QUIRK_GENRE_BANE -1
#define QUIRK_GENRE_NEUTRAL 0
#define QUIRK_GENRE_BOON 1

/// This quirk can only be applied to humans
#define QUIRK_HUMAN_ONLY (1<<0)
/// This quirk processes on SSquirks (and should implement quirk process)
#define QUIRK_PROCESSES (1<<1)
/// This quirk is has a visual aspect in that it changes how the player looks. Used in generating dummies.
#define QUIRK_CHANGES_APPEARANCE (1<<2)
