// **********************
// Other harvested materials from plants (that are not food)
// **********************

/obj/item/grown // Grown weapons
	name = "grown_weapon"
	icon = 'icons/obj/hydroponics/harvest.dmi'
	worn_icon = 'icons/mob/clothing/head/hydroponics.dmi'
	resistance_flags = FLAMMABLE

	/// Plant datum that defines the stats of this edible.
	var/datum/plant/plant_datum
	var/cached_potency = 0
	var/cached_endurance = 0

/obj/item/grown/Initialize(mapload, obj/item/seeds/new_seed)
	. = ..()
	create_reagents(100)

	if(istype(copy_from))
		plant_datum = copy_from.Copy()

	else if(ispath(plant_datum))
		// This is for adminspawn or map-placed growns. They get the default stats of their seed type.
		plant_datum = new plant_datum(random_genes = TRUE)
		plant_datum.gene_holder.potency = max(50, plant_datum.gene_holder.potency)

	pixel_x = base_pixel_x + rand(-5, 5)
	pixel_y = base_pixel_y + rand(-5, 5)

	if(plant_datum)
		cached_potency = plant_datum.get_effective_stat(PLANT_STAT_POTENCY)
		cached_endurance = plant_datum.get_effective_stat(PLANT_STAT_ENDURANCE)

		// Go through all traits in their genes and call on_new_plant from them.
		for(var/datum/plant_gene/product_trait/trait in plant_datum.gene_holder.gene_list)
			trait.on_new_plant(src, loc)

		if(istype(src, plant_datum.product_path)) // no adding reagents if it is just a trash item
			plant_datum.prepare_result(src)

		transform *= TRANSFORM_USING_VARIABLE(cached_potency, 100) + 0.5
		add_juice()

/obj/item/grown/Destroy()
	if(isatom(seed))
		QDEL_NULL(seed)
	return ..()

/obj/item/grown/proc/add_juice()
	if(reagents)
		return TRUE
	return FALSE

/obj/item/grown/microwave_act(obj/machinery/microwave/M)
	return

/obj/item/grown/on_grind()
	. = ..()
	for(var/i in 1 to grind_results.len)
		grind_results[grind_results[i]] = round(cached_potency)
