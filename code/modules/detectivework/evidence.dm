/obj/item/storage/evidencebag
	name = "evidence bag"
	desc = "An empty evidence bag."
	icon = 'icons/obj/storage.dmi'
	icon_state = "evidenceobj"
	inhand_icon_state = ""
	w_class = WEIGHT_CLASS_TINY

	// Don't leave fingerprints on items moved into or out of the evidence bag.
	fingerprint_flags_interact_with_atom = parent_type::fingerprint_flags_interact_with_atom &~ (FINGERPRINT_OBJECT_SUCCESS|FINGERPRINT_OBJECT_FAILURE)

/obj/item/storage/evidencebag/Initialize(mapload)
	. = ..()
	atom_storage.max_slots = 1
	atom_storage.max_specific_storage = WEIGHT_CLASS_SMALL
	atom_storage.max_total_storage = WEIGHT_CLASS_SMALL
	atom_storage.set_holdable(null, list(type))

/obj/item/storage/evidencebag/attack_self(mob/user, modifiers)
	. = ..()
	if(.)
		return

	if(!length(contents))
		return

	return user.pickup_item(contents[1], user.get_empty_held_index())

/obj/item/storage/evidencebag/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(length(contents))
		if(isitem(interacting_with))
			return ITEM_INTERACT_BLOCKING

		var/obj/item/stored = contents[1]
		atom_storage.attempt_remove(stored, get_turf(interacting_with), user = user)
		return ITEM_INTERACT_SUCCESS

	if(!isitem(interacting_with))
		return NONE

	var/inserted = atom_storage.attempt_insert(interacting_with, user)
	if(inserted)
		return ITEM_INTERACT_SUCCESS

	return ITEM_INTERACT_BLOCKING

/obj/item/storage/evidencebag/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	var/obj/item/I = arrived
	var/mutable_appearance/in_evidence = new(I)
	in_evidence.plane = FLOAT_PLANE
	in_evidence.layer = FLOAT_LAYER
	in_evidence.pixel_x = 0
	in_evidence.pixel_y = 0
	add_overlay(in_evidence)
	add_overlay("evidence") //should look nicer for transparent stuff. not really that important, but hey.

	desc = "An evidence bag containing [I]. [I.desc]"
	w_class = I.w_class

/obj/item/storage/evidencebag/Exited(atom/movable/gone, direction)
	. = ..()
	cut_overlays() //remove the overlays
	w_class = WEIGHT_CLASS_TINY
	icon_state = "evidenceobj"
	desc = "An empty evidence bag."
