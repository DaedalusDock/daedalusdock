GLOBAL_LIST_EMPTY(augment_items)
GLOBAL_LIST_EMPTY(augment_categories_to_slots)
GLOBAL_LIST_EMPTY(augment_slot_to_items)
/// Map of species > category > slot > item
GLOBAL_LIST_EMPTY(species_augment_tree)

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

/// Returns a tree of species > category > slot > item path
/proc/get_species_augments(datum/species/S)
	RETURN_TYPE(/list)

	var/static/list/augment_tree = list()
	if(istype(S))
		S = S.type

	if(augment_tree[S])
		return augment_tree[S]

	S = new S()

	if(!augment_tree[S.type])
		augment_tree[S.type] = list()

	for(var/datum/augment_item/A as anything in GLOB.augment_items)
		A = GLOB.augment_items[A]

		if(!A.can_apply_to_species(S))
			continue
		if(!augment_tree[S.type][A.category])
			augment_tree[S.type][A.category] = list()
		if(!augment_tree[S.type][A.category][A.slot])
			augment_tree[S.type][A.category][A.slot] = list()
		augment_tree[S.type][A.category][A.slot] += A.type

	return augment_tree[S.type]
