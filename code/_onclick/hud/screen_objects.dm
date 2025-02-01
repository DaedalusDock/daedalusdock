/*
	Screen objects
	Todo: improve/re-implement

	Screen objects are only used for the hud and should not appear anywhere "in-game".
	They are used with the client/screen list and the screen_loc var.
	For more information, see the byond documentation on the screen_loc and screen vars.
*/
/atom/movable/screen
	name = ""
	icon = 'icons/hud/screen_gen.dmi'
	plane = HUD_PLANE
	animate_movement = SLIDE_STEPS
	speech_span = SPAN_ROBOT
	vis_flags = VIS_INHERIT_PLANE
	appearance_flags = APPEARANCE_UI
	flags_1 = parent_type::flags_1 | NO_SCREENTIPS_1
	/// A reference to the object in the slot. Grabs or items, generally, but any datum will do.
	var/datum/weakref/master_ref = null
	/// A reference to the owner HUD, if any.
	var/datum/hud/hud = null
	/**
	 * Map name assigned to this object.
	 * Automatically set by /client/proc/add_obj_to_map.
	 */
	var/assigned_map
	/**
	 * Mark this object as garbage-collectible after you clean the map
	 * it was registered on.
	 *
	 * This could probably be changed to be a proc, for conditional removal.
	 * But for now, this works.
	 */
	var/del_on_map_removal = TRUE

	/// If set to TRUE, mobs that do not own this hud cannot click this screen object.
	var/private_screen = TRUE
	/// If set to TRUE, call atom/Click()
	var/default_click = FALSE

/atom/movable/screen/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	if(isnull(hud_owner)) //some screens set their hud owners on /new, this prevents overriding them with null post atoms init
		return

	set_new_hud(hud_owner)

/atom/movable/screen/Destroy()
	master_ref = null
	hud = null
	return ..()

/atom/movable/screen/Click(location, control, params)
	SHOULD_CALL_PARENT(TRUE)
	. = !(TRUE || ..())

	if(!can_usr_use(usr))
		return TRUE

	if(default_click)
		..()
	else
		SEND_SIGNAL(src, COMSIG_CLICK, location, control, params, usr)

/atom/movable/screen/examine(mob/user)
	return list()

/atom/movable/screen/orbit()
	return

/atom/movable/screen/proc/can_usr_use(mob/user)
	. = TRUE
	if(private_screen && (hud?.mymob != user))
		return FALSE

///setter used to set our new hud
/atom/movable/screen/proc/set_new_hud(datum/hud/hud_owner)
	if(hud)
		UnregisterSignal(hud, COMSIG_PARENT_QDELETING)

	if(isnull(hud_owner))
		hud = null
		return

	hud = hud_owner
	RegisterSignal(hud, COMSIG_PARENT_QDELETING, PROC_REF(on_hud_delete))

/atom/movable/screen/proc/component_click(atom/movable/screen/component_button/component, params)
	return

/atom/movable/screen/proc/on_hud_delete(datum/source)
	SIGNAL_HANDLER
	set_new_hud(hud_owner = null)

/atom/movable/screen/text
	icon = null
	icon_state = null
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	screen_loc = "CENTER-7,CENTER-7"
	maptext_height = 480
	maptext_width = 480

/atom/movable/screen/swap_hand
	plane = HUD_PLANE
	name = "swap hand"

/atom/movable/screen/swap_hand/Click()
	. = ..()
	if(.)
		return FALSE

	// At this point in client Click() code we have passed the 1/10 sec check and little else
	// We don't even know if it's a middle click
	if(world.time <= usr.next_move)
		return 1

	if(usr.incapacitated())
		return 1

	if(ismob(usr))
		var/mob/M = usr
		M.swap_hand()
	return 1

/atom/movable/screen/navigate
	name = "navigate"
	icon = 'icons/hud/screen_midnight.dmi'
	icon_state = "navigate"
	screen_loc = ui_navigate_menu

/atom/movable/screen/navigate/Click()
	. = ..()
	if(.)
		return FALSE
	var/mob/living/navigator = usr
	navigator.navigate()

