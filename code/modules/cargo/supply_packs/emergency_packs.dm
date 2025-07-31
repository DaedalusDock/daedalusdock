//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Emergency ///////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/emergency
	group = "Emergency"

/datum/supply_pack/emergency/bio
	name = "Biological Emergency Crate"
	desc = "Contains a full bio suit which will protect you from viruses."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(
		/obj/item/clothing/head/bio_hood,
		/obj/item/clothing/suit/bio_suit,
		/obj/item/storage/bag/bio,
		/obj/item/reagent_containers/syringe/antiviral,
		/obj/item/clothing/gloves/color/latex/nitrile,
	)
	crate_name = "bio suit crate"

/datum/supply_pack/emergency/firefighting
	name = "Firefighting Crate"
	desc = "Only you can prevent colony fires."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(
		/obj/item/clothing/suit/fire/firefighter,
		/obj/item/clothing/mask/gas,
		/obj/item/flashlight,
		/obj/item/tank/internals/oxygen/red,
		/obj/item/extinguisher/advanced,
		/obj/item/clothing/head/hardhat/red
	)
	crate_name = "firefighting crate"

/datum/supply_pack/emergency/atmostank
	name = "Firefighting Tank Backpack"
	desc = "Mow down fires with this high-capacity fire fighting tank backpack. Requires Atmospherics access to open."
	cost = CARGO_CRATE_VALUE * 1.8
	access = ACCESS_ATMOSPHERICS
	contains = list(/obj/item/watertank/atmos)
	crate_name = "firefighting backpack crate"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/emergency/internals
	name = "Internals Crate"
	desc = "Master your life energy and control your breathing with three breath masks, three oxygen tanks and three large air tanks."//IS THAT A
	cost = CARGO_CRATE_VALUE * 2
	contains = list(
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/mask/breath,
		/obj/item/clothing/mask/breath,
		/obj/item/clothing/mask/breath,
		/obj/item/tank/internals/oxygen,
		/obj/item/tank/internals/oxygen,
		/obj/item/tank/internals/oxygen
	)
	crate_name = "internals crate"
	crate_type = /obj/structure/closet/crate/internals

/datum/supply_pack/emergency/metalfoam
	name = "Metal Foam Grenade Crate"
	desc = "Seal up those pesky hull breaches with 7 Metal Foam Grenades."
	cost = CARGO_CRATE_VALUE * 2.4
	contains = list(/obj/item/storage/box/metalfoam)
	crate_name = "metal foam grenade crate"

/datum/supply_pack/emergency/radiation
	name = "Radiation Protection Crate"
	desc = "Contains a helmet, suit, and Geiger counter."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(
		/obj/item/clothing/head/radiation,
		/obj/item/clothing/suit/radiation,
		/obj/item/geiger_counter,
	)
	crate_name = "radiation protection crate"
	crate_type = /obj/structure/closet/crate/radiation

/datum/supply_pack/emergency/spacesuit
	name = "Space Suit Crate"
	desc = "Contains one aging suit from Space-Goodwill and a jetpack."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(
		/obj/item/clothing/suit/space,
		/obj/item/clothing/head/helmet/space,
		/obj/item/clothing/mask/breath,
		/obj/item/tank/jetpack/carbondioxide
	)
	crate_name = "space suit crate"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/emergency/specialops
	name = "Special Ops Supplies"
	desc = "(*!&@#SAD ABOUT THAT NULL_ENTRY, HUH OPERATIVE? WELL, THIS LITTLE ORDER CAN STILL HELP YOU OUT IN A PINCH. CONTAINS A BOX OF FIVE EMP GRENADES, THREE SMOKEBOMBS, AN INCENDIARY GRENADE, AND A \"SLEEPY PEN\" FULL OF NICE TOXINS!#@*$"
	supply_flags = parent_type::supply_flags | SUPPLY_PACK_EMAG
	cost = CARGO_CRATE_VALUE * 4
	contains = list(
		/obj/item/storage/box/emps,
		/obj/item/grenade/smokebomb,
		/obj/item/grenade/smokebomb,
		/obj/item/grenade/smokebomb,
		/obj/item/pen/sleepy,
		/obj/item/grenade/chem_grenade/incendiary,
	)
	crate_name = "emergency crate"
	crate_type = /obj/structure/closet/crate/internals
