/// Observer hud
/datum/hud/observer/initialize_screens()
	. = ..()

	add_screen_object(/atom/movable/screen/observer/orbit, HUDKEY_GHOST_ORBIT, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/observer/reenter_corpse, HUDKEY_GHOST_REENTER_CORPSE, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/observer/teleport, HUDKEY_GHOST_TELEPORT, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/language_menu/ghost, HUDKEY_MOB_LANGUAGE_MENU, HUDGROUP_STATIC_INVENTORY, ui_style)

/datum/hud/observer/show_hud(version = 0, mob/viewmob)
	// don't show this HUD if observing; show the HUD of the observee
	var/mob/dead/observer/O = mymob
	if (istype(O) && O.observetarget)
		plane_masters_update()
		return FALSE

	. = ..()
	if(!.)
		return

	var/mob/screenmob = viewmob || mymob
	if(screenmob.client.prefs.read_preference(/datum/preference/toggle/ghost_hud))
		screenmob.client.screen += screen_groups[HUDGROUP_STATIC_INVENTORY]
	else
		screenmob.client.screen -= screen_groups[HUDGROUP_STATIC_INVENTORY]

//We should only see observed mob alerts.
/datum/hud/observer/reorganize_alerts(mob/viewmob)
	var/mob/dead/observer/O = mymob
	if (istype(O) && O.observetarget)
		return
	. = ..()

/// For ghosts instead of observers.
/datum/hud/ghost/initialize_screens()
	. = ..()

	add_screen_object(/atom/movable/screen/observer/reenter_corpse/ghost, HUDKEY_GHOST_REENTER_CORPSE, HUDGROUP_STATIC_INVENTORY)
