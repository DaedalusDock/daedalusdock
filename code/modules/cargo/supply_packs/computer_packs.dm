/datum/supply_pack/computer
	group = "Voidcomputing"

/datum/supply_pack/computer/preloaded
	name = "Hard Disk Drive (Omnifab)"
	desc = "Contains an extremely expensive data disk for use in fabricators."
	cost = CARGO_CRATE_VALUE * 5
	access = ACCESS_RESEARCH
	contains = list(/obj/item/disk/data/fabricator/omni)
	crate_name = "omnifab disk crate"

/datum/supply_pack/computer/preloaded/robotics
	name = "Hard Disk Drive (Robofab)"
	access = ACCESS_MECH_SCIENCE
	contains = list(/obj/item/disk/data/fabricator/robotics)
	crate_name = "robofab disk crate"

/datum/supply_pack/computer/preloaded/civ
	name = "Hard Disk Drive (Civfab)"
	contains = list(/obj/item/disk/data/fabricator/civ)
	crate_name = "civfab disk crate"

/datum/supply_pack/computer/preloaded/engineering
	name = "Hard Disk Drive (Engifab)"
	access = ACCESS_ENGINEERING
	contains = list(/obj/item/disk/data/fabricator/engineering)
	crate_name = "engifab disk crate"

/datum/supply_pack/computer/preloaded/medical
	name = "Hard Disk Drive (Medifab)"
	access = ACCESS_MEDICAL
	contains = list(/obj/item/disk/data/fabricator/medical)
	crate_name = "medifab disk crate"

/datum/supply_pack/computer/preloaded/supply
	name = "Hard Disk Drive (Supplyfab)"
	access = ACCESS_CARGO
	contains = list(/obj/item/disk/data/fabricator/supply)
	crate_name = "supplyfab disk crate"

/datum/supply_pack/computer/preloaded/security
	name = "Hard Disk Drive (Secfab)"
	access = ACCESS_SECURITY
	contains = list(/obj/item/disk/data/fabricator/security)
	crate_name = "secfab disk crate"

/datum/supply_pack/computer/preloaded/service
	name = "Hard Disk Drive (Servicefab)"
	access = ACCESS_SERVICE
	contains = list(/obj/item/disk/data/fabricator/service)
	crate_name = "servicefab disk crate"

/datum/supply_pack/computer/preloaded/imprinter
	name = "Hard Disk Drive (Imprinter)"
	access = ACCESS_ENGINEERING
	contains = list(/obj/item/disk/data/fabricator/imprinter)
	crate_name = "imprinter disk crate"
