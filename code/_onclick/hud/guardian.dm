/datum/hud/guardian
	ui_style = 'icons/hud/guardian.dmi'

/datum/hud/guardian/initialize_screens()
	. = ..()

	add_screen_object(/atom/movable/screen/pull{icon = 'icons/hud/guardian.dmi'}, HUDKEY_MOB_PULL, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/guardian/manifest, HUDKEY_GUARDIAN_MANIFEST, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/guardian/recall, HUDKEY_GUARDIAN_RECALL, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/guardian/toggle_light, HUDKEY_GUARDIAN_LIGHT, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/guardian/communicate, HUDKEY_GUARDIAN_COMMUNICATE, HUDGROUP_STATIC_INVENTORY)

	add_screen_object(/atom/movable/screen/healths/guardian, HUDKEY_MOB_HEALTH, HUDGROUP_INFO_DISPLAY)

	var/mob/living/simple_animal/hostile/guardian/owner = mymob
	var/atom/movable/screen/using = add_screen_object(owner.toggle_button_type, HUDKEY_GUARDIAN_TOGGLE, HUDGROUP_STATIC_INVENTORY)
	using.screen_loc = ui_storage1

/datum/hud/dextrous/guardian/initialize_screens()
	. = ..()

	var/atom/movable/screen/using
	if(istype(mymob, /mob/living/simple_animal/hostile/guardian/dextrous))
		var/atom/movable/screen/inventory/inv_box

		inv_box = add_screen_object(/atom/movable/screen/inventory, HUDKEY_ITEM_SLOT_CONST(ITEM_SLOT_DEX_STORAGE), HUDGROUP_STATIC_INVENTORY, ui_style)
		inv_box.name = "internal storage"
		inv_box.icon = ui_style
		inv_box.icon_state = "suit_storage"
		inv_box.screen_loc = ui_id
		inv_box.slot_id = ITEM_SLOT_DEX_STORAGE

		using = add_screen_object(/atom/movable/screen/guardian/communicate, HUDKEY_GUARDIAN_COMMUNICATE, HUDGROUP_STATIC_INVENTORY)
		using.screen_loc = ui_sstore1

	else

		using = add_screen_object(/atom/movable/screen/guardian/communicate, HUDKEY_GUARDIAN_COMMUNICATE, HUDGROUP_STATIC_INVENTORY)
		using.screen_loc = ui_id

	add_screen_object(/atom/movable/screen/pull{icon = 'icons/hud/guardian.dmi'}, HUDKEY_MOB_PULL, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/guardian/manifest{screen_loc = ui_belt}, HUDKEY_GUARDIAN_MANIFEST, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/guardian/recall{screen_loc = ui_back}, HUDKEY_GUARDIAN_RECALL, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/guardian/toggle_light{screen_loc = ui_inventory}, HUDKEY_GUARDIAN_LIGHT, HUDGROUP_STATIC_INVENTORY)

	add_screen_object(/atom/movable/screen/healths/guardian, HUDKEY_MOB_HEALTH, HUDGROUP_INFO_DISPLAY)

	var/mob/living/simple_animal/hostile/guardian/owner = mymob
	using = add_screen_object(owner.toggle_button_type, HUDKEY_GUARDIAN_TOGGLE, HUDGROUP_STATIC_INVENTORY)
	using.screen_loc = ui_storage2

/datum/hud/dextrous/guardian/persistent_inventory_update()
	if(!mymob)
		return
	if(istype(mymob, /mob/living/simple_animal/hostile/guardian/dextrous))
		var/mob/living/simple_animal/hostile/guardian/dextrous/D = mymob

		if(hud_shown)
			if(D.internal_storage)
				D.internal_storage.screen_loc = ui_id
				D.client.screen += D.internal_storage
		else
			if(D.internal_storage)
				D.internal_storage.screen_loc = null

	..()
