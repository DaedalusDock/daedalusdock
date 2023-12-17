/obj/item/storage/belt/new_holster

/obj/item/storage/belt/new_holster/create_storage(
		max_slots,
		max_specific_storage,
		max_total_storage,
		numerical_stacking,
		allow_quick_gather,
		allow_quick_empty,
		collection_mode,
		attack_hand_interact,
		list/canhold,
		list/canthold,
		type = /datum/storage/holster
	)

	return ..()

/obj/item/storage/belt/holster/shoulder
	name = "shoulder holster"
	desc = "A rather plain but still cool looking holster that can hold a " + /obj/item/gun/ballistic/revolver/detective::name + "and some small objects."
	icon_state = "holster"
	inhand_icon_state = "holster"
	worn_icon_state = "holster"
	alternate_worn_layer = UNDER_SUIT_LAYER
	w_class = WEIGHT_CLASS_BULKY

/obj/item/storage/belt/new_holster/shoulder/Initialize()
	. = ..()
	var/datum/storage/holster/storage = atom_storage
	storage.holster_slots = 1
	storage.max_slots = 3
	storage.max_specific_storage = WEIGHT_CLASS_TINY
	storage.set_holsterable(
		/obj/item/gun/ballistic/revolver/detective,
	)

/obj/item/storage/belt/new_holster/shoulder/full/PopulateContents()
	generate_items_inside(list(
		/obj/item/gun/ballistic/revolver/detective = 1,
		/obj/item/ammo_box/c38 = 2,
	),src)
