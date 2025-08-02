//////////////////////////////////////////////////////////////////////////////
/////////////////////////////// Service //////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/service
	group = "Hermes Galactic Freight Co."

/datum/supply_pack/service/cargo_supples
	name = "Hermes Technician Equipment Crate"
	desc = "Contains equipment for an aspiring Hermes Galactic Freight Co. technician."
	cost = PAYCHECK_ASSISTANT * 4.5 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/stamp,
		/obj/item/stamp/denied,
		/obj/item/export_scanner,
		/obj/item/dest_tagger,
		/obj/item/hand_labeler,
		/obj/item/stack/package_wrap
	)
	crate_name = "cargo supplies crate"

/datum/supply_pack/service/minerkit
	name = "Mining Equipment Crate"
	desc = "All the miners died too fast? Assistant wants to get a taste of life off-station? Either way, this kit is the best way to turn a regular crewman into an ore-producing, monster-slaying machine. Contains meson goggles, a pickaxe, advanced mining scanner, cargo headset, ore bag, gasmask, an explorer suit and a miner ID upgrade."
	cost = PAYCHECK_ASSISTANT * 4.5 + CARGO_CRATE_VALUE
	contains = list(/obj/item/storage/backpack/duffelbag/mining_conscript)
	crate_name = "shaft miner starter kit"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/service/emptycrate
	name = "Empty Crate"
	desc = "It's an empty crate, for all your storage needs."
	cost = CARGO_CRATE_VALUE + CARGO_MANIFEST_VALUE
	contains = list()
	crate_name = "crate"

/datum/supply_pack/service/trolley
	name = "Trolley Crate"
	desc = "A crate containing a single trolley for transporting upto three crates at once."
	cost = PAYCHECK_ASSISTANT * 10 + CARGO_CRATE_VALUE
	contains = list(/obj/vehicle/ridden/trolley)
	crate_name = "trolley crate"

/datum/supply_pack/service/empty
	name = "Empty Supplypod"
	desc = "Presenting the New Nanotrasen-Brand Bluespace Supplypod! Transport cargo with grace and ease! Call today and we'll shoot over a demo unit for just 300 credits!"
	cost = CARGO_CRATE_VALUE
	contains = list()
	supply_flags = SUPPLY_PACK_DROPPOD_ONLY
	crate_type = null
	special_pod = /obj/structure/closet/supplypod/bluespacepod
