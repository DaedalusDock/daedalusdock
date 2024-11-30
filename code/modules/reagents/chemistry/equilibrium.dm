/*
* #/datum/equilibrium
*
* A dynamic reaction object that processes the reaction that it is set within it. Relies on a reagents holder to call and operate the functions.
*
* An object/datum to contain the vars for each of the reactions currently ongoing in a holder/reagents datum
* This way all information is kept within one accessable object
* equilibrium is a unique name as reaction is already too close to chemical_reaction
* This is set up this way to reduce holder.dm bloat as well as reduce confusing list overhead
* The crux of the fermimechanics are handled here
* Instant reactions AREN'T handled here. See holder.dm
*/
/datum/equilibrium
	///The chemical reaction that is presently being processed
	var/datum/chemical_reaction/reaction
	///The location/reagents datum the processing is taking place
	var/datum/reagents/holder
	///How much product we can make multiplied by the input recipe's products/required_reagents numerical values
	var/multiplier = INFINITY
	///The sum total of each of the product's numerical's values. This is so the addition/deletion is kept at the right values for multiple product reactions
	var/product_ratio = 0
	///The total possible that this reaction can make presently - used for gui outputs
	var/target_vol = 0
	///The target volume the reaction is headed towards. This is updated every tick, so isn't the total value for the reaction, it's just a way to ensure we can't make more than is possible.
	var/step_target_vol = INFINITY
	///How much of the reaction has been made so far. Mostly used for subprocs, but it keeps track across the whole reaction and is added to every step.
	var/reacted_vol = 0
	///If we're done with this reaction so that holder can clear it.
	var/to_delete = FALSE
	///Result vars, private - do not edit unless in reaction_step()
	///How much we're adding
	var/delta_t
	///Modifiers from catalysts, do not use negative numbers.
	///I should write a better handiler for modifying these
	///Speed mod
	var/speed_mod = 1
	///Temp mod
	var/thermic_mod = 1
	///Allow us to deal with lag by "charging" up our reactions to react faster over a period - this means that the reaction doesn't suddenly mass react - which can cause explosions
	var/time_deficit
	/// Tracks if we were overheating last tick or not.
	var/last_tick_overheating = FALSE
	///Used to store specific data needed for a reaction, usually used to keep track of things between explosion calls. CANNOT be used as a part of chemical_recipe - those vars are static lookup tables.
	var/data = list()

/*
* Creates and sets up a new equlibrium object
*
* Arguments:
* * input_reaction - the chemical_reaction datum that will be processed
* * input_holder - the reagents datum that the output will be put into
*/
/datum/equilibrium/New(datum/chemical_reaction/input_reaction, datum/reagents/input_holder)
	reaction = input_reaction
	holder = input_holder
	if(!holder || !reaction) //sanity check
		stack_trace("A new [type] was set up, with incorrect/null input vars!")
		to_delete = TRUE
		return
	if(!check_inital_conditions()) //If we're outside of the scope of the reaction vars
		to_delete = TRUE
		return
	if(!length(reaction.results)) //Come back to and revise the affected reactions in the next PR, this is a placeholder fix.
		holder.instant_react(reaction) //Even if this check fails, there's a backup - look inside of calculate_yield()
		to_delete = TRUE
		return
	LAZYADD(holder.reaction_list, src)
	SSblackbox.record_feedback("tally", "chemical_reaction", 1, "[reaction.type] attempts")


/datum/equilibrium/Destroy()
	if(reacted_vol < target_vol) //We did NOT finish from reagents - so we can restart this reaction given property changes in the beaker. (i.e. if it stops due to low temp, this will allow it to fast restart when heated up again)
		LAZYADD(holder.failed_but_capable_reactions, reaction) //Consider replacing check with calculate_yield()
	LAZYREMOVE(holder.reaction_list, src)
	holder = null
	reaction = null
	return ..()

/*
* Check to make sure our input vars are sensible - truncated version of check_reagent_properties()
*
* (as the setup in holder.dm checks for that already - this is a way to reduce calculations on New())
* Don't call this unless you know what you're doing, this is an internal proc
*/
/datum/equilibrium/proc/check_inital_conditions()
	//Make sure we have the right multipler for on_reaction()
	for(var/single_reagent in reaction.required_reagents)
		multiplier = min(multiplier, round((holder.get_reagent_amount(single_reagent) / reaction.required_reagents[single_reagent]), CHEMICAL_QUANTISATION_LEVEL))
	if(multiplier == INFINITY)
		return FALSE
	return TRUE

