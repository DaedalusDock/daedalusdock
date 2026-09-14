/atom/movable/screen/observer
	icon = 'icons/hud/screen_ghost.dmi'
	private_screen = FALSE

/atom/movable/screen/observer/MouseEntered(location, control, params)
	. = ..()
	flick(icon_state + "_anim", src)

/atom/movable/screen/observer/orbit
	name = "Orbit"
	icon_state = "orbit"
	screen_loc = ui_observer_orbit

/atom/movable/screen/observer/orbit/Click()
	. = ..()
	if(.)
		return FALSE
	var/mob/dead/observer/G = usr
	G.follow()

/atom/movable/screen/observer/reenter_corpse
	name = "Reenter corpse"
	icon_state = "reenter_corpse"
	screen_loc = ui_observer_reenter_corpse

/atom/movable/screen/observer/reenter_corpse/Click()
	. = ..()
	if(.)
		return FALSE
	var/mob/dead/G = usr
	G.reenter_corpse()

/// For ghosts instead of observers
/atom/movable/screen/observer/reenter_corpse/ghost
	name = "Reenter corpse"
	icon_state = "reenter_corpse"
	screen_loc = "SOUTH:6,CENTER"

/atom/movable/screen/observer/teleport
	name = "Teleport"
	icon_state = "teleport"
	screen_loc = ui_observer_teleport

/atom/movable/screen/observer/teleport/Click()
	. = ..()
	if(.)
		return FALSE

	var/mob/dead/observer/G = usr
	G.dead_tele()
