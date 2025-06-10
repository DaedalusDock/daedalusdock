/obj/structure/trash_can
	name = "trash can"
	desc = "I'm the trash can."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "trashcan"

	density = TRUE
	anchored = TRUE

	max_integrity = 200
	armor = list(BLUNT = 20, PUNCTURE = 50, SLASH = 70, LASER = 10, ENERGY = 0, BOMB = 10, BIO = 0, FIRE = 70, ACID = 60)

	/// The currently inserted trashbag, if any
	var/obj/item/storage/bag/trash/trash_bag

/obj/structure/trash_can/Initialize(mapload)
	. = ..()
	set_trash_bag(new /obj/item/storage/bag/trash(src))
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/trash_can/examine(mob/user)
	. = ..()
	#warn trash text

/obj/structure/trash_can/update_overlays()
	. = ..()
	if(length(trash_bag?.contents))
		var/used_ratio = round(trash_bag.get_used_storage_ratio(), 0.01)
		var/trash_state

		if(used_ratio <= 0.33)
			trash_state = "1"

		else if(used_ratio <= 0.66)
			trash_state = "2"

		else
			trash_state = "3"

		. += image(icon = icon, icon_state = "trashcan_trash_[trash_state]")

	. += image(icon = icon, icon_state = "trashcan_overlay")

/obj/structure/trash_can/IsContainedAtomAccessible(atom/contained, atom/movable/user)
	return (contained.loc == trash_bag) || (contained.loc ==  src)

/obj/structure/trash_can/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	if(!isitem(AM) || !trash_bag)
		return ..()

	if(isliving(throwingdatum.thrower))
		var/mob/living/thrower = throwingdatum.thrower
		var/datum/roll_result/result = thrower.stat_roll(4, /datum/rpg_skill/handicraft, -ceil(get_dist_euclidean(src, throwingdatum.origin_turf)))
		if(result.outcome < SUCCESS)
			visible_message(span_warning("[AM] bounces off of [src]'s rim."))
			return ..()

	else if(prob(25))
		visible_message(span_warning("[AM] bounces off of [src]'s rim."))
		return ..()

	if(trash_bag.atom_storage.attempt_insert(AM))
		visible_message(span_notice("[AM] lands in [src]."))
	else
		visible_message(span_notice("[AM] lands on top of [src]."))
		AM.forceMove(loc)

/obj/structure/trash_can/MouseDroppedOn(atom/dropped, mob/living/user)
	. = ..()
	if(isitem(dropped))
		item_interaction(user, dropped)

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

	if(!trash_bag.atom_storage.attempt_insert(tool, user))
		return NONE

	user.visible_message(span_notice("<b>[user]</b> [pick("discards", "dumps", "places", "drops")] [tool] into [src]."))
	return ITEM_INTERACT_SUCCESS

/// Setter for the trash_bag var.
/obj/structure/trash_can/proc/set_trash_bag(obj/item/new_bag)
	if(trash_bag)
		UnregisterSignal(trash_bag, COMSIG_MOVABLE_MOVED)
		UnregisterSignal(trash_bag.atom_storage, list(COMSIG_STORAGE_INSERTED_ITEM, COMSIG_STORAGE_REMOVED_ITEM))
		trash_bag.atom_storage.open_sound = initial(trash_bag.atom_storage.open_sound)
		trash_bag.atom_storage.rustle_sound = initial(trash_bag.atom_storage.rustle_sound)

	trash_bag = new_bag

	if(!isnull(trash_bag))
		RegisterSignal(trash_bag, COMSIG_MOVABLE_MOVED, PROC_REF(bag_moved))
		RegisterSignal(trash_bag.atom_storage, list(COMSIG_STORAGE_INSERTED_ITEM, COMSIG_STORAGE_REMOVED_ITEM), PROC_REF(contents_change))
		trash_bag.atom_storage.open_sound = null
		trash_bag.atom_storage.rustle_sound = null

/// Called when an object is inserted or removed into/from the trash bag.
/obj/structure/trash_can/proc/contents_change(datum/source)
	SIGNAL_HANDLER
	update_appearance()

// Handler for the trash bag disappearing to fuck knows where.
/obj/structure/trash_can/proc/bag_moved(datum/source)
	SIGNAL_HANDLER
	set_trash_bag(null)

