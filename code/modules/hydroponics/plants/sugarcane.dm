
// Sugarcane
/datum/plant/sugarcane
	species = "sugarcane"
	name = "Sugarcane"

	growthstages = 2


	base_health = 10
	base_maturation = 30
	base_production = 60
	base_harvest_amt = 1
	base_harvest_yield = 7
	base_endurance = 0

	genome = 8
	force_single_harvest = TRUE

	seed_path = /obj/item/seeds/sugarcane
	product_path = /obj/item/food/grown/sugarcane

	reagents_per_potency = list(/datum/reagent/consumable/sugar = 0.25)
	possible_mutations = list(/datum/plant_mutation/sugarcane_bamboo)

/obj/item/seeds/sugarcane
	name = "pack of sugarcane seeds"
	desc = "These seeds grow into sugarcane."
	icon_state = "seed-sugarcane"

	plant_type = /datum/plant/sugarcane

/obj/item/food/grown/sugarcane
	plant_datum = /datum/plant/sugarcane
	name = "sugarcane"
	desc = "Sickly sweet."
	icon_state = "sugarcane"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES | SUGAR
	distill_reagent = /datum/reagent/consumable/ethanol/rum

///and bamboo!
/datum/plant_mutation/sugarcane_bamboo
	plant_type = /datum/plant/bamboo

/datum/plant/bamboo
	species = "bamboo"
	name = "Bamboo"

	growing_icon = 'icons/obj/hydroponics/growing.dmi'
	icon_dead = "bamboo-dead"
	growthstages = 3

	seed_path = /obj/item/seeds/bamboo
	product_path = /obj/item/grown/log/bamboo

/obj/item/seeds/bamboo
	name = "pack of bamboo seeds"
	desc = "A plant known for its flexible and resistant logs."
	icon_state = "seed-bamboo"

	plant_type = /datum/plant/bamboo

/obj/item/grown/log/bamboo
	plant_datum = /datum/plant/bamboo
	name = "bamboo log"
	desc = "A long and resistant bamboo log."
	icon_state = "bamboo"
	plank_type = /obj/item/stack/sheet/mineral/bamboo
	plank_name = "bamboo sticks"

/obj/item/grown/log/bamboo/CheckAccepted(obj/item/I)
	return FALSE