/atom/movable/screen/craft
	name = "crafting menu"
	icon = 'icons/hud/screen_midnight.dmi'
	icon_state = "craft"
	screen_loc = ui_crafting

/atom/movable/screen/area_creator
	name = "create new area"
	icon = 'icons/hud/screen_midnight.dmi'
	icon_state = "area_edit"
	screen_loc = ui_building

/atom/movable/screen/area_creator/Click()
	. = ..()
	if(.)
		return FALSE
	if(usr.incapacitated() || (isobserver(usr) && !isAdminGhostAI(usr)))
		return TRUE

	var/area/A = get_area(usr)
	if(!A.outdoors)
		to_chat(usr, span_warning("There is already a defined structure here."))
		return TRUE
	create_area(usr)

/atom/movable/screen/language_menu
	name = "language menu"
	icon = 'icons/hud/screen_midnight.dmi'
	icon_state = "talk_wheel"
	screen_loc = ui_language_menu

/atom/movable/screen/language_menu/Click()
	. = ..()
	if(.)
		return FALSE

	var/mob/M = usr
	var/datum/language_holder/H = M.get_language_holder()
	H.open_language_menu(usr)

/atom/movable/screen/inventory
	/// The identifier for the slot. It has nothing to do with ID cards.
	var/slot_id
	/// Icon when empty. For now used only by humans.
	var/icon_empty
	/// Icon when contains an item. For now used only by humans.
	var/icon_full
	/// The overlay when hovering over with an item in your hand
	var/image/object_overlay
	plane = HUD_PLANE
	mouse_drop_zone = TRUE

/atom/movable/screen/inventory/Click(location, control, params)
	// At this point in client Click() code we have passed the 1/10 sec check and little else
	// We don't even know if it's a middle click
	. = ..()
	if(.)
		return FALSE

	if(world.time <= usr.next_move)
		return TRUE

	if(usr.incapacitated(IGNORE_STASIS))
		return TRUE
	if(ismecha(usr.loc)) // stops inventory actions in a mech
		return TRUE

	if(hud?.mymob && slot_id)
		var/obj/item/inv_item = hud.mymob.get_item_by_slot(slot_id)
		if(inv_item)
			return inv_item.Click(location, control, params)

	if(usr.attack_ui(slot_id, params))
		usr.update_held_items()
	return TRUE

/atom/movable/screen/inventory/MouseDroppedOn(atom/dropped, mob/user, params)
	if(user != hud?.mymob || !slot_id)
		return TRUE
	if(!isitem(dropped))
		return TRUE
	if(world.time <= usr.next_move)
		return TRUE
	if(usr.incapacitated(IGNORE_STASIS))
		return TRUE
	if(ismecha(usr.loc)) // stops inventory actions in a mech
		return TRUE
	if(!user.is_holding(dropped))
		return TRUE

	user.equip_to_slot_if_possible(dropped, slot_id, FALSE, FALSE, FALSE)
	return TRUE

/atom/movable/screen/inventory/MouseEntered(location, control, params)
	. = ..()
	add_overlays()

/atom/movable/screen/inventory/MouseExited()
	..()
	cut_overlay(object_overlay)
	QDEL_NULL(object_overlay)

/atom/movable/screen/inventory/update_icon_state()
	if(!icon_empty)
		icon_empty = icon_state

	if(!hud?.mymob || !slot_id || !icon_full)
		return ..()
	icon_state = hud.mymob.get_item_by_slot(slot_id) ? icon_full : icon_empty
	return ..()

/atom/movable/screen/inventory/proc/add_overlays()
	var/mob/user = hud?.mymob

	if(!user || !slot_id)
		return

	var/obj/item/holding = user.get_active_held_item()

	if(!holding || user.get_item_by_slot(slot_id))
		return

	var/image/item_overlay = image(holding)
	item_overlay.alpha = 92

	if(!holding.mob_can_equip(user, null, slot_id, disable_warning = TRUE, bypass_equip_delay_self = TRUE))
		item_overlay.color = "#FF0000"
	else
		item_overlay.color = "#00ff00"

	cut_overlay(object_overlay)
	object_overlay = item_overlay
	add_overlay(object_overlay)

