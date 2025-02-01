#define REAGENTS_UI_MODE_LOOKUP 0
#define REAGENTS_UI_MODE_REAGENT 1
#define REAGENTS_UI_MODE_RECIPE 2

#define REAGENT_TRANSFER_AMOUNT "amount"

///////////////////////////////Main reagents code/////////////////////////////////////////////

/// Holder for a bunch of [/datum/reagent]
/datum/reagents
	/// The reagents being held
	var/list/datum/reagent/reagent_list = new/list()
	/// Current volume of all the reagents
	var/total_volume = 0
	/// Max volume of this holder
	var/maximum_volume = 100
	/// The atom this holder is attached to
	var/atom/my_atom = null
	/// Current temp of the holder volume
	var/chem_temp = 150
	/// unused
	var/last_tick = 1
	/// various flags, see code\__DEFINES\reagents.dm
	var/flags
	///list of reactions currently on going, this is a lazylist for optimisation
	var/list/datum/equilibrium/reaction_list
	///cached list of reagents typepaths (not object references), this is a lazylist for optimisation
	var/list/datum/reagent/previous_reagent_list
	///If a reaction fails due to temperature, this tracks the required temperature for it to be enabled.
	var/list/failed_but_capable_reactions
	///Hard check to see if the reagents is presently reacting
	var/is_reacting = FALSE
	///UI lookup stuff
	///Keeps the id of the reaction displayed in the ui
	var/ui_reaction_id = null
	///Keeps the id of the reagent displayed in the ui
	var/ui_reagent_id = null
	///The bitflag of the currently selected tags in the ui
	var/ui_tags_selected = NONE
	///What index we're at if we have multiple reactions for a reagent product
	var/ui_reaction_index = 1
	///If we're syncing with the beaker - so return reactions that are actively happening
	var/ui_beaker_sync = FALSE
	/// The metabolism type this container uses. For mobs.
	var/metabolism_class

/datum/reagents/New(maximum=100, new_flags=0)
	maximum_volume = maximum
	flags = new_flags

/datum/reagents/Destroy()
	//We're about to delete all reagents, so lets cleanup
	for(var/datum/reagent/reagent as anything in reagent_list)
		qdel(reagent)
	reagent_list = null
	if(is_reacting) //If false, reaction list should be cleaned up
		force_stop_reacting()
	QDEL_LAZYLIST(reaction_list)
	previous_reagent_list = null
	if(my_atom && my_atom.reagents == src)
		my_atom.reagents = null
	my_atom = null
	return ..()

/**
 * Adds a reagent to this holder
 *
 * Arguments:
 * * reagent - The reagent id to add
 * * amount - Amount to add
 * * list/data - Any reagent data for this reagent, used for transferring data with reagents
 * * reagtemp - Temperature of this reagent, will be equalized
 * * no_react - prevents reactions being triggered by this addition
 * * ignore splitting - Don't call the process that handles reagent spliting in a mob (impure/inverse) - generally leave this false unless you care about REAGENTS_DONOTSPLIT flags (see reagent defines)
 */
/datum/reagents/proc/add_reagent(reagent, amount, list/data=null, reagtemp = DEFAULT_REAGENT_TEMPERATURE, no_react = FALSE, ignore_splitting = FALSE)
	if(!isnum(amount) || !amount)
		return FALSE

	if(amount <= CHEMICAL_QUANTISATION_LEVEL)//To prevent small amount problems.
		return FALSE

	if(SEND_SIGNAL(src, COMSIG_REAGENTS_PRE_ADD_REAGENT, reagent, amount, reagtemp, data, no_react) & COMPONENT_CANCEL_REAGENT_ADD)
		return FALSE

	var/datum/reagent/glob_reagent = SSreagents.chemical_reagents_list[reagent]
	if(!glob_reagent)
		stack_trace("[my_atom] attempted to add a reagent called '[reagent]' which doesn't exist. ([usr])")
		return FALSE

	var/cached_total = total_volume
	if(cached_total + amount > maximum_volume)
		amount = maximum_volume - cached_total //Doesnt fit in. Make it disappear. shouldn't happen. Will happen.

	amount = round(amount, CHEMICAL_QUANTISATION_LEVEL)
	if(amount <= 0)
		return FALSE

	var/cached_temp = chem_temp
	var/list/cached_reagents = reagent_list

	//Equalize temperature - Not using specific_heat() because the new chemical isn't in yet.
	var/old_heat_capacity = 0
	if(reagtemp != cached_temp)
		for(var/datum/reagent/iter_reagent as anything in cached_reagents)
			old_heat_capacity += iter_reagent.specific_heat * iter_reagent.volume

	//add the reagent to the existing if it exists
	for(var/datum/reagent/iter_reagent as anything in cached_reagents)
		if(iter_reagent.type == reagent)
			iter_reagent.volume += amount
			update_total()

			iter_reagent.on_merge(data, amount)
			if(reagtemp != cached_temp)
				var/new_heat_capacity = getHeatCapacity()
				if(new_heat_capacity)
					set_temperature(((old_heat_capacity * cached_temp) + (iter_reagent.specific_heat * amount * reagtemp)) / new_heat_capacity)
				else
					set_temperature(reagtemp)

			SEND_SIGNAL(src, COMSIG_REAGENTS_ADD_REAGENT, iter_reagent, amount, reagtemp, data, no_react)
			if(!no_react && !is_reacting) //To reduce the amount of calculations for a reaction the reaction list is only updated on a reagents addition.
				handle_reactions()
			return amount

	//otherwise make a new one
	var/datum/reagent/new_reagent = new reagent(data)
	cached_reagents += new_reagent
	new_reagent.holder = src
	new_reagent.volume = amount
	new_reagent.on_new(data)

	if(isliving(my_atom))
		new_reagent.on_mob_add(my_atom, amount, metabolism_class) //Must occur before it could posibly run on_mob_delete


	update_total()
	if(reagtemp != cached_temp)
		var/new_heat_capacity = getHeatCapacity()
		if(new_heat_capacity)
			set_temperature(((old_heat_capacity * cached_temp) + (new_reagent.specific_heat * amount * reagtemp)) / new_heat_capacity)
		else
			set_temperature(reagtemp)

	SEND_SIGNAL(src, COMSIG_REAGENTS_NEW_REAGENT, new_reagent, amount, reagtemp, data, no_react)
	if(!no_react)
		handle_reactions()
	return TRUE

/**
 * Removes a specific reagent. can supress reactions if needed
 * Arguments
 *
 * * [reagent_type][datum/reagent] - the type of reagent
 * * amount - the volume to remove
 * * safety - if FALSE will initiate reactions upon removing. used for trans_id_to
 * * include_subtypes - if TRUE will remove the specified amount from all subtypes of reagent_type as well
 */
/datum/reagents/proc/remove_reagent(datum/reagent/reagent_type, amount, safety = TRUE, include_subtypes = FALSE)
	if(!ispath(reagent_type))
		stack_trace("invalid reagent passed to remove reagent [reagent_type]")
		return FALSE

	if(!IS_FINITE(amount))
		stack_trace("non finite amount passed to remove reagent [amount] [reagent_type]")
		return FALSE

	amount = round(amount, CHEMICAL_QUANTISATION_LEVEL)
	if(amount <= 0)
		return FALSE

	var/total_removed_amount = 0
	var/remove_amount = 0
	var/list/cached_reagents = reagent_list
	for(var/datum/reagent/cached_reagent as anything in cached_reagents)
		//check for specific type or subtypes
		if(!include_subtypes)
			if(cached_reagent.type != reagent_type)
				continue
		else if(!istype(cached_reagent, reagent_type))
			continue

		remove_amount = min(cached_reagent.volume, amount)
		cached_reagent.volume -= remove_amount

		update_total()
		if(!safety)//So it does not handle reactions when it need not to
			handle_reactions()
		SEND_SIGNAL(src, COMSIG_REAGENTS_REM_REAGENT, QDELING(cached_reagent) ? reagent_type : cached_reagent, amount)

		total_removed_amount += remove_amount

		//if we reached here means we have found our specific reagent type so break
		if(!include_subtypes)
			return total_removed_amount

	return round(total_removed_amount, CHEMICAL_VOLUME_ROUNDING)

/**
 * Removes all reagents either proportionally(amount is the direct volume to remove)
 * when proportional the total volume of all reagents removed will equal to amount
 * or relatively(amount is a percentile between 0->1) when relative amount is the %
 * of each reagent to be removed
 *
 * Arguments
 *
 * * amount - the amount to remove
 * * relative - if TRUE amount is treated as an percentage between 0->1. If FALSE amount is the direct volume to remove
 */
/datum/reagents/proc/remove_all(amount = 1, relative = FALSE)
	if(!total_volume)
		return FALSE

	if(!IS_FINITE(amount))
		stack_trace("non finite amount passed to remove all reagents [amount]")
		return FALSE
	if(relative && (amount < 0 || amount > 1))
		stack_trace("illegal percentage value passed to remove all reagents [amount]")
		return FALSE

	amount = round(amount, CHEMICAL_QUANTISATION_LEVEL)
	if(amount <= 0)
		return FALSE

	var/list/cached_reagents = reagent_list
	var/total_removed_amount = 0
	var/part = amount
	if(!relative)
		part /= total_volume
	for(var/datum/reagent/reagent as anything in cached_reagents)
		total_removed_amount += remove_reagent(reagent.type, reagent.volume * part)
	handle_reactions()

	return round(total_removed_amount, CHEMICAL_VOLUME_ROUNDING)

