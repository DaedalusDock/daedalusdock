/datum/codex_category/plants
	name = "Plants"
	desc = "Information on plants found in game."

/datum/codex_category/plants/Populate()
	var/list/mutations_by_plant = list()

	for(var/datum/plant_mutation/mutation as anything in SShydroponics.mutation_list)
		mutations_by_plant[mutation.plant_type] = mutation.type

	for(var/datum/plant/P as anything in subtypesof(/datum/plant))
		if(isabstract(P))
			continue
		P = new P
		var/list/mechanics = list()

		mechanics += "It grows in [P.base_maturation] seconds."
		mechanics += "It can produce harvests after [P.base_production] more seconds."

		if(length(P.latent_genes))
			mechanics += "It carries the following latent genes:"
			for(var/datum/plant_gene/path as anything in P.latent_genes)
				mechanics += "[FOURSPACES] [initial(path.desc) ? CODEX_LINK(initial(path.name), "[path]") : initial(path.name)]"

		if(length(P.innate_genes))
			mechanics += "It carries the following innate genes:"
			for(var/datum/plant_gene/path as anything in P.innate_genes)
				mechanics += "[FOURSPACES] [initial(path.desc) ? CODEX_LINK(initial(path.name), "[path]") : initial(path.name)]"

		var/datum/plant_mutation/mutation_source = SShydroponics.mutation_list[mutations_by_plant[P.type]]
		if(mutation_source)
			mechanics += "Mutation requirements: "
			mechanics += "[FOURSPACES]A bit of luck."

			if(length(mutation_source.required_genes))
				var/list/english_genes = list()
				for(var/datum/plant_gene/gene_path as anything in mutation_source.required_genes)
					english_genes += initial(gene_path.name)

				mechanics += "[FOURSPACES]All Genes: [english_list(english_genes)]."

			if(length(mutation_source.infusion_reagents))
				var/list/english_reagents = list()
				for(var/datum/reagent/reagent_path as anything in mutation_source.infusion_reagents)
					if(initial(reagent_path.chemical_flags) & REAGENT_INVISIBLE)
						continue
					english_reagents += initial(reagent_path.name)
				mechanics += "[FOURSPACES]Any of Infusions: [english_list(english_reagents)]."

			for(var/stat in mutation_source.ranges)
				var/list/stat_requirement = mutation_source.ranges[stat]
				var/lower_bound = stat_requirement[1]
				var/upper_bound = stat_requirement[2]
				if(lower_bound == -INFINITY && upper_bound == INFINITY)
					continue

				var/list/stat_data = list()
				if(lower_bound != -INFINITY)
					stat_data += "[stat]: Atleast [lower_bound]"

				if(upper_bound != INFINITY)
					if(length(stat_data))
						stat_data += " and atmost [upper_bound]."
					else
						stat_data += "[stat]: Atmost [upper_bound]."
				else
					stat_data += "."

				mechanics += "[FOURSPACES][jointext(stat_data, "")]"

		if(length(P.possible_mutations))
			mechanics += "It can mutate into the following plants:"
			for(var/datum/plant_mutation/mutation as anything in P.possible_mutations)
				var/datum/plant/mutation_plant_path = mutation.plant_type
				mechanics += "[FOURSPACES][CODEX_LINK(initial(mutation_plant_path.name), initial(mutation_plant_path.name))]"

		var/datum/codex_entry/entry = new(
			_display_name = "[P.name] (plant)",
			_associated_paths = list(P.type),
			_mechanics_text = jointext(mechanics, "<br>"),
		)

		items += entry
		qdel(P)

	return ..()