/atom/movable/screen/inventory/hand
	var/mutable_appearance/handcuff_overlay
	var/static/mutable_appearance/blocked_overlay = mutable_appearance('icons/hud/screen_gen.dmi', "blocked")
	var/held_index = 0

/atom/movable/screen/inventory/hand/update_overlays()
	. = ..()

	if(!handcuff_overlay)
		var/state = (!(held_index % 2)) ? "markus" : "gabrielle"
		handcuff_overlay = mutable_appearance('icons/hud/screen_gen.dmi', state)

	if(!hud?.mymob)
		return

	if(iscarbon(hud.mymob))
		var/mob/living/carbon/C = hud.mymob
		if(C.handcuffed)
			. += handcuff_overlay

		if(held_index)
			if(!C.has_hand_for_held_index(held_index))
				. += blocked_overlay

	if(held_index == hud.mymob.active_hand_index)
		. += "hand_active"


/atom/movable/screen/inventory/hand/Click(location, control, params)
	SHOULD_CALL_PARENT(FALSE)
	// At this point in client Click() code we have passed the 1/10 sec check and little else
	// We don't even know if it's a middle click
	if(!can_usr_use(usr))
		return TRUE

	SEND_SIGNAL(src, COMSIG_CLICK, location, control, params, usr)

	var/mob/user = hud?.mymob
	if(world.time <= user.next_move)
		return TRUE

	if(user.incapacitated())
		return TRUE

	if (ismecha(user.loc)) // stops inventory actions in a mech
		return TRUE

	if(user.active_hand_index == held_index)
		var/obj/item/I = user.get_active_held_item()
		if(I)
			I.Click(location, control, params)
	else
		user.swap_hand(held_index)
	return TRUE

/atom/movable/screen/inventory/hand/MouseDroppedOn(atom/dropping, mob/user, params)
	if(!isitem(dropping))
		return TRUE

	if(usr != hud?.mymob)
		return TRUE

	if(world.time <= user.next_move)
		return TRUE

	if(user.incapacitated())
		return TRUE

	if(ismecha(user.loc)) // stops inventory actions in a mech
		return TRUE

	if(!dropping.IsReachableBy(user))
		return TRUE

	var/obj/item/I = dropping
	if(!(user.is_holding(I) || (I.item_flags & (IN_STORAGE|IN_INVENTORY))))
		return TRUE

	var/item_index = user.get_held_index_of_item(I)
	if(item_index)
		user.swapHeldIndexes(item_index, held_index)
	else
		user.putItemFromInventoryInHandIfPossible(dropping, held_index, use_unequip_delay = TRUE)
		I.add_fingerprint(user)
	return TRUE

/atom/movable/screen/close
	name = "close"
	plane = ABOVE_HUD_PLANE
	icon_state = "backpack_close"

/atom/movable/screen/close/Initialize(mapload, datum/hud/hud_owner, new_master)
	. = ..()
	master_ref = WEAKREF(new_master)

/atom/movable/screen/close/can_usr_use(mob/user)
	return TRUE

/atom/movable/screen/close/Click()
	. = ..()
	if(.)
		return

	var/datum/storage/storage = master_ref?.resolve()
	if(!storage)
		return
	storage.hide_contents(usr)
	return TRUE

/atom/movable/screen/drop
	name = "drop"
	icon = 'icons/hud/screen_midnight.dmi'
	icon_state = "act_drop"
	plane = HUD_PLANE

/atom/movable/screen/drop/Click()
	. = ..()
	if(.)
		return FALSE
	if(usr.stat == CONSCIOUS)
		usr.dropItemToGround(usr.get_active_held_item())

/atom/movable/screen/combattoggle
	name = "toggle combat mode"
	icon = 'icons/hud/screen_midnight.dmi'
	icon_state = "help"
	screen_loc = ui_combat_toggle

/atom/movable/screen/combattoggle/Initialize(mapload)
	. = ..()
	update_appearance()

