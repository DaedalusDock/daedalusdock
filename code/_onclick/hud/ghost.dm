/datum/hud/ghost/initialize_screens()
	. = ..()

	add_screen_object(/atom/movable/screen/ghost/spawners_menu, HUDKEY_GHOST_SPAWNERS, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/ghost/orbit, HUDKEY_GHOST_ORBIT, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/ghost/reenter_corpse, HUDKEY_GHOST_REENTER_CORPSE, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/ghost/teleport, HUDKEY_GHOST_TELEPORT, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/ghost/pai, HUDKEY_GHOST_PAI, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/ghost/minigames_menu, HUDKEY_GHOST_MINIGAMES, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/language_menu{screen_loc = ui_ghost_language_menu}, HUDKEY_MOB_LANGUAGE_MENU, HUDGROUP_STATIC_INVENTORY, ui_style)

/datum/hud/ghost/show_hud(version = 0, mob/viewmob)
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
/datum/hud/ghost/reorganize_alerts(mob/viewmob)
	var/mob/dead/observer/O = mymob
	if (istype(O) && O.observetarget)
		return
	. = ..()

