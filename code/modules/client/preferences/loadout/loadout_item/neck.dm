/datum/loadout_item/neck
	category = LOADOUT_CATEGORY_NECK

//MISC
/datum/loadout_item/neck/headphones
	path = /obj/item/clothing/ears/headphones

/datum/loadout_item/neck/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	. = outfit.neck
	outfit.neck = path

/datum/loadout_item/neck/goldnecklace
	path = /obj/item/clothing/neck/necklace/dope
	cost = 3

/datum/loadout_item/neck/collar
	path = /obj/item/clothing/neck/petcollar
	description = "You really should not be wearing this."

/datum/loadout_item/neck/beads
	path = /obj/item/clothing/neck/beads

//SCARVES
/datum/loadout_item/neck/scarf
	subcategory = LOADOUT_SUBCATEGORY_NECK_SCARVES

/datum/loadout_item/neck/scarf/scarf
	path = /obj/item/clothing/neck/scarf

/datum/loadout_item/neck/scarf/blackscarf
	path = /obj/item/clothing/neck/scarf/black

/datum/loadout_item/neck/scarf/redscarf
	path = /obj/item/clothing/neck/scarf/red

/datum/loadout_item/neck/scarf/greenscarf
	path = /obj/item/clothing/neck/scarf/green

/datum/loadout_item/neck/scarf/darkbluescarf
	path = /obj/item/clothing/neck/scarf/darkblue

/datum/loadout_item/neck/scarf/purplescarf
	path = /obj/item/clothing/neck/scarf/purple

/datum/loadout_item/neck/scarf/yellowscarf
	path = /obj/item/clothing/neck/scarf/yellow

/datum/loadout_item/neck/scarf/orangescarf
	path = /obj/item/clothing/neck/scarf/orange

/datum/loadout_item/neck/scarf/cyanscarf
	path = /obj/item/clothing/neck/scarf/cyan

/datum/loadout_item/neck/scarf/stripedredscarf
	path = /obj/item/clothing/neck/stripedredscarf

/datum/loadout_item/neck/scarf/stripedbluescarf
	path = /obj/item/clothing/neck/stripedbluescarf

/datum/loadout_item/neck/scarf/stripedgreenscarf
	path = /obj/item/clothing/neck/stripedgreenscarf

/datum/loadout_item/neck/scarf/zebra
	path = /obj/item/clothing/neck/scarf/zebra

//TIES
/datum/loadout_item/neck/tie
	subcategory = LOADOUT_SUBCATEGORY_NECK_TIE

/datum/loadout_item/neck/tie/bluetie
	path = /obj/item/clothing/neck/tie/blue

/datum/loadout_item/neck/tie/redtie
	path = /obj/item/clothing/neck/tie/red

/datum/loadout_item/neck/tie/blacktie
	path = /obj/item/clothing/neck/tie/black

/datum/loadout_item/neck/tie/horrible
	path = /obj/item/clothing/neck/tie/horrible