/**
 * Removes an specific reagent from this holder
 * Arguments
 *
 * * [target_reagent_typepath][datum/reagent] - type typepath of the reagent to remove
 */
/datum/reagents/proc/del_reagent(datum/reagent/target_reagent_typepath)
	if(!ispath(target_reagent_typepath))
		stack_trace("invalid reagent path passed to del reagent [target_reagent_typepath]")
		return FALSE

	//setting the volume to 0 will allow update_total() to clear it up for us
	var/list/cached_reagents = reagent_list
	for(var/datum/reagent/reagent as anything in cached_reagents)
		if(reagent.type == target_reagent_typepath)
			reagent.volume = 0
			update_total()
			return TRUE

	return FALSE

/**
 * Turn one reagent into another, preserving volume, temp, purity, ph
 * Arguments
 *
 * * [source_reagent_typepath][/datum/reagent] - the typepath of the reagent you are trying to convert
 * * [target_reagent_typepath][/datum/reagent] - the final typepath the source_reagent_typepath will be converted into
 * * multiplier - the multiplier applied on the source_reagent_typepath volume before converting
 * * include_source_subtypes- if TRUE will convert all subtypes of source_reagent_typepath into target_reagent_typepath as well
 */
/datum/reagents/proc/convert_reagent(
	datum/reagent/source_reagent_typepath,
	datum/reagent/target_reagent_typepath,
	multiplier = 1,
	include_source_subtypes = FALSE
)
	if(!ispath(source_reagent_typepath))
		stack_trace("invalid reagent path passed to convert reagent [source_reagent_typepath]")
		return FALSE

	var/reagent_amount = 0
	if(include_source_subtypes)
		var/list/reagent_type_list = typecacheof(source_reagent_typepath)
		for(var/datum/reagent/reagent as anything in reagent_list)
			if(is_type_in_typecache(reagent, reagent_type_list))
				reagent_amount += reagent.volume
				remove_reagent(reagent.type, reagent.volume * multiplier)
	else
		var/datum/reagent/source_reagent = has_reagent(source_reagent_typepath)
		if(istype(source_reagent))
			reagent_amount = source_reagent.volume
			remove_reagent(source_reagent_typepath, reagent_amount)

	if(reagent_amount > 0)
		add_reagent(target_reagent_typepath, reagent_amount * multiplier, reagtemp = chem_temp)

/// Remove every reagent except this one
/datum/reagents/proc/isolate_reagent(reagent)
	for(var/datum/reagent/cached_reagent as anything in reagent_list)
		if(cached_reagent.type != reagent)
			del_reagent(cached_reagent.type)
			update_total()

/// Removes all reagents
/datum/reagents/proc/clear_reagents()
	for(var/datum/reagent/reagent as anything in reagent_list)
		del_reagent(reagent.type)
	SEND_SIGNAL(src, COMSIG_REAGENTS_CLEAR_REAGENTS)


/**
 * Check if this holder contains this reagent.
 * Reagent takes a PATH to a reagent.
 * Amount checks for having a specific amount of that chemical.
 * Needs matabolizing takes into consideration if the chemical is matabolizing when it's checked.
 */
/datum/reagents/proc/has_reagent(reagent, amount = -1, needs_metabolizing = FALSE)
	for(var/datum/reagent/holder_reagent as anything in reagent_list)
		if (holder_reagent.type == reagent)
			if(!amount)
				if(needs_metabolizing && !holder_reagent.metabolizing)
					return FALSE
				return holder_reagent
			else
				if(round(holder_reagent.volume, CHEMICAL_QUANTISATION_LEVEL) >= amount)
					if(needs_metabolizing && !holder_reagent.metabolizing)
						return FALSE
					return holder_reagent
	return FALSE

/// Like has_reagent but you can enter a list.
/datum/reagents/proc/has_reagent_list(list/list_reagents)
	for(var/r_id in list_reagents)
		var/amt = list_reagents[r_id]
		if(!has_reagent(r_id, amt))
			return FALSE
	return TRUE

/**
 * Like add_reagent but you can enter a list.
 * Arguments
 *
 * * [list_reagents][list] - list to add. Format it like this: list(/datum/reagent/toxin = 10, "beer" = 15)
 * * [data][list] - additional data to add
 */
/datum/reagents/proc/add_reagent_list(list/list_reagents, list/data)
	for(var/r_id in list_reagents)
		var/amt = list_reagents[r_id]
		add_reagent(r_id, amt, data)

/// Like remove_reagent but you can enter a list.
/datum/reagents/proc/remove_reagent_list(list/list_reagents)
	for(var/r_id in list_reagents)
		var/amt = list_reagents[r_id]
		remove_reagent(r_id, amt)

/// Adds a reagent up to a cap.
/datum/reagents/proc/add_reagent_up_to(reagent, amount, cap)
	var/existing = get_reagent_amount(reagent)
	if(existing >= cap)
		return

	var/to_add = min(cap - amount, cap - existing, amount)
	return add_reagent(reagent, to_add)

/**
 * Check if this holder contains a reagent with a chemical_flags containing this flag
 * Reagent takes the bitflag to search for
 * Amount checks for having a specific amount of reagents matching that chemical
 */
/datum/reagents/proc/has_chemical_flag(chemical_flag, amount = 0)
	var/found_amount = 0
	for(var/datum/reagent/holder_reagent as anything in reagent_list)
		if (holder_reagent.chemical_flags & chemical_flag)
			found_amount += holder_reagent.volume
			if(found_amount >= amount)
				return TRUE
	return FALSE


/**
 * Transfer some stuff from this holder to a target object
 *
 * Arguments:
 * * obj/target - Target to attempt transfer to
 * * amount - amount of reagent volume to transfer
 * * multiplier - multiplies amount of each reagent by this number
 * * preserve_data - if preserve_data=0, the reagents data will be lost. Usefull if you use data for some strange stuff and don't want it to be transferred.
 * * no_react - passed through to [/datum/reagents/proc/add_reagent]
 * * mob/transfered_by - used for logging
 * * remove_blacklisted - skips transferring of reagents with REAGENT_SPECIAL in chemical_flags
 * * methods - passed through to [/datum/reagents/proc/expose_single] and [/datum/reagent/proc/on_transfer]
 * * show_message - passed through to [/datum/reagents/proc/expose_single]
 * * round_robin - if round_robin=TRUE, so transfer 5 from 15 water, 15 sugar and 15 plasma becomes 10, 15, 15 instead of 13.3333, 13.3333 13.3333. Good if you hate floating point errors
 */
/datum/reagents/proc/trans_to(obj/target, amount = 1, multiplier = 1, preserve_data = TRUE, no_react = FALSE, mob/transfered_by, remove_blacklisted = FALSE, methods = NONE, show_message = TRUE, round_robin = FALSE)
	if(QDELETED(target) || !total_volume)
		return FALSE

	if(!IS_FINITE(amount))
		stack_trace("non finite amount passed to trans_to [amount] amount of reagents")
		return FALSE

	var/list/cached_reagents = reagent_list
	var/cached_amount = amount
	var/atom/target_atom
	var/datum/reagents/R

	if(istype(target, /datum/reagents))
		R = target
		target_atom = R.my_atom
	else
		if(istype(target, /mob/living/carbon))
			var/mob/living/carbon/C = target
			if(methods & INGEST)
				var/obj/item/organ/stomach/belly = C.getorganslot(ORGAN_SLOT_STOMACH)
				if(!belly)
					C.expel_ingested(my_atom, amount)
					return
				R = belly.reagents
				target_atom = C

			else if(methods & TOUCH)
				R = C.touching
				target_atom = C

			else
				R = C.bloodstream
				target_atom = C

		else if(!target.reagents)
			return
		else
			R = target.reagents
			target_atom = target


	//Set up new reagents to inherit the old ongoing reactions
	if(!no_react)
		transfer_reactions(R)

	amount = min(min(amount, src.total_volume), R.maximum_volume-R.total_volume)
	var/trans_data = null
	var/transfer_log = list()
	if(!round_robin)
		var/part = amount / src.total_volume
		for(var/datum/reagent/reagent as anything in cached_reagents)
			if(remove_blacklisted && (reagent.chemical_flags & REAGENT_SPECIAL))
				continue
			var/transfer_amount = reagent.volume * part
			if(preserve_data)
				trans_data = copy_data(reagent)
			if(reagent.intercept_reagents_transfer(R, cached_amount))//Use input amount instead.
				continue
			if(!R.add_reagent(reagent.type, transfer_amount * multiplier, trans_data, chem_temp, no_react = TRUE, ignore_splitting = reagent.chemical_flags & REAGENT_DONOTSPLIT)) //we only handle reaction after every reagent has been transfered.
				continue
			if(methods)
				if(istype(target_atom, /obj/item/organ))
					R.expose_single(reagent, target, methods, transfer_amount, multiplier, show_message)
				else
					R.expose_single(reagent, target_atom, methods, transfer_amount, multiplier, show_message)
				reagent.on_transfer(target_atom, methods, transfer_amount * multiplier)

			remove_reagent(reagent.type, transfer_amount)
			var/list/reagent_qualities = list(REAGENT_TRANSFER_AMOUNT = transfer_amount)
			transfer_log[reagent.type] = reagent_qualities

	else
		var/to_transfer = amount
		for(var/datum/reagent/reagent as anything in cached_reagents)
			if(!to_transfer)
				break
			if(remove_blacklisted && (reagent.chemical_flags & REAGENT_SPECIAL))
				continue
			if(preserve_data)
				trans_data = copy_data(reagent)
			var/transfer_amount = amount
			if(amount > reagent.volume)
				transfer_amount = reagent.volume
			if(reagent.intercept_reagents_transfer(R, cached_amount))//Use input amount instead.
				continue
			if(!R.add_reagent(reagent.type, transfer_amount * multiplier, trans_data, chem_temp, no_react = TRUE, ignore_splitting = reagent.chemical_flags & REAGENT_DONOTSPLIT)) //we only handle reaction after every reagent has been transfered.
				continue
			to_transfer = max(to_transfer - transfer_amount , 0)
			if(methods)
				if(istype(target_atom, /obj/item/organ))
					R.expose_single(reagent, target, methods, transfer_amount, multiplier, show_message)
				else
					R.expose_single(reagent, target_atom, methods, transfer_amount, multiplier, show_message)
				reagent.on_transfer(target_atom, methods, transfer_amount * multiplier)

			remove_reagent(reagent.type, transfer_amount)
			var/list/reagent_qualities = list(REAGENT_TRANSFER_AMOUNT = transfer_amount)
			transfer_log[reagent.type] = reagent_qualities

	if(transfered_by && target_atom)
		target_atom.log_touch(transfered_by) //log prints so admins can figure out who touched it last.
		log_combat(transfered_by, target_atom, "transferred reagents ([get_external_reagent_log_string(transfer_log)]) from [my_atom] to")

	update_total()
	R.update_total()
	if(!no_react)
		R.handle_reactions()
		src.handle_reactions()
	return amount

