/datum/loadout_item/glasses
	category = LOADOUT_CATEGORY_GLASSES

/datum/loadout_item/glasses/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	. = outfit.glasses
	outfit.glasses = path

//MISC
/datum/loadout_item/glasses/blindfold
	path = /obj/item/clothing/glasses/blindfold

/datum/loadout_item/glasses/trickblindfold
	name = "blindfold (fake)"
	path = /obj/item/clothing/glasses/trickblindfold

/datum/loadout_item/glasses/cold
	path = /obj/item/clothing/glasses/cold

/datum/loadout_item/glasses/eyepatch
	path = /obj/item/clothing/glasses/eyepatch

/datum/loadout_item/glasses/heat
	path = /obj/item/clothing/glasses/heat

/datum/loadout_item/glasses/hipster
	path = /obj/item/clothing/glasses/regular/hipster

/datum/loadout_item/glasses/jamjar
	path = /obj/item/clothing/glasses/regular/jamjar

/datum/loadout_item/glasses/circle
	path = /obj/item/clothing/glasses/regular/circle

/datum/loadout_item/glasses/monocle
	path = /obj/item/clothing/glasses/monocle

/datum/loadout_item/glasses/orange
	path = /obj/item/clothing/glasses/orange
	customization_flags = CUSTOMIZE_NAME_DESC_ROTATION

/datum/loadout_item/glasses/red
	path = /obj/item/clothing/glasses/red
	customization_flags = CUSTOMIZE_NAME_DESC_ROTATION

/datum/loadout_item/glasses/prescription
	path = /obj/item/clothing/glasses/regular
