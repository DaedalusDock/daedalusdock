/obj/machinery/seed_splicer
	name = "seed splicer"
	desc = "Extracts and bags seeds from produce."
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "sextractor"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/seed_extractor

/obj/machinery/seed_splicer/proc/splice(obj/item/seeds/seed_one, obj/item/seeds/seed_two)
	var/datum/plant/plant_one = seed_one.plant_datum
	var/datum/plant/plant_two = seed_two.plant_datum

	if(!plant_one || !plant_two)
		return FALSE

	var/datum/plant/dominant_species = SShydroponics.splice_alleles(plant_one.gene_holder.species_dominance, plant_two.gene_holder.species_dominance)
	var/datum/plant/recessive_species = dominant_species == plant_one ? plant_two : plant_one

	var/new_seed_type = dominant_species.seed_path
	var/obj/item/seeds/new_seed = new new_seed_type(src)
	var/datum/plant/new_plant = new_seed.plant_datum

	new_plant.is_hybrid = TRUE
	new_plant.generation = max(dominant_species.generation, recessive_species.generation) + 1

	if(dominant_species.name != recessive_species.name)
		var/part1 = copytext(dominant_species.name, 1, round(length(dominant_species.name) * 0.65 + 1.5))
		var/part2 = copytext(recessive_species.name, round(length(recessive_species.name) * 0.45 + 1), 0)
		new_plant.name = "[part1][part2]"
	else
		new_plant.name = dominant_species.name

	new_plant.species = dominant_species.species
	new_plant.growing_icon = dominant_species.growing_icon
	new_plant.icon_dead = dominant_species.icon_dead
	new_plant.icon_grow = dominant_species.icon_grow
	new_plant.icon_harvest = dominant_species.icon_harvest

	new_plant.base_health = dominant_species.base_health

	new_plant.genome = round((dominant_species.genome + recessive_species.genome) / 2)
	new_seed.name = "[new_plant.name] seed"

	for(var/datum/plant_gene/gene as anything in dominant_species.gene_holder.gene_list)
		if(gene.gene_flags & PLANT_GENE_UNSPLICABLE)
			continue

		new_plant.gene_holder.add_active_gene(gene.Copy())

	new_plant.innate_genes = dominant_species.innate_genes | recessive_species.innate_genes
	new_plant.latent_genes = dominant_species.latent_genes | recessive_species.latent_genes

	new_plant.reagents_per_potency = list()
	for(var/reagent_path in dominant_species.reagents_per_potency)
		new_plant.reagents_per_potency[reagent_path] = dominant_species.reagents_per_potency[reagent_path]

	for(var/reagent_path in (recessive_species.reagents_per_potency - dominant_species.reagents_per_potency))
		new_plant.reagents_per_potency[reagent_path] = recessive_species.reagents_per_potency[reagent_path]

	var/datum/plant_gene_holder/dominant_dna = dominant_species.gene_holder
	var/datum/plant_gene_holder/recessive_dna = recessive_species.gene_holder

	new_plant.gene_holder.potency = SShydroponics.splice_alleles(dominant_dna.potency_dominance, recessive_dna.potency_dominance, dominant_dna.potency, recessive_dna.potency)
	new_plant.base_potency = SShydroponics.splice_alleles(dominant_dna.potency_dominance, recessive_dna.potency_dominance, dominant_species.base_potency, recessive_species.base_potency)

	new_plant.gene_holder.endurance = SShydroponics.splice_alleles(dominant_dna.endurance_dominance, recessive_dna.endurance_dominance, dominant_dna.endurance, recessive_dna.endurance)
	new_plant.base_endurance = SShydroponics.splice_alleles(dominant_dna.endurance_dominance, recessive_dna.endurance_dominance, dominant_species.base_endurance, recessive_species.base_endurance)

	new_plant.gene_holder.production = SShydroponics.splice_alleles(dominant_dna.produce_time_dominance, recessive_dna.produce_time_dominance, dominant_dna.production, recessive_dna.production)
	new_plant.base_production = SShydroponics.splice_alleles(dominant_dna.produce_time_dominance, recessive_dna.produce_time_dominance, dominant_species.base_production, recessive_species.base_production)

	new_plant.gene_holder.maturation = SShydroponics.splice_alleles(dominant_dna.growth_time_dominance, recessive_dna.growth_time_dominance, dominant_dna.maturation, recessive_dna.maturation)
	new_plant.base_maturation = SShydroponics.splice_alleles(dominant_dna.growth_time_dominance, recessive_dna.growth_time_dominance, dominant_species.base_maturation, recessive_species.base_maturation)

	new_plant.gene_holder.harvest_yield = SShydroponics.splice_alleles(dominant_dna.yield_dominance, recessive_dna.yield_dominance, dominant_dna.harvest_yield, recessive_dna.harvest_yield)
	new_plant.base_harvest_yield = SShydroponics.splice_alleles(dominant_dna.yield_dominance, recessive_dna.yield_dominance, dominant_species.base_harvest_yield, recessive_species.base_harvest_yield)

	new_plant.gene_holder.harvest_amt = SShydroponics.splice_alleles(dominant_dna.harvest_amt_dominance, recessive_dna.harvest_amt_dominance, dominant_dna.harvest_amt, recessive_dna.harvest_amt)
	new_plant.base_harvest_amt = SShydroponics.splice_alleles(dominant_dna.harvest_amt_dominance, recessive_dna.harvest_amt_dominance, dominant_species.base_harvest_amt, recessive_species.base_harvest_amt)

	new_seed.forceMove(drop_location())
	qdel(seed_one)
	qdel(seed_two)
	return TRUE

/obj/machinery/seed_splicer/proc/get_splice_chance(obj/item/seeds/seed_one, obj/item/seeds/seed_two)
	var/datum/plant/plant_one = seed_one.plant_datum
	var/datum/plant/plant_two = seed_two.plant_datum

	var/splice_chance = 100
	var/genome_delta = abs(plant_one.genome - plant_two.genome)

	splice_chance -= genome_delta * 10

	return min(splice_chance, 0)
