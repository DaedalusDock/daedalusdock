/datum/hud/living/blobbernaut/initialize_screens()
	. = ..()
	add_screen_object(/atom/movable/screen/healths/blob/overmind, HUDKEY_BLOB_POWER_DISPLAY, HUDGROUP_INFO_DISPLAY)
