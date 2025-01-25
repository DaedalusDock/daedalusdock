// Finally, peas.
/datum/plant/peas
	species = "peas"
	name = "Pea"

	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "peas-grow"
	icon_dead = "peas-dead"
	growthstages = 3

	base_health = 40
	base_maturation = 50
	base_production = 130
	base_harvest_amt = 4
	base_harvest_yield = 2
	base_endurance = 0

	genome = 8

	seed_path = /obj/item/seeds/peas
	product_path = /obj/item/food/grown/peas
	base_harvest_yield = 3

	reagents_per_potency = list(/datum/reagent/consumable/nutriment/vitamin = 0.1, /datum/reagent/consumable/nutriment = 0.05, /datum/reagent/water = 0.05)

/obj/item/seeds/peas
	name = "pack of pea pods"
	desc = "These seeds grows into vitamin rich peas!"
	icon_state = "seed-peas"

	plant_type = /datum/plant/peas

/obj/item/food/grown/peas
	plant_datum = /datum/plant/peas
	name = "peapod"
	desc = "Finally... peas."
	icon_state = "peas"
	foodtypes = VEGETABLES
	tastes = list ("peas" = 1, "chalky saltiness" = 1)
	wine_power = 50
	wine_flavor = "what is, distressingly, fermented peas."