/atom/movable/screen/combattoggle/Click()
	. = ..()
	if(.)
		return FALSE

	if(isliving(usr))
		var/mob/living/owner = usr
		owner.set_combat_mode(!owner.combat_mode, FALSE)
		update_appearance()

/atom/movable/screen/combattoggle/update_icon_state()
	var/mob/living/user = hud?.mymob
	if(!istype(user) || !user.client)
		return ..()

	if(user.client.keys_held["Ctrl"])
		icon_state = "grab"
	else
		icon_state = user.combat_mode ? "harm" : "help" //Treats the combat_mode
	return ..()

//Version of the combat toggle with the flashy overlay
/atom/movable/screen/combattoggle/flashy
	///Mut appearance for flashy border
	var/mutable_appearance/flashy

/atom/movable/screen/combattoggle/flashy/update_overlays()
	. = ..()
	var/mob/living/user = hud?.mymob
	if(!istype(user) || !user.client)
		return

	if(!user.combat_mode)
		return

	if(!flashy)
		flashy = mutable_appearance('icons/hud/screen_gen.dmi', "togglefull_flash")
		flashy.color = "#C62727"
	. += flashy

/atom/movable/screen/combattoggle/robot
	icon = 'icons/hud/screen_cyborg.dmi'
	screen_loc = ui_borg_intents

/atom/movable/screen/spacesuit
	name = "Space suit cell status"
	icon_state = "spacesuit_0"
	screen_loc = ui_spacesuit

/atom/movable/screen/mov_intent
	name = "run/walk toggle"
	icon = 'icons/hud/screen_midnight.dmi'
	icon_state = "running"

/atom/movable/screen/mov_intent/Click()
	. = ..()
	if(.)
		return FALSE
	toggle(usr)

/atom/movable/screen/mov_intent/update_icon_state()
	switch(hud?.mymob?.m_intent)
		if(MOVE_INTENT_WALK)
			icon_state = "walking"
		if(MOVE_INTENT_RUN, MOVE_INTENT_SPRINT)
			icon_state = "running"
	return ..()

/atom/movable/screen/mov_intent/proc/toggle(mob/user)
	if(user.m_intent != MOVE_INTENT_WALK)
		user.set_move_intent(MOVE_INTENT_WALK)
	else
		user.set_move_intent(MOVE_INTENT_RUN)

/atom/movable/screen/pull
	name = "stop pulling"
	icon = 'icons/hud/screen_midnight.dmi'
	icon_state = "pull"
	base_icon_state = "pull"

/atom/movable/screen/pull/Click()
	. = ..()
	if(.)
		return FALSE

	var/mob/living/L = usr
	L.release_all_grabs()

/atom/movable/screen/pull/update_icon_state()
	icon_state = "[base_icon_state][LAZYLEN(hud?.mymob?:active_grabs) ? null : 0]"
	return ..()

/atom/movable/screen/pull/robot
	icon = 'icons/hud/screen_cyborg.dmi'

/atom/movable/screen/pull/robot/update_icon_state()
	. = ..()
	if(LAZYLEN(hud?.mymob?:active_grabs))
		icon_state = base_icon_state
	else
		icon_state = null

/atom/movable/screen/resist
	name = "resist"
	icon = 'icons/hud/screen_midnight.dmi'
	icon_state = "act_resist"
	plane = HUD_PLANE

/atom/movable/screen/resist/Click()
	. = ..()
	if(.)
		return FALSE
	var/mob/living/L = usr
	L.resist()

/atom/movable/screen/rest
	name = "rest"
	icon = 'icons/hud/screen_midnight.dmi'
	icon_state = "act_rest"
	base_icon_state = "act_rest"
	plane = HUD_PLANE

/atom/movable/screen/rest/Click()
	. = ..()
	if(.)
		return FALSE

	var/mob/living/L = usr
	L.toggle_resting()

/atom/movable/screen/rest/update_icon_state()
	var/mob/living/user = hud?.mymob
	if(!istype(user))
		return ..()
	icon_state = "[base_icon_state][user.resting ? 0 : null]"
	return ..()

