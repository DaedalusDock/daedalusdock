/datum/hud/alien
	ui_style = 'icons/hud/screen_alien.dmi'

/datum/hud/alien/initialize_screens()
	. = ..()

	var/atom/movable/screen/using
	build_hand_slots()

	using = add_screen_object(/atom/movable/screen/swap_hand, HUDKEY_MOB_SWAPHAND_1, HUDGROUP_STATIC_INVENTORY, ui_style)
	using.icon_state = "swap_1"
	using.screen_loc = ui_swaphand_position(mymob,1)

	using = add_screen_object(/atom/movable/screen/swap_hand, HUDKEY_MOB_SWAPHAND_2, HUDGROUP_STATIC_INVENTORY, ui_style)
	using.icon_state = "swap_2"
	using.screen_loc = ui_swaphand_position(mymob, 2)

	add_screen_object(/atom/movable/screen/combattoggle/flashy, HUDKEY_MOB_INTENTS, HUDGROUP_STATIC_INVENTORY, ui_style)
	add_screen_object(/atom/movable/screen/pull{icon = 'icons/hud/screen_alien.dmi'}, HUDKEY_MOB_PULL, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/language_menu{screen_loc = ui_alien_language_menu}, HUDKEY_MOB_LANGUAGE_MENU, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/navigate{screen_loc = ui_alien_navigate_menu}, HUDKEY_MOB_NAVIGATE_MENU, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/zone_sel/alien, HUDKEY_MOB_ZONE_SELECTOR, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/drop, HUDKEY_MOB_DROP, HUDGROUP_STATIC_INVENTORY, ui_style)
	add_screen_object(/atom/movable/screen/pull, HUDKEY_MOB_PULL, HUDGROUP_STATIC_INVENTORY, ui_style)

	add_screen_object(/atom/movable/screen/resist, HUDKEY_MOB_RESIST, HUDGROUP_HOTKEY_BUTTONS, ui_style)
	add_screen_object(/atom/movable/screen/throw_catch, HUDKEY_MOB_THROW, HUDGROUP_HOTKEY_BUTTONS, ui_style)

	add_screen_object(/atom/movable/screen/healths/alien, HUDKEY_MOB_HEALTH, HUDGROUP_INFO_DISPLAY)
	add_screen_object(/atom/movable/screen/alien/plasma_display, HUDKEY_ALIEN_PLASMA_DISPLAY, HUDGROUP_INFO_DISPLAY)

	if(isalienhunter(mymob))
		add_screen_object(/atom/movable/screen/alien/leap, HUDKEY_ALIEN_HUNTER_LEAP, HUDGROUP_STATIC_INVENTORY, ui_style)

	if(!isalienqueen(mymob))
		add_screen_object(/atom/movable/screen/alien/plasma_display, HUDKEY_ALIEN_QUEEN_FINDER, HUDGROUP_INFO_DISPLAY)

/datum/hud/alien/persistent_inventory_update()
	if(!mymob)
		return
	var/mob/living/carbon/alien/humanoid/H = mymob
	if(hud_version != HUD_STYLE_NOHUD)
		for(var/obj/item/I in H.held_items)
			I.screen_loc = ui_hand_position(H.get_held_index_of_item(I))
			H.client.screen += I
	else
		for(var/obj/item/I in H.held_items)
			I.screen_loc = null
			H.client.screen -= I