/*
* Check to make sure our input vars are sensible - is the holder overheated? does it have the required reagents? Does it have the required calalysts?
*
* If you're adding more checks for reactions, this is the proc to edit
* otherwise, generally, don't call this directed except internally
*/
/datum/equilibrium/proc/check_reagent_properties()
	//Have we exploded from on_reaction?
	if(!holder.my_atom || holder.reagent_list.len == 0)
		return FALSE
	if(!holder)
		stack_trace("an equilibrium is missing it's holder.")
		return FALSE
	if(!reaction)
		stack_trace("an equilibrium is missing it's reaction.")
		return FALSE

	//set up catalyst checks
	var/total_matching_catalysts = 0
	//Reagents check should be handled in the calculate_yield() from multiplier

	//This is generally faster
	if(length(reaction.inhibitors))
		for(var/datum/reagent/reagent as anything in holder.reagent_list)
			if(reagent in reaction.inhibitors)
				return FALSE

	//If the product/reactants are able to occur
	for(var/datum/reagent/reagent as anything in holder.reagent_list)
		//this is done this way to reduce processing compared to holder.has_reagent(P)
		if(reagent.type in reaction.required_catalysts)
			total_matching_catalysts++

	if(!(total_matching_catalysts == reaction.required_catalysts.len))
		return FALSE

	//All good!
	return TRUE

/*
* Calculates how much we're aiming to create
*
* Specifically calcuates multiplier, product_ratio, step_target_vol
* Also checks to see if these numbers are sane, returns a TRUE/FALSE
* Generally an internal proc
*/
/datum/equilibrium/proc/calculate_yield()
	if(!reaction)
		stack_trace("Tried to calculate an equlibrium for reaction [reaction.type], but there was no reaction set for the datum")
		return FALSE

	multiplier = INFINITY
	for(var/reagent in reaction.required_reagents)
		multiplier = min(multiplier, round((holder.get_reagent_amount(reagent) / reaction.required_reagents[reagent]), CHEMICAL_QUANTISATION_LEVEL))

	if(!length(reaction.results)) //Incase of no reagent product
		product_ratio = 1
		step_target_vol = INFINITY
		for(var/reagent in reaction.required_reagents)
			step_target_vol = min(step_target_vol, multiplier * reaction.required_reagents[reagent])
		if(step_target_vol == 0 || multiplier == 0)
			return FALSE
		//Sanity Check
		if(step_target_vol == INFINITY || multiplier == INFINITY) //I don't see how this can happen, but I'm not bold enough to let infinities roll around for free
			to_delete = TRUE
			CRASH("Tried to calculate target vol for [reaction.type] with no products, but could not find required reagents for the reaction. If it got here, something is really broken with the recipe.")
		return TRUE

	product_ratio = 0
	step_target_vol = 0
	var/true_reacted_vol //Because volumes can be lost mid reactions
	for(var/product in reaction.results)
		step_target_vol += (reaction.results[product]*multiplier)
		product_ratio += reaction.results[product]
		true_reacted_vol += holder.get_reagent_amount(product)
	if(step_target_vol == 0 || multiplier == INFINITY)
		return FALSE
	target_vol = step_target_vol + true_reacted_vol
	reacted_vol = true_reacted_vol
	return TRUE

/*
* Deals with lag - allows a reaction to speed up to 3x from delta_time
* "Charged" time (time_deficit) discharges by incrementing reactions by doubling them
* If delta_time is greater than 1.5, then we save the extra time for the next ticks
*
* Arguments:
* * delta_time - the time between the last proc in world.time
*/
/datum/equilibrium/proc/deal_with_time(delta_time)
	if(delta_time > 1)
		time_deficit += delta_time - 1
		delta_time = 1 //Lets make sure reactions aren't super speedy and blow people up from a big lag spike
	else if (time_deficit)
		if(time_deficit < 0.25)
			delta_time += time_deficit
			time_deficit = 0
		else
			delta_time += 0.25
			time_deficit -= 0.25
	return delta_time

/*
* Main method of checking for explosive - or failed states
* Checks overheated() and overly_impure() of a reaction
* This was moved from the start, to the end - after a reaction, so post reaction temperature changes aren't ignored.
* overheated() is first - so double explosions can't happen (i.e. explosions that blow up the holder)
* step_volume_added is how much product (across all products) was added for this single step
*/
/datum/equilibrium/proc/check_fail_states(step_volume_added)
	//Are we overheated?
	if(holder.is_reaction_overheating(reaction))
		SSblackbox.record_feedback("tally", "chemical_reaction", 1, "[reaction.type] overheated reaction steps")
		reaction.overheated(holder, src, step_volume_added)

	//did we explode?
	if(!holder.my_atom || holder.reagent_list.len == 0)
		return FALSE
	return TRUE

