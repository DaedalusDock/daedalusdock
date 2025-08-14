/datum/component/clothing_lover
	dupe_mode = COMPONENT_DUPE_ALLOWED

	/// A list of clothing paths that will satisfy the component.
	var/list/desired_types

	/// The above but as a typecache. This is for optimizing recheck_slots().
	var/list/desired_types_typecache

	/// Slots to check for the desired types.
	var/check_slots = ALL & ~(ITEM_SLOT_HANDS)

	/// The moodlet path to apply if the wearer isnt wearing any of the desired types.
	var/moodlet_path
	/// The category the moodlet applies to.
	var/moodlet_category

/datum/component/clothing_lover/Initialize( _desired_types, _moodlet_category, _moodlet_path, _check_slots)
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	desired_types = _desired_types
	desired_types_typecache = typecacheof(_desired_types)
	moodlet_path = _moodlet_path
	moodlet_category = _moodlet_category

	if(!isnull(_check_slots))
		check_slots = _check_slots

	RegisterSignal(parent, COMSIG_MOB_EQUIPPED_ITEM, PROC_REF(on_equip_item))
	RegisterSignal(parent, COMSIG_ITEM_POST_UNEQUIP, PROC_REF(on_unequip_item))

	recheck_slots()

/datum/component/clothing_lover/Destroy(force, silent)
	var/mob/living/carbon/human/H = parent
	if(H)
		H.mob_mood.clear_mood_event(moodlet_category)
		UnregisterSignal(H, list(COMSIG_MOB_EQUIPPED_ITEM, COMSIG_ITEM_POST_UNEQUIP))
	return ..()

/datum/component/clothing_lover/proc/recheck_slots()
	var/mob/living/carbon/human/H = parent

	var/list/worn_items = H.get_all_worn_items()
	var/satisfied = FALSE
	for(var/path as anything in desired_types)
		var/obj/item/worn = locate(path) in worn_items
		if(!worn)
			continue

		if(H.get_slot_by_item(worn) & check_slots)
			satisfied = TRUE
			break

	if(satisfied)
		H.mob_mood.clear_mood_event(moodlet_category)
	else
		H.mob_mood.add_mood_event(moodlet_category, moodlet_path)

/datum/component/clothing_lover/proc/on_equip_item(datum/source, obj/item/I, slot)
	SIGNAL_HANDLER
	if(!(slot & check_slots))
		return

	if(!desired_types_typecache[I.type])
		return

	var/mob/living/carbon/human/H = parent
	H.mob_mood.clear_mood_event(moodlet_category)

/datum/component/clothing_lover/proc/on_unequip_item(datum/source, obj/item/I)
	SIGNAL_HANDLER

	recheck_slots()
