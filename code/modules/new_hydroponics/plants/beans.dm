// Soybeans
/datum/plant/soybean
	species = "soybean"
	plantname = "soybean plants"

	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "soybean-grow"
	icon_dead = "soybean-dead"
	growthstages = 4

	possible_mutations = list(/datum/plant_mutation/soybean_koi)

	seed_path = /obj/item/seeds/soya
	product_path = /obj/item/food/grown/soybeans
	harvest_yield = 3

	reagents_per_potency = list(
		/datum/reagent/consumable/nutriment/vitamin = 0.04,
		/datum/reagent/consumable/nutriment = 0.05,
		/datum/reagent/consumable/cooking_oil = 0.03
	)

/obj/item/seeds/soya
	name = "pack of soybean seeds"
	desc = "These seeds grow into soybean plants."
	icon_state = "seed-soybean"

/obj/item/food/grown/soybeans
	seed = /obj/item/seeds/soya
	name = "soybeans"
	desc = "It's pretty bland, but oh the possibilities..."
	gender = PLURAL
	icon_state = "soybeans"
	foodtypes = VEGETABLES
	grind_results = list(/datum/reagent/consumable/soymilk = 0)
	tastes = list("soy" = 1)
	wine_power = 20

// Koibean
/datum/plant_mutation/soybean_koi
	plant_type = /datum/plant/soybean/koi

	chance = 5

/datum/plant/soybean/koi
	species = "koibean"
	name = "Koibean Plants"

	seed_path = /obj/item/seeds/soya/koi
	product_path = /obj/item/food/grown/koibeans

	base_potency = 10

	possible_mutations = null
	reagents_per_potency = list(
		/datum/reagent/toxin/carpotoxin = 0.1,
		/datum/reagent/consumable/nutriment/vitamin = 0.04,
		/datum/reagent/consumable/nutriment = 0.05
	)


/obj/item/seeds/soya/koi
	name = "pack of koibean seeds"
	desc = "These seeds grow into koibean plants."
	icon_state = "seed-koibean"

/obj/item/food/grown/koibeans
	seed = /obj/item/seeds/soya/koi
	name = "koibean"
	desc = "Something about these seems fishy."
	icon_state = "koibeans"
	foodtypes = VEGETABLES
	tastes = list("koi" = 1)
	wine_power = 40
