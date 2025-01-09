/// Makes the plant and its seeds fireproof. From lavaland plants.
/datum/plant_gene/product_trait/fire_resistance
	name = "Fire Resistance"
	mutability_flags = PLANT_GENE_REMOVABLE | PLANT_GENE_MUTATABLE | PLANT_GENE_GRAFTABLE

/datum/plant_gene/product_trait/fire_resistance/on_new_seed(obj/item/seeds/new_seed)
	new_seed.resistance_flags |= FIRE_PROOF

/datum/plant_gene/product_trait/fire_resistance/on_remove(datum/plant_gene_holder/gene_holder)
	if(old_seed.resistance_flags & FIRE_PROOF)
		old_seed.resistance_flags &= ~FIRE_PROOF

/datum/plant_gene/product_trait/fire_resistance/on_new_product(obj/item/product, newloc, datum/plant/plant_datum)
	. = ..()
	if(!.)
		return

	product.resistance_flags |= FIRE_PROOF
