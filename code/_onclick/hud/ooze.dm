///Hud type with targetting dol and a nutrition bar
/datum/hud/ooze/New(mob/living/owner)
	. = ..()

	add_screen_object(/atom/movable/screen/zone_sel, HUDKEY_MOB_ZONE_SELECTOR, HUDGROUP_STATIC_INVENTORY, ui_style)
	add_screen_object(/atom/movable/screen/ooze_nutrition_display, HUDKEY_MOB_NUTRITION, HUDGROUP_INFO_DISPLAY)

/atom/movable/screen/ooze_nutrition_display
	icon = 'icons/hud/screen_alien.dmi'
	icon_state = "power_display"
	name = "nutrition"
	screen_loc = ui_alienplasmadisplay