/atom/movable/screen/storage
	name = "storage"
	icon_state = "block"
	screen_loc = "7,7 to 10,8"
	plane = HUD_PLANE
	mouse_drop_zone = TRUE

/atom/movable/screen/storage/Initialize(mapload, datum/hud/hud_owner, new_master)
	. = ..()
	master_ref = WEAKREF(new_master)

/atom/movable/screen/storage/can_usr_use(mob/user)
	// Storage does all of it's own sanity checking and stuff.
	return TRUE

/atom/movable/screen/storage/Click(location, control, params)
	. = ..()
	if(.)
		return

	var/datum/storage/storage_master = master_ref?.resolve()
	if(!istype(storage_master))
		return FALSE

	if(world.time <= usr.next_move)
		return TRUE
	if(usr.incapacitated())
		return TRUE
	if(ismecha(usr.loc)) // stops inventory actions in a mech
		return TRUE

	var/obj/item/inserted = usr.get_active_held_item()
	if(inserted)
		storage_master.attempt_insert(inserted, usr)

	return TRUE

/atom/movable/screen/storage/MouseDroppedOn(atom/dropping, mob/user, params)
	var/datum/storage/storage_master = master_ref?.resolve()

	if(!istype(storage_master))
		return FALSE

	if(!isitem(dropping))
		return TRUE

	if(world.time <= user.next_move)
		return TRUE

	if(user.incapacitated())
		return TRUE

	if(ismecha(user.loc)) // stops inventory actions in a mech
		return TRUE

	if(!dropping.IsReachableBy(user))
		return TRUE

	var/obj/item/I = dropping
	if(!(user.is_holding(I) || (I.item_flags & IN_STORAGE)))
		return TRUE

	storage_master.attempt_insert(dropping, usr)

	return TRUE

/atom/movable/screen/throw_catch
	name = "throw/catch"
	icon = 'icons/hud/screen_midnight.dmi'
	icon_state = "act_throw_off"

/atom/movable/screen/throw_catch/Click()
	. = ..()
	if(.)
		return FALSE

	var/mob/living/carbon/C = usr
	C.toggle_throw_mode()

/atom/movable/screen/zone_sel
	name = "damage zone"
	icon_state = "zone_sel"
	screen_loc = ui_zonesel
	var/overlay_icon = 'icons/hud/screen_gen.dmi'
	var/static/list/hover_overlays_cache = list()
	var/hovering

/atom/movable/screen/zone_sel/Click(location, control,params)
	. = ..()
	if(.)
		return FALSE

	var/list/modifiers = params2list(params)
	var/icon_x = text2num(LAZYACCESS(modifiers, ICON_X))
	var/icon_y = text2num(LAZYACCESS(modifiers, ICON_Y))
	var/choice = get_zone_at(icon_x, icon_y)
	if (!choice)
		return 1

	return set_selected_zone(choice, usr)

/atom/movable/screen/zone_sel/MouseEntered(location, control, params)
	. = ..()
	MouseMove(location, control, params)

/atom/movable/screen/zone_sel/MouseMove(location, control, params)
	if(isobserver(usr))
		return

	var/list/modifiers = params2list(params)
	var/icon_x = text2num(LAZYACCESS(modifiers, ICON_X))
	var/icon_y = text2num(LAZYACCESS(modifiers, ICON_Y))
	var/choice = get_zone_at(icon_x, icon_y)

	if(hovering == choice)
		return
	remove_viscontents(hover_overlays_cache[hovering])
	hovering = choice

	var/obj/effect/overlay/zone_sel/overlay_object = hover_overlays_cache[choice]
	if(!overlay_object)
		overlay_object = new
		overlay_object.icon_state = "[choice]"
		hover_overlays_cache[choice] = overlay_object
	add_viscontents(overlay_object)

/obj/effect/overlay/zone_sel
	icon = 'icons/hud/screen_gen.dmi'
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 128
	anchored = TRUE
	plane = ABOVE_HUD_PLANE

