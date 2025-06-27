//Fallout 13 shoes directory
/*
/obj/item/clothing/shoes
	var/stepsound = TRUE
*/
/obj/item/clothing/shoes/f13
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/shoes

/obj/item/clothing/shoes/f13/enclave/serviceboots
	name = "enclave service boots"
	desc = "(III)Tall shiny boots with kevlar layers."
	icon_state = "boots_enclave"
	inhand_icon_state = "boots_enclave"

/obj/item/clothing/shoes/f13/rag
	name = "footcloths"
	desc = "Ripped cloth used as improvised foot strips, instead of shoes. Crude and gets dirty fast."
	icon_state = "rag"
	inhand_icon_state = "rag"

/obj/item/clothing/shoes/f13/tan
	name = "tan shoes"
	desc = "A pair of tanned leather shoes."
	icon_state = "tan"
	inhand_icon_state = "tan"

/obj/item/clothing/shoes/f13/brownie //Make a craft recipe, and delete this comment.
	name = "brown shoes"
	desc = "A pair of brown leather shoes made of wasteland animals hides."
	icon_state = "brownie"
	inhand_icon_state = "brownie"

/obj/item/clothing/shoes/f13/fancy
	name = "black shoes"
	desc = "A pair of fancy black shoes." //Nice shoes!
	icon_state = "fancy"
	inhand_icon_state = "fancy"

/obj/item/clothing/shoes/f13/cowboy
	name = "cowboy boots"
	desc = "A pair of cowhide boots with spurs.<br>They have a Cuban heel, rounded to pointed toe, high shaft, and, traditionally, no lacing."
	icon_state = "cowboy"
	inhand_icon_state = "cowboy"

/obj/item/clothing/shoes/f13/explorer
	name = "worn boots"
	desc = "A pair of slightly worn, steel-toed work boots.<br>Good at keeping toes safe from falling junk you find amid the ruins."
	icon_state = "explorer"
	armor = list(melee = 10, bullet = 10, laser = 0, energy = 0, bomb = 10, bio = 0, rad = 0, fire = 10, acid = 0)

/obj/item/clothing/shoes/f13/raidertreads
	name = "raider treads"
	desc = "A decrepit boot on one foot, fuckall on the other, the height of raider fashion."
	icon_state = "raidertreads"
	inhand_icon_state = "raidertreads"

/obj/item/clothing/shoes/f13/diesel
	name = "male diesel boots"
	desc = "Fancy mens' steel-toed boots."
	icon_state = "diesel_m"
	inhand_icon_state = "diesel_m"
	armor = list(melee = 20, bullet = 10, laser = 10, energy = 10, bomb = 10, bio = 0, rad = 0, fire = 0, acid = 0)
	cold_protection = FEET
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT

/obj/item/clothing/shoes/f13/diesel/alt
	name = "female diesel boots"
	desc = "Fancy womens' knee-high platform boots with shiny steel clasps."
	icon_state = "diesel_f"
	inhand_icon_state = "diesel_f"

/obj/item/clothing/shoes/f13/military
	name = "military boots"
	desc = "High speed, no-drag combat boots designed for use by the U.S. Army before the Great War."
	icon_state = "military"
	inhand_icon_state = "military"
	permeability_coefficient = 0.05
	armor = list(melee = 10, bullet = 10, laser = 0, energy = 0, bomb = 10, bio = 0, rad = 0, fire = 10, acid = 0)
	strip_delay = 40
	resistance_flags = NONE
	can_be_tied = FALSE
	cold_protection = FEET
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/shoes

/obj/item/clothing/shoes/f13/military/leather
	name = "leather combat boots"
	desc = "A pair of laced, heavy-duty leather boots designed for hard combat."
	icon_state = "laced"
	inhand_icon_state = "laced"

/obj/item/clothing/shoes/f13/military/desert
	name = "desert combat boots"
	desc = "An old pair of desert combat boots. This one seems to have a tighter fit, and a padded interior."
	icon_state = "erin_boot"
	inhand_icon_state = "erin_boot"

/obj/item/clothing/shoes/f13/military/ncr
	name = "patrol boots"
	desc = "A pair of standard issue brown boots, with a puttee."
	icon_state = "ncr_boots"
	inhand_icon_state = "ncr"

/obj/item/clothing/shoes/f13/military/ncr_officer_boots
	name = "officer boots"
	desc = "A pair of well-polished brown leather calf boots fitted with straps."
	icon_state = "ncr_officer_boots"
	inhand_icon_state = "ncr_officer_boots"


/obj/item/clothing/shoes/roman
	name = "roman sandals"
	desc = "Sandals with buckled leather straps on it."
	icon = 'modular_fallout/master_files/icons/fallout/clothing/shoes.dmi'
	icon_state = "legion_sandals"
	inhand_icon_state = "legion_sandals"
	strip_delay = 100
	equip_delay_other = 100
	permeability_coefficient = 0.9
	can_be_tied = FALSE

