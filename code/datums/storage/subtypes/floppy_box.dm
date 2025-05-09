/datum/storage/box/floppy
	max_slots = 8

/datum/storage/box/floppy/New(atom/parent, max_slots, max_specific_storage, max_total_storage, numerical_stacking, allow_quick_gather, allow_quick_empty, collection_mode, attack_hand_interact)
	. = ..()
	set_holdable(list(
		/obj/item/disk/data/floppy
	))
