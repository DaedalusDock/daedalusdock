/datum/plant_gene_holder
	/// The plant we belong to.
	var/datum/plant/parent

	/// Modifier for /datum/plant/var/time_to_grow
	var/time_to_grow = 0
	/// Modifier for /datum/plant/var/time_to_produce
	var/time_to_produce = 0
	/// Modifier for /datum/plant/var/time_to_harvest
	var/harvest_amt = 0
	/// Modifier for /datum/plant/var/harvest_yield
	var/harvest_yield = 0

	var/potency = 0
	var/endurance = 0

	/// Transferrable mutations
	var/list/gene_list

	/// This plant's mutation, if any
	var/datum/plant_mutation/mutation

	//* Dominant Alleles *//
	var/species_dominance = FALSE
	var/growth_time_dominance = FALSE
	var/produce_time_dominance = FALSE
	var/yield_dominance = FALSE
	var/harvest_amt_dominance = FALSE
	var/potency_dominance = FALSE
	var/endurance_dominance = FALSE

/// Randomize the dominance of the alleles in this plant.
/datum/plant_gene_holder/proc/randomize_alleles()
	species_dominance = rand(0, 1)
	growth_time_dominance = rand(0, 1)
	produce_time_dominance = rand(0, 1)
	yield_dominance = rand(0, 1)
	harvest_amt_dominance = rand(0, 1)
	potency_dominance = rand(0, 1)
	endurance_dominance = rand(0, 1)

/// Returns the given stat, including active gene modifiers.
/datum/plant_gene_holder/proc/get_effective_stat(stat)
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

	if(length(gene_list))
		for(var/datum/plant_gene/gene as anything in gene_list)
			. += gene.get_stat_modifier(src, stat, base_val)

/// Does the plant have the given gene active
/datum/plant_gene_holder/proc/has_active_gene(gene_path)
	if(length(gene_list))
		for(var/datum/plant_gene/gene as anything in gene_list)
			if(gene.type == gene_path)
				return gene

/// Add an active gene, not a latent one.
/datum/plant_gene_holder/proc/add_active_gene(gene_path)
	if(length(gene_list))
		for(var/datum/plant_gene/gene as anything in gene_list)
			if(gene.type == gene_path)
				return FALSE


	var/datum/plant_gene/new_gene = SShydroponics.gene_list[gene_path]

	LAZYADD(gene_list, new_gene)
	new_gene.on_add(src)
	return TRUE

/// Remove an active gene.
/datum/plant_gene_holder/proc/remove_active_gene(gene_path)
	var/datum/plant_gene/gene_to_remove = has_active_gene(gene_path)
	if(!gene_to_remove)
		return FALSE

	LAZYREMOVE(gene_list, gene_to_remove)
	gene_to_remove.on_remove(src)

/// Randomly activate a latent gene.
/datum/plant_gene_holder/proc/activate_latent_gene(multiplier = 1)
	if(has_active_gene(/datum/plant_gene/stabilizer))
		return FALSE

	if(length(parent.latent_gene_list))
		return FALSE

	var/datum/plant_gene/gene_to_activate

	for(var/datum/plant_gene/latent_gene as anything in parent.latent_gene_list)
		if(has_active_gene(latent_gene.type))
			continue

		if(prob(latent_gene.development_chance))
			gene_to_activate = latent_gene
			break

	if(!gene_to_activate)
		return FALSE

	LAZYREMOVE(gene_list, gene_to_activate)
	gene_to_add.on_add(src)
