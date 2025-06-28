DEFINE_INTERACTABLE(/obj/structure/trash_can)

TYPEINFO_DEF(/obj/structure/trash_can)
	default_armor = list(BLUNT = 20, PUNCTURE = 50, SLASH = 70, LASER = 10, ENERGY = 0, BOMB = 10, BIO = 0, FIRE = 70, ACID = 60)

/obj/structure/trash_can
	name = "trash can"
	desc = "A steel framed bin for discarded items."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "trashcan"

	density = TRUE
	anchored = TRUE

	max_integrity = 200

	/// The currently inserted trashbag, if any
	var/obj/item/storage/bag/trash/trash_bag

/obj/structure/trash_can/Initialize(mapload)
	. = ..()
	set_trash_bag(new /obj/item/storage/bag/trash(src))

/obj/structure/trash_can/Destroy()
	QDEL_NULL(trash_bag)
	return ..()

/obj/structure/trash_can/examine(mob/user)
	. = ..()
	if(anchored)
		. += span_info("It is bolted to the floor.")

	if(!trash_bag)
		. += span_alert("There is no trash bag inside.")
	else
		switch(round(trash_bag.get_used_storage_ratio(), 0.01))
			if(0)
				. += span_info("It is empty.")
			if(0.01 to 0.49)
				. += span_info("There is some trash at the bottom.")
			if(0.5 to 0.8)
				. += span_info("It is about half full.")
			else
				. += span_info("It is almost overflowing.")

	var/datum/roll_result/result = user.get_examine_result("trashcan_examine", 11)
	if(result?.outcome >= SUCCESS)
		result.do_skill_sound(user)
		. += result.create_tooltip("A relic of municipal design, the steel trash can stands stoic and immovable. Chipped paint and rust's first blossom rides along the rim, a symbol time has long forgotten, faded away on the side.", body_only = TRUE)

/obj/structure/trash_can/disco_flavor(mob/living/carbon/human/user, nearby, is_station_level)
	. = ..()
	var/datum/roll_result/result = user.get_examine_result("trashcan_flavor", 11, only_once = TRUE)
	if(result?.outcome >= SUCCESS)
		result.do_skill_sound(user)
		to_chat(
			user,
			result.create_tooltip("An envelope falls into it's metal tomb, staring up at its previous owner as a tear falls upon it. Soft weeping echoes throughout the hollow chamber as the man fades into the cityscape."),
		)
	else
		var/datum/roll_result/other_result = user.get_examine_result("trashcan_federation_flavor", 12, only_once = TRUE)
		if(other_result?.outcome >= SUCCESS)
			other_result.do_skill_sound(user)
			to_chat(
				user,
				other_result.create_tooltip("A faceless worker bearing the emblem of the Federation stands up, admiring his work with a wide smile."),
			)

/obj/structure/trash_can/update_overlays()
	. = ..()
	if(trash_bag)
		. += image(icon = icon, icon_state = "trashcan_bag")

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

/obj/structure/trash_can/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)
	. = ..()
	if(!.)
		return

	if(over == usr)
		trash_bag?.atom_storage.open_storage(usr)

/obj/structure/trash_can/MouseDroppedOn(atom/dropped, mob/living/user)
	. = ..()
	if(isitem(dropped))
		item_interaction(user, dropped)

/obj/structure/trash_can/AltClick(mob/user)
	if(trash_bag?.atom_storage.open_storage(user))
		return

	return ..()

/obj/structure/trash_can/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return

	if(!trash_bag)
		return

	if(modifiers?[RIGHT_CLICK])
		var/obj/item/bag_ref = trash_bag
		if(user.pickup_item(trash_bag, user.get_empty_held_index()))
			bag_ref.do_pickup_animation(user, loc)
			return TRUE

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

		set_trash_bag(tool)
		user.visible_message(span_notice("<b>[user]</b> lines [src] with [tool]."))
		return ITEM_INTERACT_SUCCESS

	if(!trash_bag.atom_storage.attempt_insert(tool, user))
		return NONE

	user.visible_message(span_notice("<b>[user]</b> [pick("discards", "dumps", "places", "drops")] [tool] into [src]."))
	return ITEM_INTERACT_SUCCESS

/obj/structure/trash_can/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	return default_unfasten_wrench(user, tool, 4 SECONDS)

/// Setter for the trash_bag var.
/obj/structure/trash_can/proc/set_trash_bag(obj/item/new_bag)
	if(trash_bag)
		UnregisterSignal(trash_bag, COMSIG_MOVABLE_MOVED)
		UnregisterSignal(trash_bag.atom_storage, list(COMSIG_STORAGE_INSERTED_ITEM, COMSIG_STORAGE_REMOVED_ITEM))
		trash_bag.atom_storage.open_sound = initial(trash_bag.atom_storage.open_sound)
		trash_bag.atom_storage.rustle_sound = initial(trash_bag.atom_storage.rustle_sound)

	trash_bag = new_bag

	update_appearance()
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

