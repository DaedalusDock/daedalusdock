// Eggplant
/datum/plant/eggplant
	species = "eggplant"
	name = "Eggplant"

	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "eggplant-grow"
	icon_dead = "eggplant-dead"

	seed_path = /obj/item/seeds/eggplant
	product_path = /obj/item/food/grown/eggplant

	base_health = 25
	base_maturation = 70
	base_production = 110
	base_harvest_amt = 2
	base_harvest_yield = 4
	base_endurance = 2

	genome = 18

	latent_genes = list(/datum/plant_gene/mutations, /datum/plant_gene/continous_damage/sudden_death)
	reagents_per_potency = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/seeds/eggplant
	name = "pack of eggplant seeds"
	desc = "These seeds grow to produce berries that look nothing like eggs."
	icon_state = "seed-eggplant"
	plant_type = /datum/plant/eggplant

/obj/item/food/grown/eggplant
	plant_datum = /datum/plant/eggplant
	name = "eggplant"
	desc = "Maybe there's a chicken inside?"
	icon_state = "eggplant"
	foodtypes = FRUIT
	wine_power = 20
