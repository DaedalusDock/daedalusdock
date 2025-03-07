// Herbs
/datum/plant/herbs
	species = "herbs"
	name = "Herbs"

	growing_icon = 'icons/obj/hydroponics/growing.dmi'
	icon_grow = "herbs-grow"
	icon_dead = "herbs-dead"
	growthstages = 2

	base_health = 20
	base_maturation = 30
	base_production = 100
	base_harvest_amt = 1
	base_harvest_yield = 5
	base_endurance = 0

	genome = 3
	force_single_harvest = TRUE

	seed_path = /obj/item/seeds/herbs
	product_path = /obj/item/food/grown/herbs
	reagents_per_potency = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/seeds/herbs
	name = "pack of herb seeds"
	desc = "These seeds grow to produce an assortment of herbs and seasonings."
	icon_state = "seed-herbs"

	plant_type = /datum/plant/herbs

/obj/item/food/grown/herbs
	plant_datum = /datum/plant/herbs
	name = "bundle of herbs"
	desc = "A bundle of various herbs. Somehow, you're always able to pick what you need out."
	icon_state = "herbs"
	foodtypes = VEGETABLES
	grind_results = list(/datum/reagent/consumable/nutriment = 0)
	juice_results = list(/datum/reagent/consumable/nutriment = 0)
	tastes = list("nondescript herbs" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/fernet