/// Transfer a specific reagent id to the target object. Accepts a reagent instance, but assumes the reagent is in src.
/datum/reagents/proc/trans_id_to(obj/target, datum/reagent/reagent, amount=1, preserve_data=1)//Not sure why this proc didn't exist before. It does now! /N
	var/list/cached_reagents = reagent_list
	if (!target)
		return

	var/datum/reagents/holder
	if(istype(target, /datum/reagents))
		holder = target
	else if(target.reagents && total_volume > 0 && get_reagent_amount(reagent))
		holder = target.reagents
	else
		return
	if(amount <= CHEMICAL_QUANTISATION_LEVEL)
		return

	var/cached_amount = amount
	var/trans_data = null
	if(!istype(reagent))
		amount = min(get_reagent_amount(reagent), amount)
		amount = min(round(amount, CHEMICAL_VOLUME_ROUNDING), holder.maximum_volume - holder.total_volume)

		for (var/looping_through_reagents in cached_reagents)
			var/datum/reagent/current_reagent = looping_through_reagents
			if(current_reagent.type == reagent)
				if(preserve_data)
					trans_data = current_reagent.data
				if(current_reagent.intercept_reagents_transfer(holder, cached_amount))//Use input amount instead.
					break
				force_stop_reagent_reacting(current_reagent)
				holder.add_reagent(current_reagent.type, amount, trans_data, chem_temp, no_react = TRUE, ignore_splitting = current_reagent.chemical_flags & REAGENT_DONOTSPLIT)
				remove_reagent(current_reagent.type, amount, 1)
				break
	else
		amount = min(round(reagent.volume, CHEMICAL_QUANTISATION_LEVEL), amount)
		amount = min(round(amount, CHEMICAL_VOLUME_ROUNDING), holder.maximum_volume - holder.total_volume)
		if(preserve_data)
			trans_data = reagent.data
		if(!reagent.intercept_reagents_transfer(holder, cached_amount))//Use input amount instead.
			force_stop_reagent_reacting(reagent)
			holder.add_reagent(reagent.type, amount, trans_data, chem_temp, no_react = TRUE, ignore_splitting = reagent.chemical_flags & REAGENT_DONOTSPLIT)
			remove_reagent(reagent.type, amount, 1)

	update_total()
	holder.update_total()
	holder.handle_reactions()
	return amount

/// Copies the reagents to the target object
/datum/reagents/proc/copy_to(obj/target, amount = 1, multiplier = 1, preserve_data = TRUE, no_react = FALSE)
	var/list/cached_reagents = reagent_list
	if(!target || !total_volume)
		return

	var/datum/reagents/target_holder
	if(istype(target, /datum/reagents))
		target_holder = target
	else
		if(!target.reagents)
			return
		target_holder = target.reagents

	if(amount < 0)
		return

	amount = min(min(amount, total_volume), target_holder.maximum_volume - target_holder.total_volume)
	var/part = amount / total_volume
	var/trans_data = null
	for(var/datum/reagent/reagent as anything in cached_reagents)
		var/copy_amount = reagent.volume * part
		if(preserve_data)
			trans_data = reagent.data
		target_holder.add_reagent(reagent.type, copy_amount * multiplier, trans_data, chem_temp, no_react = TRUE, ignore_splitting = reagent.chemical_flags & REAGENT_DONOTSPLIT)

	if(!no_react)
		// pass over previous ongoing reactions before handle_reactions is called
		transfer_reactions(target_holder)

		target_holder.update_total()
		target_holder.handle_reactions()

	return amount

///Multiplies the reagents inside this holder by a specific amount
/datum/reagents/proc/multiply_reagents(multiplier=1)
	var/list/cached_reagents = reagent_list
	if(!total_volume)
		return
	var/change = (multiplier - 1) //Get the % change
	for(var/datum/reagent/reagent as anything in cached_reagents)
		if(change > 0)
			add_reagent(reagent.type, reagent.volume * change, ignore_splitting = reagent.chemical_flags & REAGENT_DONOTSPLIT)
		else
			remove_reagent(reagent.type, abs(reagent.volume * change)) //absolute value to prevent a double negative situation (removing -50% would be adding 50%)

	update_total()
	handle_reactions()


/// Get the name of the reagent there is the most of in this holder
/datum/reagents/proc/get_master_reagent_name()
	var/list/cached_reagents = reagent_list
	var/name
	var/max_volume = 0
	for(var/datum/reagent/reagent as anything in cached_reagents)
		if(reagent.volume > max_volume)
			max_volume = reagent.volume
			name = reagent.name

	return name

/// Get the id of the reagent there is the most of in this holder
/datum/reagents/proc/get_master_reagent_id()
	var/list/cached_reagents = reagent_list
	var/max_type
	var/max_volume = 0
	for(var/datum/reagent/reagent as anything in cached_reagents)
		if(reagent.volume > max_volume)
			max_volume = reagent.volume
			max_type = reagent.type

	return max_type

/// Get a reference to the reagent there is the most of in this holder
/datum/reagents/proc/get_master_reagent()
	var/list/cached_reagents = reagent_list
	var/datum/reagent/master
	var/max_volume = 0
	for(var/datum/reagent/reagent as anything in cached_reagents)
		if(reagent.volume > max_volume)
			max_volume = reagent.volume
			master = reagent

	return master
/*							MOB/CARBON RELATED PROCS 								*/

/**
 * Triggers metabolizing for all the reagents in this holder
 *
 * Arguments:
 * * mob/living/carbon/carbon - The mob to metabolize in, if null it uses [/datum/reagents/var/my_atom]
 * * delta_time - the time in server seconds between proc calls (when performing normally it will be 2)
 * * times_fired - the number of times the owner's life() tick has been called aka The number of times SSmobs has fired
 * * can_overdose - Allows overdosing
 * * liverless - Stops reagents that aren't set as [/datum/reagent/var/self_consuming] from metabolizing
 */
/datum/reagents/proc/metabolize(mob/living/carbon/owner, delta_time, times_fired, can_overdose = FALSE, liverless = FALSE, updatehealth = TRUE)
	if(owner)
		expose_temperature(owner.bodytemperature, 0.25)

	var/need_mob_update = FALSE
	for(var/datum/reagent/reagent as anything in reagent_list)
		if(owner.stat == DEAD && !(reagent.chemical_flags & REAGENT_DEAD_PROCESS))
			continue
		need_mob_update += metabolize_reagent(owner, reagent, delta_time, times_fired, can_overdose, liverless)

	update_total()

	if(owner && updatehealth && need_mob_update)
		owner.updatehealth()
		owner.update_damage_overlays()

	return need_mob_update

/*
 * Metabolises a single reagent for a target owner carbon mob. See above.
 *
 * Arguments:
 * * mob/living/carbon/owner - The mob to metabolize in, if null it uses [/datum/reagents/var/my_atom]
 * * delta_time - the time in server seconds between proc calls (when performing normally it will be 2)
 * * times_fired - the number of times the owner's life() tick has been called aka The number of times SSmobs has fired
 * * can_overdose - Allows overdosing
 * * liverless - Stops reagents that aren't set as [/datum/reagent/var/self_consuming] from metabolizing
 */
/datum/reagents/proc/metabolize_reagent(mob/living/carbon/owner, datum/reagent/reagent, delta_time, times_fired, can_overdose = FALSE, liverless = FALSE)
	var/need_mob_update = FALSE
	if(QDELETED(reagent.holder))
		return FALSE

	if(!owner)
		owner = reagent.holder.my_atom

	if(owner && reagent)
		if(liverless && !reagent.self_consuming) //need to be metabolized
			return
		if(!reagent.metabolizing)
			reagent.metabolizing = TRUE
			need_mob_update += reagent.on_mob_metabolize(owner, metabolism_class)

		if(can_overdose)
			if(reagent.overdose_threshold)
				if(reagent.volume >= reagent.overdose_threshold && !reagent.overdosed)
					reagent.overdosed = TRUE
					need_mob_update += reagent.overdose_start(owner)
					log_game("[key_name(owner)] has started overdosing on [reagent.name] at [reagent.volume] units.")

			if(reagent.overdosed)
				need_mob_update += reagent.overdose_process(owner)

		need_mob_update += reagent.on_mob_life(owner, metabolism_class, can_overdose)
	return need_mob_update

