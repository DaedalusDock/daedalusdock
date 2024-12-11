/datum/plant
	var/name = "BAD NAME"

	/// Used to update icons. Should match the name in the sprites unless all icon_* are overridden.
	var/species = ""
	///the file that stores the sprites of the growing plant from this seed.
	var/growing_icon = 'icons/obj/hydroponics/growing.dmi'
	/// Used to override grow icon (default is `"[species]-grow"`). You can use one grow icon for multiple closely related plants with it.
	var/icon_grow
	/// Used to override dead icon (default is `"[species]-dead"`). You can use one dead icon for multiple closely related plants with it.
	var/icon_dead
	/// Used to override harvest icon (default is `"[species]-harvest"`). If null, plant will use `[icon_grow][growthstages]`.
	var/icon_harvest

	/// The starting health value of this plant.
	var/base_health = 15
	/// The baseline amount of time to reach maturity. Half of this value is the time to reach "Growing"
	var/time_to_grow = 40 SECONDS
	/// The baseline amount of time AFTER reaching maturity to produce a harvest.
	var/time_to_produce = 40 SECONDS

	// * Stats * //
	/// The starting amount of endurance this plant has.
	var/base_endurance = 0
	/// The starting amount of potency this plant has.
	var/base_potency = 0

	/// Typepath of the product upon harvesting.
	var/product_path
	/// Type of seed produced.
	var/seed_path = /obj/item/seeds
	/// How many instances of the product are yielded per harvest.
	var/harvest_yield = 1
	/// How many times you can harvest this plant.
	var/harvest_amt = 1

	/// Innate genes that all instances of this plant have.
	var/list/innate_genes
	/// Genes this plant has, may or may not be active.
	var/list/latent_genes
	/// Possible mutation paths for this plant.
	var/list/possible_mutations

	/// A pseudoarbitrary value. When attempting to splice two plants together, a larger difference in genome value makes it more difficult.
	var/genome = 1

	/// If the plant needs water to survive.
	var/needs_water = TRUE
	/// If this plant was created as a result of genetic splicing.
	var/is_hybrid = FALSE

	//* Stateful vars *//

	///The status of the plant in the tray. Whether it's harvestable, alive, missing or dead.
	var/plant_status = PLANT_DEAD

	/// The genes of the plant.
	var/datum/plant_gene_holder/gene_holder

/**
 * Returns the plant's growth state.
 * Args:
 * * gene_holder: The plant's plant_gene_holder
 * * growth: Given growth time
 */
/datum/plant/get_growth_status(growth)
	if(growth <= 0)
		return PLANT_DEAD

	if(growth >= get_growth_for_state(PLANT_HARVESTABLE))
		return PLANT_HARVESTABLE

	else if(growth >= get_growth_for_state(PLANT_MATURE))
		return PLANT_MATURE

	else if(growth >= get_growth_for_state(PLANT_GROWING))
		return PLANT_GROWING

	else
		return PLANT_PLANTED

/// Get the required growth value to reach a given state.
/datum/plant/proc/get_growth_for_state(desired_state)
	switch(desired_state)
		if(PLANT_HARVESTABLE)
			return get_effective_stat(PLANT_STAT_PRODUCE_TIME)
		if(PLANT_MATURE)
			return gene_holder.get_effective_stat(PLANT_STAT_GROW_TIME)
		if(PLANT_GROWING)
			return gene_holder.get_effective_stat(PLANT_STAT_GROW_TIME) / 2

/// Returns the given stat, including active gene modifiers.
/datum/plant/proc/get_effective_stat(stat)
	var/base_val = 0
	switch(stat)
		if(PLANT_STAT_GROW_TIME)
			base_val = time_to_grow
		if(PLANT_STAT_PRODUCE_TIME)
			base_val = time_to_produce
		if(PLANT_STAT_ENDURANCE)
			base_val = endurance
		if(PLANT_STAT_POTENCY)
			base_val = potency
		if(PLANT_STAT_YIELD)
			base_val = harvest_yield
		if(PLANT_STAT_HARVEST_AMT)
			base_val = harvest_amt

	. = 0

	. += gene_holder.get_effective_stat(stat)
