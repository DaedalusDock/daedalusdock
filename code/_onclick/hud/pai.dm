/datum/hud/pai/initialize_screens()
	. = ..()
	add_screen_object(/atom/movable/screen/language_menu{screen_loc = ui_pai_language_menu}, HUDKEY_MOB_LANGUAGE_MENU, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/navigate{screen_loc = ui_pai_navigate_menu}, HUDKEY_MOB_NAVIGATE_MENU, HUDGROUP_STATIC_INVENTORY)

	add_screen_object(/atom/movable/screen/pai/software, HUDKEY_PAI_SOFTWARE, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/pai/shell, HUDKEY_PAI_SHELL, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/pai/chassis, HUDKEY_PAI_CHASSIS, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/pai/rest, HUDKEY_MOB_REST, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/pai/light, HUDKEY_CYBORG_LAMP, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/pai/newscaster, HUDKEY_PAI_NEWSCASTER, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/pai/host_monitor, HUDKEY_PAI_HOST_MONITOR, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/pai/crew_manifest, HUDKEY_AI_CREW_MANIFEST, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/pai/state_laws, HUDKEY_AI_STATE_LAWS, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/pai/internal_gps, HUDKEY_PAI_GPS, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/pai/image_take, HUDKEY_AI_TAKE_IMAGE, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/pai/image_view, HUDKEY_AI_IMAGE_VIEW, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/pai/radio, HUDKEY_CYBORG_RADIO, HUDGROUP_STATIC_INVENTORY)


	var/mob/living/silicon/pai/mypai = mymob
	var/atom/movable/screen/pai/modpc/tabletbutton = add_screen_object(__IMPLIED_TYPE__, HUDKEY_SILICON_TABLET, HUDGROUP_STATIC_INVENTORY)
	mypai.interfaceButton = tabletbutton
	tabletbutton.pAI = mypai

	update_software_buttons()

/datum/hud/pai/proc/update_software_buttons()
	var/mob/living/silicon/pai/owner = mymob
	for(var/atom/movable/screen/pai/button in screen_groups[HUDGROUP_STATIC_INVENTORY])
		if(button.required_software)
			button.color = owner.software.Find(button.required_software) ? null : "#808080"

