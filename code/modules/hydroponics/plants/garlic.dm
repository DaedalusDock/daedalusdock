/datum/plant/garlic
	species = "garlic"
	name = "Garlic"

	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'

	base_health = 20
	base_maturation = 60
	base_production = 100
	base_harvest_amt = 1
	base_harvest_yield = 3
	base_endurance = 3

	genome = 13

	seed_path = /obj/item/seeds/garlic
	product_path = /obj/item/food/grown/garlic

	latent_genes = list(/datum/plant_gene/splicability/positive)
	reagents_per_potency = list(/datum/reagent/consumable/garlic = 0.15, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/seeds/garlic
	name = "pack of garlic seeds"
	desc = "A packet of extremely pungent seeds."
	icon_state = "seed-garlic"

	plant_type = /datum/plant/garlic

/obj/item/food/grown/garlic
	plant_datum = /datum/plant/garlic
	name = "garlic"
	desc = "Delicious, but with a potentially overwhelming odor."
	icon_state = "garlic"
	tastes = list("garlic" = 1)
	wine_power = 10
