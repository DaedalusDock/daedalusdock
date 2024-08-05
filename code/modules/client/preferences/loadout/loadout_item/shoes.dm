/datum/loadout_item/shoes
	category = LOADOUT_CATEGORY_SHOES

/datum/loadout_item/shoes/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	. = outfit.shoes
	outfit.shoes = path

//MISC
/datum/loadout_item/shoes/laceup
	path = /obj/item/clothing/shoes/laceup

/datum/loadout_item/shoes/workboots
	path = /obj/item/clothing/shoes/workboots

/datum/loadout_item/shoes/jackboots
	path = /obj/item/clothing/shoes/jackboots

/datum/loadout_item/shoes/winterboots
	path = /obj/item/clothing/shoes/winterboots

/datum/loadout_item/shoes/sandals
	path = /obj/item/clothing/shoes/sandal

/datum/loadout_item/shoes/blackshoes
	path = /obj/item/clothing/shoes/sneakers/black

/datum/loadout_item/shoes/brownshoes
	path = /obj/item/clothing/shoes/sneakers/brown

/datum/loadout_item/shoes/whiteshoes
	path = /obj/item/clothing/shoes/sneakers/white

/datum/loadout_item/shoes/gildedcuffs
	path= /obj/item/clothing/shoes/legwraps

/datum/loadout_item/shoes/silvercuffs
	path= /obj/item/clothing/shoes/legwraps/silver

/datum/loadout_item/shoes/redcuffs
	path= /obj/item/clothing/shoes/legwraps/red

/datum/loadout_item/shoes/bluecuffs
	path= /obj/item/clothing/shoes/legwraps/blue

/datum/loadout_item/shoes/russian
	path = /obj/item/clothing/shoes/russian

/datum/loadout_item/shoes/cowboyboots
	path = /obj/item/clothing/shoes/cowboy

/datum/loadout_item/shoes/cowboyboots/black
	path = /obj/item/clothing/shoes/cowboy/black

/datum/loadout_item/shoes/cowboyboots/fancy
	path = /obj/item/clothing/shoes/cowboy/fancy
	cost = 2

/datum/loadout_item/shoes/yellowsinger
	path = /obj/item/clothing/shoes/singery

/datum/loadout_item/shoes/swag
	path = /obj/item/clothing/shoes/swagshoes
	cost = 4

/datum/loadout_item/shoes/wheelys
	path = /obj/item/clothing/shoes/wheelys
	cost = 4

/datum/loadout_item/shoes/rollerskates
	path = /obj/item/clothing/shoes/wheelys/rollerskates
	cost = 3
