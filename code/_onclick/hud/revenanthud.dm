/datum/hud/revenant
	ui_style = 'icons/hud/screen_gen.dmi'

/datum/hud/revenant/initialize_screens()
	. = ..()

	var/atom/movable/screen/pull_icon = add_screen_object(/atom/movable/screen/pull, HUDKEY_MOB_PULL, HUDGROUP_STATIC_INVENTORY)
	pull_icon.icon = ui_style
	pull_icon.update_appearance()

	add_screen_object(/atom/movable/screen/healths/revenant, HUDKEY_MOB_HEALTH, HUDGROUP_INFO_DISPLAY)
