/mob/living/carbon/get_item_by_slot(slot_id)
	switch(slot_id)
		if(ITEM_SLOT_BACK)
			return back
		if(ITEM_SLOT_MASK)
			return wear_mask
		if(ITEM_SLOT_NECK)
			return wear_neck
		if(ITEM_SLOT_HEAD)
			return head
		if(ITEM_SLOT_HANDCUFFED)
			return handcuffed
		if(ITEM_SLOT_LEGCUFFED)
			return legcuffed
	return ..()

/mob/living/carbon/proc/get_all_worn_items(include_pockets = TRUE)
	return list(
		back,
		wear_mask,
		wear_neck,
		head,
		handcuffed,
		legcuffed,
	)

/mob/living/carbon/get_slot_by_item(obj/item/looking_for)
	if(looking_for == back)
		return ITEM_SLOT_BACK

	if(back && (looking_for in back))
		return ITEM_SLOT_BACKPACK

	if(looking_for == wear_mask)
		return ITEM_SLOT_MASK

	if(looking_for == wear_neck)
		return ITEM_SLOT_NECK

	if(looking_for == head)
		return ITEM_SLOT_HEAD

	if(looking_for == handcuffed)
		return ITEM_SLOT_HANDCUFFED

	if(looking_for == legcuffed)
		return ITEM_SLOT_LEGCUFFED

	return ..()

/mob/living/carbon/proc/equip_in_one_of_slots(obj/item/I, list/slots, qdel_on_fail = 1)
	for(var/slot in slots)
		if(equip_to_slot_if_possible(I, slots[slot], qdel_on_fail = 0, disable_warning = TRUE))
			return slot
	if(qdel_on_fail)
		qdel(I)
	return null

//This is an UNSAFE proc. Use mob_can_equip() before calling this one! Or rather use equip_to_slot_if_possible() or advanced_equip_to_slot_if_possible()
/mob/living/carbon/equip_to_slot(obj/item/I, slot, initial = FALSE, redraw_mob = FALSE)
	if(!slot)
		return
	if(!istype(I))
		return

	var/index = get_held_index_of_item(I)
	if(index)
		held_items[index] = null

	if(LAZYLEN(I.grabbed_by))
		I.free_from_all_grabs()

	I.screen_loc = null
	if(client)
		client.screen -= I
	if(LAZYLEN(observers))
		for(var/mob/dead/observe as anything in observers)
			if(observe.client)
				observe.client.screen -= I

	I.forceMove(src)
	I.plane = ABOVE_HUD_PLANE
	I.appearance_flags |= NO_CLIENT_COLOR
	var/not_handled = FALSE

	switch(slot)
		if(ITEM_SLOT_BACK)
			if(back)
				return
			back = I

		if(ITEM_SLOT_MASK)
			if(wear_mask)
				return

			wear_mask = I
			wear_mask_update(I, toggle_off = 0)

		if(ITEM_SLOT_HEAD)
			if(head)
				return

			head = I

		if(ITEM_SLOT_NECK)
			if(wear_neck)
				return
			wear_neck = I

		if(ITEM_SLOT_HANDCUFFED)
			set_handcuffed(I)

		if(ITEM_SLOT_LEGCUFFED)
			legcuffed = I
			update_worn_legcuffs()

		if(ITEM_SLOT_HANDS)
			put_in_hands(I)

		if(ITEM_SLOT_BACKPACK)
			if(!back || !back.atom_storage?.attempt_insert(I, src, override = TRUE))
				not_handled = TRUE
		else
			not_handled = TRUE

	//Item has been handled at this point and equipped callback can be safely called
	//We cannot call it for items that have not been handled as they are not yet correctly
	//in a slot (handled further down inheritance chain, probably living/carbon/human/equip_to_slot
	if(!not_handled)
		afterEquipItem(I, slot, initial)

	return not_handled

/// This proc is called after an item has been successfully handled and equipped to a slot.
/mob/living/carbon/proc/afterEquipItem(obj/item/item, slot, initial = FALSE)
	if(length(item.actions))
		item.update_action_buttons(UPDATE_BUTTON_STATUS)

	return item.equipped(src, slot, initial)

