//Oasis/Town
/obj/item/clothing/suit/armor/f13/town
	name = "town trenchcoat"
	desc = "A non-descript black trenchcoat."
	icon_state = "towntrench"
	inhand_icon_state = "hostrench"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	armor = list("tier" = 3, ENERGY = 40, BOMB = 25, BIO = 40, RAD = 30, FIRE = 80, ACID = 0)

/obj/item/clothing/suit/armor/f13/town/mayor
	name = "mayor trenchcoat"
	desc = "A symbol of the mayor's authority (or lack thereof)."
	armor = list("tier" = 4, ENERGY = 40, BOMB = 25, BIO = 40, RAD = 35, FIRE = 80, ACID = 0)

/obj/item/clothing/suit/armor/f13/town/sheriff
	name = "sheriff trenchcoat"
	desc = "A trenchcoat which does not attempt to hide the full-body combat armor beneath it."
	icon_state = "towntrench_heavy"
	armor = list("tier" = 6, ENERGY = 40, BOMB = 25, BIO = 40, RAD = 40, FIRE = 80, ACID = 0)

/obj/item/clothing/suit/armor/f13/town/commissioner
	name = "commissioner's jacket"
	desc = "A navy-blue jacket with blue shoulder designations, '/OPD/' stitched into one of the chest pockets, and hidden ceramic trauma plates. It has a small compartment for a holdout pistol."
	icon_state = "warden_alt"
	inhand_icon_state = "armor"
	armor = list("tier" = 5, "linebullet" = 75, ENERGY = 30, BOMB = 25, BIO = 40, RAD = 40, FIRE = 80, ACID = 0)
	pocket_storage_component_path = /datum/storage/concrete/pockets/small/holdout

/obj/item/clothing/suit/armor/f13/town/deputy
	name = "deputy trenchcoat"
	desc = "An armored trench coat with added shoulderpads, a chestplate, and legguards."
	icon_state = "towntrench_medium"
	armor = list("tier" = 5, ENERGY = 40, BOMB = 25, BIO = 40, RAD = 35, FIRE = 80, ACID = 0)
