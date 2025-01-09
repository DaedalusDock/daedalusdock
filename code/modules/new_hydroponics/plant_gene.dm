/datum/plant_gene
	var/name = "BAD GENE"
	var/desc = ""

	var/mutability_flags = NONE

	/// Chance for this gene to develop fully and become active.
	var/development_chance = 10
	/// Is this gene considered bad.
	var/is_negative = FALSE

	/// Chance to process
	var/process_chance = 100

/// Processing effects. Return TRUE to cancel effects for children.
/datum/plant_gene/proc/tick(delta_time, obj/machinery/hydroponics/tray, datum/plant/plant, datum/plant_tick/plant_tick)
	SHOULD_CALL_PARENT(TRUE)

	if(!DT_PROB(process_chance, delta_time))
		return TRUE

/**
 * Returns the plant's growth state.
 * Args:
 * * gene_holder: The plant's plant_gene_holder
 * * stat: Desired stat
 * * base_val: The value of the gene holder's stat, before any gene modifiers.
 */
/datum/plant_gene/proc/get_stat_modifier(datum/plant_gene_holder/gene_holder, stat, base_val)
	return 0

/*
 * Returns the formatted name of the plant gene.
 *
 * Overridden by the various subtypes of plant genes to format their respective names.
 */
/datum/plant_gene/proc/get_name()
	return name

/*
 * Check if the seed can accept this plant gene.
 *
 * our_seed - the seed we're adding the gene to
 *
 * Returns TRUE if the seed can take the gene, and FALSE otherwise.
 */
/datum/plant_gene/proc/can_add(obj/item/seeds/our_seed)
	return !istype(our_seed, /obj/item/seeds/sample) // Samples can't accept new genes.

/*
 * on_add is called when seed genes are initialized on the /obj/seed.
 */
/datum/plant_gene/proc/on_add(datum/plant_gene_holder/gene_holder)
	return // Not implemented

/*
 * on_remove is called when the gene is removed from a seed.
 */
/datum/plant_gene/proc/on_remove(datum/plant_gene_holder/gene_holder)
	return

/// Copies over vars and information about our current gene to a new gene and returns the new instance of gene.
/datum/plant_gene/proc/Copy()
	var/datum/plant_gene/new_gene = new type
	new_gene.mutability_flags = mutability_flags
	return new_gene

//* PRODUCT-AFFECTING GENES *//
/// Traits that affect the grown product.
/datum/plant_gene/product_trait
	/// The rate at which this trait affects something. This can be anything really - why? I dunno.
	var/rate = 0.05
	/// Bonus lines displayed on examine.
	var/examine_line = ""
	/// Flag - Traits that share an ID cannot be placed on the same plant.
	var/trait_ids
	/// Flag - Modifications made to the final product.
	var/trait_flags
	/// A blacklist of seeds that a trait cannot be attached to.
	var/list/obj/item/seeds/seed_blacklist

/datum/plant_gene/product_trait/Copy()
	. = ..()
	var/datum/plant_gene/product_trait/new_trait_gene = .
	new_trait_gene.rate = rate
	return

/*
 * Checks if we can add the trait to the seed in question.
 *
 * source_seed - the seed genes we're adding the trait too
 */
/datum/plant_gene/product_trait/can_add(obj/item/seeds/source_seed)
	. = ..()
	if(!.)
		return FALSE

	for(var/obj/item/seeds/found_seed as anything in seed_blacklist)
		if(istype(source_seed, found_seed))
			return FALSE

	for(var/datum/plant_gene/product_trait/trait in source_seed.genes)
		if(trait_ids & trait.trait_ids)
			return FALSE
		if(type == trait.type)
			return FALSE

	return TRUE

/*
 * on_new_product is called for every plant trait on an /obj/item/grown or /obj/item/food/grown when initialized.
 *
 * product - the source product being created
 * newloc - the loc of the plant
 */
/datum/plant_gene/product_trait/proc/on_new_product(obj/item/product, newloc, datum/plant/plant_datum)
	// Plant products should always have a bound plant datum.
	if(isnull(product.get_plant_datum()))
		stack_trace("[product] ([product.type]) has a nulled plant_datum value while trying to initialize [src]!")
		return FALSE

	// Add on any bonus lines on examine
	if(examine_line)
		RegisterSignal(product, COMSIG_PARENT_EXAMINE, PROC_REF(examine))

	return TRUE

/// Add on any unique examine text to the plant's examine text.
/datum/plant_gene/product_trait/proc/examine(obj/item/our_plant, mob/examiner, list/examine_list)
	SIGNAL_HANDLER

	examine_list += examine_line
