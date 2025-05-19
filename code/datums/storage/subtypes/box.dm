/datum/storage/box
	open_sound = 'sound/storage/box.ogg'

/// Storage type for holding small and skinny objects such as pens or syringes.
/datum/storage/box/small_skinny
	max_slots = 9

/datum/storage/box/small_skinny/New(atom/parent, max_slots, max_specific_storage, max_total_storage, numerical_stacking, allow_quick_gather, allow_quick_empty, collection_mode, attack_hand_interact)
	. = ..()
	set_holdable(list(
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/hypospray,
		/obj/item/pen,
		/obj/item/chalk,
	))
