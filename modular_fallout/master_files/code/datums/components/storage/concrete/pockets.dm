/datum/storage/concrete/pockets
	max_specific_storage = 2
	max_specific_storage = WEIGHT_CLASS_SMALL
	max_total_storage = 50
	rustle_sound = FALSE

/datum/storage/concrete/pockets/handle_item_insertion(obj/item/I, prevent_warning, mob/user)
	. = ..()
	if(. && silent && !prevent_warning)
		if(quickdraw)
			to_chat(user, "<span class='notice'>You discreetly slip [I] into [parent]. Alt-click [parent] to remove it.</span>")
		else
			to_chat(user, "<span class='notice'>You discreetly slip [I] into [parent].</span>")

/datum/storage/concrete/pockets/huge
	max_specific_storage = WEIGHT_CLASS_NORMAL

/datum/storage/concrete/pockets/small
	max_specific_storage = 1
	attack_hand_interact = FALSE

/datum/storage/concrete/pockets/small/collar
	max_specific_storage = 1

/datum/storage/concrete/pockets/small/collar
	can_hold = typecacheof(list(
	/obj/item/food/cookie,
	/obj/item/food/cookie/sugar))

/datum/storage/concrete/pockets/small/collar/locked
	can_hold = typecacheof(list(
	/obj/item/food/cookie,
	/obj/item/food/sugarcookie,
	/obj/item/key/collar))

/datum/storage/concrete/pockets/binocular
	max_specific_storage = 1

/datum/storage/concrete/pockets/binocular
	can_hold = GLOB.storage_binocular_can_hold


/datum/storage/concrete/pockets/treasurer
	max_specific_storage = 4

/datum/storage/concrete/pockets/treasurer
	can_hold = GLOB.storage_treasurer_can_hold


/datum/storage/concrete/pockets/bartender
	max_specific_storage = 2

/datum/storage/concrete/pockets/bartender
	can_hold = GLOB.storage_bartender_can_hold


/datum/storage/concrete/pockets/kitchen
	max_specific_storage = 2

/datum/storage/concrete/pockets/kitcheN
	can_hold = GLOB.storage_kitchen_can_hold


/datum/storage/concrete/pockets/crafter
	max_specific_storage = 2

/datum/storage/concrete/pockets/crafter
	can_hold = GLOB.storage_crafter_can_hold


/datum/storage/concrete/pockets/medical
	max_specific_storage = 2

/datum/storage/concrete/pockets/medical
	can_hold = GLOB.storage_medical_can_hold


/datum/storage/concrete/pockets/tiny
	max_specific_storage = 1
	max_specific_storage = WEIGHT_CLASS_TINY
	attack_hand_interact = FALSE

/datum/storage/concrete/pockets/small/detective
	attack_hand_interact = TRUE // so the detectives would discover pockets in their hats

/datum/storage/concrete/pockets/shoes
	attack_hand_interact = FALSE
	quickdraw = TRUE
	silent = TRUE

/datum/storage/concrete/pockets/shoes
	cant_hold = typecacheof(list(/obj/item/screwdriver/power))
	can_hold = GLOB.storage_shoes_can_hold

/datum/storage/concrete/pockets/small/rushelmet
	max_specific_storage = 1
	quickdraw = TRUE

/datum/storage/concrete/pockets/small/rushelmet
	can_hold = GLOB.storage_hat_can_hold


/datum/storage/concrete/pockets/bos/paladin/
	max_specific_storage = 4
	max_specific_storage = WEIGHT_CLASS_NORMAL

/datum/storage/concrete/pockets/bos/paladin/
	can_hold = GLOB.storage_holster_can_hold

/datum/storage/concrete/pockets/small/holdout
	max_specific_storage = 1
	attack_hand_interact = TRUE
	max_specific_storage = WEIGHT_CLASS_NORMAL
	quickdraw = TRUE

/datum/storage/concrete/pockets/small/holdout
	can_hold = GLOB.storage_holdout_can_hold

/datum/storage/concrete/pockets/bulletbelt
	max_specific_storage = 4

/datum/storage/concrete/pockets/bulletbelt
	can_hold = GLOB.storage_bulletbelt_can_hold

GLOBAL_LIST_INIT(storage_bartender_can_hold, typecacheof(list(
	/obj/item/kitchen,
	/obj/item/reagent_containers/cup/glass/bottle,
	/obj/item/gun/ballistic/revolver/detective,
	/obj/item/gun/ballistic/revolver/m29/snub,
	)))

GLOBAL_LIST_INIT(storage_kitchen_can_hold, typecacheof(list(
	/obj/item/kitchen,
	/obj/item/reagent_containers/condiment,
	)))

GLOBAL_LIST_INIT(storage_crafter_can_hold, typecacheof(list(
	/obj/item/crowbar,
	/obj/item/wrench,
	/obj/item/screwdriver,
	/obj/item/multitool,
	/obj/item/wirecutters,
	)))