/obj/item/clothing/shoes/f13/peltboots
	name = "pelt boots"
	desc = "These boots are made from tanned hide and lined with soft long horner wool. A fashion from wealthy tribes that has spread. "
	icon = 'modular_fallout/master_files/icons/fallout/clothing/shoes.dmi'
	icon_state = "legion_pelt"
	inhand_icon_state = "legion_pelt"
	cold_protection = FEET
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT

/obj/item/clothing/shoes/f13/military/legion
	name = "rough leather boots"
	desc = "A pair of crudely made leather boots, followng the standardized pattern laid down according to the wisdom of Caesar."
	icon = 'modular_fallout/master_files/icons/fallout/clothing/shoes.dmi'
	icon_state = "legion_leather"
	inhand_icon_state = "legion_leather"

/obj/item/clothing/shoes/f13/military/plated
	name = "plated war boots"
	desc = "A pair of leather boots reinforced with hardened toe caps and shin guards, usually recycled old workboot steel caps taken from rotted old boots and glued to new ones."
	icon = 'modular_fallout/master_files/icons/fallout/clothing/shoes.dmi'
	icon_state = "legion_war"
	inhand_icon_state = "legion_war"
	armor = list(melee = 20, bullet = 20, laser = 10, energy = 10, bomb = 20, bio = 0, rad = 0, fire = 20, acid = 0)

/obj/item/clothing/shoes/f13/military/legate
	name = "heavy metal boots"
	desc = "A pair of heavy leather boots with bronzed metal leg guards added. These belong to a Legate of Caesar's Legion."
	icon = 'modular_fallout/master_files/icons/fallout/clothing/shoes.dmi'
	icon_state = "legion_legate"
	inhand_icon_state = "legion_legate"
	armor = list(melee = 30, bullet = 30, laser = 20, energy = 20, bomb = 30, bio = 0, rad = 10, fire = 30, acid = 10)



//Fluff

/obj/item/clothing/shoes/f13/swimfins
	name = "swimming fins"
	desc = "You see, Ivan, when you wear fin in desert, they help you swim good if you find much water."
	icon_state = "flippers"
	inhand_icon_state = "flippers"

/obj/item/clothing/shoes/f13/moon
	name = "moon boots"
	desc = "These boots are constructed with a thin rubber exterior and cellular rubber midsole covered by colorful nylon fabrics and using polyurethane foams.<br>To the Moon!"
	icon_state = "moon"
	inhand_icon_state = "moon"
	armor = list(melee = 40, bullet = 20, laser = 20, energy = 20, bomb = 20, bio = 10, rad = 50, fire = 0, acid = 0)
	cold_protection = FEET
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT

/obj/item/clothing/shoes/f13/doom
	name = "mars boots"
	desc = "These boots are constructed with a titanium alloy. There are some runes engraved on the side.<br>To Mars!"
	icon_state = "mars"
	inhand_icon_state = "mars"
	armor = list(melee = 40, bullet = 20, laser = 20, energy = 20, bomb = 20, bio = 80, rad = 80, fire = 80, acid = 50)
	cold_protection = FEET
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT

/obj/item/clothing/shoes/f13/miner
	name = "mining boots"
	desc = "Heavy-duty work boots with steel-reinforced toes and some fluffy wool for extra warmth."
	icon_state = "miner"
	inhand_icon_state = "miner"
	armor = list(melee = 20, bullet = 0, laser = 0, energy = 0, bomb = 20, bio = 0, rad = 0, fire = 0, acid = 0)
	cold_protection = FEET
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT

/obj/item/clothing/shoes/f13/jamrock
	name = "Green Snakeskin Shoes"
	desc = "They may have lost some of their lustre over the years, but these green crocodile leather shoes fit you perfectly."
	icon_state = "jamrock_skins"
	inhand_icon_state = "jamrock_skins"
	armor = list(melee = 20, bullet = 0, laser = 0, energy = 0, bomb = 20, bio = 0, rad = 0, fire = 0, acid = 0)
	cold_protection = FEET
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT

/obj/item/clothing/shoes/f13/mutie
	name = "super mutant sandals"
	desc = "A pair of oversized sandals, likely designed for super mutants."
	icon_state = "mutie_sandals"
	icon_state = "mutie_sandals"

/obj/item/clothing/shoes/f13/mutie/boots
	name = "super mutant boots"
	desc = "(III) A pair of oversized boots."
	icon_state = "mutie_boots"
	icon_state = "mutie_boots"
	armor = list("tier" = 3, ENERGY = 40, BOMB = 50, BIO = 60, RAD = 40, FIRE = 30, ACID = 20)
	cold_protection = FEET

/obj/item/clothing/shoes/f13/mutie/boots/dark
	icon_state = "mutie_boots_dark"
	icon_state = "mutie_boots_dark"

/obj/item/clothing/shoes/f13/mutie/boots/ncr
	icon_state = "mutie_boots_ncr"
	icon_state = "mutie_boots_ncr"

/obj/item/clothing/shoes/f13/mutie/boots/ncr/ranger
	icon_state = "mutie_boots_ranger"
	icon_state = "mutie_boots_ranger"

/obj/item/clothing/shoes/f13/tribal_sandals
	icon_state = "tribaltreads"
	icon_state = "tribaltreads"
