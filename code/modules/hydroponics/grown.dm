// ***********************************************************
// Foods that are produced from hydroponics ~~~~~~~~~~
// Data from the seeds carry over to these grown foods
// ***********************************************************

// A few defines for use in calculating our plant's bite size.
/// When calculating bite size, potency is multiplied by this number.
#define BITE_SIZE_POTENCY_MULTIPLIER 0.05
/// When calculating bite size, max_volume is multiplied by this number.
#define BITE_SIZE_VOLUME_MULTIPLIER 0.01

// Base type. Subtypes are found in /grown dir. Lavaland-based subtypes can be found in mining/ash_flora.dm
/obj/item/food/grown
	icon = 'icons/obj/hydroponics/harvest.dmi'
	worn_icon = 'icons/mob/clothing/head/hydroponics.dmi'
	name = "fresh produce" // so recipe text doesn't say 'snack'
	max_volume = 100
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FLAMMABLE

	/// Plant datum that defines the stats of this edible.
	var/datum/plant/plant_datum
	var/cached_potency = 0
	var/cached_endurance = 0

	///Name of the plant
	var/plantname = ""
	/// The modifier applied to the plant's bite size. If a plant has a large amount of reagents naturally, this should be increased to match.
	var/bite_consumption_mod = 1
	/// The typepath made when the plant is splatted with liquid contents.
	var/splat_type = /obj/effect/decal/cleanable/food/plant_smudge
	/// If TRUE, this object needs to be dry to be ground up
	var/dry_grind = FALSE
	/// If FALSE, this object cannot be distilled into an alcohol.
	var/can_distill = TRUE
	/// The reagent this plant distill to. If NULL, it uses a generic fruit_wine reagent and adjusts its variables.
	var/distill_reagent
	/// Flavor of the plant's wine if NULL distll_reagent. If NULL, this is automatically set to the fruit's flavor.
	var/wine_flavor
	/// Boozepwr of the wine if NULL distill_reagent
	var/wine_power = 10
	/// Color of the grown object, for use in coloring greyscale splats.
	var/filling_color
	/// If the grown food has an alternaitve icon state to use in places.
	var/alt_icon

/obj/item/food/grown/Initialize(mapload, datum/plant/copy_from)
	if(!tastes)
		tastes = list("[name]" = 1) //This happens first else the component already inits

	if(istype(copy_from))
		plant_datum = copy_from.Copy()

	else if(ispath(plant_datum))
		// This is for adminspawn or map-placed growns. They get the default stats of their seed type.
		plant_datum = new plant_datum()

	else if(!plant_datum)
		stack_trace("Grown object created without a plant datum. WTF")
		return INITIALIZE_HINT_QDEL

	pixel_x = base_pixel_x + rand(-5, 5)
	pixel_y = base_pixel_y + rand(-5, 5)

	make_dryable()

	cached_potency = plant_datum.get_scaled_potency()
	cached_endurance = plant_datum.get_effective_stat(PLANT_STAT_ENDURANCE)

	var/datum/plant_gene_holder/gene_holder = plant_datum.gene_holder

	// Go through all traits in their genes and call on_new_product from them.
	for(var/datum/plant_gene/product_trait/trait in gene_holder.gene_list)
		trait.on_new_product(src, loc, plant_datum)

	// Set our default bitesize: bite size = 1 + (potency * 0.05) * (max_volume * 0.01) * modifier
	// A 100 potency, non-densified plant = 1 + (5 * 1 * modifier) = 6u bite size
	// For reference, your average 100 potency tomato has 14u of reagents - So, with no modifier it is eaten in 3 bites
	bite_consumption = 1 + round(max((cached_potency * BITE_SIZE_POTENCY_MULTIPLIER), 1) * (max_volume * BITE_SIZE_VOLUME_MULTIPLIER) * bite_consumption_mod)

	. = ..() //Only call it here because we want all the genes and shit to be applied before we add edibility. God this code is a mess.

	plant_datum.prepare_product(src)
	transform *= TRANSFORM_USING_VARIABLE(cached_potency, 100) + 0.5 //Makes the resulting produce's sprite larger or smaller based on potency!

/obj/item/food/grown/Destroy()
	if(istype(plant_datum))
		QDEL_NULL(plant_datum)
	return ..()

/obj/item/food/grown/MakeEdible()
	AddComponent(/datum/component/edible,\
				initial_reagents = food_reagents,\
				food_flags = food_flags,\
				foodtypes = foodtypes,\
				volume = max_volume,\
				eat_time = eat_time,\
				tastes = tastes,\
				eatverbs = eatverbs,\
				bite_consumption = bite_consumption,\
				microwaved_type = microwaved_type,\
				junkiness = junkiness,\
				on_consume = CALLBACK(src, PROC_REF(on_consume))\
			)


/// Callback for when the food item is FULLY eaten.
/obj/item/food/grown/proc/on_consume(mob/living/eater, mob/living/feeder)
	if(prob(20) && !plant_datum.gene_holder.has_active_gene_of_type(/datum/plant_gene/seedless))
		var/obj/item/seeds/seed = plant_datum.CopySeed()
		eater.visible_message(span_notice("</b>[eater]</b> spits out a seed."))
		seed.forceMove(eater.drop_location())

/obj/item/food/grown/proc/make_dryable()
	AddElement(/datum/element/dryable, type)

/obj/item/food/grown/MakeLeaveTrash()
	if(trash_type)
		AddElement(/datum/element/food_trash, trash_type, FOOD_TRASH_OPENABLE, TYPE_PROC_REF(/obj/item/food/grown, generate_trash))
	return

/// Callback proc for bonus behavior for generating trash of grown food. Used by [/datum/element/food_trash].
/obj/item/food/grown/proc/generate_trash()
	// If this is some type of grown thing, we pass a seed arg into its Inititalize()
	if(ispath(trash_type, /obj/item/grown) || ispath(trash_type, /obj/item/food/grown))
		return new trash_type(src, plant_datum)

	return new trash_type(src)

/obj/item/food/grown/grind_requirements()
	if(dry_grind && !HAS_TRAIT(src, TRAIT_DRIED))
		to_chat(usr, span_warning("[src] needs to be dry before it can be ground up!"))
		return
	return TRUE

/obj/item/food/grown/can_be_ground()
	return reagents.total_volume || ..()

/obj/item/food/grown/do_grind(datum/reagents/target_holder, mob/user)
	var/grind_results_num = LAZYLEN(grind_results)

	if(grind_results_num)
		var/total_nutriment_amount = reagents.get_reagent_amount(/datum/reagent/consumable/nutriment, type_check = REAGENT_SUB_TYPE)
		var/single_reagent_amount = grind_results_num > 1 ? round(total_nutriment_amount / grind_results_num, CHEMICAL_QUANTISATION_LEVEL) : total_nutriment_amount

		reagents.remove_reagent(/datum/reagent/consumable/nutriment, total_nutriment_amount, include_subtypes = TRUE)
		for(var/reagent in grind_results)
			reagents.add_reagent(reagent, single_reagent_amount)

	return reagents?.trans_to(target_holder, reagents.total_volume, transfered_by = user)

#undef BITE_SIZE_POTENCY_MULTIPLIER
#undef BITE_SIZE_VOLUME_MULTIPLIER
