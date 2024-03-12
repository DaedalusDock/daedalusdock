/atom/movable/screen/human
	icon = 'icons/hud/screen_midnight.dmi'

/atom/movable/screen/human/toggle
	name = "toggle"
	icon_state = "toggle"
	screen_loc = ui_inventory
	private_screen = FALSE // We handle cases where usr != owner.

/atom/movable/screen/human/toggle/Click()
	. = ..()
	if(.)
		return FALSE

	var/mob/targetmob = usr

	if(isobserver(usr))
		if(ishuman(usr.client.eye) && (usr.client.eye != usr))
			var/mob/M = usr.client.eye
			targetmob = M

	if(usr.hud_used.inventory_shown && targetmob.hud_used)
		usr.hud_used.inventory_shown = FALSE
		usr.client.screen -= targetmob.hud_used.screen_groups[HUDGROUP_TOGGLEABLE_INVENTORY]
	else
		usr.hud_used.inventory_shown = TRUE
		usr.client.screen += targetmob.hud_used.screen_groups[HUDGROUP_TOGGLEABLE_INVENTORY]

	targetmob.hud_used.hidden_inventory_update(usr)

/atom/movable/screen/human/equip
	name = "equip"
	icon_state = "act_equip"

/atom/movable/screen/human/equip/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	if(hud_owner)
		screen_loc = ui_equip_position(hud_owner.mymob)

/atom/movable/screen/human/equip/Click()
	. = ..()
	if(.)
		return FALSE
	if(ismecha(usr.loc)) // stops inventory actions in a mech
		return TRUE

	var/mob/living/carbon/human/H = usr
	H.quick_equip()

/atom/movable/screen/ling
	icon = 'icons/hud/screen_changeling.dmi'

/atom/movable/screen/ling/chems
	name = "chemical storage"
	icon_state = "power_display"
	screen_loc = ui_lingchemdisplay

/atom/movable/screen/ling/sting
	name = "current sting"
	screen_loc = ui_lingstingdisplay
	invisibility = INVISIBILITY_ABSTRACT

/atom/movable/screen/ling/sting/Click()
	. = ..()
	if(.)
		return FALSE

	var/mob/living/carbon/carbon_user = hud.mymob
	carbon_user.unset_sting()

