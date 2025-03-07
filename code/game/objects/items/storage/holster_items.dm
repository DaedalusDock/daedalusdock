/obj/item/storage/belt/holster
	alternate_worn_layer = UNDER_SUIT_LAYER
	w_class = WEIGHT_CLASS_BULKY
	storage_type = /datum/storage/holster

/// Detective's shoulder holster.
/obj/item/storage/belt/holster/shoulder
	name = "revolver shoulder holster"
	desc = "A strap of leather designed to hold a " + /obj/item/gun/ballistic/revolver/detective::name + " and some small objects."
	icon_state = "holster"
	inhand_icon_state = "holster"
	worn_icon_state = "holster"
	alternate_worn_layer = UNDER_SUIT_LAYER
	w_class = WEIGHT_CLASS_BULKY

/obj/item/storage/belt/holster/shoulder/Initialize()
	. = ..()
	var/datum/storage/holster/storage = atom_storage
	storage.holster_slots = 1
	storage.max_slots = 3
	storage.max_specific_storage = WEIGHT_CLASS_TINY
	storage.set_holsterable(
		/obj/item/gun/ballistic/revolver,
	)

/obj/item/storage/belt/holster/shoulder/full/PopulateContents()
	generate_items_inside(list(
		/obj/item/gun/ballistic/revolver/detective = 1,
		/obj/item/ammo_box/c38 = 2,
	),src)

/// Generic shoulder holster for holding small arms
/obj/item/storage/belt/holster/shoulder/generic
	name = "small shoulder holster"

/obj/item/storage/belt/holster/shoulder/generic/Initialize()
	. = ..()
	var/datum/storage/holster/storage = atom_storage
	storage.max_slots = 1
	storage.holster_slots = 1
	storage.set_holsterable(list(
		/obj/item/gun/ballistic/automatic/pistol,
		/obj/item/gun/ballistic/revolver,
		/obj/item/gun/energy/e_gun/mini,
		/obj/item/gun/energy/disabler,
		/obj/item/gun/energy/dueling,
		/obj/item/food/grown/banana,
		/obj/item/gun/energy/laser/thermal
	))

/obj/item/storage/belt/holster/shoulder/ert
	name = "marine's holster"
	desc = "A rather plain but still cool looking holster that can hold an " + /obj/item/gun/ballistic/automatic/pistol/m1911::name + "and some small objects."
	icon_state = "syndicate_holster"
	inhand_icon_state = "syndicate_holster"
	worn_icon_state = "syndicate_holster"

/obj/item/storage/belt/holster/shoulder/ert/Initialize()
	. = ..()
	var/datum/storage/holster/storage = atom_storage
	storage.holster_slots = 1
	storage.max_slots = 3
	storage.max_specific_storage = WEIGHT_CLASS_TINY
	storage.set_holsterable(
		/obj/item/gun/ballistic/automatic/pistol/m1911,
	)

/obj/item/storage/belt/holster/shoulder/ert/full/PopulateContents()
	generate_items_inside(list(
		/obj/item/gun/ballistic/automatic/pistol/m1911 = 1,
		/obj/item/ammo_box/magazine/m45 = 2,
	),src)

//
// CHAMELEON HOLSTER
//
/obj/item/storage/belt/holster/shoulder/chameleon
	name = "chameleon holster"
	desc = "A hip holster that uses chameleon technology to disguise itself, due to the added chameleon tech, it cannot be mounted onto armor."
	icon_state = "syndicate_holster"
	inhand_icon_state = "syndicate_holster"
	worn_icon_state = "syndicate_holster"
	w_class = WEIGHT_CLASS_NORMAL
	var/datum/action/item_action/chameleon/change/chameleon_action

/obj/item/storage/belt/holster/shoulder/chameleon/Initialize(mapload)
	. = ..()

	chameleon_action = new(src)
	chameleon_action.chameleon_type = /obj/item/storage/belt
	chameleon_action.chameleon_name = "Belt"
	chameleon_action.initialize_disguises()
	add_item_action(chameleon_action)

/obj/item/storage/belt/holster/shoulder/chameleon/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	chameleon_action.emp_randomise()

/obj/item/storage/belt/holster/shoulder/chameleon/broken/Initialize(mapload)
	. = ..()
	chameleon_action.emp_randomise(INFINITY)

/obj/item/storage/belt/holster/shoulder/chameleon/Initialize()
	. = ..()
	var/datum/storage/holster/storage = atom_storage
	storage.max_slots = 2
	storage.max_total_storage = WEIGHT_CLASS_TINY * 2
	storage.holster_slots = 1
	storage.set_holsterable(list(
		/obj/item/gun/ballistic/automatic/pistol,
		/obj/item/gun/ballistic/revolver,
		/obj/item/ammo_box/magazine/toy/pistol,
		/obj/item/gun/energy/recharge/ebow,
		/obj/item/gun/energy/e_gun/mini,
		/obj/item/gun/energy/disabler,
		/obj/item/gun/energy/dueling
	))

	storage.set_holdable(list(
		/obj/item/ammo_box/c38,
		/obj/item/ammo_box/a357,
		/obj/item/ammo_box/a762,
		/obj/item/ammo_box/magazine/toy/pistol,
		/obj/item/ammo_box/magazine/m9mm,
		/obj/item/ammo_box/magazine/m9mm_aps,
		/obj/item/ammo_box/magazine/m45,
		/obj/item/ammo_box/magazine/m50,
	))

