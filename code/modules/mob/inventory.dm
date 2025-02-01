//These procs handle putting s tuff in your hands
//as they handle all relevant stuff like adding it to the player's screen and updating their overlays.

///Returns the thing we're currently holding
/mob/proc/get_active_held_item()
	return get_item_for_held_index(active_hand_index)


//Finds the opposite limb for the active one (eg: upper left arm will find the item in upper right arm)
//So we're treating each "pair" of limbs as a team, so "both" refers to them
/mob/proc/get_inactive_held_item()
	return get_item_for_held_index(get_inactive_hand_index())


//Finds the opposite index for the active one (eg: upper left arm will find the item in upper right arm)
//So we're treating each "pair" of limbs as a team, so "both" refers to them
/mob/proc/get_inactive_hand_index()
	var/other_hand = 0
	if(!(active_hand_index % 2))
		other_hand = active_hand_index-1 //finding the matching "left" limb
	else
		other_hand = active_hand_index+1 //finding the matching "right" limb
	if(other_hand < 0 || other_hand > held_items.len)
		other_hand = 0
	return other_hand


/mob/proc/get_item_for_held_index(i)
	if(i > 0 && i <= held_items.len)
		return held_items[i]
	return null


//Odd = left. Even = right
/mob/proc/held_index_to_dir(i)
	if(!(i % 2))
		return "r"
	return "l"

//Check we have an organ for this hand slot (Dismemberment), Only relevant for humans
/mob/proc/has_hand_for_held_index(i)
	return TRUE


//Check we have an organ for our active hand slot (Dismemberment),Only relevant for humans
/mob/proc/has_active_hand()
	return has_hand_for_held_index(active_hand_index)


/// Returns the first available empty held index
/mob/proc/get_empty_held_index()
	for(var/i in 1 to length(held_items))
		if(isnull(held_items[i]))
			return i

//Finds the first available (null) index OR all available (null) indexes in held_items based on a side.
//Lefts: 1, 3, 5, 7...
//Rights:2, 4, 6, 8...
/mob/proc/get_empty_held_index_for_side(side = LEFT_HANDS, all = FALSE)
	var/list/empty_indexes = all ? list() : null
	for(var/i in (side == LEFT_HANDS) ? 1 : 2 to held_items.len step 2)
		if(!held_items[i])
			if(!all)
				return i
			empty_indexes += i
	return empty_indexes


//Same as the above, but returns the first or ALL held *ITEMS* for the side
/mob/proc/get_held_items_for_side(side = LEFT_HANDS, all = FALSE)
	var/list/holding_items = all ? list() : null
	for(var/i in (side == LEFT_HANDS) ? 1 : 2 to held_items.len step 2)
		var/obj/item/I = held_items[i]
		if(I)
			if(!all)
				return I
			holding_items += I
	return holding_items


/mob/proc/get_empty_held_indexes()
	var/list/L
	for(var/i in 1 to held_items.len)
		if(!held_items[i])
			LAZYADD(L, i)
	return L

/mob/proc/get_held_index_of_item(obj/item/I)
	return held_items.Find(I)


///Find number of held items, multihand compatible
/mob/proc/get_num_held_items()
	. = 0
	for(var/i in 1 to held_items.len)
		if(held_items[i])
			.++

//Sad that this will cause some overhead, but the alias seems necessary
//*I* may be happy with a million and one references to "indexes" but others won't be
/mob/proc/is_holding(obj/item/I)
	return get_held_index_of_item(I)


//Checks if we're holding an item of type: typepath
/mob/proc/is_holding_item_of_type(typepath)
	return locate(typepath) in held_items


//Checks if we're holding a tool that has given quality
//Returns the tool that has the best version of this quality
/mob/proc/is_holding_tool_quality(quality)
	var/obj/item/best_item
	var/best_quality = INFINITY

	for(var/obj/item/I in held_items)
		if(I.tool_behaviour == quality && I.toolspeed < best_quality)
			best_item = I
			best_quality = I.toolspeed

	return best_item


