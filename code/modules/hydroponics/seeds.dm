// ********************************************************
// Here's all the seeds (plants) that can be used in hydro
// ********************************************************

/obj/item/seeds
	icon = 'icons/obj/hydroponics/seeds.dmi'
	icon_state = "seed" // Unknown plant seed - these shouldn't exist in-game.
	worn_icon_state = "seed"
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE

	/// The plant within.
	var/datum/plant/plant_datum

	/// Typepath of plant_datum
	var/plant_type

	///Describes the product on the product path.
	var/productdesc

	/// How rare the plant is. Used for giving points to cargo when shipping off to CentCom.
	var/rarity = 0
	/// The type of plants that this plant can mutate into.
	var/list/mutatelist
	///Determines if the plant should be allowed to mutate early at 30+ instability.
	var/seed_flags = MUTATE_EARLY

/obj/item/seeds/Initialize(mapload, nogenes = FALSE)
	. = ..()
	pixel_x = base_pixel_x + rand(-8, 8)
	pixel_y = base_pixel_y + rand(-8, 8)

	plant_datum = new plant_type(!nogenes)

/obj/item/seeds/Destroy()
	QDEL_NULL(plant_datum)
	return ..()

/obj/item/seeds/examine(mob/user)
	. = ..()
	. += span_notice("Use a pen on it to rename it or change its description.")

/// Copy all the variables from one seed to a new instance of the same seed and return it.
/obj/item/seeds/proc/Copy()
	var/obj/item/seeds/copy_seed = new type(null, TRUE)
	copy_seed.plant_datum.gene_holder.CopyFrom(plant_datum.gene_holder)
	return copy_seed


/**
 * Override for seeds with unique text for their analyzer. (No newlines at the start or end of unique text!)
 * Returns null if no unique text, or a string of text if there is.
 */
/obj/item/seeds/proc/get_unique_analyzer_text()
	return null

/*
 * Both `/item/food/grown` and `/item/grown` implement a seed variable which tracks
 * plant statistics, genes, traits, etc. This proc gets the seed for either grown food or
 * grown inedibles and returns it, or returns null if it's not a plant.
 *
 * Returns an `/obj/item/seeds` ref for grown foods or grown inedibles.
 *  - returned seed CAN be null in weird cases but in all applications it SHOULD NOT be.
 * Returns null if it is not a plant.
 */
/obj/item/proc/get_plant_datum()
	return null

/obj/item/food/grown/get_plant_datum()
	return plant_datum

/obj/item/grown/get_plant_datum()
	return plant_datum

/obj/item/seeds/proc/reagents_from_genes()
	reagents_add = list()
	for(var/datum/plant_gene/reagent/R in genes)
		reagents_add[R.reagent_id] = R.rate