/atom/movable/screen/zone_sel/MouseExited(location, control, params)
	. = ..()
	if(!isobserver(usr) && hovering)
		remove_viscontents(hover_overlays_cache[hovering])
		hovering = null

/atom/movable/screen/zone_sel/proc/get_zone_at(icon_x, icon_y)
	switch(icon_y)
		if(1 to 9) //Legs
			switch(icon_x)
				if(10 to 15)
					return BODY_ZONE_R_LEG
				if(17 to 22)
					return BODY_ZONE_L_LEG
		if(10 to 13) //Hands and groin
			switch(icon_x)
				if(8 to 11)
					return BODY_ZONE_R_ARM
				if(12 to 20)
					return BODY_ZONE_PRECISE_GROIN
				if(21 to 24)
					return BODY_ZONE_L_ARM
		if(14 to 22) //Chest and arms to shoulders
			switch(icon_x)
				if(8 to 11)
					return BODY_ZONE_R_ARM
				if(12 to 20)
					return BODY_ZONE_CHEST
				if(21 to 24)
					return BODY_ZONE_L_ARM
		if(23 to 30) //Head, but we need to check for eye or mouth
			if(icon_x in 12 to 20)
				switch(icon_y)
					if(23 to 24)
						if(icon_x in 15 to 17)
							return BODY_ZONE_PRECISE_MOUTH
					if(26) //Eyeline, eyes are on 15 and 17
						if(icon_x in 14 to 18)
							return BODY_ZONE_PRECISE_EYES
					if(25 to 27)
						if(icon_x in 15 to 17)
							return BODY_ZONE_PRECISE_EYES
				return BODY_ZONE_HEAD

/atom/movable/screen/zone_sel/proc/set_selected_zone(choice, mob/user)
	if(user != hud?.mymob)
		return

	if(choice != hud.mymob.zone_selected)
		hud.mymob.zone_selected = choice
		update_appearance()
		SEND_SIGNAL(user, COMSIG_MOB_SELECTED_ZONE_SET, choice)

	return TRUE

/atom/movable/screen/zone_sel/update_overlays()
	. = ..()
	if(!hud?.mymob)
		return
	. += mutable_appearance(overlay_icon, "[hud.mymob.zone_selected]")

/atom/movable/screen/zone_sel/alien
	icon = 'icons/hud/screen_alien.dmi'
	overlay_icon = 'icons/hud/screen_alien.dmi'

/atom/movable/screen/zone_sel/robot
	icon = 'icons/hud/screen_cyborg.dmi'

/atom/movable/screen/flash
	name = "flash"
	icon_state = "blank"
	blend_mode = BLEND_ADD
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	layer = FLASH_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/damageoverlay
	icon = 'icons/hud/screen_full.dmi'
	icon_state = "oxydamageoverlay0"
	name = "dmg"
	blend_mode = BLEND_MULTIPLY
	screen_loc = "CENTER-7,CENTER-7"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = UI_DAMAGE_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/healths
	name = "health"
	icon_state = "health0"
	screen_loc = ui_health

/atom/movable/screen/healths/alien
	icon = 'icons/hud/screen_alien.dmi'
	screen_loc = ui_alien_health

/atom/movable/screen/healths/robot
	icon = 'icons/hud/screen_cyborg.dmi'
	screen_loc = ui_borg_health

/atom/movable/screen/healths/blob
	name = "blob health"
	icon_state = "block"
	screen_loc = ui_blob_health
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/screen/healths/blob/overmind
	name = "overmind health"
	icon = 'icons/hud/blob.dmi'
	icon_state = "corehealth"
	screen_loc = ui_blobbernaut_overmind_health

/atom/movable/screen/healths/guardian
	name = "summoner health"
	icon = 'icons/mob/guardian.dmi'
	icon_state = "base"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/screen/healths/revenant
	name = "essence"
	icon = 'icons/mob/actions/backgrounds.dmi'
	icon_state = "bg_revenant"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/screen/healthdoll
	name = "physical health"
	screen_loc = ui_healthdoll

