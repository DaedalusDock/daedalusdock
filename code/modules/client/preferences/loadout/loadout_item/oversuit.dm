/datum/loadout_item/suit
	category = LOADOUT_CATEGORY_SUIT

/datum/loadout_item/suit/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	. = outfit.suit
	outfit.suit = path

//MISC
/datum/loadout_item/suit/poncho
	path = /obj/item/clothing/suit/poncho

/datum/loadout_item/suit/ponchogreen
	path = /obj/item/clothing/suit/poncho/green

/datum/loadout_item/suit/ponchored
	path = /obj/item/clothing/suit/poncho/red

/datum/loadout_item/suit/bluesuspenders
	path = /obj/item/clothing/suit/toggle/suspenders/blue

/datum/loadout_item/suit/greysuspenders
	path = /obj/item/clothing/suit/toggle/suspenders/gray

/datum/loadout_item/suit/ianshirt
	path = /obj/item/clothing/suit/ianshirt

//COATS
/datum/loadout_item/suit/coat
	subcategory = LOADOUT_SUBCATEGORY_SUIT_COATS

/datum/loadout_item/suit/coat/normal
	path = /obj/item/clothing/suit/hooded/wintercoat

/datum/loadout_item/suit/coat/tailored
	path = /obj/item/clothing/suit/hooded/wintercoat/custom
	cost = 2

//JACKETS
/datum/loadout_item/suit/jacket
	subcategory = LOADOUT_SUBCATEGORY_SUIT_JACKETS

/datum/loadout_item/suit/jacket/jacketbomber
	path = /obj/item/clothing/suit/jacket

/datum/loadout_item/suit/jacket/jacketleather
	path = /obj/item/clothing/suit/jacket/leather

/datum/loadout_item/suit/jacket/overcoatleather
	path = /obj/item/clothing/suit/jacket/leather/overcoat

/datum/loadout_item/suit/jacket/jacketpuffer
	path = /obj/item/clothing/suit/jacket/puffer

/datum/loadout_item/suit/jacket/vestpuffer
	path = /obj/item/clothing/suit/jacket/puffer/vest

/datum/loadout_item/suit/jacket/jacketlettermanbrown
	path = /obj/item/clothing/suit/jacket/letterman

/datum/loadout_item/suit/jacket/jacketlettermanred
	path = /obj/item/clothing/suit/jacket/letterman_red

/datum/loadout_item/suit/jacket/jacketlettermanNT
	path = /obj/item/clothing/suit/jacket/letterman_nanotrasen

/datum/loadout_item/suit/jacket/overalls
	path = /obj/item/clothing/suit/apron/overalls

/datum/loadout_item/suit/jacket/militaryjacket
	path = /obj/item/clothing/suit/jacket/miljacket

