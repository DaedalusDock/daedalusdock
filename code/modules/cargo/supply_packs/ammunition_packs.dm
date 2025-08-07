/datum/supply_pack/ammunition
	group = "Ammunition"
	crate_type = /obj/structure/closet/crate/secure/gear

/datum/supply_pack/ammunition/beanbag
	name = "12 ga Beanbag Shot"
	desc = "Contains three boxes of beanbag shotgun rounds."
	cost = PAYCHECK_ASSISTANT * 3.2 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/storage/box/beanbag,
		/obj/item/storage/box/beanbag,
		/obj/item/storage/box/beanbag,
	)
	crate_name = "beanbag crate"

/datum/supply_pack/ammunition/rubbershot
	name = "12 ga Rubbershot"
	desc = "Contains three boxes of rubber less-than-lethal shotgun rounds."
	cost = PAYCHECK_ASSISTANT * 4.3 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/storage/box/rubbershot,
		/obj/item/storage/box/rubbershot,
		/obj/item/storage/box/rubbershot,
	)
	crate_name = "less-than-lethal crate"

/datum/supply_pack/ammunition/c38_special
	name = ".38 Special Speedloaders"
	desc = "Contains three speedloaders of .38 Special."
	cost = PAYCHECK_ASSISTANT * 7 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/ammo_box/c38,
		/obj/item/ammo_box/c38,
		/obj/item/ammo_box/c38,
	)
	crate_name = ".38 special crate"

/datum/supply_pack/ammunition/c38_specialer
	name = ".38 Special-er Speedloaders"
	desc = "Contains several speedloaders for experimental rounds of the .38 Special caliber."
	cost = PAYCHECK_ASSISTANT * 12.1 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/ammo_box/c38/hotshot,
		/obj/item/ammo_box/c38/hotshot,
		/obj/item/ammo_box/c38/hotshot,
		/obj/item/ammo_box/c38/iceblox,
		/obj/item/ammo_box/c38/iceblox,
		/obj/item/ammo_box/c38/iceblox,
	)
	crate_name = ".38 special-er crate"

/datum/supply_pack/ammunition/c38_special/dumdum
	name = ".38 Special DumDum Speedloaders"
	desc = "Contains three speedloaders of .38 DumDum ammunition, good for embedding in soft targets."
	cost = PAYCHECK_ASSISTANT * 9.2 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/ammo_box/c38/dumdum,
		/obj/item/ammo_box/c38/dumdum,
		/obj/item/ammo_box/c38/dumdum,
	)

/datum/supply_pack/ammunition/c38_special/match
	name = ".38 Special Match Speedloader"
	desc = "Contains three speedloaders of match grade .38 ammunition, perfect for showing off trickshots."
	cost = PAYCHECK_ASSISTANT * 2.3 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/ammo_box/c38/match,
		/obj/item/ammo_box/c38/match,
		/obj/item/ammo_box/c38/match,
	)

/datum/supply_pack/ammunition/c38_special/rubber
	name = ".38 Special Rubbershot Speedloader"
	desc = "Contains three speedloaders  of bouncy rubber .38 ammunition, for when you want to bounce your shots off anything and everything."
	cost = PAYCHECK_ASSISTANT * 3.5 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/ammo_box/c38/match/bouncy,
		/obj/item/ammo_box/c38/match/bouncy,
		/obj/item/ammo_box/c38/match/bouncy,
	)

