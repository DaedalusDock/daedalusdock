/datum/hud/ai
	ui_style = 'icons/hud/screen_ai.dmi'

/datum/hud/ai/initialize_screens()
	. = ..()

	add_screen_object(/atom/movable/screen/language_menu{screen_loc = ui_ai_language_menu}, HUDKEY_MOB_LANGUAGE_MENU, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/ai/aicore, HUDKEY_AI_AICORE, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/ai/camera_list, HUDKEY_AI_CAMERA_LIST, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/ai/camera_track, HUDKEY_AI_CAMERA_TRACK, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/ai/camera_light, HUDKEY_AI_CAMERA_LIGHT, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/ai/crew_monitor, HUDKEY_AI_CREW_MONITOR, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/ai/crew_manifest, HUDKEY_AI_CREW_MANIFEST, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/ai/alerts, HUDKEY_SILICON_ALERTS, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/ai/announcement, HUDKEY_AI_ANNOUNCEMENT, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/ai/call_shuttle, HUDKEY_AI_CALL_SHUTTLE, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/ai/state_laws, HUDKEY_AI_STATE_LAWS, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/ai/image_take, HUDKEY_AI_TAKE_IMAGE, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/ai/image_view, HUDKEY_AI_IMAGE_VIEW, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/ai/sensors, HUDKEY_AI_SENSORS, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/ai/multicam, HUDKEY_AI_MULTICAM, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/ai/add_multicam, HUDKEY_AI_ADD_MULTICAM, HUDGROUP_STATIC_INVENTORY)

	// Modular Interface
	var/atom/movable/screen/ai/modpc/tabletbutton = add_screen_object(__IMPLIED_TYPE__, HUDKEY_SILICON_TABLET, HUDGROUP_STATIC_INVENTORY)
	var/mob/living/silicon/ai/myai = mymob
	myai.interfaceButton = tabletbutton
	tabletbutton.robot = myai
