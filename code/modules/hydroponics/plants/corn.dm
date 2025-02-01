// Corn
/datum/plant/corn
	species = "corn"
	name = "Corn"

	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "corn-grow" // Uses one growth icons set for all the subtypes
	icon_dead = "corn-dead" // Same for the dead icon

	seed_path = /obj/item/seeds/corn
	product_path = /obj/item/food/grown/corn

	growthstages = 3

	base_health = 20
	base_maturation = 60
	base_production = 110
	base_harvest_amt = 3
	base_harvest_yield = 3
	base_endurance = 2

	genome = 10

	reagents_per_potency = list(
		/datum/reagent/consumable/cornoil = 0.2,
		/datum/reagent/consumable/nutriment/vitamin = 0.04,
		/datum/reagent/consumable/nutriment = 0.1
	)

	latent_genes = list(/datum/plant_gene/splicability/negative)
	possible_mutations = list(/datum/plant_mutation/corn_snapscorn)

/obj/item/seeds/corn
	name = "pack of corn seeds"
	desc = "I don't mean to sound corny..."
	icon_state = "seed-corn"

	plant_type = /datum/plant/corn

/obj/item/food/grown/corn
	plant_datum = /datum/plant/corn
	name = "ear of corn"
	desc = "Needs some butter!"
	icon_state = "corn"
	microwaved_type = /obj/item/food/popcorn
	trash_type = /obj/item/grown/corncob
	bite_consumption_mod = 2
	foodtypes = VEGETABLES
	juice_results = list(/datum/reagent/consumable/corn_starch = 0)
	tastes = list("corn" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/whiskey

/obj/item/food/grown/corn/MakeBakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/oven_baked_corn, rand(15 SECONDS, 35 SECONDS), TRUE, TRUE)

/obj/item/grown/corncob
	name = "corn cob"
	desc = "A reminder of meals gone by."
	icon_state = "corncob"
	inhand_icon_state = "corncob"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_range = 7
	grind_results = list(/datum/reagent/cellulose = 10) //really partially hemicellulose

/obj/item/grown/corncob/attackby(obj/item/grown/W, mob/user, params)
	if(W.sharpness)
		to_chat(user, span_notice("You use [W] to fashion a pipe out of the corn cob!"))
		new /obj/item/clothing/mask/cigarette/pipe/cobpipe (user.loc)
		qdel(src)
	else
		return ..()

// Snapcorn
/datum/plant_mutation/corn_snapscorn
	plant_type = /datum/plant/corn/snapcorn

/datum/plant/corn/snapcorn
	species = "snapcorn"
	name = "Snapcorn"

	seed_path = /obj/item/seeds/corn/snapcorn
	product_path = /obj/item/grown/snapcorn

	possible_mutations = null
	rarity = 10

/obj/item/seeds/corn/snapcorn
	name = "pack of snapcorn seeds"
	desc = "Oh snap!"
	icon_state = "seed-snapcorn"

	plant_type = /datum/plant/corn/snapcorn

/obj/item/grown/snapcorn
	plant_datum = /datum/plant/corn/snapcorn
	name = "snap corn"
	desc = "A cob with snap pops."
	icon_state = "snapcorn"
	inhand_icon_state = "corncob"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_range = 7
	var/snap_pops = 1

/obj/item/grown/snapcorn/add_juice()
	..()
	snap_pops = max(round(cached_potency/8), 1)

/obj/item/grown/snapcorn/attack_self(mob/user)
	..()
	to_chat(user, span_notice("You pick a snap pop from the cob."))
	var/obj/item/toy/snappop/S = new /obj/item/toy/snappop(user.loc)
	if(ishuman(user))
		user.put_in_hands(S)
	snap_pops -= 1
	if(!snap_pops)
		new /obj/item/grown/corncob(user.loc)
		qdel(src)