/datum/hud/human/initialize_screens()
	. = ..()

	// Static inventory
	add_screen_object(/atom/movable/screen/language_menu, HUDKEY_MOB_LANGUAGE_MENU, HUDGROUP_STATIC_INVENTORY, ui_style)
	add_screen_object(/atom/movable/screen/navigate, HUDKEY_MOB_NAVIGATE_MENU, HUDGROUP_STATIC_INVENTORY, ui_style)
	add_screen_object(/atom/movable/screen/area_creator, HUDKEY_HUMAN_AREA_CREATOR, HUDGROUP_STATIC_INVENTORY, ui_style)
	add_screen_object(/atom/movable/screen/combattoggle/flashy, HUDKEY_MOB_INTENTS, HUDGROUP_STATIC_INVENTORY, ui_style)
	add_screen_object(/atom/movable/screen/drop, HUDKEY_MOB_DROP, HUDGROUP_STATIC_INVENTORY, ui_style)
	add_screen_object(/atom/movable/screen/human/toggle, HUDKEY_HUMAN_TOGGLE_INVENTORY, HUDGROUP_STATIC_INVENTORY, ui_style)
	add_screen_object(/atom/movable/screen/human/equip, HUDKEY_HUMAN_EQUIP_ITEM, HUDGROUP_STATIC_INVENTORY, ui_style)
	add_screen_object(/atom/movable/screen/mov_intent, HUDKEY_MOB_MOVE_INTENT, HUDGROUP_STATIC_INVENTORY, ui_style)
	add_screen_object(/atom/movable/screen/rest, HUDKEY_MOB_REST, HUDGROUP_STATIC_INVENTORY, ui_style)
	add_screen_object(/atom/movable/screen/pull, HUDKEY_MOB_PULL, HUDGROUP_STATIC_INVENTORY, ui_style)
	add_screen_object(/atom/movable/screen/zone_sel, HUDKEY_MOB_ZONE_SELECTOR, HUDGROUP_STATIC_INVENTORY, ui_style)
	add_screen_object(/atom/movable/screen/progbar_container, HUDKEY_MOB_USE_TIMER, HUDGROUP_STATIC_INVENTORY)
	// Hotkey buttons
	add_screen_object(/atom/movable/screen/throw_catch, HUDKEY_MOB_THROW, HUDGROUP_HOTKEY_BUTTONS, ui_style)
	add_screen_object(/atom/movable/screen/resist, HUDKEY_MOB_RESIST, HUDGROUP_HOTKEY_BUTTONS, ui_style)

	// Info
	add_screen_object(/atom/movable/screen/spacesuit, HUDKEY_MOB_SPACESUIT, HUDGROUP_INFO_DISPLAY)
	add_screen_object(/atom/movable/screen/healthdoll, HUDKEY_MOB_HEALTH, HUDGROUP_INFO_DISPLAY)
	add_screen_object(/atom/movable/screen/stamina, HUDKEY_MOB_STAMINA, HUDGROUP_INFO_DISPLAY)
	add_screen_object(/atom/movable/screen/combo, HUDKEY_MOB_COMBO, HUDGROUP_INFO_DISPLAY)
	add_screen_object(/atom/movable/screen/gun_mode, HUDKEY_MOB_GUN_MODE, HUDGROUP_INFO_DISPLAY, ui_style)

	// Gun options
	add_screen_object(/atom/movable/screen/gun_item, HUDKEY_MOB_GUN_ITEM, HUDGROUP_GUN_OPTIONS, ui_style)
	add_screen_object(/atom/movable/screen/gun_move, HUDKEY_MOB_GUN_MOVE, HUDGROUP_GUN_OPTIONS, ui_style)
	add_screen_object(/atom/movable/screen/gun_radio, HUDKEY_MOB_GUN_RADIO, HUDGROUP_GUN_OPTIONS, ui_style)

	// Misc
	add_screen_object(/atom/movable/screen/pain, HUDKEY_MOB_PAIN)

	// Holders for whats to come
	var/atom/movable/screen/inventory/inv_box
	var/atom/movable/screen/using

	using = add_screen_object(/atom/movable/screen/swap_hand, HUDKEY_MOB_SWAPHAND_1, HUDGROUP_STATIC_INVENTORY)
	using.icon_state = "swap_1"
	using.screen_loc = ui_swaphand_position(mymob,1)

	using = add_screen_object(/atom/movable/screen/swap_hand, HUDKEY_MOB_SWAPHAND_2, HUDGROUP_STATIC_INVENTORY)
	using.icon_state = "swap_2"
	using.screen_loc = ui_swaphand_position(mymob, 2)

	inv_box = add_screen_object(/atom/movable/screen/inventory, HUDKEY_ITEM_SLOT_CONST(ITEM_SLOT_ICLOTHING), HUDGROUP_TOGGLEABLE_INVENTORY, ui_style)
	inv_box.name = "i_clothing"
	inv_box.icon = ui_style
	inv_box.slot_id = ITEM_SLOT_ICLOTHING
	inv_box.icon_state = "uniform"
	inv_box.screen_loc = ui_iclothing

	inv_box = add_screen_object(/atom/movable/screen/inventory, HUDKEY_ITEM_SLOT_CONST(ITEM_SLOT_OCLOTHING), HUDGROUP_TOGGLEABLE_INVENTORY, ui_style)
	inv_box.name = "o_clothing"
	inv_box.icon = ui_style
	inv_box.slot_id = ITEM_SLOT_OCLOTHING
	inv_box.icon_state = "suit"
	inv_box.screen_loc = ui_oclothing

	build_hand_slots()

	inv_box = add_screen_object(/atom/movable/screen/inventory, HUDKEY_ITEM_SLOT_CONST(ITEM_SLOT_ID), HUDGROUP_STATIC_INVENTORY, ui_style)
	inv_box.name = "id"
	inv_box.icon = ui_style
	inv_box.icon_state = "id"
	inv_box.screen_loc = ui_id
	inv_box.slot_id = ITEM_SLOT_ID

	inv_box = add_screen_object(/atom/movable/screen/inventory, HUDKEY_ITEM_SLOT_CONST(ITEM_SLOT_MASK), HUDGROUP_TOGGLEABLE_INVENTORY, ui_style)
	inv_box.name = "mask"
	inv_box.icon = ui_style
	inv_box.icon_state = "mask"
	inv_box.screen_loc = ui_mask
	inv_box.slot_id = ITEM_SLOT_MASK

	inv_box = add_screen_object(/atom/movable/screen/inventory, HUDKEY_ITEM_SLOT_CONST(ITEM_SLOT_NECK), HUDGROUP_TOGGLEABLE_INVENTORY, ui_style)
	inv_box.name = "neck"
	inv_box.icon = ui_style
	inv_box.icon_state = "neck"
	inv_box.screen_loc = ui_neck
	inv_box.slot_id = ITEM_SLOT_NECK

	inv_box = add_screen_object(/atom/movable/screen/inventory, HUDKEY_ITEM_SLOT_CONST(ITEM_SLOT_BACK), HUDGROUP_STATIC_INVENTORY, ui_style)
	inv_box.name = "back"
	inv_box.icon = ui_style
	inv_box.icon_state = "back"
	inv_box.screen_loc = ui_back
	inv_box.slot_id = ITEM_SLOT_BACK

	inv_box = add_screen_object(/atom/movable/screen/inventory, HUDKEY_ITEM_SLOT_CONST(ITEM_SLOT_LPOCKET), HUDGROUP_STATIC_INVENTORY, ui_style)
	inv_box.name = "storage1"
	inv_box.icon = ui_style
	inv_box.icon_state = "pocket"
	inv_box.screen_loc = ui_storage1
	inv_box.slot_id = ITEM_SLOT_LPOCKET

	inv_box = add_screen_object(/atom/movable/screen/inventory, HUDKEY_ITEM_SLOT_CONST(ITEM_SLOT_RPOCKET), HUDGROUP_STATIC_INVENTORY, ui_style)
	inv_box.name = "storage2"
	inv_box.icon = ui_style
	inv_box.icon_state = "pocket"
	inv_box.screen_loc = ui_storage2
	inv_box.slot_id = ITEM_SLOT_RPOCKET

	inv_box = add_screen_object(/atom/movable/screen/inventory, HUDKEY_ITEM_SLOT_CONST(ITEM_SLOT_SUITSTORE), HUDGROUP_STATIC_INVENTORY, ui_style)
	inv_box.name = "suit storage"
	inv_box.icon = ui_style
	inv_box.icon_state = "suit_storage"
	inv_box.screen_loc = ui_sstore1
	inv_box.slot_id = ITEM_SLOT_SUITSTORE

	inv_box = add_screen_object(/atom/movable/screen/inventory, HUDKEY_ITEM_SLOT_CONST(ITEM_SLOT_GLOVES), HUDGROUP_TOGGLEABLE_INVENTORY, ui_style)
	inv_box.name = "gloves"
	inv_box.icon = ui_style
	inv_box.icon_state = "gloves"
	inv_box.screen_loc = ui_gloves
	inv_box.slot_id = ITEM_SLOT_GLOVES

	inv_box = add_screen_object(/atom/movable/screen/inventory, HUDKEY_ITEM_SLOT_CONST(ITEM_SLOT_EYES), HUDGROUP_TOGGLEABLE_INVENTORY, ui_style)
	inv_box.name = "eyes"
	inv_box.icon = ui_style
	inv_box.icon_state = "glasses"
	inv_box.screen_loc = ui_glasses
	inv_box.slot_id = ITEM_SLOT_EYES

	inv_box = add_screen_object(/atom/movable/screen/inventory, HUDKEY_ITEM_SLOT_CONST(ITEM_SLOT_EARS), HUDGROUP_TOGGLEABLE_INVENTORY, ui_style)
	inv_box.name = "ears"
	inv_box.icon = ui_style
	inv_box.icon_state = "ears"
	inv_box.screen_loc = ui_ears
	inv_box.slot_id = ITEM_SLOT_EARS

	inv_box = add_screen_object(/atom/movable/screen/inventory, HUDKEY_ITEM_SLOT_CONST(ITEM_SLOT_HEAD), HUDGROUP_TOGGLEABLE_INVENTORY, ui_style)
	inv_box.name = "head"
	inv_box.icon = ui_style
	inv_box.icon_state = "head"
	inv_box.screen_loc = ui_head
	inv_box.slot_id = ITEM_SLOT_HEAD

	inv_box = add_screen_object(/atom/movable/screen/inventory, HUDKEY_ITEM_SLOT_CONST(ITEM_SLOT_SHOES), HUDGROUP_TOGGLEABLE_INVENTORY, ui_style)
	inv_box.name = "shoes"
	inv_box.icon = ui_style
	inv_box.icon_state = "shoes"
	inv_box.screen_loc = ui_shoes
	inv_box.slot_id = ITEM_SLOT_FEET

	inv_box = add_screen_object(/atom/movable/screen/inventory, HUDKEY_ITEM_SLOT_CONST(ITEM_SLOT_BELT), HUDGROUP_STATIC_INVENTORY, ui_style)
	inv_box.name = "belt"
	inv_box.icon = ui_style
	inv_box.icon_state = "belt"
	inv_box.screen_loc = ui_belt
	inv_box.slot_id = ITEM_SLOT_BELT

