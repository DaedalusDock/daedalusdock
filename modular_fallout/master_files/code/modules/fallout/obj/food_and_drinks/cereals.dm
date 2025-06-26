// Wheat
/obj/item/seeds/wheat
	name = "pack of wheat seeds"
	desc = "These may, or may not, grow into wheat."
	icon_state = "seed-wheat"
	plant_type = /datum/plant/wheat

/obj/item/food/grown/wheat
	name = "wheat"
	desc = "Sigh... wheat... a-grain?"
	gender = PLURAL
	icon_state = "wheat"
	filling_color = "#F0E68C"
	bite_consumption = 2
	foodtypes = GRAIN
	grind_results = list(/datum/reagent/consumable/flour = 0)
	distill_reagent = /datum/reagent/consumable/ethanol/beer
