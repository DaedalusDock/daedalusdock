/datum/supply_pack/engineering
	group = "Engineering"
	crate_type = /obj/structure/closet/crate/engineering

/datum/supply_pack/engineering/engiequipment
	name = "Engineering Gear Crate"
	desc = "Gear up with a toolbelt, high-visibility vest, welding goggles, a hardhat and insulated gloves."
	cost = PAYCHECK_ASSISTANT * 6.6 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/storage/belt/utility,
		/obj/item/clothing/suit/hazardvest,
		/obj/item/clothing/glasses/welding,
		/obj/item/clothing/head/hardhat,
		/obj/item/clothing/gloves/color/yellow,
	)
	crate_name = "engineering gear crate"

/datum/supply_pack/engineering/pacman
	name = "P.A.C.M.A.N Generator Crate"
	desc = "Engineers can't set up the engine? Not an issue for you, once you get your hands on this P.A.C.M.A.N. Generator! Takes in plasma and spits out sweet sweet energy."
	cost = PAYCHECK_ASSISTANT * 23.2 + CARGO_CRATE_VALUE
	contains = list(/obj/machinery/power/port_gen/pacman)
	crate_name = "\improper PACMAN generator crate"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engineering/power
	name = "Power Cell Crate"
	desc = "Looking for power overwhelming? Look no further. Contains three high-voltage power cells."
	cost = PAYCHECK_ASSISTANT * 8.7 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/stock_parts/cell/high,
		/obj/item/stock_parts/cell/high,
		/obj/item/stock_parts/cell/high
	)
	crate_name = "power cell crate"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engineering/tools
	name = "Toolbox Crate"
	desc = "Any robust spaceman is never far from their trusty toolbox. Contains an electrical toolbox and an mechanical toolbox."
	contains = list(
		/obj/item/storage/toolbox/electrical,
		/obj/item/storage/toolbox/mechanical,
	)
	cost = PAYCHECK_ASSISTANT * 14.1 + CARGO_CRATE_VALUE
	crate_name = "toolbox crate"

/datum/supply_pack/engineering/space_heater
	name = "Space Heater Crate"
	desc = "A dual purpose heater/cooler for when things are too chilly/toasty."
	cost = PAYCHECK_ASSISTANT * 22 + CARGO_CRATE_VALUE
	contains = list(/obj/machinery/space_heater)
	crate_name = "space heater crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/engineering/teg
	name = "Thermo-Electric Generator Crate"
	desc = "All the components for building your own Thermoelectric Generator! Contains a generator and two circulators."
	cost = PAYCHECK_ASSISTANT * 90.7 + CARGO_CRATE_VALUE // How the fuck are you going to LOSE a TEG?
	contains = list(
		/obj/machinery/power/generator/unwrenched,
		/obj/machinery/atmospherics/components/binary/circulator/unwrenched,
		/obj/machinery/atmospherics/components/binary/circulator/unwrenched
	)
	crate_name = "thermoelectric generator crate"
	crate_type = /obj/structure/closet/crate/large
