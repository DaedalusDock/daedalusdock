/datum/plant_gene_holder
	/// The plant we belong to.
	var/datum/plant/parent

	/// Modifier for /datum/plant/var/maturation
	var/maturation = 0
	/// Modifier for /datum/plant/var/time	_to_produce
	var/production = 0
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

/datum/plant_gene_holder/proc/CopyFrom(datum/plant_gene_holder/from_holder)
	potency = from_holder.potency
	endurance = from_holder.endurance

	maturation = from_holder.maturation
	production = from_holder.production
	harvest_amt = from_holder.harvest_amt
	harvest_yield = from_holder.harvest_yield

	species_dominance = from_holder.species_dominance
	growth_time_dominance = from_holder.growth_time_dominance
	produce_time_dominance = from_holder.produce_time_dominance
	yield_dominance = from_holder.yield_dominance
	harvest_amt_dominance = from_holder.harvest_amt_dominance
	potency_dominance = from_holder.potency_dominance
	endurance_dominance = from_holder.endurance_dominance

	for(var/datum/plant_gene/gene as anything in from_holder.gene_list)
		add_active_gene(gene.type)

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
		if(PLANT_STAT_MATURATION)
			base_val = maturation
		if(PLANT_STAT_PRODUCTION)
			base_val = production
		if(PLANT_STAT_ENDURANCE)
			base_val = endurance
		if(PLANT_STAT_POTENCY)
			base_val = potency
		if(PLANT_STAT_YIELD)
			base_val = harvest_yield
		if(PLANT_STAT_HARVEST_AMT)
			base_val = harvest_amt

	. = base_val

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
/datum/plant_gene_holder/proc/add_active_gene(datum/plant_gene/gene_path)
	var/datum/plant_gene/gene_instance
	if(istype(gene_path))
		gene_instance = gene_path
		gene_path = gene_instance.type

	if(length(gene_list))
		for(var/datum/plant_gene/gene as anything in gene_list)
			if(gene.type == gene_path)
				return FALSE


	var/datum/plant_gene/new_gene = gene_instance || SShydroponics.gene_list[gene_path]

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

/datum/plant_gene_holder/proc/multi_mutate(stat_power = 1, gene_power = 1, type_power = 1)
	if(has_active_gene(/datum/plant_gene/stabilizer))
		return FALSE

	if(stat_power >= 1)
		. += try_mutate_stats(stat_power, TRUE)

	if(gene_power >= 1)
		. += try_activate_latent_gene(gene_power, TRUE)

	if(type_power >= 1)
		. += try_mutate_type(type_power, TRUE)


/// Randomly activate a latent gene.
/datum/plant_gene_holder/proc/try_activate_latent_gene(mutation_power = 1, ignore_stable = FALSE)
	if(!ignore_stable && has_active_gene(/datum/plant_gene/stabilizer))
		return FALSE

	if(!length(parent.latent_genes))
		return FALSE

	var/datum/plant_gene/gene_to_activate

	for(var/datum/plant_gene/latent_gene as anything in parent.latent_genes)
		if(has_active_gene(latent_gene.type))
			continue

		if(prob(latent_gene.development_chance * mutation_power))
			gene_to_activate = latent_gene
			break

	if(!gene_to_activate)
		return FALSE

	LAZYREMOVE(gene_list, gene_to_activate)
	gene_to_activate.on_add(src)
	return TRUE

/// Mutate the plant in various ways.
/datum/plant_gene_holder/proc/try_mutate_stats(mutation_power = 1, ignore_stable = FALSE)
	if(!ignore_stable && has_active_gene(/datum/plant_gene/stabilizer))
		return FALSE

	maturation += rand(-1 SECONDS * mutation_power, 1 SECONDS * mutation_power)
	production += rand(-1 SECONDS * mutation_power, 1 SECONDS * mutation_power)
	harvest_yield += rand(-2 * mutation_power, 2 * mutation_power)
	potency += rand(-5 * mutation_power, 5 * mutation_power)
	endurance += rand(-5* mutation_power, 5 * mutation_power)
	if(prob(20))
		harvest_amt += rand(-1 * mutation_power, 1 * mutation_power)

	return TRUE

/datum/plant_gene_holder/proc/try_mutate_type(mutation_power = 1, ignore_stable = FALSE)
	if(!ignore_stable && has_active_gene(/datum/plant_gene/stabilizer))
		return FALSE

	if(!length(parent.possible_mutations))
		return FALSE

	if(!parent.in_seed)
		return FALSE

	var/prob_modifier = 0
	for(var/datum/plant_gene/mutations/gene in gene_list)
		if(gene.is_negative)
			prob_modifier -= gene.mutation_chance_modifier
		else
			prob_modifier -= gene.mutation_chance_modifier

	for(var/datum/plant_mutation/mutation as anything in parent.possible_mutations)
		if(!prob((mutation.mutation_chance + prob_modifier) * mutation_power))
			continue

		if(!mutation.can_mutate(parent))
			continue

		var/new_path = mutation.plant_type.seed_path
		var/obj/item/seeds/new_seed = new new_path(null, TRUE)
		new_seed.plant_datum.gene_holder.CopyFrom(src)

		var/atom/parent_loc = parent.in_seed.loc
		qdel(parent.in_seed)

		if(istype(parent_loc, /obj/machinery/hydroponics))
			var/obj/machinery/hydroponics/tray = parent_loc
			tray.plant_seed(new_seed)
		else
			new_seed.forceMove(parent_loc.drop_location())
		break

