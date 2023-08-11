/datum/loadout_item/hands
	category = LOADOUT_CATEGORY_HANDS

/datum/loadout_item/hands/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(!outfit.r_hand && !equipper.get_item_for_held_index(2))
		outfit.r_hand = path
		return
	if(!outfit.l_hand && !equipper.get_item_for_held_index(1))
		outfit.l_hand = path
		return

	if(outfit.r_hand && !equipper.get_item_for_held_index(2))
		. = outfit.r_hand
		outfit.r_hand = path
		return

	if(outfit.l_hand && !equipper.get_item_for_held_index(1))
		. = outfit.l_hand
		outfit.l_hand = path
		return

	return path

//MISC
/datum/loadout_item/hands/cane
	path = /obj/item/cane
