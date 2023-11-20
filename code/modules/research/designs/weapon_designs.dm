/////////////////////////////////////////
/////////////////Weapons/////////////////
/////////////////////////////////////////

/datum/design/rubbershot/sec
	name = "Rubber Slug"
	id = "sec_rshot"
	build_type = FABRICATOR
	category = list(DCAT_AMMO)
	mapload_design_flags = DESIGN_FAB_SECURITY

/datum/design/beanbag_slug/sec
	name = "Beanbag Slug"
	id = "sec_beanbag_slug"
	build_type = FABRICATOR
	category = list(DCAT_AMMO)
	mapload_design_flags = DESIGN_FAB_SECURITY

/datum/design/pin_testing
	name = "Test-Range Firing Pin"
	desc = "This safety firing pin allows firearms to be operated within proximity to a firing range."
	id = "pin_testing"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 500, /datum/material/glass = 300)
	build_path = /obj/item/firing_pin/test_range
	category = list("Firing Pins")
	mapload_design_flags = DESIGN_FAB_SECURITY

/datum/design/pin_mindshield
	name = "Mindshield Firing Pin"
	desc = "This is a security firing pin which only authorizes users who are mindshield-implanted."
	id = "pin_loyalty"
	build_type = FABRICATOR
	materials = list(/datum/material/silver = 600, /datum/material/diamond = 600, /datum/material/uranium = 200)
	build_path = /obj/item/firing_pin/implant/mindshield
	category = list("Firing Pins")
	mapload_design_flags = DESIGN_FAB_SECURITY

/datum/design/stunrevolver
	name = "Tesla Cannon Part Kit"
	desc = "The kit for a high-tech cannon that fires internal, reusable bolt cartridges in a revolving cylinder. The cartridges can be recharged using conventional rechargers."
	id = "stunrevolver"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 10000, /datum/material/silver = 10000)
	build_path = /obj/item/weaponcrafting/gunkit/tesla
	category = list(DCAT_WEAPON)
	mapload_design_flags = DESIGN_FAB_SECURITY

/datum/design/nuclear_gun
	name = "Advanced Energy Gun Part Kit"
	desc = "The kit for an energy gun with an experimental miniaturized reactor."
	id = "nuclear_gun"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 2000, /datum/material/uranium = 3000, /datum/material/titanium = 1000)
	build_path = /obj/item/weaponcrafting/gunkit/nuclear
	category = list(DCAT_WEAPON)
	mapload_design_flags = DESIGN_FAB_SECURITY

/datum/design/flora_gun
	name = "Floral Somatoray"
	desc = "A tool that discharges controlled radiation which induces mutation in plant cells. Harmless to other organic life."
	id = "flora_gun"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 500, /datum/material/uranium = 2000)
	build_path = /obj/item/gun/energy/floragun
	category = list(DCAT_BOTANICAL)
	mapload_design_flags = DESIGN_FAB_SERVICE

/datum/design/large_grenade
	name = "Large Chemical Grenade"
	desc = "A grenade that affects a larger area and use larger containers."
	id = "large_Grenade"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 3000)
	build_path = /obj/item/grenade/chem_grenade/large
	category = list(DCAT_WEAPON)
	mapload_design_flags = DESIGN_FAB_MEDICAL | DESIGN_FAB_OMNI

/datum/design/pyro_grenade
	name = "Pyro Grenade"
	desc = "An advanced grenade that is able to self ignite its mixture."
	id = "pyro_Grenade"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 2000, /datum/material/plasma = 500)
	build_path = /obj/item/grenade/chem_grenade/pyro
	category = list(DCAT_WEAPON)
	mapload_design_flags = DESIGN_FAB_SECURITY | DESIGN_FAB_MEDICAL | DESIGN_FAB_OMNI

/datum/design/cryo_grenade
	name = "Cryo Grenade"
	desc = "An advanced grenade that rapidly cools its contents upon detonation."
	id = "cryo_Grenade"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 2000, /datum/material/silver = 500)
	build_path = /obj/item/grenade/chem_grenade/cryo
	category = list(DCAT_WEAPON)
	mapload_design_flags = DESIGN_FAB_SECURITY | DESIGN_FAB_MEDICAL | DESIGN_FAB_OMNI

/datum/design/adv_grenade
	name = "Advanced Release Grenade"
	desc = "An advanced grenade that can be detonated several times, best used with a repeating igniter."
	id = "adv_Grenade"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 3000, /datum/material/glass = 500)
	build_path = /obj/item/grenade/chem_grenade/adv_release
	category = list(DCAT_WEAPON)
	mapload_design_flags = DESIGN_FAB_SECURITY | DESIGN_FAB_MEDICAL | DESIGN_FAB_OMNI

/datum/design/stunshell
	name = "Stun Shell"
	desc = "A stunning shell for a shotgun."
	id = "stunshell"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 200)
	build_path = /obj/item/ammo_casing/shotgun/stunslug
	category = list(DCAT_AMMO)
	mapload_design_flags = DESIGN_FAB_SECURITY

/datum/design/suppressor // Do not add to sec fab
	name = "Suppressor"
	desc = "A reverse-engineered suppressor that fits on most small arms with threaded barrels."
	id = "suppressor"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 2000, /datum/material/silver = 500)
	build_path = /obj/item/suppressor
	category = list(DCAT_WEAPON)

/datum/design/cleric_mace
	name = "Cleric Mace"
	desc = "A mace fit for a cleric. Useful for bypassing plate armor, but too bulky for much else."
	id = "cleric_mace"
	build_type = AUTOLATHE
	materials = list(MAT_CATEGORY_ITEM_MATERIAL = 12000)
	build_path = /obj/item/melee/cleric_mace
	category = list("Imported")
