/datum/plant/ambrosia
	name = "Ambrosia"
	species = "ambrosiavulgaris"
	icon_dead = "ambrosia-dead"

	seed_path = /obj/item/seeds/ambrosia
	product_path = /obj/item/food/grown/ambrosia

	base_health = 30
	base_maturation = 30
	base_production = 150
	base_harvest_amt = 1
	base_harvest_yield = 5
	base_endurance = 0

	genome = 1 //the progenitor. or something.
	force_single_harvest = TRUE

	possible_mutations = list(/datum/plant_mutation/ambrosia_deus)
	reagents_per_potency = list(
		/datum/reagent/ichor = 0.15,
		/datum/reagent/consumable/nutriment/vitamin = 0.04,
		/datum/reagent/consumable/nutriment = 0.05
	)

/obj/item/seeds/ambrosia
	name = "pack of ambrosia seeds"
	desc = "These seeds grow into a plant with healing properties."
	icon_state = "seed-ambrosiavulgaris"

	plant_type = /datum/plant/ambrosia

/obj/item/food/grown/ambrosia
	plant_datum = /datum/plant/ambrosia
	name = "ambrosia branch"
	desc = "This is a plant containing various healing chemicals."
	icon_state = "ambrosiavulgaris"

	wine_power = 30

// Ambrosia Deus
/datum/plant_mutation/ambrosia_deus
	plant_type = /datum/plant/ambrosia/deus
	mutation_chance = 15

/datum/plant/ambrosia/deus
	species = "ambrosiadeus"
	name = "Ambrosia Deus"

	seed_path = /obj/item/seeds/ambrosia/deus
	product_path = /obj/item/food/grown/ambrosia/deus
	possible_mutations = list(/datum/plant_mutation/ambrosia_gaia)

	reagents_per_potency = list(
		/datum/reagent/medicine/tricordrazine = 0.15,
		/datum/reagent/medicine/synaptizine = 0.15,
		/datum/reagent/drug/space_drugs = 0.1,
		/datum/reagent/consumable/nutriment/vitamin = 0.04,
		/datum/reagent/consumable/nutriment = 0.05
	)

	rarity = 40

/obj/item/seeds/ambrosia/deus
	name = "pack of ambrosia deus seeds"
	desc = "These seeds grow into ambrosia deus. Could it be the food of the gods..?"
	icon_state = "seed-ambrosiadeus"

	plant_type = /datum/plant/ambrosia/deus

/obj/item/food/grown/ambrosia/deus
	plant_datum = /datum/plant/ambrosia/deus
	name = "ambrosia deus branch"
	desc = "Eating this makes you feel immortal!"
	icon_state = "ambrosiadeus"
	wine_power = 50

//Ambrosia Gaia
/datum/plant_mutation/ambrosia_gaia
	plant_type = /datum/plant/ambrosia/gaia

	ranges = list(
		PLANT_STAT_ENDURANCE = list(40, INFINITY),
		PLANT_STAT_POTENCY = list(-INFINITY, INFINITY),
		PLANT_STAT_MATURATION = list(-INFINITY, INFINITY),
		PLANT_STAT_PRODUCTION = list(-INFINITY, INFINITY),
		PLANT_STAT_HARVEST_AMT = list(-INFINITY, INFINITY),
		PLANT_STAT_YIELD = list(-INFINITY, INFINITY)
	)

	infusion_reagents = list(/datum/reagent/medicine/morphine)


/datum/plant/ambrosia/gaia
	species = "ambrosia_gaia"
	name = "Ambrosia Gaia"

	seed_path = /obj/item/seeds/ambrosia/gaia
	product_path = /obj/item/food/grown/ambrosia/gaia
	reagents_per_potency = list(
		/datum/reagent/medicine/morphine = 0.05,
		/datum/reagent/consumable/nutriment = 0.06,
		/datum/reagent/consumable/nutriment/vitamin = 0.05
	)

	possible_mutations = null
	rarity = 30 //These are some pretty good plants right here

/obj/item/seeds/ambrosia/gaia
	name = "pack of ambrosia gaia seeds"
	desc = "These seeds grow into ambrosia gaia, filled with infinite potential."
	icon_state = "seed-ambrosia_gaia"

	plant_type = /datum/plant/ambrosia/gaia

/obj/item/food/grown/ambrosia/gaia
	name = "ambrosia gaia branch"
	desc = "Eating this <i>makes</i> you immortal."
	icon_state = "ambrosia_gaia"
	light_system = OVERLAY_LIGHT
	light_outer_range = 3
	plant_datum = /datum/plant/ambrosia/gaia
	wine_power = 70
	wine_flavor = "the earthmother's blessing"