/// Signals that metabolization has stopped, triggering the end of trait-based effects
/datum/reagents/proc/end_metabolization(mob/living/carbon/C, keep_liverless = TRUE)
	for(var/datum/reagent/reagent as anything in reagent_list)
		if(QDELETED(reagent.holder))
			continue
		if(keep_liverless && reagent.self_consuming) //Will keep working without a liver
			continue
		if(!C)
			C = reagent.holder.my_atom
		if(reagent.metabolizing)
			reagent.metabolizing = FALSE
			reagent.on_mob_end_metabolize(C, metabolism_class)

/// Handle any reactions possible in this holder
/// Also UPDATES the reaction list
/// High potential for infinite loopsa if you're editing this.
/datum/reagents/proc/handle_reactions()
	if(QDELING(src))
		CRASH("[my_atom] is trying to handle reactions while being flagged for deletion. It presently has [length(reagent_list)] number of reactants in it. If that is over 0 then something terrible happened.")

	if(!length(reagent_list))//The liver is calling this method a lot, and is often empty of reagents so it's pointless busywork. It should be an easy fix, but I'm nervous about touching things beyond scope. Also since everything is so handle_reactions() trigger happy it might be a good idea having this check anyways.
		return FALSE

	if(flags & NO_REACT)
		if(is_reacting)
			force_stop_reacting() //Force anything that is trying to to stop
		return FALSE //Yup, no reactions here. No siree.

	if(is_reacting)//Prevent wasteful calculations
		if(datum_flags != DF_ISPROCESSING)//If we're reacting - but not processing (i.e. we've transfered)
			START_PROCESSING(SSreagents, src)
		if(!(has_changed_state()))
			return FALSE

	var/list/cached_reagents = reagent_list
	var/list/cached_reactions = SSreagents.chemical_reactions_list_reactant_index
	var/datum/cached_my_atom = my_atom
	LAZYNULL(failed_but_capable_reactions)

	. = 0
	var/list/possible_reactions = list()
	for(var/datum/reagent/reagent as anything in cached_reagents)
		for(var/datum/chemical_reaction/reaction as anything in cached_reactions[reagent.type]) // Was a big list but now it should be smaller since we filtered it with our reagent id
			if(!reaction)
				continue

			if(!reaction.required_reagents)//Don't bring in empty ones
				continue
			var/list/cached_required_reagents = reaction.required_reagents
			var/total_required_reagents = cached_required_reagents.len
			var/total_matching_reagents = 0
			var/list/cached_required_catalysts = reaction.required_catalysts
			var/total_required_catalysts = cached_required_catalysts.len
			var/total_matching_catalysts= 0
			var/matching_container = FALSE
			var/matching_other = FALSE
			var/required_temp = reaction.required_temp
			var/is_cold_recipe = reaction.is_cold_recipe
			var/meets_temp_requirement = FALSE
			var/granularity = 1
			if(!(reaction.reaction_flags & REACTION_INSTANT))
				granularity = CHEMICAL_VOLUME_MINIMUM

			for(var/req_reagent in cached_required_reagents)
				if(!has_reagent(req_reagent, (cached_required_reagents[req_reagent]*granularity)))
					break
				total_matching_reagents++

			for(var/_catalyst in cached_required_catalysts)
				if(!has_reagent(_catalyst, (cached_required_catalysts[_catalyst]*granularity)))
					break
				total_matching_catalysts++

			if(cached_my_atom)
				if(!reaction.required_container)
					matching_container = TRUE
				else
					if(cached_my_atom.type == reaction.required_container)
						matching_container = TRUE
				if (isliving(cached_my_atom) && !reaction.mob_react) //Makes it so certain chemical reactions don't occur in mobs
					matching_container = FALSE
				if(!reaction.required_other)
					matching_other = TRUE

				else if(istype(cached_my_atom, /obj/item/slime_extract))
					var/obj/item/slime_extract/extract = cached_my_atom

					if(extract.Uses > 0) // added a limit to slime cores -- Muskets requested this
						matching_other = TRUE
			else
				if(!reaction.required_container)
					matching_container = TRUE
				if(!reaction.required_other)
					matching_other = TRUE

			if(required_temp == 0 || (is_cold_recipe && chem_temp <= required_temp) || (!is_cold_recipe && chem_temp >= required_temp))
				meets_temp_requirement = TRUE

			if(total_matching_reagents == total_required_reagents && total_matching_catalysts == total_required_catalysts && matching_container && matching_other)
				if(meets_temp_requirement)
					possible_reactions += reaction
				else
					LAZYADD(failed_but_capable_reactions, reaction)

	update_previous_reagent_list()
	//This is the point where we have all the possible reactions from a reagent/catalyst point of view, so we set up the reaction list
	for(var/datum/chemical_reaction/selected_reaction as anything in possible_reactions)
		if((selected_reaction.reaction_flags & REACTION_INSTANT) || (flags & REAGENT_HOLDER_INSTANT_REACT)) //If we have instant reactions, we process them here
			instant_react(selected_reaction)
			.++
			update_total()
			continue
		else
			var/exists = FALSE
			for(var/datum/equilibrium/E_exist as anything in reaction_list)
				if(ispath(E_exist.reaction.type, selected_reaction.type)) //Don't add duplicates
					exists = TRUE

			//Add it if it doesn't exist in the list
			if(!exists)
				is_reacting = TRUE//Prevent any on_reaction() procs from infinite looping
				var/datum/equilibrium/equilibrium = new (selected_reaction, src) //Otherwise we add them to the processing list.
				if(equilibrium.to_delete)//failed startup checks
					qdel(equilibrium)
				else
					//Adding is done in new(), deletion is in qdel
					equilibrium.reaction.on_reaction(src, equilibrium, equilibrium.multiplier)
					equilibrium.react_timestep(1)//Get an initial step going so there's not a delay between setup and start - DO NOT ADD THIS TO equilibrium.NEW()

	if(LAZYLEN(reaction_list))
		is_reacting = TRUE //We've entered the reaction phase - this is set here so any reagent handling called in on_reaction() doesn't cause infinite loops
		START_PROCESSING(SSreagents, src) //see process() to see how reactions are handled
	else
		is_reacting = FALSE

	if(.)
		SEND_SIGNAL(src, COMSIG_REAGENTS_REACTED, .)

/*
* Main Reaction loop handler, Do not call this directly
*
* Checks to see if there's a reaction, then processes over the reaction list, removing them if flagged
* If any are ended, it displays the reaction message and removes it from the reaction list
* If the list is empty at the end it finishes reacting.
* Arguments:
* * delta_time - the time between each time step
*/
/datum/reagents/process(delta_time)
	if(!is_reacting)
		force_stop_reacting()
		stack_trace("[src] | [my_atom] was forced to stop reacting. This might be unintentional.")
	//sum of output messages.
	var/list/mix_message = list()
	//Process over our reaction list
	//See equilibrium.dm for mechanics
	var/num_reactions = 0
	for(var/datum/equilibrium/equilibrium as anything in reaction_list)
		//Continue reacting
		equilibrium.react_timestep(delta_time)
		num_reactions++
		//if it's been flagged to delete
		if(equilibrium.to_delete)
			var/temp_mix_message = end_reaction(equilibrium)
			if(!text_in_list(temp_mix_message, mix_message))
				mix_message += temp_mix_message
			continue
		SSblackbox.record_feedback("tally", "chemical_reaction", 1, "[equilibrium.reaction.type] total reaction steps")
	if(num_reactions)
		SEND_SIGNAL(src, COMSIG_REAGENTS_REACTION_STEP, num_reactions, delta_time)

	if(length(mix_message)) //This is only at the end
		my_atom.audible_message(span_notice("[icon2html(my_atom, viewers(DEFAULT_MESSAGE_RANGE, src))] [mix_message.Join()]"))

	if(!LAZYLEN(reaction_list))
		finish_reacting()
	else
		update_total()
		handle_reactions()

/*
* This ends a single instance of an ongoing reaction
*
* Arguments:
* * E - the equilibrium that will be ended
* Returns:
* * mix_message - the associated mix message of a reaction
*/
/datum/reagents/proc/end_reaction(datum/equilibrium/equilibrium)
	equilibrium.reaction.reaction_finish(src, equilibrium, equilibrium.reacted_vol)
	if(!equilibrium.holder || !equilibrium.reaction) //Somehow I'm getting empty equilibrium. This is here to handle them
		LAZYREMOVE(reaction_list, equilibrium)
		qdel(equilibrium)
		stack_trace("The equilibrium datum currently processing in this reagents datum had a nulled holder or nulled reaction. src holder:[my_atom] || src type:[my_atom.type] ") //Shouldn't happen. Does happen
		return
	if(equilibrium.holder != src) //When called from Destroy() eqs are nulled in smoke. This is very strange. This is probably causing it to spam smoke because of the runtime interupting the removal.
		stack_trace("The equilibrium datum currently processing in this reagents datum had a desynced holder to the ending reaction. src holder:[my_atom] | equilibrium holder:[equilibrium.holder.my_atom] || src type:[my_atom.type] | equilibrium holder:[equilibrium.holder.my_atom.type]")
		LAZYREMOVE(reaction_list, equilibrium)

	var/reaction_message = equilibrium.reaction.mix_message
	if(equilibrium.reaction.mix_sound)
		playsound(get_turf(my_atom), equilibrium.reaction.mix_sound, 80, TRUE)
	qdel(equilibrium)
	update_total()
	SEND_SIGNAL(src, COMSIG_REAGENTS_REACTED, .)
	return reaction_message

