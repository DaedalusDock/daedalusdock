/// From mob/living/*/set_combat_mode(): (new_state)
#define COMSIG_LIVING_COMBAT_MODE_TOGGLE "living_combat_mode_toggle"
///Fired in combat_indicator.dm, used for syncing CI between mech and pilot
#define COMSIG_MOB_CI_TOGGLED "mob_ci_toggled"

//Gun signals
///When a gun is switched to automatic fire mode
#define COMSIG_GUN_AUTOFIRE_SELECTED "gun_autofire_selected"
///When a gun is switched off of automatic fire mode
#define COMSIG_GUN_AUTOFIRE_DESELECTED "gun_autofire_deselected"

//Unused at the moment

// ///The gun has jammed.
// #define COMSIG_GUN_JAMMED "gun_jammed"
// ///The gun needs to update the gun hud!
// #define COMSIG_UPDATE_AMMO_HUD "update_ammo_hud"
