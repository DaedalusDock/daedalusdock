/datum/hud/larva
	ui_style = 'icons/hud/screen_alien.dmi'

/datum/hud/larva/initialize_screens()
	. = ..()
	add_screen_object(/atom/movable/screen/combattoggle/flashy, HUDKEY_MOB_INTENTS, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/pull{icon = 'icons/hud/screen_alien.dmi'}, HUDKEY_MOB_PULL, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/language_menu{screen_loc = ui_alien_language_menu}, HUDKEY_MOB_LANGUAGE_MENU, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/navigate{screen_loc = ui_alien_navigate_menu}, HUDKEY_MOB_NAVIGATE_MENU, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/zone_sel/alien, HUDKEY_MOB_ZONE_SELECTOR, HUDGROUP_STATIC_INVENTORY)

	add_screen_object(/atom/movable/screen/healths/alien, HUDKEY_MOB_HEALTH, HUDGROUP_INFO_DISPLAY)
	add_screen_object(/atom/movable/screen/alien/alien_queen_finder, HUDKEY_ALIEN_QUEEN_FINDER, HUDGROUP_INFO_DISPLAY)
