/datum/loadout_item/gloves
	category = LOADOUT_CATEGORY_GLOVES

/datum/loadout_item/gloves/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	. = outfit.gloves
	outfit.gloves = path

//MISC
/datum/loadout_item/gloves/fingerless
	path = /obj/item/clothing/gloves/fingerless

/datum/loadout_item/gloves/goldring
	path = /obj/item/clothing/gloves/ring
	cost = 2

/datum/loadout_item/gloves/silverring
	path = /obj/item/clothing/gloves/ring/silver
	cost = 2

/datum/loadout_item/gloves/diamondring
	path = /obj/item/clothing/gloves/ring/diamond
	cost = 4

/datum/loadout_item/gloves/white
	path = /obj/item/clothing/gloves/color/white
	customization_flags = CUSTOMIZE_NAME_DESC_COLOR