/mob/living/carbon/tryUnequipItem(obj/item/I, force, newloc, no_move, invdrop = TRUE, silent = FALSE, use_unequip_delay = FALSE, slot = get_slot_by_item(I))
	. = ..() //Sets the default return value to what the parent returns.
	if(!. || !I) //We don't want to set anything to null if the parent returned 0.
		return

	var/handled = TRUE
	if(I == head)
		head = null

	else if(I == back)
		back = null

	else if(I == wear_mask)
		wear_mask = null
		if(!QDELETED(src))
			wear_mask_update(I, toggle_off = 1)

	else if(I == wear_neck)
		wear_neck = null

	else if(I == handcuffed)
		set_handcuffed(null)

	else if(I == shoes)
		shoes = null

	else if(I == legcuffed)
		legcuffed = null
		if(!QDELETED(src))
			update_worn_legcuffs()

	else
		handled = FALSE

	// Not an else-if because we're probably equipped in another slot
	if((I == internal || I == external) && (QDELETED(src) || QDELETED(I) || I.loc != src))
		cutoff_internals()
		if(!QDELETED(src))
			update_mob_action_buttons(UPDATE_BUTTON_STATUS)

	if(handled && !QDELETED(src))
		update_slots_for_item(I, slot)

//handle stuff to update when a mob equips/unequips a mask.
/mob/living/proc/wear_mask_update(obj/item/I, toggle_off = 1)
	update_worn_mask()

/mob/living/carbon/wear_mask_update(obj/item/I, toggle_off = 1)
	var/obj/item/clothing/C = I
	if(istype(C) && (C.tint || initial(C.tint)))
		update_tint()
	update_worn_mask()

/mob/living/carbon/proc/get_holding_bodypart_of_item(obj/item/I)
	var/index = get_held_index_of_item(I)
	return index && hand_bodyparts[index]

/**
 * Proc called when offering an item to another player
 *
 * This handles creating an alert and adding an overlay to it
 */
/mob/living/carbon/proc/give(mob/living/carbon/offered)
	if(has_status_effect(/datum/status_effect/offering))
		to_chat(src, span_warning("You're already offering something!"))
		return

	if(IS_DEAD_OR_INCAP(src))
		to_chat(src, span_warning("You're unable to offer anything in your current state!"))
		return

	var/obj/item/offered_item = get_active_held_item()
	if(!offered_item)
		to_chat(src, span_warning("You're not holding anything to offer!"))
		return

	if(offered)
		if(offered == src)
			if(!swap_hand(get_inactive_hand_index())) //have to swap hands first to take something
				to_chat(src, span_warning("You try to take [offered_item] from yourself, but fail."))
				return
			if(!put_in_active_hand(offered_item))
				to_chat(src, span_warning("You try to take [offered_item] from yourself, but fail."))
				return
			else
				to_chat(src, span_notice("You take [offered_item] from yourself."))
				return

		if(IS_DEAD_OR_INCAP(offered))
			to_chat(src, span_warning("[offered.p_theyre(TRUE)] unable to take anything in [offered.p_their()] current state!"))
			return

		if(!offered.IsReachableBy(src))
			to_chat(src, span_warning("You have to be beside [offered.p_them()]!"))
			return
	else
		if(!(locate(/mob/living/carbon) in orange(1, src)))
			to_chat(src, span_warning("There's nobody beside you to take it!"))
			return

	if(offered_item.on_offered(src)) // see if the item interrupts with its own behavior
		return

	visible_message(span_notice("[src] is offering [offered ? "[offered] " : ""][offered_item]."), \
					span_notice("You offer [offered ? "[offered] " : ""][offered_item]."), null, 2)

	apply_status_effect(/datum/status_effect/offering, offered_item, null, offered)

/**
 * Proc called when the player clicks the give alert
 *
 * Handles checking if the player taking the item has open slots and is in range of the offerer
 * Also deals with the actual transferring of the item to the players hands
 * Arguments:
 * * offerer - The person giving the original item
 * * I - The item being given by the offerer
 */
/mob/living/carbon/proc/take(mob/living/carbon/offerer, obj/item/I)
	clear_alert("[offerer]")
	if(IS_DEAD_OR_INCAP(src))
		to_chat(src, span_warning("You're unable to take anything in your current state!"))
		return
	if(get_dist(src, offerer) > 1)
		to_chat(src, span_warning("[offerer] is out of range!"))
		return
	if(!I || offerer.get_active_held_item() != I)
		to_chat(src, span_warning("[offerer] is no longer holding the item they were offering!"))
		return
	if(!get_empty_held_indexes())
		to_chat(src, span_warning("You have no empty hands!"))
		return

	if(I.on_offer_taken(offerer, src)) // see if the item has special behavior for being accepted
		return

	if(!offerer.temporarilyRemoveItemFromInventory(I))
		visible_message(span_notice("[offerer] tries to hand over [I] but it's stuck to them...."))
		return

	visible_message(span_notice("[src] takes [I] from [offerer]."), \
					span_notice("You take [I] from [offerer]."))
	put_in_hands(I)

