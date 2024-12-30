
/////////////////////////////////////////
///////////////Bluespace/////////////////
/////////////////////////////////////////

/datum/design/bluespace_crystal
	name = "Artificial Bluespace Crystal"
	desc = "A small blue crystal with mystical properties."
	id = "bluespace_crystal"
	build_type = FABRICATOR
	materials = list(/datum/material/diamond = 1500, /datum/material/plasma = 1500)
	build_path = /obj/item/stack/ore/bluespace_crystal/artificial
	category = list("Bluespace Designs")
	mapload_design_flags = DESIGN_FAB_OMNI | DESIGN_FAB_ENGINEERING

/datum/design/telesci_gps
	name = "GPS Device"
	desc = "Little thingie that can track its position at all times."
	id = "telesci_gps"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 500, /datum/material/glass = 1000)
	build_path = /obj/item/gps
	category = list("Bluespace Designs")
	mapload_design_flags = DESIGN_FAB_OMNI | DESIGN_FAB_ENGINEERING | DESIGN_FAB_SUPPLY

/datum/design/miningsatchel_holding
	name = "Mining Satchel of Holding"
	desc = "A mining satchel that can hold a seemingly infinite amount of ores."
	id = "minerbag_holding"
	build_type = FABRICATOR
	materials = list(/datum/material/gold = 250, /datum/material/uranium = 500) //quite cheap, for more convenience
	build_path = /obj/item/storage/bag/ore/holding
	category = list("Bluespace Designs")
	mapload_design_flags = DESIGN_FAB_OMNI | DESIGN_FAB_SUPPLY