/datum/hud/human/update_locked_slots()
	if(!mymob)
		return

	var/mob/living/carbon/human/H = mymob
	if(!istype(H) || !H.dna.species)
		return

	var/datum/species/S = H.dna.species
	for(var/atom/movable/screen/inventory/inv in screen_objects)
		if(inv.slot_id)
			if(inv.slot_id in S.no_equip)
				inv.alpha = 128
			else
				inv.alpha = initial(inv.alpha)

/datum/hud/human/hidden_inventory_update(mob/viewer)
	if(!mymob)
		return
	var/mob/living/carbon/human/H = mymob

	var/mob/screenmob = viewer || H

	if(screenmob.hud_used.inventory_shown && screenmob.hud_used.hud_shown)
		if(H.shoes)
			H.shoes.screen_loc = ui_shoes
			screenmob.client.screen += H.shoes
		if(H.gloves)
			H.gloves.screen_loc = ui_gloves
			screenmob.client.screen += H.gloves
		if(H.ears)
			H.ears.screen_loc = ui_ears
			screenmob.client.screen += H.ears
		if(H.glasses)
			H.glasses.screen_loc = ui_glasses
			screenmob.client.screen += H.glasses
		if(H.w_uniform)
			H.w_uniform.screen_loc = ui_iclothing
			screenmob.client.screen += H.w_uniform
		if(H.wear_suit)
			H.wear_suit.screen_loc = ui_oclothing
			screenmob.client.screen += H.wear_suit
		if(H.wear_mask)
			H.wear_mask.screen_loc = ui_mask
			screenmob.client.screen += H.wear_mask
		if(H.wear_neck)
			H.wear_neck.screen_loc = ui_neck
			screenmob.client.screen += H.wear_neck
		if(H.head)
			H.head.screen_loc = ui_head
			screenmob.client.screen += H.head
	else
		if(H.shoes) screenmob.client.screen -= H.shoes
		if(H.gloves) screenmob.client.screen -= H.gloves
		if(H.ears) screenmob.client.screen -= H.ears
		if(H.glasses) screenmob.client.screen -= H.glasses
		if(H.w_uniform) screenmob.client.screen -= H.w_uniform
		if(H.wear_suit) screenmob.client.screen -= H.wear_suit
		if(H.wear_mask) screenmob.client.screen -= H.wear_mask
		if(H.wear_neck) screenmob.client.screen -= H.wear_neck
		if(H.head) screenmob.client.screen -= H.head



