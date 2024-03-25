//Used for normal mobs that have hands.
/datum/hud/dextrous/initialize_screens()
	. = ..()
	var/atom/movable/screen/using

	using = add_screen_object(/atom/movable/screen/swap_hand, HUDKEY_MOB_SWAPHAND_1, HUDGROUP_STATIC_INVENTORY, ui_style)
	using.icon_state = "swap_1"
	using.screen_loc = ui_swaphand_position(mymob,1)

	using = add_screen_object(/atom/movable/screen/swap_hand, HUDKEY_MOB_SWAPHAND_2, HUDGROUP_STATIC_INVENTORY, ui_style)
	using.icon_state = "swap_2"
	using.screen_loc = ui_swaphand_position(mymob, 2)

	add_screen_object(/atom/movable/screen/drop, HUDKEY_MOB_DROP, HUDGROUP_STATIC_INVENTORY, ui_style)
	add_screen_object(/atom/movable/screen/pull, HUDKEY_MOB_PULL, HUDGROUP_STATIC_INVENTORY, ui_style)

	mymob.canon_client.screen = list()

	build_hand_slots()

	add_screen_object(/atom/movable/screen/combattoggle/flashy, HUDKEY_MOB_INTENTS, HUDGROUP_STATIC_INVENTORY, ui_style)
	add_screen_object(/atom/movable/screen/zone_sel, HUDKEY_MOB_ZONE_SELECTOR, HUDGROUP_STATIC_INVENTORY, ui_style)
	add_screen_object(/atom/movable/screen/area_creator, HUDKEY_HUMAN_AREA_CREATOR, HUDGROUP_STATIC_INVENTORY, ui_style)
	add_screen_object(/atom/movable/screen/gun_mode, HUDKEY_MOB_GUN_MODE, HUDGROUP_INFO_DISPLAY, ui_style)

	add_screen_object(/atom/movable/screen/gun_item, HUDKEY_MOB_GUN_ITEM, HUDGROUP_GUN_OPTIONS, ui_style)
	add_screen_object(/atom/movable/screen/gun_move, HUDKEY_MOB_GUN_MOVE, HUDGROUP_GUN_OPTIONS, ui_style)
	add_screen_object(/atom/movable/screen/gun_radio, HUDKEY_MOB_GUN_RADIO, HUDGROUP_GUN_OPTIONS, ui_style)

/datum/hud/dextrous/persistent_inventory_update()
	if(!mymob)
		return
	var/mob/living/D = mymob
	if(hud_version != HUD_STYLE_NOHUD)
		for(var/obj/item/I in D.held_items)
			I.screen_loc = ui_hand_position(D.get_held_index_of_item(I))
			D.client.screen += I
	else
		for(var/obj/item/I in D.held_items)
			I.screen_loc = null
			D.client.screen -= I


//Dextrous simple mobs can use hands!
/mob/living/simple_animal/create_mob_hud()
	if(dextrous)
		hud_type = dextrous_hud_type
	return ..()