/atom/movable/screen/healthdoll/Click()
	. = ..()
	if(.)
		return FALSE

	var/mob/living/carbon/C = usr
	C.check_self_for_injuries()

/atom/movable/screen/healthdoll/living
	icon_state = "fullhealth0"
	screen_loc = ui_living_healthdoll
	var/filtered = FALSE //so we don't repeatedly create the mask of the mob every update

/atom/movable/screen/component_button
	var/atom/movable/screen/parent

/atom/movable/screen/component_button/Initialize(mapload, atom/movable/screen/parent)
	. = ..()
	src.parent = parent

/atom/movable/screen/component_button/Click(params)
	. = ..()
	if(.)
		return FALSE

	if(parent)
		parent.component_click(src, params)

/atom/movable/screen/combo
	icon_state = ""
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	screen_loc = ui_combo
	plane = ABOVE_HUD_PLANE
	var/timerid

/atom/movable/screen/combo/proc/clear_streak()
	animate(src, alpha = 0, 2 SECONDS, SINE_EASING)
	timerid = addtimer(CALLBACK(src, PROC_REF(reset_icons)), 2 SECONDS, TIMER_UNIQUE | TIMER_STOPPABLE)

/atom/movable/screen/combo/proc/reset_icons()
	cut_overlays()
	icon_state = ""

/atom/movable/screen/combo/update_icon_state(streak = "", time = 2 SECONDS)
	reset_icons()
	if(timerid)
		deltimer(timerid)
	alpha = 255
	if(!streak)
		return ..()
	timerid = addtimer(CALLBACK(src, PROC_REF(clear_streak)), time, TIMER_UNIQUE | TIMER_STOPPABLE)
	icon_state = "combo"
	for(var/i = 1; i <= length(streak); ++i)
		var/intent_text = copytext(streak, i, i + 1)
		var/image/intent_icon = image(icon,src,"combo_[intent_text]")
		intent_icon.pixel_x = 16 * (i - 1) - 8 * length(streak)
		add_overlay(intent_icon)
	return ..()

/atom/movable/screen/stamina
	name = "stamina"
	icon_state = "stamina0"
	screen_loc = ui_stamina
	private_screen = FALSE

