/obj/structure/trash_can
	name = "trash can"
	desc = "I'm the trash can."

	max_integrity = 200
	armor = list(BLUNT = 20, PUNCTURE = 50, SLASH = 70, LASER = 10, ENERGY = 0, BOMB = 10, BIO = 0, FIRE = 70, ACID = 60)

	/// The currently inserted trashbag, if any
	var/obj/item/storage/bag/trash/trash_bag

/obj/structure/trash_can/Initialize(mapload)
	. = ..()
	set_trash_bag(new /obj/item/storage/bag/trash(src))

/obj/structure/trash_can/examine(mob/user)
	. = ..()
	#warn trash text

/obj/structure/trash_can/IsContainedAtomAccessible(atom/contained, atom/movable/user)
	return (contained.loc == trash_bag) || (contained.loc ==  src)

/obj/structure/trash_can/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return

	if(!trash_bag)
		return

	if(modifiers?[RIGHT_CLICK])
		return user.pickup_item(trash_bag, user.get_empty_held_index())

	trash_bag.atom_storage.open_storage(user)
	return TRUE

/obj/structure/trash_can/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.combat_mode)
		return NONE

	if(!trash_bag)
		if(!istype(tool, /obj/item/storage/bag/trash))
			to_chat(user, span_warning("There is no trash bag inside of [src], we are civilized people."))
			return NONE

		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING

		user.visible_message(span_notice("<b>[user]</b> lines [src] with [tool]."))
		return ITEM_INTERACT_SUCCESS

	#warn animation
	if(!trash_bag.atom_storage.attempt_insert(tool, user))
		return NONE

	update_appearance()
	trash_bag.update_appearance()
	user.visible_message(span_notice("<b>[user]</b> [pick("discards", "dumps", "places", "drops")] [tool] into [src]."))
	return ITEM_INTERACT_SUCCESS

/// Setter for the trash_bag var.
/obj/structure/trash_can/proc/set_trash_bag(obj/item/new_bag)
	if(trash_bag)
		UnregisterSignal(trash_bag, COMSIG_MOVABLE_MOVED)
		UnregisterSignal(trash_bag.atom_storage, COMSIG_STORAGE_INSERTED_ITEM)

	trash_bag = new_bag

	if(!isnull(trash_bag))
		RegisterSignal(trash_bag, COMSIG_MOVABLE_MOVED, PROC_REF(bag_moved))
		RegisterSignal(trash_bag.atom_storage, COMSIG_STORAGE_INSERTED_ITEM, PROC_REF(on_item_inserted))

/// Called when an object is inserted into the trash bag.
/obj/structure/trash_can/proc/on_item_inserted(datum/source)
	SIGNAL_HANDLER
	update_appearance()

// Handler for the trash bag disappearing to fuck knows where.
/obj/structure/trash_can/proc/bag_moved(datum/source)
	SIGNAL_HANDLER
	set_trash_bag(null)

