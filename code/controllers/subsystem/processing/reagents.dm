//Used for active reactions in reagents/equilibrium datums

PROCESSING_SUBSYSTEM_DEF(reagents)
	name = "Reagents"
	init_order = INIT_ORDER_REAGENTS
	priority = FIRE_PRIORITY_REAGENTS
	wait = 0.25 SECONDS //You might think that base_reaction_rate has to be set to half, but since everything is normalised around delta_time, it automatically adjusts it to be per second. Magic!
	flags = SS_KEEP_TIMING | SS_HIBERNATE
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	///What time was it when we last ticked
	var/previous_world_time = 0

	///List of all /datum/chemical_reaction datums indexed by their typepath. Use this for general lookup stuff
	var/chemical_reactions_list
	///List of all /datum/chemical_reaction datums. Used during chemical reactions. Indexed by REACTANT types
	var/chemical_reactions_list_reactant_index
	///List of all /datum/chemical_reaction datums. Used for the reaction lookup UI. Indexed by PRODUCT type
	var/chemical_reactions_list_product_index
	///List of all /datum/reagent datums indexed by reagent id. Used by chemistry stuff
	var/chemical_reagents_list
	///List of all reactions with their associated product and result ids. Used for reaction lookups
	var/chemical_reactions_results_lookup_list

/datum/controller/subsystem/processing/reagents/Initialize()
	//So our first step isn't insane
	previous_world_time = world.time
	chemical_reagents_list = init_chemical_reagent_list()
	//Build GLOB lists - see holder.dm
	build_chemical_reactions_lists()
	return ..()

/datum/controller/subsystem/processing/reagents/fire(resumed = FALSE)
	if (!resumed)
		currentrun = processing.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/current_run = currentrun

	//Attempt to realtime reactions in a way that doesn't make them overtly dangerous
	var/delta_realtime = (world.time - previous_world_time)/10 //normalise to s from ds
	previous_world_time = world.time

	while(current_run.len)
		var/datum/thing = current_run[current_run.len]
		current_run.len--
		if(QDELETED(thing))
			stack_trace("Found qdeleted thing in [type], in the current_run list.")
			processing -= thing
		else if(thing.process(delta_realtime) == PROCESS_KILL) //we are realtime
			// fully stop so that a future START_PROCESSING will work
			STOP_PROCESSING(src, thing)
		if (MC_TICK_CHECK)
			return

/// Initialises all /datum/reagent into a list indexed by reagent id
/datum/controller/subsystem/processing/reagents/proc/init_chemical_reagent_list()
	var/list/reagent_list = list()

	var/paths = subtypesof(/datum/reagent)

	for(var/datum/reagent/path as anything in paths)
		if(isabstract(path))//Are we abstract?
			continue
		var/datum/reagent/D = new path()
		reagent_list[path] = D

	return reagent_list

/datum/controller/subsystem/processing/reagents/proc/build_chemical_reactions_lists()
	//Chemical Reactions - Initialises all /datum/chemical_reaction into a list
	// It is filtered into multiple lists within a list.
	// For example:
	// chemical_reactions_list_reactant_index[/datum/reagent/toxin/plasma] is a list of all reactions relating to plasma
	//For chemical reaction list product index - indexes reactions based off the product reagent type - see get_recipe_from_reagent_product() in helpers
	//For chemical reactions list lookup list - creates a bit list of info passed to the UI. This is saved to reduce lag from new windows opening, since it's a lot of data.

	//Prevent these reactions from appearing in lookup tables (UI code)
	var/list/blacklist = (/datum/chemical_reaction/randomized)

	if(SSreagents.chemical_reactions_list_reactant_index)
		return

	//Randomized need to go last since they need to check against conflicts with normal recipes
	var/paths = subtypesof(/datum/chemical_reaction) - typesof(/datum/chemical_reaction/randomized) + subtypesof(/datum/chemical_reaction/randomized)
	SSreagents.chemical_reactions_list = list() //typepath to reaction list
	SSreagents.chemical_reactions_list_reactant_index = list() //reagents to reaction list
	SSreagents.chemical_reactions_results_lookup_list = list() //UI glob
	SSreagents.chemical_reactions_list_product_index = list() //product to reaction list

	for(var/path in paths)
		var/datum/chemical_reaction/D = new path()
		var/list/reaction_ids = list()
		var/list/product_ids = list()
		var/list/reagents = list()
		var/list/product_names = list()

		if(!D.required_reagents || !D.required_reagents.len) //Skip impossible reactions
			continue

		SSreagents.chemical_reactions_list[path] = D

		for(var/reaction in D.required_reagents)
			reaction_ids += reaction
			var/datum/reagent/reagent = find_reagent_object_from_type(reaction)
			reagents += list(list("name" = reagent.name, "id" = reagent.type))

		for(var/product in D.results)
			var/datum/reagent/reagent = find_reagent_object_from_type(product)
			product_names += reagent.name
			product_ids += product

		var/product_name
		if(!length(product_names))
			var/list/names = splittext("[D.type]", "/")
			product_name = names[names.len]
		else
			product_name = product_names[1]

		// Create filters based on each reagent id in the required reagents list - this is specifically for finding reactions from product(reagent) ids/typepaths.
		for(var/id in product_ids)
			if(is_type_in_list(D.type, blacklist))
				continue
			if(!SSreagents.chemical_reactions_list_product_index[id])
				SSreagents.chemical_reactions_list_product_index[id] = list()
			SSreagents.chemical_reactions_list_product_index[id] += D

		//Master list of ALL reactions that is used in the UI lookup table. This is expensive to make, and we don't want to lag the server by creating it on UI request, so it's cached to send to UIs instantly.
		if(!(is_type_in_list(D.type, blacklist)))
			SSreagents.chemical_reactions_results_lookup_list += list(list("name" = product_name, "id" = D.type, "reactants" = reagents))

		// Create filters based on each reagent id in the required reagents list - this is used to speed up handle_reactions()
		for(var/id in reaction_ids)
			if(!SSreagents.chemical_reactions_list_reactant_index[id])
				SSreagents.chemical_reactions_list_reactant_index[id] = list()
			SSreagents.chemical_reactions_list_reactant_index[id] += D
			break // Don't bother adding ourselves to other reagent ids, it is redundant