/atom/movable/screen/stamina/Click(location, control, params)
	. = ..()
	if(.)
		return FALSE
	var/mob/living/carbon/C = hud.mymob
	var/content = {"
	<div class='examine_block'>
		[span_boldnotice("You have [C.stamina.current]/[C.stamina.maximum] stamina.")]
	</div>
	"}
	to_chat(usr, content)

/atom/movable/screen/stamina/MouseEntered(location, control, params)
	. = ..()
	if(QDELETED(src))
		return

	var/mob/living/L = hud.mymob
	var/_content = {"
		Stamina: [L.stamina.current]/[L.stamina.maximum]<br>
		Regen: [L.stamina.regen_rate]
	"}
	openToolTip(usr, src, params, title = "Stamina", content = _content)

/atom/movable/screen/stamina/MouseExited(location, control, params)
	. = ..()
	closeToolTip(usr)

/atom/movable/screen/gun_mode
	name = "Toggle Gun Mode"
	icon_state = "gun0"
	screen_loc = ui_gun_select

/atom/movable/screen/gun_mode/Click(location, control, params)
	. = ..()
	if(.)
		return FALSE

	var/mob/living/user = hud?.mymob
	if(!user)
		return
	user.use_gunpoint = !user.use_gunpoint

	hud.gun_setting_icon.update_icon_state()
	hud.update_gunpoint(user)

/atom/movable/screen/gun_mode/update_icon_state()
	. = ..()
	var/mob/living/user = hud?.mymob
	if(!user)
		return

	if(!user.use_gunpoint)
		icon_state = "gun0"
		user.client.screen -= hud.gunpoint_options
	else
		icon_state = "gun1"
		user.client.screen += hud.gunpoint_options

/atom/movable/screen/gun_radio
	name = "Disallow Radio Use"
	icon_state = "no_radio1"
	screen_loc = ui_gun1

/atom/movable/screen/gun_radio/Click(location, control, params)
	. = ..()
	if(.)
		return FALSE

	var/mob/living/user = hud?.mymob
	if(!user)
		return

	user.toggle_gunpoint_flag(TARGET_CAN_RADIO)
	update_icon_state()

/atom/movable/screen/gun_radio/update_icon_state()
	. = ..()

	var/mob/living/user = hud?.mymob
	if(user.gunpoint_flags & TARGET_CAN_RADIO)
		icon_state = "no_radio1"
	else
		icon_state = "no_radio0"

/atom/movable/screen/gun_item
	name = "Allow Item Use"
	icon_state = "no_item1"
	screen_loc = ui_gun2

/atom/movable/screen/gun_item/Click(location, control, params)
	. = ..()
	if(.)
		return FALSE

	var/mob/living/user = hud?.mymob
	if(!user)
		return

	user.toggle_gunpoint_flag(TARGET_CAN_INTERACT)
	update_icon_state()

/atom/movable/screen/gun_item/update_icon_state()
	. = ..()

	var/mob/living/user = hud?.mymob
	if(user.gunpoint_flags & TARGET_CAN_INTERACT)
		icon_state = "no_item1"
	else
		icon_state = "no_item0"

/atom/movable/screen/gun_move
	name = "Allow Movement"
	icon_state = "no_walk1"
	screen_loc = ui_gun3

/atom/movable/screen/gun_move/Click(location, control, params)
	. = ..()
	if(.)
		return FALSE

	var/mob/living/user = hud?.mymob
	if(!user)
		return

	user.toggle_gunpoint_flag(TARGET_CAN_MOVE)
	update_icon_state()

/atom/movable/screen/gun_move/update_icon_state()
	. = ..()

	var/mob/living/user = hud?.mymob
	if(user.gunpoint_flags & TARGET_CAN_MOVE)
		icon_state = "no_walk1"
	else
		icon_state = "no_walk0"

/atom/movable/screen/pain
	name = "pain overlay"
	icon_state = ""
	layer = UI_DAMAGE_LAYER
	plane = FULLSCREEN_PLANE
	screen_loc = "WEST,SOUTH to EAST,NORTH"

/atom/movable/screen/progbar_container
	name = "swing cooldown"
	icon_state = ""
	screen_loc = "CENTER,SOUTH:16"
	var/datum/world_progressbar/progbar
	var/iteration = 0

/atom/movable/screen/progbar_container/Initialize(mapload)
	. = ..()
	progbar = new(src)
	progbar.qdel_when_done = FALSE
	progbar.bar.vis_flags = VIS_INHERIT_ID | VIS_INHERIT_LAYER | VIS_INHERIT_PLANE
	progbar.bar.appearance_flags = APPEARANCE_UI

/atom/movable/screen/progbar_container/Destroy()
	QDEL_NULL(progbar)
	return ..()

/atom/movable/screen/progbar_container/proc/on_changenext(datum/source, next_move)
	SIGNAL_HANDLER

	iteration++
	progbar.goal = next_move - world.time
	progbar.bar.icon_state = "prog_bar_0"

	progbar_process(next_move)

/atom/movable/screen/progbar_container/proc/progbar_process(next_move)
	set waitfor = FALSE

	var/start_time = world.time
	var/iteration = src.iteration
	while(iteration == src.iteration && (world.time < next_move))
		progbar.update(world.time - start_time)
		sleep(1)

	if(iteration == src.iteration)
		progbar.end_progress()


/atom/movable/screen/holomap
	icon = ""
	plane = FULLSCREEN_PLANE
	layer = FLOAT_LAYER
	// Holomaps are 480x480.
	// We offset them by half the size on each axis to center them.
	// We need to account for this object being 32x32, so we subtract 32 from the initial 480 before dividing
	screen_loc = "CENTER:-224,CENTER:-224"

/atom/movable/screen/vis_holder
	icon = ""
	invisibility = INVISIBILITY_MAXIMUM

/atom/movable/screen/mood
	name = "mood"
	icon_state = "mood5"
	screen_loc = ui_mood
	color = "#4b96c4"
