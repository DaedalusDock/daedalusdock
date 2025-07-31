/datum/supply_pack/ammunition
	group = "Ammunition"
	crate_type = /obj/structure/closet/crate/secure/gear

/datum/supply_pack/ammunition/beanbag
	name = "Beanbag Crate"
	desc = "Contains three boxes of beanbag shotgun rounds."
	cost = CARGO_CRATE_VALUE * 8
	contains = list(
		/obj/item/storage/box/beanbag,
		/obj/item/storage/box/beanbag,
		/obj/item/storage/box/beanbag,
	)
	crate_name = "beanbag crate"

/datum/supply_pack/ammunition/rubbershot
	name = "Less-than-lethal Crate"
	desc = "Contains three boxes of rubber less-than-lethal shotgun rounds."
	cost = CARGO_CRATE_VALUE * 8
	contains = list(
		/obj/item/storage/box/rubbershot,
		/obj/item/storage/box/rubbershot,
		/obj/item/storage/box/rubbershot,
	)
	crate_name = "less-than-lethal crate"

/datum/supply_pack/ammunition/c38_specialer
	name = ".38 Special-er Crate"
	desc = "Contains several speedloaders for experimental rounds of the .38 Special caliber."
	contains = list(
		/obj/item/ammo_box/c38/hotshot,
		/obj/item/ammo_box/c38/hotshot,
		/obj/item/ammo_box/c38/hotshot,
		/obj/item/ammo_box/c38/iceblox,
		/obj/item/ammo_box/c38/iceblox,
		/obj/item/ammo_box/c38/iceblox,
	)
	crate_name = ".38 special-er crate"
