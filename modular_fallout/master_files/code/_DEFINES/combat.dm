//Gun weapon weight
#define WEAPON_LIGHT 1
#define WEAPON_MEDIUM 2
#define WEAPON_HEAVY 3

///Time to spend without clicking on other things required for your shots to become accurate.
#define GUN_AIMING_TIME (2 SECONDS)

//stamina stuff
///Threshold over which attacks start being hindered.
#define STAMINA_NEAR_SOFTCRIT				100
///softcrit for stamina damage. prevents standing up, some actions that cost stamina, etc, but doesn't force a rest or stop movement
#define STAMINA_SOFTCRIT					96
///sanity cap to prevent stamina actions (that are still performable) from sending you into crit.
#define STAMINA_NEAR_CRIT					60
///crit for stamina damage. forces a rest, and stops movement until stamina goes back to stamina softcrit
#define STAMINA_CRIT						48
