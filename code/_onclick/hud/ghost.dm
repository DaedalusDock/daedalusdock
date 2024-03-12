/atom/movable/screen/ghost
	icon = 'icons/hud/screen_ghost.dmi'
	private_screen = FALSE

/atom/movable/screen/ghost/MouseEntered(location, control, params)
	. = ..()
	flick(icon_state + "_anim", src)

/atom/movable/screen/ghost/spawners_menu
	name = "Spawners menu"
	icon_state = "spawners"
	screen_loc = ui_ghost_spawners_menu

/atom/movable/screen/ghost/spawners_menu/Click()
	. = ..()
	if(.)
		return FALSE
	var/mob/dead/observer/observer = usr
	observer.open_spawners_menu()

/atom/movable/screen/ghost/orbit
	name = "Orbit"
	icon_state = "orbit"
	screen_loc = ui_ghost_orbit

/atom/movable/screen/ghost/orbit/Click()
	. = ..()
	if(.)
		return FALSE
	var/mob/dead/observer/G = usr
	G.follow()

/atom/movable/screen/ghost/reenter_corpse
	name = "Reenter corpse"
	icon_state = "reenter_corpse"
	screen_loc = ui_ghost_reenter_corpse

/atom/movable/screen/ghost/reenter_corpse/Click()
	. = ..()
	if(.)
		return FALSE
	var/mob/dead/observer/G = usr
	G.reenter_corpse()

/atom/movable/screen/ghost/teleport
	name = "Teleport"
	icon_state = "teleport"
	screen_loc = ui_ghost_teleport

/atom/movable/screen/ghost/teleport/Click()
	. = ..()
	if(.)
		return FALSE

	var/mob/dead/observer/G = usr
	G.dead_tele()

/atom/movable/screen/ghost/pai
	name = "pAI Candidate"
	icon_state = "pai"
	screen_loc = ui_ghost_pai

/atom/movable/screen/ghost/pai/Click()
	. = ..()
	if(.)
		return FALSE

	var/mob/dead/observer/G = usr
	G.register_pai()

/atom/movable/screen/ghost/minigames_menu
	name ="Minigames"
	icon_state = "minigames"
	screen_loc = ui_ghost_minigames

/atom/movable/screen/ghost/minigames_menu/Click()
	. = ..()
	if(.)
		return FALSE

	var/mob/dead/observer/observer = usr
	observer.open_minigames_menu()

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

