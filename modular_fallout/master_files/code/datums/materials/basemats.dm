/datum/material/blackpowder
	name = "blackpowder"
	desc = "blackpowder"
	color = "#000000"
	alpha = 150
	categories = list(MAT_CATEGORY_RIGID = TRUE, MAT_CATEGORY_BASE_RECIPES = TRUE)
	sheet_type = /obj/item/stack/ore/blackpowder
	value_per_unit = 0.0050

/datum/material/lead
	name = "lead"
	desc = "Common lead ore often found in sedimentary and igneous layers of the crust."
	color = "#878687"
	categories = list(MAT_CATEGORY_ORE = TRUE, MAT_CATEGORY_RIGID = TRUE, MAT_CATEGORY_BASE_RECIPES = TRUE)
	sheet_type = /obj/item/stack/sheet/lead
	value_per_unit = 0.0025

#warn Slop location
// This is kinda slop to put it here

/obj/item/stack/ore/lead
	name = "lead ore"
	icon_state = "lead ore"
	item_state = "lead ore"
	singular_name = "lead ore chunk"
	points = 3
	custom_materials = list(/datum/material/lead=MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/lead
	merge_type = /obj/item/stack/ore/lead

/obj/item/stack/ore/blackpowder
	name = "gunpowder"
	icon_state = "Blackpowder ore"
	item_state = "Blackpowder ore"
	singular_name = "blackpowder"
	points = 1
	merge_type = /obj/item/stack/ore/blackpowder
	custom_materials = list(/datum/material/blackpowder=MINERAL_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/blackpowder = 50)
	w_class = WEIGHT_CLASS_TINY
