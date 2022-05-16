// --- Loadout item datums for exosuits / suits ---

/// Exosuit / Outersuit Slot Items (Moves items to backpack)
GLOBAL_LIST_INIT(loadout_exosuits, generate_loadout_items(/datum/loadout_item/suit))

/datum/loadout_item/suit
	category = LOADOUT_ITEM_SUIT

/datum/loadout_item/suit/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(override_items == LOADOUT_OVERRIDE_BACKPACK && !visuals_only)
		if(outfit.suit)
			LAZYADD(outfit.backpack_contents, outfit.suit)
		outfit.suit = item_path
	else
		outfit.suit = item_path

/datum/loadout_item/suit/winter_coat
	name = "Winter Coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat

/datum/loadout_item/suit/winter_coat_greyscale
	name = "Greyscale Winter Coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/custom

/datum/loadout_item/suit/denim_overalls
	name = "Denim Overalls"
	item_path = /obj/item/clothing/suit/apron/overalls

/datum/loadout_item/suit/black_suit_jacket
	name = "Black Suit Jacket"
	item_path = /obj/item/clothing/suit/toggle/lawyer/black

/datum/loadout_item/suit/blue_suit_jacket
	name = "Blue Suit Jacket"
	item_path = /obj/item/clothing/suit/toggle/lawyer

/datum/loadout_item/suit/purple_suit_jacket
	name = "Purple Suit Jacket"
	item_path = /obj/item/clothing/suit/toggle/lawyer/purple

/datum/loadout_item/suit/purple_apron
	name = "Purple Apron"
	item_path = /obj/item/clothing/suit/apron/purple_bartender

/datum/loadout_item/suit/suspenders_blue
	name = "Blue Suspenders"
	item_path = /obj/item/clothing/suit/toggle/suspenders/blue

/datum/loadout_item/suit/suspenders_grey
	name = "Grey Suspenders"
	item_path = /obj/item/clothing/suit/toggle/suspenders/gray

/datum/loadout_item/suit/suspenders_red
	name = "Red Suspenders"
	item_path = /obj/item/clothing/suit/toggle/suspenders

/datum/loadout_item/suit/white_dress
	name = "White Dress"
	item_path = /obj/item/clothing/suit/whitedress

/datum/loadout_item/suit/labcoat
	name = "Labcoat"
	item_path = /obj/item/clothing/suit/toggle/labcoat

/datum/loadout_item/suit/labcoat_green
	name = "Green Labcoat"
	item_path = /obj/item/clothing/suit/toggle/labcoat/mad

/datum/loadout_item/suit/poncho
	name = "Poncho"
	item_path = /obj/item/clothing/suit/poncho

/datum/loadout_item/suit/poncho_green
	name = "Green Poncho"
	item_path = /obj/item/clothing/suit/poncho/green

/datum/loadout_item/suit/poncho_red
	name = "Red Poncho"
	item_path = /obj/item/clothing/suit/poncho/red

/datum/loadout_item/suit/wawaiian_shirt
	name = "Hawaiian Shirt"
	item_path = /obj/item/clothing/suit/hawaiian

/datum/loadout_item/suit/bomber_jacket
	name = "Bomber Jacket"
	item_path = /obj/item/clothing/suit/jacket

/datum/loadout_item/suit/military_jacket
	name = "Military Jacket"
	item_path = /obj/item/clothing/suit/jacket/miljacket

/datum/loadout_item/suit/puffer_jacket
	name = "Puffer Jacket"
	item_path = /obj/item/clothing/suit/jacket/puffer

/datum/loadout_item/suit/puffer_vest
	name = "Puffer Vest"
	item_path = /obj/item/clothing/suit/jacket/puffer/vest

/datum/loadout_item/suit/leather_jacket
	name = "Leather Jacket"
	item_path = /obj/item/clothing/suit/jacket/leather

/datum/loadout_item/suit/leather_coat
	name = "Leather Coat"
	item_path = /obj/item/clothing/suit/jacket/leather/overcoat

/datum/loadout_item/suit/brown_letterman
	name = "Brown Letterman"
	item_path = /obj/item/clothing/suit/jacket/letterman

/datum/loadout_item/suit/red_letterman
	name = "Red Letterman"
	item_path = /obj/item/clothing/suit/jacket/letterman_red

/datum/loadout_item/suit/blue_letterman
	name = "Blue Letterman"
	item_path = /obj/item/clothing/suit/jacket/letterman_nanotrasen

//MISC
/datum/loadout_item/suit/poncho
	name = "Poncho"
	item_path = /obj/item/clothing/suit/poncho

/datum/loadout_item/suit/ponchogreen
	name = "Green poncho"
	item_path = /obj/item/clothing/suit/poncho/green

/datum/loadout_item/suit/ponchored
	name = "Red poncho"
	item_path = /obj/item/clothing/suit/poncho/red

/datum/loadout_item/suit/ianshirt
	name = "Ian Shirt"
	item_path = /obj/item/clothing/suit/ianshirt

//JOB RELATED

/datum/loadout_item/suit/coat_med
	name = "Medical winter coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/medical
	restricted_roles = list(JOB_CHIEF_MEDICAL_OFFICER, JOB_MEDICAL_DOCTOR) // Reserve it to Medical Doctors, Orderlies, and their boss, the Chief Medical Officer

/datum/loadout_item/suit/coat_sci
	name = "Science winter coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/science
	restricted_roles = list(JOB_RESEARCH_DIRECTOR, JOB_SCIENTIST, JOB_ROBOTICIST) // Reserve it to the Science Departement

/datum/loadout_item/suit/coat_eng
	name = "Engineering winter coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/engineering
	restricted_roles = list(JOB_CHIEF_ENGINEER, JOB_STATION_ENGINEER) // Reserve it to Station Engineers, Engineering Guards, and their boss, the Chief Engineer

/datum/loadout_item/suit/coat_atmos
	name = "Atmospherics winter coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/engineering/atmos
	restricted_roles = list(JOB_CHIEF_ENGINEER, JOB_ATMOSPHERIC_TECHNICIAN) // Reserve it to Atmos Techs and their boss, the Chief Engineer

/datum/loadout_item/suit/coat_hydro
	name = "Hydroponics winter coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/hydro
	restricted_roles = list(JOB_HEAD_OF_PERSONNEL, JOB_BOTANIST) // Reserve it to Botanists and their boss, the Head of Personnel

/datum/loadout_item/suit/coat_cargo
	name = "Cargo winter coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/cargo
	restricted_roles = list(JOB_QUARTERMASTER, JOB_CARGO_TECHNICIAN) // Reserve it to Cargo Techs, Customs Agentes, and their boss, the Quartermaster

/datum/loadout_item/suit/coat_miner
	name = "Mining winter coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/miner
	restricted_roles = list(JOB_QUARTERMASTER, JOB_SHAFT_MINER) // Reserve it to Miners and their boss, the Quartermaster
