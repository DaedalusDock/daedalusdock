/datum/hud/dextrous/drone/initialize_screens()
	. = ..()
	var/atom/movable/screen/inventory/inv_box

	inv_box = add_screen_object(/atom/movable/screen/inventory, HUDKEY_ITEM_SLOT_CONST(ITEM_SLOT_DEX_STORAGE), HUDGROUP_STATIC_INVENTORY)
	inv_box.name = "internal storage"
	inv_box.icon = ui_style
	inv_box.icon_state = "suit_storage"
	inv_box.screen_loc = ui_drone_storage
	inv_box.slot_id = ITEM_SLOT_DEX_STORAGE

	inv_box = add_screen_object(/atom/movable/screen/inventory, HUDKEY_ITEM_SLOT_CONST(ITEM_SLOT_HEAD), HUDGROUP_STATIC_INVENTORY)
	inv_box.name = "head/mask"
	inv_box.icon = ui_style
	inv_box.icon_state = "mask"
	inv_box.screen_loc = ui_drone_head
	inv_box.slot_id = ITEM_SLOT_HEAD

/datum/hud/dextrous/drone/persistent_inventory_update()
	if(!mymob)
		return
	var/mob/living/simple_animal/drone/D = mymob

	if(hud_shown)
		if(D.internal_storage)
			D.internal_storage.screen_loc = ui_drone_storage
			D.client.screen += D.internal_storage
		if(D.head)
			D.head.screen_loc = ui_drone_head
			D.client.screen += D.head
	else
		if(D.internal_storage)
			D.internal_storage.screen_loc = null
		if(D.head)
			D.head.screen_loc = null

	..()
