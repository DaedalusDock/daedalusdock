//This is part of replicapod.dm in the old system. Renamed because replica pods cringe.

/datum/plant/cabbage
	species = "cabbage"
	plantname = "Cabbages"

	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	product_path = /obj/item/food/grown/cabbage

	growthstages = 1
	harvest_amt = 4

	base_endurance = 25

	reagents_per_potency = list(
		/datum/reagent/consumable/nutriment/vitamin = 0.04,
		/datum/reagent/consumable/nutriment = 0.1
		)

/obj/item/seeds/cabbage
	name = "pack of cabbage seeds"
	desc = "These seeds grow into cabbages."
	icon_state = "seed-cabbage"

/obj/item/food/grown/cabbage
	seed = /obj/item/seeds/cabbage
	name = "cabbage"
	desc = "Ewwwwwwwwww. Cabbage."
	icon_state = "cabbage"
	foodtypes = VEGETABLES
	wine_power = 20