//
// NUKIE HOLSTER
//
/obj/item/storage/belt/holster/shoulder/nukie
	name = "operative holster"
	desc = "A deep shoulder holster capable of holding almost any form of firearm and its ammo."
	icon_state = "syndicate_holster"
	inhand_icon_state = "syndicate_holster"
	worn_icon_state = "syndicate_holster"
	w_class = WEIGHT_CLASS_BULKY

/obj/item/storage/belt/holster/shoulder/nukie/Initialize()
	. = ..()
	var/datum/storage/holster/storage = atom_storage
	storage.max_slots = 2
	storage.max_total_storage = WEIGHT_CLASS_BULKY
	storage.holster_slots = 1
	storage.max_slots = 2
	storage.set_holsterable(list(
		/obj/item/gun, // ALL guns.
	))

	storage.set_holdable(list(
		/obj/item/ammo_box/magazine, // ALL magazines.
		/obj/item/ammo_box/c38, //There isn't a speedloader parent type, so I just put these three here by hand.
		/obj/item/ammo_box/a357, //I didn't want to just use /obj/item/ammo_box, because then this could hold huge boxes of ammo.
		/obj/item/ammo_box/a762,
		/obj/item/ammo_casing, // For shotgun shells, rockets, launcher grenades, and a few other things.
		/obj/item/grenade, // All regular grenades, the big grenade launcher fires these.
	))


//
// THERMAL HOLSTER
//
/obj/item/storage/belt/holster/shoulder/thermal
	name = "thermal shoulder holsters"
	desc = "A rather plain pair of shoulder holsters with a bit of insulated padding inside. Meant to hold a twinned pair of thermal pistols, but can fit several kinds of energy handguns as well."

/obj/item/storage/belt/holster/shoulder/thermal/Initialize()
	. = ..()
	// So here we're making ONE slot a holster, so you can hold 2 thermal pistols or 1 E gun
	var/datum/storage/holster/storage = atom_storage
	storage.max_slots = 2
	storage.holster_slots = 1
	storage.max_specific_storage = /obj/item/gun/energy/laser/thermal::w_class
	storage.set_holdable(list(
		/obj/item/gun/energy/e_gun/mini,
		/obj/item/gun/energy/disabler,
		/obj/item/gun/energy/dueling,
		/obj/item/food/grown/banana,
		/obj/item/gun/energy/laser/thermal
	))
	storage.set_holsterable(
		/obj/item/gun/energy/laser/thermal,
	)

/obj/item/storage/belt/holster/shoulder/thermal/PopulateContents()
	generate_items_inside(list(
		/obj/item/gun/energy/laser/thermal/inferno = 1,
		/obj/item/gun/energy/laser/thermal/cryo = 1,
	),src)

/// Security sidearm + gear belt.
/obj/item/storage/belt/holster/security
	name = "tactical holster belt"
	desc = "A security belt with small gear pouches and a hip-holster for a sidearm."
	icon_state = "security"
	inhand_icon_state = "security"
	worn_icon_state = "security"
	alternate_worn_layer = UNDER_SUIT_LAYER
	w_class = WEIGHT_CLASS_BULKY

/obj/item/storage/belt/holster/security/Initialize()
	. = ..()
	var/datum/storage/holster/storage = atom_storage
	storage.holster_slots = 1
	storage.max_slots = 5
	storage.max_specific_storage = WEIGHT_CLASS_TINY
	storage.set_holsterable(list(
		/obj/item/gun/ballistic/automatic/pistol,
		/obj/item/gun/ballistic/revolver,
		/obj/item/gun/energy/disabler,
	))
	//LIST DIRECTLY COPIED FROM SEC BELT!! REVIEW LATER
	storage.set_holdable(list(
		/obj/item/ammo_box,
		/obj/item/ammo_casing/shotgun,
		/obj/item/assembly/flash/handheld,
		/obj/item/clothing/glasses,
		/obj/item/clothing/gloves,
		/obj/item/flashlight/seclite,
		/obj/item/food/donut,
		/obj/item/grenade,
		/obj/item/holosign_creator/security,
		/obj/item/knife/combat,
		/obj/item/melee/baton,
		/obj/item/grenade,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/restraints/handcuffs,
		/obj/item/clothing/glasses,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_box,
		/obj/item/food/donut,
		/obj/item/knife/combat,
		/obj/item/flashlight/seclite,
		/obj/item/radio,
		/obj/item/clothing/gloves,
		/obj/item/restraints/legcuffs/bola,
		/obj/item/holosign_creator/security,
		))

/obj/item/storage/belt/holster/security/full/PopulateContents()
	new /obj/item/reagent_containers/spray/pepper(src)
	new /obj/item/restraints/handcuffs(src)
	new /obj/item/grenade/flashbang(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/melee/baton/security/loaded(src)
	update_appearance()