/datum/hud/human/persistent_inventory_update(mob/viewer)
	if(!mymob)
		return
	..()
	var/mob/living/carbon/human/H = mymob

	var/mob/screenmob = viewer || H

	if(screenmob.hud_used)
		if(screenmob.hud_used.hud_shown)
			if(H.s_store)
				H.s_store.screen_loc = ui_sstore1
				screenmob.client.screen += H.s_store
			if(H.wear_id)
				H.wear_id.screen_loc = ui_id
				screenmob.client.screen += H.wear_id
			if(H.belt)
				H.belt.screen_loc = ui_belt
				screenmob.client.screen += H.belt
			if(H.back)
				H.back.screen_loc = ui_back
				screenmob.client.screen += H.back
			if(H.l_store)
				H.l_store.screen_loc = ui_storage1
				screenmob.client.screen += H.l_store
			if(H.r_store)
				H.r_store.screen_loc = ui_storage2
				screenmob.client.screen += H.r_store
		else
			if(H.s_store)
				screenmob.client.screen -= H.s_store
			if(H.wear_id)
				screenmob.client.screen -= H.wear_id
			if(H.belt)
				screenmob.client.screen -= H.belt
			if(H.back)
				screenmob.client.screen -= H.back
			if(H.l_store)
				screenmob.client.screen -= H.l_store
			if(H.r_store)
				screenmob.client.screen -= H.r_store

	if(hud_version != HUD_STYLE_NOHUD)
		for(var/obj/item/I in H.held_items)
			I.screen_loc = ui_hand_position(H.get_held_index_of_item(I))
			screenmob.client.screen += I
	else
		for(var/obj/item/I in H.held_items)
			I.screen_loc = null
			screenmob.client.screen -= I


/mob/living/carbon/human/verb/toggle_hotkey_verbs()
	set category = "OOC"
	set name = "Toggle hotkey buttons"
	set desc = "This disables or enables the user interface buttons which can be used with hotkeys."

	if(hud_used.hotkey_ui_hidden)
		client.screen += hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = FALSE
	else
		client.screen -= hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = TRUE