/*
* Main reaction processor - Increments the reaction by a timestep
*
* First checks the holder to make sure it can continue
* Then calculates the purity and volume produced.TRUE
* Then adds/removes reagents
* Then alters the holder temperature, and calls reaction_step
* Arguments:
* * delta_time - the time displacement between the last call and the current, 1 is a standard step
*/
/datum/equilibrium/proc/react_timestep(delta_time)
	if(to_delete)
		//This occurs when it explodes
		return FALSE
	if(!check_reagent_properties()) //this is first because it'll call explosions first
		to_delete = TRUE
		return
	if(!calculate_yield())//So that this can detect if we're missing reagents
		to_delete = TRUE
		return
	delta_time = deal_with_time(delta_time)

	delta_t = 0 //how far off optimal temp we care
	var/cached_temp = holder.chem_temp

	//Begin checks

	//Calculate DeltaT (Deviation of T from optimal)
	if(!reaction.is_cold_recipe)
		if (cached_temp < reaction.optimal_temp && cached_temp >= reaction.required_temp)
			delta_t = ((cached_temp - reaction.required_temp) / (reaction.optimal_temp - reaction.required_temp)) ** reaction.temp_exponent_factor
		else if (cached_temp >= reaction.optimal_temp)
			delta_t = 1
		else //too hot
			delta_t = 0
			to_delete = TRUE
			return
	else
		if (cached_temp > reaction.optimal_temp && cached_temp <= reaction.required_temp)
			delta_t = ((reaction.required_temp - cached_temp) / (reaction.required_temp - reaction.optimal_temp)) ** reaction.temp_exponent_factor
		else if (cached_temp <= reaction.optimal_temp)
			delta_t = 1
		else //Too cold
			delta_t = 0
			to_delete = TRUE
			return

	//Call any special reaction steps BEFORE addition
	if(reaction.reaction_step(holder, src, delta_t, step_target_vol) == END_REACTION)
		to_delete = TRUE
		return

	//Catalyst modifier
	delta_t *= speed_mod

	//Now we calculate how much to add - this is normalised to the rate up limiter
	var/delta_chem_factor = reaction.rate_up_lim * delta_t *delta_time //add/remove factor
	var/total_step_added = 0
	//keep limited
	if(delta_chem_factor > step_target_vol)
		delta_chem_factor = step_target_vol

	delta_chem_factor = round(delta_chem_factor / product_ratio, CHEMICAL_VOLUME_ROUNDING)
	if(delta_chem_factor <= 0)
		to_delete = TRUE
		return

	//Calculate how much product to make and how much reactant to remove factors..
	var/required_amount
	for(var/datum/reagent/requirement as anything in reaction.required_reagents)
		required_amount = reaction.required_reagents[requirement]
		if(!holder.remove_reagent(requirement, delta_chem_factor * required_amount))
			to_delete = TRUE
			return

	var/step_add
	for(var/datum/reagent/product as anything in reaction.results)
		step_add = holder.add_reagent(product, delta_chem_factor * reaction.results[product])
		if(!step_add)
			to_delete = TRUE
			return

		//record amounts created
		reacted_vol += step_add
		total_step_added += step_add

	#ifdef REAGENTS_TESTING //Kept in so that people who want to write fermireactions can contact me with this log so I can help them
	if(GLOB.Debug2) //I want my spans for my sanity
		message_admins("<span class='green'>Reaction step active for:[reaction.type]</span>")
		message_admins("<span class='notice'>|Reaction conditions| Temp: [holder.chem_temp], reactions: [length(holder.reaction_list)], awaiting reactions: [length(holder.failed_but_capable_reactions)], no. reagents:[length(holder.reagent_list)], no. prev reagents: [length(holder.previous_reagent_list)]</span>")
		message_admins("<span class='warning'>Reaction vars: PreReacted:[reacted_vol] of [step_target_vol] of total [target_vol]. delta_t [delta_t], multiplier [multiplier], delta_chem_factor [delta_chem_factor] Pfactor [product_ratio]. DeltaTime: [delta_time]</span>")
	#endif

	var/heat_energy = reaction.thermic_constant * total_step_added * thermic_mod
	if(reaction.reaction_flags & REACTION_HEAT_ARBITARY) //old method - for every bit added, the whole temperature is adjusted
		holder.set_temperature(clamp(holder.chem_temp + heat_energy, 0, CHEMICAL_MAXIMUM_TEMPERATURE))
	else //Standard mechanics - heat is relative to the beaker conditions
		holder.adjust_thermal_energy(heat_energy * SPECIFIC_HEAT_DEFAULT, 0, CHEMICAL_MAXIMUM_TEMPERATURE)

	var/is_overheating = holder.is_reaction_overheating(reaction)
	//Give a chance of sounds
	if(prob(5) || (is_overheating && !last_tick_overheating))
		holder.reaction_message(reaction)

	last_tick_overheating = is_overheating

	//post reaction checks
	if(!(check_fail_states(total_step_added)))
		to_delete = TRUE

	//If the volume of reagents created(total_step_added) >= volume of reagents still to be created(step_target_vol) then end
	//i.e. we have created all the reagents needed for this reaction
	//This is only accurate when a single reaction is present and we don't have multiple reactions where
	//reaction B consumes the products formed from reaction A(which can happen in add_reagent() as it also triggers handle_reactions() which can consume the reagent just added)
	//because total_step_added will be higher than the actual volume that was created leading to the reaction ending early
	//and yielding less products than intended
	if(total_step_added >= step_target_vol && length(holder.reaction_list) == 1)
		to_delete = TRUE

///Panic stop a reaction - cleanup should be handled by the next timestep
/datum/equilibrium/proc/force_clear_reactive_agents()
	for(var/reagent in reaction.required_reagents)
		holder.remove_reagent(reagent, (multiplier * reaction.required_reagents[reagent]), safety = 1)