/*
* This stops the holder from processing at the end of a series of reactions (i.e. when all the equilibriums are completed)
*
* Also resets reaction variables to be null/empty/FALSE so that it can restart correctly in the future
*/
/datum/reagents/proc/finish_reacting()
	STOP_PROCESSING(SSreagents, src)
	is_reacting = FALSE
	LAZYNULL(previous_reagent_list) //reset it to 0 - because any change will be different now.
	update_total()

/*
* Force stops the current holder/reagents datum from reacting
*
* Calls end_reaction() for each equlilbrium datum in reaction_list and finish_reacting()
* Usually only called when a datum is transfered into a NO_REACT container
*/
/datum/reagents/proc/force_stop_reacting()
	var/list/mix_message = list()
	for(var/datum/equilibrium/equilibrium as anything in reaction_list)
		mix_message += end_reaction(equilibrium)
	if(my_atom && length(mix_message))
		my_atom.audible_message(span_notice("[icon2html(my_atom, viewers(DEFAULT_MESSAGE_RANGE, src))] [mix_message.Join()]"))
	finish_reacting()

/*
* Force stops a specific reagent's associated reaction if it exists
*
* Mostly used if a reagent is being taken out by trans_id_to
* Might have some other applciations
* Returns TRUE if it stopped something, FALSE if it didn't
* Arguments:
* * reagent - the reagent PRODUCT that we're seeking reactions for, any and all found will be shut down
*/
/datum/reagents/proc/force_stop_reagent_reacting(datum/reagent/reagent)
	var/any_stopped = FALSE
	var/list/mix_message = list()
	for(var/datum/equilibrium/equilibrium as anything in reaction_list)
		for(var/result in equilibrium.reaction.results)
			if(result == reagent.type)
				mix_message += end_reaction(equilibrium)
				any_stopped = TRUE
	if(length(mix_message))
		my_atom.audible_message(span_notice("[icon2html(my_atom, viewers(DEFAULT_MESSAGE_RANGE, src))][mix_message.Join()]"))
	return any_stopped

/*
* Transfers the reaction_list to a new reagents datum
*
* Arguments:
* * target - the datum/reagents that this src is being transfered into
*/
/datum/reagents/proc/transfer_reactions(datum/reagents/target)
	if(QDELETED(target))
		CRASH("transfer_reactions() had a [target] ([target.type]) passed to it when it was set to qdel, or it isn't a reagents datum.")
	if(!reaction_list)
		return
	for(var/datum/equilibrium/reaction_source as anything in reaction_list)
		var/exists = FALSE
		for(var/datum/equilibrium/reaction_target as anything in target.reaction_list) //Don't add duplicates
			if(reaction_source.reaction.type == reaction_target.reaction.type)
				exists = TRUE
		if(exists)
			continue
		if(!reaction_source.holder)
			CRASH("reaction_source is missing a holder in transfer_reactions()!")

		var/datum/equilibrium/new_E = new (reaction_source.reaction, target)//addition to reaction_list is done in new()
		if(new_E.to_delete)//failed startup checks
			qdel(new_E)

	target.previous_reagent_list = LAZYLISTDUPLICATE(previous_reagent_list)
	target.is_reacting = is_reacting

///Checks to see if the reagents has a difference in reagents_list and previous_reagent_list (I.e. if there's a difference between the previous call and the last)
///Also checks to see if the saved reactions in failed_but_capable_reactions can start as a result of temp change
/datum/reagents/proc/has_changed_state()
	//Check if reagents are different
	var/total_matching_reagents = 0
	for(var/reagent in previous_reagent_list)
		if(has_reagent(reagent))
			total_matching_reagents++
	if(total_matching_reagents != reagent_list.len)
		return TRUE

	//Check our last reactions
	for(var/datum/chemical_reaction/reaction as anything in failed_but_capable_reactions)
		if(reaction.is_cold_recipe)
			if(reaction.required_temp >= chem_temp)
				return TRUE
		else
			if(reaction.required_temp <= chem_temp)
				return TRUE
	return FALSE

/datum/reagents/proc/update_previous_reagent_list()
	LAZYNULL(previous_reagent_list)
	for(var/datum/reagent/reagent as anything in reagent_list)
		LAZYADD(previous_reagent_list, reagent.type)

/// Returns TRUE if this container's temp would overheat a reaction.
/datum/reagents/proc/is_reaction_overheating(datum/chemical_reaction/reaction)
	if(reaction.is_cold_recipe)
		if(chem_temp < reaction.overheat_temp && reaction.overheat_temp != NO_OVERHEAT)
			return TRUE

	else if(chem_temp > reaction.overheat_temp)
		return TRUE

	return FALSE

/// Gives feedback that a reaction is occuring. Returns an icon2html string.
/datum/reagents/proc/reaction_message(datum/chemical_reaction/reaction, is_overheating = is_reaction_overheating(reaction), atom/display_atom = my_atom)
	var/turf/T = get_turf(display_atom)
	if(isnull(T))
		return

	var/list/seen = viewers(4, display_atom)
	var/iconhtml = icon2html(display_atom, seen)

	if(is_overheating)
		display_atom.audible_message(span_alert("[iconhtml] [display_atom] sizzles as the solution boils off."))
		playsound(T, 'sound/effects/wounds/sizzle1.ogg', 80, TRUE)
		return

	display_atom.audible_message(span_notice("[iconhtml] [reaction.mix_message]"))
	if(reaction.mix_sound)
		playsound(T, reaction.mix_sound, 80, TRUE)


///Old reaction mechanics, edited to work on one only
///This is changed from the old - purity of the reagents will affect yield
/datum/reagents/proc/instant_react(datum/chemical_reaction/selected_reaction)
	var/list/cached_required_reagents = selected_reaction.required_reagents
	var/list/cached_results = selected_reaction.results
	var/datum/cached_my_atom = my_atom
	var/multiplier = INFINITY

	var/total_reagent_potency = 0
	for(var/reagent in cached_required_reagents)
		multiplier = round(min(multiplier, round(get_reagent_amount(reagent) / cached_required_reagents[reagent])))

	if(!multiplier)//Incase we're missing reagents - usually from on_reaction being called in an equlibrium when the results.len == 0 handlier catches a misflagged reaction
		return FALSE

	for(var/_reagent in cached_required_reagents)//this is not an object
		var/datum/reagent/reagent = has_reagent(_reagent)
		if (!reagent)
			continue

		if(istype(reagent, /datum/reagent/ichor))
			total_reagent_potency += reagent.data?["potency"] || 0

		remove_reagent(_reagent, (multiplier * cached_required_reagents[_reagent]), safety = 1)

	for(var/product in cached_results)
		multiplier = max(multiplier, 1) //this shouldn't happen ...
		var/yield = (cached_results[product]*multiplier)
		SSblackbox.record_feedback("tally", "chemical_reaction", yield, product)
		add_reagent(
			product,
			yield,
			total_reagent_potency && list("potency" = total_reagent_potency),
			chem_temp
		)

	if(cached_my_atom)
		if(!ismob(cached_my_atom)) // No bubbling mobs
			reaction_message(selected_reaction, display_atom = cached_my_atom)

		if(istype(cached_my_atom, /obj/item/slime_extract))
			var/list/seen = viewers(4, cached_my_atom)
			var/iconhtml = icon2html(cached_my_atom, seen)
			var/obj/item/slime_extract/extract = cached_my_atom
			extract.Uses--
			if(extract.Uses <= 0) // give the notification that the slime core is dead
				my_atom.visible_message(span_notice("[iconhtml] \The [cached_my_atom]'s power is consumed in the reaction."))
				extract.name = "used slime extract"
				extract.desc = "This extract has been used up."

	selected_reaction.on_reaction(src, null, multiplier)

///Possibly remove - see if multiple instant reactions is okay (Though, this "sorts" reactions by temp decending)
///Presently unused
/datum/reagents/proc/get_priority_instant_reaction(list/possible_reactions)
	if(!length(possible_reactions))
		return FALSE
	var/datum/chemical_reaction/selected_reaction = possible_reactions[1]
	//select the reaction with the most extreme temperature requirements
	for(var/datum/chemical_reaction/competitor as anything in possible_reactions)
		if(selected_reaction.is_cold_recipe)
			if(competitor.required_temp <= selected_reaction.required_temp)
				selected_reaction = competitor
		else
			if(competitor.required_temp >= selected_reaction.required_temp)
				selected_reaction = competitor
	return selected_reaction

