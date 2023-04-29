///////SMELTABLE ALLOYS///////

/datum/design/alloy
	name = "ERROR"
	id = "ERROR_ALLOY"
	build_type = NONE

/datum/design/alloy/plasteel_alloy
	name = "Plasma + Iron alloy"
	id = "plasteel"
	build_type = SMELTER | FABRICATOR
	materials = list(/datum/material/iron = MINERAL_MATERIAL_AMOUNT, /datum/material/plasma = MINERAL_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/plasteel
	category = list("initial", "Stock Parts")
	mapload_design_flags = DESIGN_FAB_SUPPLY | DESIGN_FAB_OMNI | DESIGN_FAB_ENGINEERING
	maxstack = 50


/datum/design/alloy/plastitanium_alloy
	name = "Plasma + Titanium alloy"
	id = "plastitanium"
	build_type = SMELTER | FABRICATOR
	materials = list(/datum/material/titanium = MINERAL_MATERIAL_AMOUNT, /datum/material/plasma = MINERAL_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/mineral/plastitanium
	category = list("initial", "Stock Parts")
	mapload_design_flags = DESIGN_FAB_SUPPLY | DESIGN_FAB_OMNI | DESIGN_FAB_ENGINEERING
	maxstack = 50

/datum/design/alloy/plaglass_alloy
	name = "Plasma + Glass alloy"
	id = "plasmaglass"
	build_type = SMELTER | FABRICATOR
	materials = list(/datum/material/plasma = MINERAL_MATERIAL_AMOUNT * 0.5, /datum/material/glass = MINERAL_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/plasmaglass
	category = list("initial", "Stock Parts")
	mapload_design_flags = DESIGN_FAB_SUPPLY | DESIGN_FAB_OMNI | DESIGN_FAB_ENGINEERING
	maxstack = 50

/datum/design/alloy/plasmarglass_alloy
	name = "Plasma + Iron + Glass alloy"
	id = "plasmareinforcedglass"
	build_type = SMELTER | FABRICATOR
	materials = list(/datum/material/plasma = MINERAL_MATERIAL_AMOUNT * 0.5, /datum/material/iron = MINERAL_MATERIAL_AMOUNT * 0.5,  /datum/material/glass = MINERAL_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/plasmarglass
	category = list("initial", "Stock Parts")
	mapload_design_flags = DESIGN_FAB_SUPPLY | DESIGN_FAB_OMNI | DESIGN_FAB_ENGINEERING
	maxstack = 50

/datum/design/alloy/titaniumglass_alloy
	name = "Titanium + Glass alloy"
	id = "titaniumglass"
	build_type = SMELTER | FABRICATOR
	materials = list(/datum/material/titanium = MINERAL_MATERIAL_AMOUNT * 0.5, /datum/material/glass = MINERAL_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/titaniumglass
	category = list("initial", "Stock Parts")
	mapload_design_flags = DESIGN_FAB_SUPPLY | DESIGN_FAB_OMNI | DESIGN_FAB_ENGINEERING
	maxstack = 50

/datum/design/alloy/plastitaniumglass_alloy
	name = "Plasma + Titanium + Glass alloy"
	id = "plastitaniumglass"
	build_type = SMELTER | FABRICATOR
	materials = list(/datum/material/plasma = MINERAL_MATERIAL_AMOUNT * 0.5, /datum/material/titanium = MINERAL_MATERIAL_AMOUNT * 0.5, /datum/material/glass = MINERAL_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/plastitaniumglass
	category = list("initial", "Stock Parts")
	mapload_design_flags = DESIGN_FAB_SUPPLY | DESIGN_FAB_OMNI | DESIGN_FAB_ENGINEERING
	maxstack = 50
