/datum/hud/living
	ui_style = 'icons/hud/screen_gen.dmi'

/datum/hud/living/New(mob/living/owner)
	..()

	add_screen_object(/atom/movable/screen/pull, HUDKEY_MOB_PULL, HUDGROUP_STATIC_INVENTORY, ui_style)
	add_screen_object(/atom/movable/screen/combo, HUDKEY_MOB_COMBO, HUDGROUP_INFO_DISPLAY)
	add_screen_object(/atom/movable/screen/healthdoll/living, HUDKEY_MOB_HEALTH, HUDGROUP_INFO_DISPLAY)