/// Updates [/datum/reagents/var/total_volume]
/datum/reagents/proc/update_total()
	var/list/cached_reagents = reagent_list
	var/list/deleted_reagents = list()
	var/chem_index = 1
	var/num_reagents = length(cached_reagents)
	var/reagent_volume = 0
	. = 0

	//responsible for removing reagents and computing total ph & volume
	//all it's code was taken out of del_reagent() initially for efficiency purposes
	while(chem_index <= num_reagents)
		var/datum/reagent/reagent = cached_reagents[chem_index]
		chem_index += 1
		reagent_volume = round(reagent.volume, CHEMICAL_QUANTISATION_LEVEL) //round to this many decimal places

		//remove very small amounts of reagents
		if(reagent_volume <= 0 || (!is_reacting && reagent_volume < CHEMICAL_VOLUME_ROUNDING))
			//end metabolization
			if(isliving(my_atom))
				if(reagent.metabolizing)
					reagent.metabolizing = FALSE
					reagent.on_mob_end_metabolize(my_atom, metabolism_class)
				reagent.on_mob_delete(my_atom, metabolism_class)

			//removing it and store in a seperate list for processing later
			cached_reagents -= reagent
			LAZYREMOVE(previous_reagent_list, reagent.type)
			deleted_reagents += reagent

			//move pointer back so we don't overflow & decrease length
			chem_index -= 1
			num_reagents -= 1
			continue

		//compute volume & ph like we would normally
		. += reagent_volume

		//reasign rounded value
		reagent.volume = reagent_volume

	//assign the final values, rounding up can sometimes cause overflow so bring it down
	total_volume = min(round(., CHEMICAL_VOLUME_ROUNDING), maximum_volume)

	//now send the signals after the volume & ph has been computed
	for(var/datum/reagent/deleted_reagent as anything in deleted_reagents)
		SEND_SIGNAL(src, COMSIG_REAGENTS_DEL_REAGENT, deleted_reagent)
		qdel(deleted_reagent)

/**
 * Applies the relevant expose_ proc for every reagent in this holder
 * * [/datum/reagent/proc/expose_mob]
 * * [/datum/reagent/proc/expose_turf]
 * * [/datum/reagent/proc/expose_obj]
 *
 * Arguments
 * - Atom/A: What mob/turf/object is being exposed to reagents? This is your reaction target.
 * - Methods: What reaction type is the reagent itself going to call on the reaction target? Types are TOUCH, INGEST, VAPOR, PATCH, and INJECT.
 * - Volume_modifier: What is the reagent volume multiplied by when exposed? Note that this is called on the volume of EVERY reagent in the base body, so factor in your Maximum_Volume if necessary!
 * - Show_message: Whether to display anything to mobs when they are exposed.
 */
/datum/reagents/proc/expose(atom/A, methods = TOUCH, volume_modifier = 1, show_message = 1)
	if(isnull(A))
		return null

	var/list/cached_reagents = reagent_list
	if(!cached_reagents.len)
		return null

	var/list/reagents = list()
	for(var/datum/reagent/reagent as anything in cached_reagents)
		reagents[reagent] = reagent.volume * volume_modifier

	return A.expose_reagents(reagents, src, methods, volume_modifier, show_message, chem_temp)

/// Same as [/datum/reagents/proc/expose] but only for one reagent
/datum/reagents/proc/expose_single(datum/reagent/R, atom/A, methods = TOUCH, expose_volume, volume_modifier = 1, show_message = TRUE)
	if(isnull(A))
		return null

	if(ispath(R))
		R = get_reagent(R)
	if(isnull(R))
		return null

	// Yes, we need the parentheses.
	return A.expose_reagents(list((R) = expose_volume), src, methods, volume_modifier, show_message, chem_temp)

/// Is this holder full or not
/datum/reagents/proc/holder_full()
	return total_volume >= maximum_volume

/**
 * Get the amount of this reagent or the sum of all its subtypes if specified
 * Arguments
 * * [reagent][datum/reagent] - the typepath of the reagent to look for
 * * type_check - see defines under reagents.dm file
 */
/datum/reagents/proc/get_reagent_amount(datum/reagent/reagent, type_check = REAGENT_STRICT_TYPE)
	if(!ispath(reagent))
		stack_trace("invalid path passed to get_reagent_amount [reagent]")
		return 0
	var/list/cached_reagents = reagent_list

	var/total_amount = 0
	for(var/datum/reagent/cached_reagent as anything in cached_reagents)
		switch(type_check)
			if(REAGENT_STRICT_TYPE)
				if(cached_reagent.type != reagent)
					continue
			if(REAGENT_PARENT_TYPE) //to simulate typesof() which returns the type and then child types
				if(cached_reagent.type != reagent && type2parent(cached_reagent.type) != reagent)
					continue
			else
				if(!istype(cached_reagent, reagent))
					continue

		total_amount += cached_reagent.volume

		//short cut to break when we have found our one exact type
		if(type_check == REAGENT_STRICT_TYPE)
			return total_amount

	return round(total_amount, CHEMICAL_VOLUME_ROUNDING)

/// Get a comma separated string of every reagent name in this holder. UNUSED
/datum/reagents/proc/get_reagent_names()
	var/list/names = list()
	var/list/cached_reagents = reagent_list
	for(var/datum/reagent/reagent as anything in cached_reagents)
		names += reagent.name

	return jointext(names, ",")

/// helper function to preserve data across reactions (needed for xenoarch)
/datum/reagents/proc/get_data(reagent_id)
	var/list/cached_reagents = reagent_list
	for(var/datum/reagent/reagent as anything in cached_reagents)
		if(reagent.type == reagent_id)
			return reagent.data

/// helper function to preserve data across reactions (needed for xenoarch)
/datum/reagents/proc/set_data(reagent_id, new_data)
	var/list/cached_reagents = reagent_list
	for(var/datum/reagent/reagent as anything in cached_reagents)
		if(reagent.type == reagent_id)
			reagent.data = new_data

/// Shallow copies (deep copy of viruses) data from the provided reagent into our copy of that reagent
/datum/reagents/proc/copy_data(datum/reagent/current_reagent)
	if(!current_reagent || !current_reagent.data)
		return null
	if(!istype(current_reagent.data, /list))
		return current_reagent.data

	var/list/trans_data = current_reagent.data.Copy()

	// We do this so that introducing a virus to a blood sample
	// doesn't automagically infect all other blood samples from
	// the same donor.
	//
	// Technically we should probably copy all data lists, but
	// that could possibly eat up a lot of memory needlessly
	// if most data lists are read-only.
	if(trans_data["viruses"])
		var/list/v = trans_data["viruses"]
		trans_data["viruses"] = v.Copy()

	return trans_data

/// Get a reference to the reagent if it exists
/datum/reagents/proc/get_reagent(type)
	RETURN_TYPE(/datum/reagent)
	. = locate(type) in reagent_list

/**
 * Returns what this holder's reagents taste like
 *
 * Arguments:
 * * mob/living/taster - who is doing the tasting. Some mobs can pick up specific flavours.
 * * minimum_percent - the lower the minimum percent, the more sensitive the message is.
 */
/datum/reagents/proc/generate_taste_message(mob/living/taster, minimum_percent)
	var/list/out = list()
	var/list/tastes = list() //descriptor = strength
	if(minimum_percent <= 100)
		for(var/datum/reagent/reagent as anything in reagent_list)
			if(!reagent.taste_mult)
				continue

			var/list/taste_data = reagent.get_taste_description(taster)
			for(var/taste in taste_data)
				if(taste in tastes)
					tastes[taste] += taste_data[taste] * reagent.volume * reagent.taste_mult
				else
					tastes[taste] = taste_data[taste] * reagent.volume * reagent.taste_mult
		//deal with percentages
		// TODO it would be great if we could sort these from strong to weak
		var/total_taste = counterlist_sum(tastes)
		if(total_taste > 0)
			for(var/taste_desc in tastes)
				var/percent = tastes[taste_desc]/total_taste * 100
				if(percent < minimum_percent)
					continue
				var/intensity_desc = "a hint of"
				if(percent > minimum_percent * 2 || percent == 100)
					intensity_desc = ""
				else if(percent > minimum_percent * 3)
					intensity_desc = "the strong flavor of"
				if(intensity_desc != "")
					out += "[intensity_desc] [taste_desc]"
				else
					out += "[taste_desc]"

	return english_list(out, "something indescribable")


/// Returns the total heat capacity for all of the reagents currently in this holder.
/datum/reagents/proc/getHeatCapacity()
	. = 0
	var/list/cached_reagents = reagent_list //cache reagents
	for(var/datum/reagent/reagent in cached_reagents)
		. += reagent.specific_heat * reagent.volume

/** Adjusts the thermal energy of the reagents in this holder by an amount.
 *
 * Arguments:
 * - delta_energy: The amount to change the thermal energy by.
 * - min_temp: The minimum temperature that can be reached.
 * - max_temp: The maximum temperature that can be reached.
 */
/datum/reagents/proc/adjust_thermal_energy(delta_energy, min_temp = 2.7, max_temp = 1000, handle_reactions = TRUE)
	if(delta_energy == 0)
		return

	var/heat_capacity = getHeatCapacity()
	if(!heat_capacity)
		return // no div/0 please
	set_temperature(clamp(chem_temp + (delta_energy / heat_capacity), min_temp, max_temp))
	if(handle_reactions)
		handle_reactions()

/// Applies heat to this holder
/datum/reagents/proc/expose_temperature(temperature, coeff=0.02)
	if(istype(my_atom,/obj/item/reagent_containers))
		var/obj/item/reagent_containers/RCs = my_atom
		if(RCs.reagent_flags & NO_REACT) //stasis holders IE cryobeaker
			return

	var/temp_delta = (temperature - chem_temp) * coeff
	if(temp_delta == 0)
		return

	if(temp_delta > 0)
		chem_temp = min(chem_temp + max(temp_delta, 1), temperature)
	else
		chem_temp = max(chem_temp + min(temp_delta, -1), temperature)
	set_temperature(round(chem_temp))
	handle_reactions()

