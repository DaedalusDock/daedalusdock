/datum/supply_pack/construction
	group = "Construction"
	crate_type = /obj/structure/closet/crate/engineering

/datum/supply_pack/construction/conveyor
	name = "Conveyor Assembly Crate"
	desc = "Keep production moving along with thirty conveyor belts. Conveyor switch included. If you have any questions, consult the enclosed instruction book."
	cost = CARGO_CRATE_VALUE * 3.5
	contains = list(
		/obj/item/stack/conveyor/thirty,
		/obj/item/conveyor_switch_construct,
		/obj/item/paper/guides/conveyor,
	)
	crate_name = "conveyor assembly crate"

/datum/supply_pack/construction/carpet
	name = "Premium Carpet Crate"
	desc = "Iron floor tiles getting on your nerves? These stacks of extra soft carpet will tie any room together."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(
		/obj/item/stack/tile/carpet/fifty,
		/obj/item/stack/tile/carpet/fifty,
		/obj/item/stack/tile/carpet/black/fifty,
		/obj/item/stack/tile/carpet/black/fifty
	)
	crate_name = "premium carpet crate"

/datum/supply_pack/construction/carpet_exotic
	name = "Exotic Carpet Crate"
	desc = "Exotic carpets straight from Space Russia, for all your decorating needs. Contains 100 tiles each of 8 different flooring patterns."
	cost = CARGO_CRATE_VALUE * 8
	contains = list(
		/obj/item/stack/tile/carpet/blue/fifty,
		/obj/item/stack/tile/carpet/blue/fifty,
		/obj/item/stack/tile/carpet/cyan/fifty,
		/obj/item/stack/tile/carpet/cyan/fifty,
		/obj/item/stack/tile/carpet/green/fifty,
		/obj/item/stack/tile/carpet/green/fifty,
		/obj/item/stack/tile/carpet/orange/fifty,
		/obj/item/stack/tile/carpet/orange/fifty,
		/obj/item/stack/tile/carpet/purple/fifty,
		/obj/item/stack/tile/carpet/purple/fifty,
		/obj/item/stack/tile/carpet/red/fifty,
		/obj/item/stack/tile/carpet/red/fifty,
		/obj/item/stack/tile/carpet/royalblue/fifty,
		/obj/item/stack/tile/carpet/royalblue/fifty,
		/obj/item/stack/tile/carpet/royalblack/fifty,
		/obj/item/stack/tile/carpet/royalblack/fifty
	)
	crate_name = "exotic carpet crate"

/datum/supply_pack/construction/carpet_neon
	name = "Simple Neon Carpet Crate"
	desc = "Simple rubbery mats with phosphorescent lining. Contains 120 tiles each of 13 color variants. Limited edition release."
	cost = CARGO_CRATE_VALUE * 15
	contains = list(
		/obj/item/stack/tile/carpet/neon/simple/white/sixty,
		/obj/item/stack/tile/carpet/neon/simple/white/sixty,
		/obj/item/stack/tile/carpet/neon/simple/black/sixty,
		/obj/item/stack/tile/carpet/neon/simple/black/sixty,
		/obj/item/stack/tile/carpet/neon/simple/red/sixty,
		/obj/item/stack/tile/carpet/neon/simple/red/sixty,
		/obj/item/stack/tile/carpet/neon/simple/orange/sixty,
		/obj/item/stack/tile/carpet/neon/simple/orange/sixty,
		/obj/item/stack/tile/carpet/neon/simple/yellow/sixty,
		/obj/item/stack/tile/carpet/neon/simple/yellow/sixty,
		/obj/item/stack/tile/carpet/neon/simple/lime/sixty,
		/obj/item/stack/tile/carpet/neon/simple/lime/sixty,
		/obj/item/stack/tile/carpet/neon/simple/green/sixty,
		/obj/item/stack/tile/carpet/neon/simple/green/sixty,
		/obj/item/stack/tile/carpet/neon/simple/teal/sixty,
		/obj/item/stack/tile/carpet/neon/simple/teal/sixty,
		/obj/item/stack/tile/carpet/neon/simple/cyan/sixty,
		/obj/item/stack/tile/carpet/neon/simple/cyan/sixty,
		/obj/item/stack/tile/carpet/neon/simple/blue/sixty,
		/obj/item/stack/tile/carpet/neon/simple/blue/sixty,
		/obj/item/stack/tile/carpet/neon/simple/purple/sixty,
		/obj/item/stack/tile/carpet/neon/simple/purple/sixty,
		/obj/item/stack/tile/carpet/neon/simple/violet/sixty,
		/obj/item/stack/tile/carpet/neon/simple/violet/sixty,
		/obj/item/stack/tile/carpet/neon/simple/pink/sixty,
		/obj/item/stack/tile/carpet/neon/simple/pink/sixty,
	)
	crate_name = "neon carpet crate"

/datum/supply_pack/construction/lightbulbs
	name = "Replacement Lights"
	desc = "May the light of Aether shine upon this station! Or at least, the light of forty two light tubes and twenty one light bulbs."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/storage/box/lights/mixed,
					/obj/item/storage/box/lights/mixed,
					/obj/item/storage/box/lights/mixed)
	crate_name = "replacement lights"