GLOBAL_LIST_INIT(storage_medical_can_hold, typecacheof(list(
	/obj/item/clothing/mask/surgical,
	/obj/item/clothing/gloves/color/latex,
	/obj/item/clothing/gloves/f13/crudemedical,
	/obj/item/healthanalyzer,
	/obj/item/reagent_containers/dropper,
	/obj/item/reagent_containers/cup/glass/bottle,
	/obj/item/reagent_containers/pill,
	/obj/item/reagent_containers/syringe,
	/obj/item/storage/pill_bottle,
	/obj/item/stack/medical,
	/obj/item/hypospray,
	/obj/item/scalpel,
	/obj/item/bonesetter,
	/obj/item/retractor,
	/obj/item/cautery,
	/obj/item/hemostat,
	/obj/item/clothing/neck/stethoscope,
	/obj/item/storage/bag/chemistry,
	/obj/item/storage/bag/bio,
	/obj/item/reagent_containers/blood,
	/obj/item/reagent_containers/chem_pack,
	)))

GLOBAL_LIST_INIT(storage_shoes_can_hold, typecacheof(list(
	/obj/item/reagent_containers/syringe,
	/obj/item/reagent_containers/hypospray/medipen,
	/obj/item/reagent_containers/dropper,
	/obj/item/screwdriver,
	/obj/item/weldingtool/mini,
	/obj/item/pen,
	/obj/item/gun/ballistic/revolver/detective,
	/obj/item/gun/ballistic/revolver/hobo/knifegun,
	/obj/item/melee/onehanded/knife,
	/obj/item/scalpel,
	)))

GLOBAL_LIST_INIT(storage_holster_can_hold, typecacheof(list(
	/obj/item/gun/ballistic/automatic/pistol,
	/obj/item/gun/ballistic/revolver,
	/obj/item/ammo_box/magazine,
	/obj/item/ammo_box/tube,
	/obj/item/ammo_box/a357,
	/obj/item/ammo_box/c38,
	/obj/item/ammo_box/l10mm,
	/obj/item/ammo_box/a762,
	/obj/item/ammo_box/shotgun,
	/obj/item/ammo_box/m44,
	/obj/item/ammo_box/a762,
	/obj/item/ammo_box/a556/stripper,
	/obj/item/ammo_box/needle,
	/obj/item/ammo_box/a308,
	/obj/item/ammo_box/c4570,
	/obj/item/ammo_box/a50MG,
	/obj/item/gun/energy/laser/solar,
	/obj/item/gun/energy/laser/pistol,
	/obj/item/gun/energy/laser/plasma/pistol,
	/obj/item/gun/energy/laser/plasma/glock,
	/obj/item/gun/energy/laser/plasma/glock/extended,
	/obj/item/gun/energy/laser/wattz,
	/obj/item/gun/energy/laser/wattz/magneto,
	/obj/item/gun/energy/laser/plasma/pistol/alien,
	/obj/item/stock_parts/cell/ammo/ec,
	)))

GLOBAL_LIST_INIT(storage_hat_can_hold, typecacheof(list(
	/obj/item/storage/fancy/cigarettes,
	/obj/item/toy/cards/deck,
	/obj/item/ammo_casing,
	)))

GLOBAL_LIST_INIT(storage_binocular_can_hold, typecacheof(list(
	/obj/item/binoculars,
	)))

GLOBAL_LIST_INIT(storage_treasurer_can_hold, typecacheof(list(
	/obj/item/stack/f13Cash,
	/obj/item/key,
	/obj/item/melee/onehanded/knife,
	/obj/item/paper,
	/obj/item/folder,
	/obj/item/storage/bag/money/small,
	/obj/item/binoculars,
	/obj/item/lipstick,
	/obj/item/pen,
	)))

GLOBAL_LIST_INIT(storage_holdout_can_hold, typecacheof(list(
	/obj/item/gun/ballistic/automatic/pistol/sig,
	/obj/item/gun/ballistic/revolver/detective,
	/obj/item/gun/ballistic/automatic/hobo/zipgun,
	/obj/item/gun/ballistic/automatic/pistol/m1911/compact,
	/obj/item/gun/ballistic/automatic/pistol/pistol14/compact,
	/obj/item/gun/ballistic/revolver/police,
	/obj/item/gun/ballistic/revolver/colt357/lucky,
	/obj/item/gun/ballistic/revolver/m29/snub,
	/obj/item/gun/ballistic/revolver/needler,
	/obj/item/gun/energy/laser/wattz,
)))

GLOBAL_LIST_INIT(storage_bulletbelt_can_hold, typecacheof(list(
	/obj/item/ammo_box/magazine,
	/obj/item/ammo_box/tube,
	/obj/item/ammo_box/a357,
	/obj/item/ammo_box/c38,
	/obj/item/ammo_box/l10mm,
	/obj/item/ammo_box/a762,
	/obj/item/ammo_box/shotgun,
	/obj/item/ammo_box/m44,
	/obj/item/ammo_box/a762,
	/obj/item/ammo_box/a556/stripper,
	/obj/item/ammo_box/needle,
	/obj/item/ammo_box/a308,
	/obj/item/ammo_box/c4570,
	/obj/item/ammo_box/a50MG,
	/obj/item/gun/energy/laser/solar,
	/obj/item/gun/energy/laser/pistol,
	/obj/item/gun/energy/laser/plasma/pistol,
	/obj/item/gun/energy/laser/plasma/glock,
	/obj/item/gun/energy/laser/plasma/glock/extended,
	/obj/item/gun/energy/laser/wattz,
	/obj/item/gun/energy/laser/wattz/magneto,
	/obj/item/gun/energy/laser/plasma/pistol/alien,
	/obj/item/stock_parts/cell/ammo/ec,
)))