/** Sets the temperature of this reagent container to a new value.
 *
 * Handles setter signals.
 *
 * Arguments:
 * - _temperature: The new temperature value.
 */
/datum/reagents/proc/set_temperature(_temperature)
	if(_temperature == chem_temp)
		return

	. = chem_temp
	chem_temp = clamp(_temperature, 0, CHEMICAL_MAXIMUM_TEMPERATURE)
	SEND_SIGNAL(src, COMSIG_REAGENTS_TEMP_CHANGE, _temperature, .)

/**
 * Outputs a log-friendly list of reagents based on an external reagent list.
 *
 * Arguments:
 * * external_list - Assoc list of (reagent_type) = list(REAGENT_TRANSFER_AMOUNT = amounts)
 */
/datum/reagents/proc/get_external_reagent_log_string(external_list)
	if(!length(external_list))
		return "no reagents"

	var/list/data = list()

	for(var/reagent_type in external_list)
		var/list/qualities = external_list[reagent_type]
		data += "[reagent_type] ([round(qualities[REAGENT_TRANSFER_AMOUNT], 0.1)]u)"

	return english_list(data)

/**
 * Outputs a log-friendly list of reagents based on the internal reagent_list.
 *
 * Arguments:
 * * external_list - Assoc list of (reagent_type) = list(REAGENT_TRANSFER_AMOUNT = amounts)
 */
/datum/reagents/proc/get_reagent_log_string()
	if(!length(reagent_list))
		return "no reagents"

	var/list/data = list()

	for(var/datum/reagent/reagent as anything in reagent_list)
		data += "[reagent.type] ([round(reagent.volume, 0.1)]u)"

	return english_list(data)

/////////////////////////////////////////////////////////////////////////////////
///////////////////////////UI / REAGENTS LOOKUP CODE/////////////////////////////
/////////////////////////////////////////////////////////////////////////////////


/datum/reagents/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Reagents", "Reaction search")
		ui.status = UI_INTERACTIVE //How do I prevent a UI from autoclosing if not in LoS
		ui_tags_selected = NONE //Resync with gui on open (gui expects no flags)
		ui_reagent_id = null
		ui_reaction_id = null
		ui.open()


/datum/reagents/ui_status(mob/user)
	return UI_INTERACTIVE //please advise

/datum/reagents/ui_state(mob/user)
	return GLOB.physical_state

/datum/reagents/proc/generate_possible_reactions()
	var/list/cached_reagents = reagent_list
	if(!cached_reagents)
		return null
	var/list/cached_reactions = list()
	var/list/possible_reactions = list()
	if(!length(cached_reagents))
		return null
	cached_reactions = SSreagents.chemical_reactions_list_reactant_index
	for(var/_reagent in cached_reagents)
		var/datum/reagent/reagent = _reagent
		for(var/_reaction in cached_reactions[reagent.type]) // Was a big list but now it should be smaller since we filtered it with our reagent id
			var/datum/chemical_reaction/reaction = _reaction
			if(!_reaction)
				continue
			if(!reaction.required_reagents)//Don't bring in empty ones
				continue
			var/list/cached_required_reagents = reaction.required_reagents
			var/total_matching_reagents = 0
			for(var/req_reagent in cached_required_reagents)
				if(!has_reagent(req_reagent, (cached_required_reagents[req_reagent]*0.01)))
					continue
				total_matching_reagents++
			if(total_matching_reagents >= reagent_list.len)
				possible_reactions += reaction
	return possible_reactions

///Generates a (rough) rate vs temperature graph profile
/datum/reagents/proc/generate_thermodynamic_profile(datum/chemical_reaction/reaction)
	var/list/coords = list()
	var/x_temp
	var/increment
	if(reaction.is_cold_recipe)
		coords += list(list(0, 0))
		coords += list(list(reaction.required_temp, 0))
		x_temp = reaction.required_temp
		increment = (reaction.optimal_temp - reaction.required_temp)/10
		while(x_temp < reaction.optimal_temp)
			var/y = (((x_temp - reaction.required_temp)**reaction.temp_exponent_factor)/((reaction.optimal_temp - reaction.required_temp)**reaction.temp_exponent_factor))
			coords += list(list(x_temp, y))
			x_temp += increment
	else
		coords += list(list(reaction.required_temp, 0))
		x_temp = reaction.required_temp
		increment = (reaction.required_temp - reaction.optimal_temp)/10
		while(x_temp > reaction.optimal_temp)
			var/y = (((x_temp - reaction.required_temp)**reaction.temp_exponent_factor)/((reaction.optimal_temp - reaction.required_temp)**reaction.temp_exponent_factor))
			coords += list(list(x_temp, y))
			x_temp -= increment

	coords += list(list(reaction.optimal_temp, 1))
	if(reaction.overheat_temp == NO_OVERHEAT)
		if(reaction.is_cold_recipe)
			coords += list(list(reaction.optimal_temp+10, 1))
		else
			coords += list(list(reaction.optimal_temp-10, 1))
		return coords
	coords += list(list(reaction.overheat_temp, 1))
	coords += list(list(reaction.overheat_temp, 0))
	return coords

/datum/reagents/proc/generate_explosive_profile(datum/chemical_reaction/reaction)
	if(reaction.overheat_temp == NO_OVERHEAT)
		return null
	var/list/coords = list()
	coords += list(list(reaction.overheat_temp, 0))
	coords += list(list(reaction.overheat_temp, 1))
	if(reaction.is_cold_recipe)
		coords += list(list(reaction.overheat_temp-50, 1))
		coords += list(list(reaction.overheat_temp-50, 0))
	else
		coords += list(list(reaction.overheat_temp+50, 1))
		coords += list(list(reaction.overheat_temp+50, 0))
	return coords


///Returns a string descriptor of a reactions themic_constant
/datum/reagents/proc/determine_reaction_thermics(datum/chemical_reaction/reaction)
	var/thermic = reaction.thermic_constant
	if(reaction.reaction_flags & REACTION_HEAT_ARBITARY)
		thermic *= 100 //Because arbitary is a lower scale
	switch(thermic)
		if(-INFINITY to -1500)
			return "Overwhelmingly endothermic"
		if(-1500 to -1000)
			return "Extremely endothermic"
		if(-1000 to -500)
			return "Strongly endothermic"
		if(-500 to -200)
			return "Moderately endothermic"
		if(-200 to -50)
			return "Endothermic"
		if(-50 to 0)
			return "Weakly endothermic"
		if(0)
			return ""
		if(0 to 50)
			return "Weakly Exothermic"
		if(50 to 200)
			return "Exothermic"
		if(200 to 500)
			return "Moderately exothermic"
		if(500 to 1000)
			return "Strongly exothermic"
		if(1000 to 1500)
			return "Extremely exothermic"
		if(1500 to INFINITY)
			return "Overwhelmingly exothermic"

/datum/reagents/proc/parse_addictions(datum/reagent/reagent)
	var/addict_text = list()
	for(var/entry in reagent.addiction_types)
		var/datum/addiction/ref = SSaddiction.all_addictions[entry]
		switch(reagent.addiction_types[entry])
			if(-INFINITY to 0)
				continue
			if(0 to 5)
				addict_text += "Weak [ref.name]"
			if(5 to 10)
				addict_text += "[ref.name]"
			if(10 to 20)
				addict_text += "Strong [ref.name]"
			if(20 to INFINITY)
				addict_text += "Potent [ref.name]"
	return addict_text

