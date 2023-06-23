GLOBAL_LIST_EMPTY(augment_items)
GLOBAL_LIST_EMPTY(augment_categories_to_slots)
GLOBAL_LIST_EMPTY(augment_slot_to_items)

/datum/augment_item
	var/name
	///Description of the loadout augment, automatically set by New() if null
	var/description
	///Category in which the augment belongs to. check "_DEFINES/augment.dm"
	var/category = AUGMENT_CATEGORY_NONE
	///Slot in which the augment belongs to, MAKE SURE THE SAME SLOT IS ONLY IN ONE CATEGORY
	var/slot = AUGMENT_SLOT_NONE
	///Can multiple of this type be taken?
	var/exclusive = TRUE
	///Typepath to the augment being used
	var/path

/datum/augment_item/New()
	if(!description && path)
		var/obj/O = path
		description = initial(O.desc)

/datum/augment_item/proc/apply_to_human(mob/living/carbon/human/H, datum/species/S)
	return

/datum/augment_item/proc/can_apply_to_species(datum/species/S)
	return TRUE