//To appropriately fluff things like "they are holding [I] in their [get_held_index_name(get_held_index_of_item(I))]"
//Can be overridden to pass off the fluff to something else (eg: science allowing people to add extra robotic limbs, and having this proc react to that
// with say "they are holding [I] in their Nanotrasen Brand Utility Arm - Right Edition" or w/e
/mob/proc/get_held_index_name(i)
	var/list/hand = list()
	if(i > 2)
		hand += "upper "
	var/num = 0
	if(!(i % 2))
		num = i-2
		hand += "right hand"
	else
		num = i-1
		hand += "left hand"
	num -= (num*0.5)
	if(num > 1) //"upper left hand #1" seems weird, but "upper left hand #2" is A-ok
		hand += " #[num]"
	return hand.Join()



//Returns if a certain item can be equipped to a certain slot.
/mob/proc/can_equip(obj/item/I, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	return FALSE

/mob/proc/can_put_in_hand(obj/item/I, hand_index)
	return FALSE

/// A helper for picking up an item.
/mob/proc/pickup_item(obj/item/I, hand_index = active_hand_index, ignore_anim = FALSE)
	if(QDELETED(I))
		return

	if(!can_put_in_hand(I, hand_index))
		return

	//If the item is in a storage item, take it out
	var/was_in_storage = I.item_flags & IN_STORAGE
	if(was_in_storage && !I.loc.atom_storage?.attempt_remove(I, src, user = src))
		return

	if(QDELETED(src)) //moving it out of the storage destroyed it.
		return

	if(I.throwing)
		I.throwing.finalize(FALSE)

	if(I.loc == src)
		if(!I.allow_attack_hand_drop(src) || !temporarilyRemoveItemFromInventory(I, use_unequip_delay = TRUE))
			return

	I.pickup(src)
	. = put_in_hand(I, hand_index, ignore_anim = ignore_anim || was_in_storage)

	if(!.)
		stack_trace("Somehow, someway, pickup_item failed put_in_hand().")
		dropItemToGround(I, silent = TRUE)

/mob/proc/put_in_hand(obj/item/I, hand_index, forced = FALSE, ignore_anim = TRUE)
	if(hand_index == null)
		return FALSE

	if(!forced && !can_put_in_hand(I, hand_index))
		return FALSE

	if(isturf(I.loc) && !ignore_anim)
		I.do_pickup_animation(src)

	if(get_item_for_held_index(hand_index))
		dropItemToGround(get_item_for_held_index(hand_index), force = TRUE)

	I.forceMove(src)
	held_items[hand_index] = I
	I.plane = ABOVE_HUD_PLANE
	I.equipped(src, ITEM_SLOT_HANDS)

	if(QDELETED(I)) // this is here because some ABSTRACT items like slappers and circle hands could be moved from hand to hand then delete, which meant you'd have a null in your hand until you cleared it (say, by dropping it)
		held_items[hand_index] = null
		return FALSE

	if(LAZYLEN(I.grabbed_by))
		I.free_from_all_grabs()

	update_held_items()
	if(hand_index == active_hand_index)
		update_mouse_pointer()
	I.pixel_x = I.base_pixel_x
	I.pixel_y = I.base_pixel_y
	return hand_index

//Puts the item into the first available left hand if possible and calls all necessary triggers/updates. returns 1 on success.
/mob/proc/put_in_l_hand(obj/item/I)
	return put_in_hand(I, get_empty_held_index_for_side(LEFT_HANDS))

//Puts the item into the first available right hand if possible and calls all necessary triggers/updates. returns 1 on success.
/mob/proc/put_in_r_hand(obj/item/I)
	return put_in_hand(I, get_empty_held_index_for_side(RIGHT_HANDS))

/mob/living/can_put_in_hand(obj/item/I, hand_index)
	if(!istype(I))
		return FALSE

	if(hand_index > held_items.len)
		return FALSE

	if(!((mobility_flags & MOBILITY_PICKUP) || (I.item_flags & ABSTRACT)))
		return FALSE

	if(SEND_SIGNAL(src, COMSIG_LIVING_TRY_PUT_IN_HAND, I) & COMPONENT_LIVING_CANT_PUT_IN_HAND)
		return FALSE

	if(!has_hand_for_held_index(hand_index))
		return FALSE

	return !held_items[hand_index]

/mob/living/carbon/human/can_put_in_hand(obj/item/I, hand_index)
	. = ..()
	if(!.)
		return

	return dna.species.can_equip(I, ITEM_SLOT_HANDS, TRUE, src)

//Puts the item into our active hand if possible. returns TRUE on success.
/mob/proc/put_in_active_hand(obj/item/I, forced = FALSE, ignore_animation = TRUE)
	return put_in_hand(I, active_hand_index, forced, ignore_animation)


//Puts the item into our inactive hand if possible, returns TRUE on success
/mob/proc/put_in_inactive_hand(obj/item/I, forced = FALSE)
	return put_in_hand(I, get_inactive_hand_index(), forced)


//Puts the item our active hand if possible. Failing that it tries other hands. Returns TRUE on success.
//If both fail it drops it on the floor and returns FALSE.
//This is probably the main one you need to know :)
/mob/proc/put_in_hands(obj/item/I, del_on_fail = FALSE, merge_stacks = TRUE, forced = FALSE)
	if(QDELETED(I))
		return FALSE

	// If the item is a stack and we're already holding a stack then merge
	if (istype(I, /obj/item/stack))
		var/obj/item/stack/item_stack = I
		var/obj/item/stack/active_stack = get_active_held_item()

		if (item_stack.is_zero_amount(delete_if_zero = TRUE))
			return FALSE

		if (merge_stacks)
			if (istype(active_stack) && active_stack.can_merge(item_stack))
				if (item_stack.merge(active_stack))
					to_chat(usr, span_notice("Your [active_stack.name] stack now contains [active_stack.get_amount()] [active_stack.singular_name]\s."))
					return TRUE
			else
				var/obj/item/stack/inactive_stack = get_inactive_held_item()
				if (istype(inactive_stack) && inactive_stack.can_merge(item_stack))
					if (item_stack.merge(inactive_stack))
						to_chat(usr, span_notice("Your [inactive_stack.name] stack now contains [inactive_stack.get_amount()] [inactive_stack.singular_name]\s."))
						return TRUE

	if(put_in_active_hand(I, forced))
		return TRUE

	var/hand = get_empty_held_index_for_side(LEFT_HANDS)
	if(!hand)
		hand = get_empty_held_index_for_side(RIGHT_HANDS)
	if(hand)
		if(put_in_hand(I, hand, forced))
			return TRUE
	if(del_on_fail)
		qdel(I)
		return FALSE
	I.layer = initial(I.layer)
	I.plane = initial(I.plane)
	I.unequipped(src)
	I.forceMove(drop_location())
	return FALSE

/mob/proc/drop_all_held_items()
	. = FALSE
	for(var/obj/item/I in held_items)
		. |= dropItemToGround(I)

/mob/proc/putItemFromInventoryInHandIfPossible(obj/item/I, hand_index, force_removal = FALSE, use_unequip_delay = FALSE)
	if(!can_put_in_hand(I, hand_index))
		return FALSE
	if(!temporarilyRemoveItemFromInventory(I, force_removal, use_unequip_delay = use_unequip_delay))
		return FALSE

	I.remove_item_from_storage(src)

	if(!pickup_item(I, hand_index, ignore_anim = TRUE))
		qdel(I)
		CRASH("Assertion failure: putItemFromInventoryInHandIfPossible") //should never be possible
	return TRUE

/// Switches the items inside of two hand indexes.
/mob/proc/swapHeldIndexes(index_A, index_B)
	if(index_A == index_B)
		return
	var/obj/item/item_A = get_item_for_held_index(index_A)
	var/obj/item/item_B = get_item_for_held_index(index_B)

	var/failed_uh_oh_abort = FALSE
	if(!(item_A || item_B))
		return
	if(item_A && !temporarilyRemoveItemFromInventory(item_A))
		failed_uh_oh_abort = TRUE
	if(item_B && !temporarilyRemoveItemFromInventory(item_B))
		failed_uh_oh_abort = TRUE

	if((item_A && !put_in_hand(item_A, index_B)) || (item_B && !put_in_hand(item_B, index_A)))
		failed_uh_oh_abort = TRUE

	if(failed_uh_oh_abort)
		if(item_A)
			temporarilyRemoveItemFromInventory(item_A)
		if(item_B)
			temporarilyRemoveItemFromInventory(item_B)
		if(item_A)
			put_in_hand(item_A, index_A)
		if(item_B)
			put_in_hand(item_B, index_B)
		return FALSE
	return TRUE

//The following functions are the same save for one small difference

/**
 * Used to drop an item (if it exists) to the ground.
 * * Will pass as TRUE is successfully dropped, or if there is no item to drop.
 * * Will pass FALSE if the item can not be dropped due to TRAIT_NODROP via tryUnequipItem()
 * If the item can be dropped, it will be forceMove()'d to the ground and the turf's Entered() will be called.
*/
/mob/proc/dropItemToGround(obj/item/I, force = FALSE, silent = FALSE, invdrop = TRUE, animate = TRUE, use_unequip_delay = FALSE)
	. = tryUnequipItem(I, force, drop_location(), FALSE, invdrop = invdrop, silent = silent, use_unequip_delay = use_unequip_delay)
	if(!. || !I) //ensure the item exists and that it was dropped properly.
		return

	if(!(I.item_flags & NO_PIXEL_RANDOM_DROP))
		I.pixel_x = I.base_pixel_x + rand(-6, 6)
		I.pixel_y = I.base_pixel_y + rand(-6, 6)

	if(animate)
		I.do_drop_animation(src)

//for when the item will be immediately placed in a loc other than the ground. Supports shifting the item's x and y from click modifiers.
/mob/proc/transferItemToLoc(obj/item/I, newloc = null, force = FALSE, silent = TRUE, list/user_click_modifiers, animate = TRUE)
	. = tryUnequipItem(I, force, newloc, FALSE, silent = silent)
	if(!.)
		return

	if(user_click_modifiers)
		//Center the icon where the user clicked.
		if(!LAZYACCESS(user_click_modifiers, ICON_X) || !LAZYACCESS(user_click_modifiers, ICON_Y))
			return
		//Clamp it so that the icon never moves more than 16 pixels in either direction (thus leaving the location)
		I.pixel_x = clamp(text2num(LAZYACCESS(user_click_modifiers, ICON_X)) - 16, -(world.icon_size/2), world.icon_size/2)
		I.pixel_y = clamp(text2num(LAZYACCESS(user_click_modifiers, ICON_Y)) - 16, -(world.icon_size/2), world.icon_size/2)

	if(animate)
		I.do_drop_animation(src)

//visibly unequips I but it is NOT MOVED AND REMAINS IN SRC
//item MUST BE FORCEMOVE'D OR QDEL'D
/mob/proc/temporarilyRemoveItemFromInventory(obj/item/I, force = FALSE, idrop = TRUE, use_unequip_delay = FALSE)
	if((I.item_flags & ABSTRACT) && !force)
		return //Do nothing. Abstract items shouldn't end up in inventories and doing this triggers various odd side effects.
	return tryUnequipItem(I, force, null, TRUE, idrop, silent = TRUE, use_unequip_delay = use_unequip_delay)

// DO NOT CALL THIS PROC
// use one of the above 3 helper procs
// you may override it, but do not modify the args
// Force overrides TRAIT_NODROP for things like wizarditis and admin undress.
// Use no_move if the item is just gonna be immediately moved afterward
// Invdrop is used to prevent stuff in pockets dropping. only set to false if it's going to immediately be replaced
/**
 * Do not call this proc. It is called by the 3 helpers above it.
 * args:
 * * I - The item to unequip.
 * * force - If TRUE, it will ignore canEquipItem and rip it off no matter what.
 * * newloc - The loc the item is being moved to, if any.
 * * no_move - Set TRUE if the item is being moved afterwards anyway.
 * * invdrop - Invdrop is used to prevent stuff in pockets dropping. only set to false if it's going to immediately be replaced.
 * * silent - If TRUE, will not play the item's drop sound.
 * * use_unequip_delay - If TRUE, will run unequip_delay_self_check()
 * * slot - DO NOT USE THIS ARG! It's used because of the awful way overriding this proc works to save on proc calls.
*/
/mob/proc/tryUnequipItem(obj/item/I, force, newloc, no_move, invdrop = TRUE, silent = FALSE, use_unequip_delay = FALSE, slot = get_slot_by_item(I))
	PROTECTED_PROC(TRUE)
	if(!I) //If there's nothing to drop, the drop is automatically succesfull. If(unEquip) should generally be used to check for TRAIT_NODROP.
		return TRUE

	if(!force && !canUnequipItem(I, newloc, no_move, invdrop, silent))
		return FALSE

	if((SEND_SIGNAL(I, COMSIG_ITEM_PRE_UNEQUIP, force, newloc, no_move, invdrop, silent) & COMPONENT_ITEM_BLOCK_UNEQUIP) && !force)
		return FALSE

	var/static/list/exclude_from_unequip_delay = list(null, ITEM_SLOT_RPOCKET, ITEM_SLOT_LPOCKET, ITEM_SLOT_SUITSTORE, ITEM_SLOT_BACKPACK, ITEM_SLOT_HANDS)
	if(use_unequip_delay && !(slot in exclude_from_unequip_delay) && !unequip_delay_self_check(I))
		return FALSE

	var/hand_index = get_held_index_of_item(I)
	if(hand_index)
		held_items[hand_index] = null
		update_held_items()

	if(I)
		if(client)
			client.screen -= I

		I.layer = initial(I.layer)
		I.plane = initial(I.plane)
		I.appearance_flags &= ~NO_CLIENT_COLOR

		if(!no_move && !(I.item_flags & DROPDEL) && !QDELETED(I)) //item may be moved/qdel'd immedietely, don't bother moving it
			if (isnull(newloc))
				I.moveToNullspace()
			else
				I.forceMove(newloc)

		I.unequipped(src, silent)

	SEND_SIGNAL(I, COMSIG_ITEM_POST_UNEQUIP, force, newloc, no_move, invdrop, silent)
	SEND_SIGNAL(src, COMSIG_MOB_UNEQUIPPED_ITEM, I, force, newloc, no_move, invdrop, silent)
	return TRUE

/// Test if an item can be dropped, core to tryUnequipItem()
/mob/proc/canUnequipItem(obj/item/I, newloc, no_move, invdrop, silent)
	if(isnull(I))
		return TRUE

	if(HAS_TRAIT(I, TRAIT_NODROP))
		return FALSE

	return TRUE

/**
 * Used to return a list of equipped items on a mob; does not include held items (use get_all_gear)
 *
 * Argument(s):
 * * Optional - include_pockets (TRUE/FALSE), whether or not to include the pockets and suit storage in the returned list
 */
/mob/proc/get_equipped_items(include_pockets = FALSE)
	return

/mob/living/get_equipped_items(include_pockets = FALSE)
	var/list/items = list()
	for(var/obj/item/item_contents in contents)
		if(item_contents.item_flags & IN_INVENTORY)
			items += item_contents
	items -= held_items
	return items

/// Gets what slot the item on the mob is held in.
/// Returns null if the item isn't in any slots on our mob.
/// Does not check if the passed item is null, which may result in unexpected outcoms.
/mob/proc/get_slot_by_item(obj/item/looking_for)
	if(looking_for in held_items)
		return ITEM_SLOT_HANDS

	return null

/**
 * Used to return a list of equipped items on a human mob; does not include held items (use get_all_gear)
 *
 * Argument(s):
 * * Optional - include_pockets (TRUE/FALSE), whether or not to include the pockets and suit storage in the returned list
 */

/mob/living/carbon/human/get_equipped_items(include_pockets = FALSE)
	var/list/items = ..()
	if(!include_pockets)
		items -= list(l_store, r_store, s_store)
	return items

/// Drop all items to the floor.
/mob/living/proc/unequip_everything()
	for(var/I in get_equipped_items(TRUE))
		dropItemToGround(I)
	drop_all_held_items()

/// Delete all held/equipped items.
/mob/living/proc/wipe_inventory()
	for(var/I in get_equipped_items(TRUE) | held_items)
		qdel(I)

/// Compiles all flags_inv vars of worn items.
/mob/living/carbon/proc/update_obscurity()
	PROTECTED_PROC(TRUE)

	obscured_slots = NONE
	for(var/obj/item/I in get_all_worn_items())
		obscured_slots |= I.flags_inv

///Returns a bitfield of covered item slots.
/mob/living/carbon/proc/check_obscured_slots(transparent_protection, input_slots)
	var/obscured = NONE
	var/hidden_slots = !isnull(input_slots) ? input_slots : src.obscured_slots

	if(transparent_protection)
		for(var/obj/item/I in get_all_worn_items())
			hidden_slots |= I.transparent_protection

	if(hidden_slots & HIDENECK)
		obscured |= ITEM_SLOT_NECK
	if(hidden_slots & HIDEMASK)
		obscured |= ITEM_SLOT_MASK
	if(hidden_slots & HIDEEYES)
		obscured |= ITEM_SLOT_EYES
	if(hidden_slots & HIDEEARS)
		obscured |= ITEM_SLOT_EARS
	if(hidden_slots & HIDEGLOVES)
		obscured |= ITEM_SLOT_GLOVES
	if(hidden_slots & HIDEJUMPSUIT)
		obscured |= ITEM_SLOT_ICLOTHING
	if(hidden_slots & HIDESHOES)
		obscured |= ITEM_SLOT_FEET
	if(hidden_slots & HIDESUITSTORAGE)
		obscured |= ITEM_SLOT_SUITSTORE
	if(hidden_slots & HIDEHEADGEAR)
		obscured |= ITEM_SLOT_HEAD

	return obscured

/// Update any visuals relating to an item when it's equipped, unequipped, or it's flags_inv changes.
/mob/living/proc/update_slots_for_item(obj/item/I, equipped_slot = null, force_obscurity_update)
	return

/obj/item/proc/equip_to_best_slot(mob/M)
	if(M.equip_to_appropriate_slot(src))
		M.update_held_items()
		return TRUE
	else
		if(equip_delay_self)
			return

	if(M.active_storage?.attempt_insert(src, M))
		return TRUE

	var/list/obj/item/possible = list(M.get_inactive_held_item(), M.get_item_by_slot(ITEM_SLOT_BELT), M.get_item_by_slot(ITEM_SLOT_DEX_STORAGE), M.get_item_by_slot(ITEM_SLOT_BACK))
	for(var/i in possible)
		if(!i)
			continue
		var/obj/item/I = i
		if(I.atom_storage?.attempt_insert(src, M))
			return TRUE

	to_chat(M, span_warning("You are unable to equip that!"))
	return FALSE


/mob/verb/quick_equip()
	set name = "quick-equip"
	set hidden = TRUE

	DEFAULT_QUEUE_OR_CALL_VERB(VERB_CALLBACK(src, PROC_REF(execute_quick_equip)))

///proc extender of [/mob/verb/quick_equip] used to make the verb queuable if the server is overloaded
/mob/proc/execute_quick_equip()
	var/obj/item/I = get_active_held_item()
	if(!I)
		to_chat(src, span_warning("You are not holding anything to equip!"))
		return

	if(I.equip_to_best_slot(src))
		return

	if(put_in_active_hand(I))
		return

	I.forceMove(drop_location())

//used in code for items usable by both carbon and drones, this gives the proper back slot for each mob.(defibrillator, backpack watertank, ...)
/mob/proc/getBackSlot()
	return ITEM_SLOT_BACK

/mob/proc/getBeltSlot()
	return ITEM_SLOT_BELT



//Inventory.dm is -kind of- an ok place for this I guess

//This is NOT for dismemberment, as the user still technically has 2 "hands"
//This is for multi-handed mobs, such as a human with a third limb installed
//This is a very rare proc to call (besides admin fuckery) so
//any cost it has isn't a worry
/mob/proc/change_number_of_hands(amt)
	if(amt < held_items.len)
		for(var/i in held_items.len to amt step -1)
			dropItemToGround(held_items[i])
	held_items.len = amt

	if(hud_used)
		hud_used.build_hand_slots()


/mob/living/carbon/human/change_number_of_hands(amt)
	var/old_limbs = held_items.len
	if(amt < old_limbs)
		for(var/i in hand_bodyparts.len to amt step -1)
			var/obj/item/bodypart/BP = hand_bodyparts[i]
			BP.dismember()
			hand_bodyparts[i] = null
		hand_bodyparts.len = amt
	else if(amt > old_limbs)
		hand_bodyparts.len = amt
		for(var/i in old_limbs+1 to amt)
			var/path = /obj/item/bodypart/arm/left
			if(!(i % 2))
				path = /obj/item/bodypart/arm/right

			var/obj/item/bodypart/BP = new path ()
			BP.held_index = i
			BP.attach_limb(src, TRUE)
			hand_bodyparts[i] = BP
	..() //Don't redraw hands until we have organs for them

//GetAllContents that is reasonable and not stupid
/mob/living/carbon/proc/get_all_gear()
	var/list/processing_list = get_equipped_items(include_pockets = TRUE) + held_items
	list_clear_nulls(processing_list) // handles empty hands
	var/i = 0
	while(i < length(processing_list) )
		var/atom/A = processing_list[++i]
		if(A.atom_storage)
			var/list/item_stuff = list()
			A.atom_storage.return_inv(item_stuff)
			processing_list += item_stuff
	return processing_list

/// Called when a mob is equipping an item to itself.
/mob/proc/equip_delay_self_check(obj/item/I, bypass_delay)
	return TRUE

/// Called when a mob is unequipping an item from itself.
/mob/proc/unequip_delay_self_check(obj/item/I, bypass_delay)
	return TRUE

#define EQUIPPING_INTERACTION_KEY(item) "equipping_item_[ref(item)]"

/mob/living/carbon/human/equip_delay_self_check(obj/item/I, bypass_delay)
	if(!I.equip_delay_self || bypass_delay)
		return TRUE

	if(DOING_INTERACTION(src, EQUIPPING_INTERACTION_KEY(I)))
		return FALSE

	visible_message(
		span_notice("[src] starts to put on [I]..."),
		span_notice("You start to put on [I]...")
	)

	. = I.do_equip_wait(src)

	if(.)
		visible_message(
			span_notice("[src] puts on [I]."),
			span_notice("You put on [I].")
		)

/mob/living/carbon/human/unequip_delay_self_check(obj/item/I)
	if(!I.equip_delay_self || is_holding(I))
		return TRUE

	if(DOING_INTERACTION(src, EQUIPPING_INTERACTION_KEY(I)))
		return FALSE

	visible_message(
		span_notice("[src] starts to take off [I]..."),
		span_notice("You start to take off [I]..."),
	)

	. = I.do_equip_wait(src)

	if(.)
		visible_message(
			span_notice("[src] takes off [I]."),
			span_notice("You take off [I].")
		)

/// Called by equip_delay_self and unequip_delay_self.
/obj/item/proc/do_equip_wait(mob/living/L)
	var/flags = DO_PUBLIC
	if(equip_self_flags & EQUIP_ALLOW_MOVEMENT)
		flags |= DO_IGNORE_USER_LOC_CHANGE | DO_IGNORE_TARGET_LOC_CHANGE

	if(equip_self_flags & EQUIP_SLOWDOWN)
		L.add_movespeed_modifier(/datum/movespeed_modifier/equipping)

	ADD_TRAIT(L, TRAIT_EQUIPPING_OR_UNEQUIPPING, ref(src))

	. = do_after(L, L, equip_delay_self, flags, interaction_key = EQUIPPING_INTERACTION_KEY(src), display = src)

	REMOVE_TRAIT(L, TRAIT_EQUIPPING_OR_UNEQUIPPING, ref(src))

	if(!HAS_TRAIT(L, TRAIT_EQUIPPING_OR_UNEQUIPPING))
		L.remove_movespeed_modifier(/datum/movespeed_modifier/equipping)

#undef EQUIPPING_INTERACTION_KEY