/datum/reagents/ui_data(mob/user)
	var/data = list()
	data["selectedBitflags"] = ui_tags_selected
	data["currentReagents"] = previous_reagent_list //This keeps the string of reagents that's updated when handle_reactions() is called
	data["beakerSync"] = ui_beaker_sync
	data["linkedBeaker"] = my_atom.name //To solidify the fact that the UI is linked to a beaker - not a machine.

	//First we check to see if reactions are synced with the beaker
	if(ui_beaker_sync)
		if(reaction_list)//But we don't want to null the previously displayed if there are none
			//makes sure we're within bounds
			if(ui_reaction_index > reaction_list.len)
				ui_reaction_index = reaction_list.len
			ui_reaction_id = reaction_list[ui_reaction_index].reaction.type

	//reagent lookup data
	if(ui_reagent_id)
		var/datum/reagent/reagent = find_reagent_object_from_type(ui_reagent_id)
		if(!reagent)
			to_chat(user, "Could not find reagent!")
			ui_reagent_id = null
		else
			data["reagent_mode_reagent"] = list("name" = reagent.name, "id" = reagent.type, "desc" = reagent.description, "reagentCol" = reagent.color, "metaRate" = (reagent.metabolization_rate/2), "OD" = reagent.overdose_threshold)
			data["reagent_mode_reagent"]["addictions"] = list()
			data["reagent_mode_reagent"]["addictions"] = parse_addictions(reagent)

			if(reagent.chemical_flags & REAGENT_DEAD_PROCESS)
				data["reagent_mode_reagent"] += list("deadProcess" = TRUE)
	else
		data["reagent_mode_reagent"] = null

	//reaction lookup data
	if (ui_reaction_id)

		var/datum/chemical_reaction/reaction = get_chemical_reaction(ui_reaction_id)
		if(!reaction)
			to_chat(user, "Could not find reaction!")
			ui_reaction_id = null
			return data
		//Required holder
		var/container_name
		if(reaction.required_container)
			var/list/names = splittext("[reaction.required_container]", "/")
			container_name = "[names[names.len-1]] [names[names.len]]"
			container_name = replacetext(container_name, "_", " ")

		//Next, find the product
		var/has_product = TRUE
		//If we have no product, use the typepath to create a name for it
		if(!length(reaction.results))
			has_product = FALSE
			var/list/names = splittext("[reaction.type]", "/")
			var/product_name = names[names.len]
			data["reagent_mode_recipe"] = list("name" = product_name, "id" = reaction.type, "hasProduct" = has_product, "reagentCol" = "#FFFFFF", "thermodynamics" = generate_thermodynamic_profile(reaction), "explosive" = generate_explosive_profile(reaction), "thermics" = determine_reaction_thermics(reaction), "thermoUpper" = reaction.rate_up_lim, "tempMin" = reaction.required_temp, "explodeTemp" = reaction.overheat_temp, "reqContainer" = container_name, "subReactLen" = 1, "subReactIndex" = 1)

		//If we do have a product then we find it
		else
			//Find out if we have multiple reactions for the same product
			var/datum/reagent/primary_reagent = find_reagent_object_from_type(reaction.results[1])//We use the first product - though it might be worth changing this
			//If we're syncing from the beaker
			var/list/sub_reactions = list()
			if(ui_beaker_sync && reaction_list)
				for(var/_ongoing_eq in reaction_list)
					var/datum/equilibrium/ongoing_eq = _ongoing_eq
					var/ongoing_r = ongoing_eq.reaction
					sub_reactions += ongoing_r
			else
				sub_reactions = get_recipe_from_reagent_product(primary_reagent.type)
			var/sub_reaction_length = length(sub_reactions)
			var/i = 1
			for(var/datum/chemical_reaction/sub_reaction in sub_reactions)
				if(sub_reaction.type == reaction.type)
					ui_reaction_index = i //update our index
					break
				i += 1
			data["reagent_mode_recipe"] = list("name" = primary_reagent.name, "id" = reaction.type, "hasProduct" = has_product, "reagentCol" = primary_reagent.color, "thermodynamics" = generate_thermodynamic_profile(reaction), "explosive" = generate_explosive_profile(reaction), "thermics" = determine_reaction_thermics(reaction), "thermoUpper" = reaction.rate_up_lim, "tempMin" = reaction.required_temp, "explodeTemp" = reaction.overheat_temp, "reqContainer" = container_name, "subReactLen" = sub_reaction_length, "subReactIndex" = ui_reaction_index)

		//Results sweep
		var/has_reagent = "default"
		for(var/_reagent in reaction.results)
			var/datum/reagent/reagent = find_reagent_object_from_type(_reagent)
			if(has_reagent(_reagent))
				has_reagent = "green"
			data["reagent_mode_recipe"]["products"] += list(list("name" = reagent.name, "id" = reagent.type, "ratio" = reaction.results[reagent.type], "hasReagentCol" = has_reagent))

		//Reactant sweep
		for(var/_reagent in reaction.required_reagents)
			var/datum/reagent/reagent = find_reagent_object_from_type(_reagent)
			var/color_r = "default" //If the holder is missing the reagent, it's displayed in orange
			if(has_reagent(reagent.type))
				color_r = "green" //It's green if it's present
			var/tooltip
			var/tooltip_bool = FALSE
			var/list/sub_reactions = get_recipe_from_reagent_product(reagent.type)
			//Get sub reaction possibilities, but ignore ones that need a specific holder atom
			var/sub_index = 0
			for(var/datum/chemical_reaction/sub_reaction as anything in sub_reactions)
				if(sub_reaction.required_container)//So we don't have slime reactions confusing things
					sub_index++
					continue
				sub_index++
				break
			if(sub_index)
				var/datum/chemical_reaction/sub_reaction = sub_reactions[sub_index]
				//Subreactions sweep (if any)
				for(var/_sub_reagent in sub_reaction.required_reagents)
					var/datum/reagent/sub_reagent = find_reagent_object_from_type(_sub_reagent)
					tooltip += "[sub_reaction.required_reagents[_sub_reagent]]u [sub_reagent.name]\n" //I forgot the better way of doing this - fix this after this works
					tooltip_bool = TRUE
			data["reagent_mode_recipe"]["reactants"] += list(list("name" = reagent.name, "id" = reagent.type, "ratio" = reaction.required_reagents[reagent.type], "color" = color_r, "tooltipBool" = tooltip_bool, "tooltip" = tooltip))

		//Catalyst sweep
		for(var/_reagent in reaction.required_catalysts)
			var/datum/reagent/reagent = find_reagent_object_from_type(_reagent)
			var/color_r = "default"
			if(has_reagent(reagent.type))
				color_r = "green"
			var/tooltip
			var/tooltip_bool = FALSE
			var/list/sub_reactions = get_recipe_from_reagent_product(reagent.type)
			if(length(sub_reactions))
				var/datum/chemical_reaction/sub_reaction = sub_reactions[1]
				//Subreactions sweep (if any)
				for(var/_sub_reagent in sub_reaction.required_reagents)
					var/datum/reagent/sub_reagent = find_reagent_object_from_type(_sub_reagent)
					tooltip += "[sub_reaction.required_reagents[_sub_reagent]]u [sub_reagent.name]\n" //I forgot the better way of doing this - fix this after this works
					tooltip_bool = TRUE
			data["reagent_mode_recipe"]["catalysts"] += list(list("name" = reagent.name, "id" = reagent.type, "ratio" = reaction.required_catalysts[reagent.type], "color" = color_r, "tooltipBool" = tooltip_bool, "tooltip" = tooltip))
		data["reagent_mode_recipe"]["isColdRecipe"] = reaction.is_cold_recipe
	else
		data["reagent_mode_recipe"] = null

	return data

/datum/reagents/ui_static_data(mob/user)
	var/data = list()
	//Use GLOB list - saves processing
	data["master_reaction_list"] = SSreagents.chemical_reactions_results_lookup_list
	return data

/* Returns a reaction type by index from an input reagent type
* i.e. the input reagent's associated reactions are found, and the index determines which one to return
* If the index is out of range, it is set to 1
*/
/datum/reagents/proc/get_reaction_from_indexed_possibilities(path, index = null)
	if(index)
		ui_reaction_index = index
	var/list/sub_reactions = get_recipe_from_reagent_product(path)
	if(!length(sub_reactions))
		to_chat(usr, "There is no recipe associated with this product.")
		return FALSE
	if(ui_reaction_index > length(sub_reactions))
		ui_reaction_index = 1
	var/datum/chemical_reaction/reaction = sub_reactions[ui_reaction_index]
	return reaction.type

/datum/reagents/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("find_reagent_reaction")
			ui_reaction_id = get_reaction_from_indexed_possibilities(text2path(params["id"]))
			return TRUE
		if("reagent_click")
			ui_reagent_id = text2path(params["id"])
			return TRUE
		if("recipe_click")
			ui_reaction_id = text2path(params["id"])
			return TRUE
		if("search_reagents")
			var/input_reagent = (input("Enter the name of any reagent", "Input") as text|null)
			input_reagent = get_reagent_type_from_product_string(input_reagent) //from string to type
			var/datum/reagent/reagent = find_reagent_object_from_type(input_reagent)
			if(!reagent)
				to_chat(usr, "Could not find reagent!")
				return FALSE
			ui_reagent_id = reagent.type
			return TRUE
		if("search_recipe")
			var/input_reagent = (input("Enter the name of product reagent", "Input") as text|null)
			input_reagent = get_reagent_type_from_product_string(input_reagent) //from string to type
			var/datum/reagent/reagent = find_reagent_object_from_type(input_reagent)
			if(!reagent)
				to_chat(usr, "Could not find product reagent!")
				return
			ui_reaction_id = get_reaction_from_indexed_possibilities(reagent.type)
			return TRUE
		if("increment_index")
			ui_reaction_index += 1
			if(!ui_beaker_sync || !reaction_list)
				ui_reaction_id = get_reaction_from_indexed_possibilities(get_reagent_type_from_product_string(params["id"]))
			return TRUE
		if("reduce_index")
			if(ui_reaction_index == 1)
				return
			ui_reaction_index -= 1
			if(!ui_beaker_sync || !reaction_list)
				ui_reaction_id = get_reaction_from_indexed_possibilities(get_reagent_type_from_product_string(params["id"]))
			return TRUE
		if("beaker_sync")
			ui_beaker_sync = !ui_beaker_sync
			return TRUE
		if("update_ui")
			return TRUE


///////////////////////////////////////////////////////////////////////////////////


/**
 * Convenience proc to create a reagents holder for an atom
 *
 * Arguments:
 * * max_vol - maximum volume of holder
 * * flags - flags to pass to the holder
 */
/atom/proc/create_reagents(max_vol, flags)
	if(reagents)
		qdel(reagents)
	reagents = new /datum/reagents(max_vol, flags)
	reagents.my_atom = src

/atom/movable/chem_holder
	name = "This atom exists to hold chems. If you can see this, make an issue report"
	desc = "God this is stupid"

#undef REAGENT_TRANSFER_AMOUNT

#undef REAGENTS_UI_MODE_LOOKUP
#undef REAGENTS_UI_MODE_REAGENT
#undef REAGENTS_UI_MODE_RECIPE
