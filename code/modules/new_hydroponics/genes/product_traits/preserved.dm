
/// Traits for flowers, makes plants not decompose.
/datum/plant_gene/product_trait/preserved
	name = "Natural Insecticide"
	mutability_flags = PLANT_GENE_REMOVABLE | PLANT_GENE_MUTATABLE | PLANT_GENE_GRAFTABLE

/datum/plant_gene/product_trait/preserved/on_new_plant(obj/item/our_plant, newloc)
	. = ..()
	if(!.)
		return

	var/obj/item/food/grown/grown_plant = our_plant
	if(istype(grown_plant))
		grown_plant.preserved_food = TRUE
