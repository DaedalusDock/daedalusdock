GLOBAL_LIST_EMPTY(cached_holster_typecaches)

/// A type of storage where a number of slots are reserved for a specific type of item
/datum/storage/holster
	insert_preposition = "in"
	quickdraw = TRUE
	rustle_sound = null
	open_sound = null
	close_sound = null
	silent = TRUE

	/// A typecache of items that can be inserted into here in the reserved slots
	var/list/holsterable
	/// How many slots are reserved for the holster list
	var/holster_slots = 1

	var/list/holstered_items

/// Checks if an item is in our holster list and we have room for it in there.
/datum/storage/holster/proc/can_holster_item(obj/item/to_insert)
	if(LAZYLEN(holstered_items) < holster_slots)
		if(is_type_in_typecache(to_insert, holsterable))
			return TRUE

	return FALSE

/datum/storage/holster/check_weight_class(obj/item/to_insert)
	if(can_holster_item(to_insert, real_location))
		return TRUE

	return ..()

/datum/storage/holster/check_slots_full(obj/item/to_insert)
	if(can_holster_item(to_insert, real_location))
		return TRUE

	return ..()

/datum/storage/holster/check_typecache_for_item(obj/item/to_insert)
	if(can_holster_item(to_insert, real_location))
		return TRUE

	return ..()

/datum/storage/holster/check_total_weight(obj/item/to_insert)
	var/total_weight = to_insert.w_class

	for(var/obj/item/thing in real_location)
		if(thing in holstered_items)
			continue
		total_weight += thing.w_class

	if(total_weight > max_total_storage)
		return FALSE

	return TRUE

/datum/storage/holster/contents_for_display()
	var/list/contents = real_location.contents - holstered_items
	contents.Insert(1, holstered_items)
	return contents

/datum/storage/holster/get_quickdraw_item()
	return (locate(/obj/item) in holstered_items) || ..()

/datum/storage/holster/handle_enter(datum/source, obj/item/arrived)
	. = ..()

	if(LAZYLEN(holstered_items) < holster_slots && is_type_in_typecache(arrived, holsterable))
		LAZYADD(holstered_items, arrived)

/datum/storage/holster/handle_exit(datum/source, obj/item/gone)
	. = ..()

	LAZYREMOVE(holstered_items, gone)

/datum/storage/holster/proc/set_holsterable(list/new_holsterable)
	if(!islist(new_holsterable))
		new_holsterable = list(new_holsterable)

	var/unique_key = json_encode(new_holsterable)
	if(!GLOB.cached_holster_typecaches[unique_key])
		GLOB.cached_holster_typecaches[unique_key] = typecacheof(new_holsterable)
	holsterable = GLOB.cached_holster_typecaches[unique_key]