///Returns a list of all body_zones covered by clothing
/mob/living/carbon/proc/get_covered_body_zones(exact_only)
	RETURN_TYPE(/list)
	SHOULD_NOT_OVERRIDE(TRUE)

	var/covered_flags = NONE
	var/list/all_worn_items = get_all_worn_items()
	for(var/obj/item/worn_item in all_worn_items)
		covered_flags |= worn_item.body_parts_covered

	return cover_flags2body_zones(covered_flags, exact_only)

///Returns a bitfield of all zones covered by clothing
/mob/living/carbon/proc/get_all_covered_flags()
	SHOULD_NOT_OVERRIDE(TRUE)

	var/covered_flags = NONE
	var/list/all_worn_items = get_all_worn_items()
	for(var/obj/item/worn_item in all_worn_items)
		covered_flags |= worn_item.body_parts_covered

	return covered_flags

///Returns an item that is covering a bodypart.
/mob/living/carbon/proc/get_item_covering_bodypart(obj/item/bodypart/BP)
	return get_item_covering_zone(BP.body_zone)

///Returns an item that is covering a body_zone (BODY_ZONE_CHEST, etc)
/mob/living/carbon/proc/get_item_covering_zone(zone)
	var/list/zones = body_zone2cover_flags(zone)
	var/cover_field = NONE
	for(var/_zone in zones)
		cover_field |= _zone

	for(var/obj/item/inv_item in get_all_worn_items())
		if(cover_field & inv_item.body_parts_covered)
			return inv_item

/mob/living/carbon/update_slots_for_item(obj/item/I, equipped_slot = null, force_obscurity_update)
	if(isnull(equipped_slot))
		equipped_slot = get_slot_by_item(I)
		if(is_holding(I))
			equipped_slot |= ITEM_SLOT_HANDS

	if(isnull(equipped_slot))
		return

	var/old_obscured_slots = obscured_slots
	var/slots_to_update = equipped_slot
	var/need_bodypart_update = FALSE
	var/update_appearance_flags = NONE

	if(I.flags_inv || force_obscurity_update)
		update_obscurity()
		var/new_obscured_slots = obscured_slots
		var/updated_slots = old_obscured_slots ^ new_obscured_slots

		// Update slots that we were obscuring/are going to obscure
		slots_to_update |= check_obscured_slots(input_slots = updated_slots)

		// Update name if we are changing face visibility
		var/face_coverage_changed = updated_slots & HIDEFACE
		if(face_coverage_changed)
			update_appearance_flags |= UPDATE_NAME

		// Update body incase any bodyparts or organs changed visibility
		var/bodypart_coverage_changed = updated_slots & BODYPART_HIDE_FLAGS
		if(bodypart_coverage_changed)
			need_bodypart_update = TRUE

	switch(equipped_slot)
		if(ITEM_SLOT_HEAD)
			if(isclothing(I))
				var/obj/item/clothing/clothing_item = I
				if(clothing_item.tint || initial(clothing_item.tint))
					update_tint()

			update_sight()

			if (invalid_internals())
				cutoff_internals()

			if(ishuman(src))
				var/mob/living/carbon/human/H = src
				H.sec_hud_set_security_status()

		if(ITEM_SLOT_ID)
			update_appearance_flags |= UPDATE_NAME
			if(ishuman(src))
				var/mob/living/carbon/human/H = src
				H.sec_hud_set_ID()

		if(ITEM_SLOT_EYES)
			var/obj/item/clothing/glasses/G = I
			if(G.tint || initial(G.tint))
				update_tint()

			if(G.vision_flags || G.darkness_view || G.invis_override || G.invis_view || !isnull(G.lighting_alpha))
				update_sight()

		if(ITEM_SLOT_BELT)
			update_appearance_flags |= UPDATE_NAME // I have literally no idea why this is needed. Ninja belt maybe?

	// Do the updates
	if(need_bodypart_update)
		update_body_parts()

	if(update_appearance_flags)
		update_appearance(update_appearance_flags)

	update_clothing(slots_to_update)
