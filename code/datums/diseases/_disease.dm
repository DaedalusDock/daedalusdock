/datum/disease
	/// The mob affected by this disease. Can be null.
	var/mob/living/carbon/affected_mob = null
	//Flags
	var/visibility_flags = 0
	var/disease_flags = DISEASE_CURABLE | DISEASE_RESIST_ON_CURE | DISEASE_NEED_ALL_CURES
	var/spread_flags = DISEASE_SPREAD_AIRBORNE | DISEASE_SPREAD_CONTACT_FLUIDS | DISEASE_SPREAD_CONTACT_SKIN

	//Fluff
	var/form = "Virus"
	var/name = "No disease"
	var/desc = ""
	var/agent = "some microbes"
	var/spread_text = ""
	var/cure_text = ""

	//Stages
	var/stage = 1
	var/max_stages = 0
	/// The probability of this infection advancing a stage every second the cure is not present.
	var/stage_prob = 2

	//Cure data
	/// A list of mob typepaths that can carry this disease.
	var/list/viable_mobtypes = list()
	/// A list of reagent typepaths that are cures for the disease.
	var/list/cures = list()
	/// The probability of this infection being cured every second the cure is present
	var/cure_chance = 4

	//Transmission data
	/// The probability of spreading through the air every second
	var/infectivity = 41
	/// If TRUE, this disease can infact mobs that have the VIRUSIMMUNITY trait.
	var/bypasses_immunity = FALSE
	/// A modifier applied to contraction chance.
	var/contraction_chance_modifier = 1
	/// A list of organ and bodypart typepaths that are needed for this disease to be contracted.
	var/list/required_organs = list()
	/// Biotypes that this pathogen can infect.
	var/infectable_biotypes = MOB_ORGANIC
	/// If TRUE, stage_act() will be run even if the host is dead.
	var/process_dead = FALSE
	/// An optional typepath of disease to provide when Copy() is run.
	var/copy_type = null

	//Other
	/// The arbitrary severity of the disease
	var/severity = DISEASE_SEVERITY_NONTHREAT
	/// If TRUE, the mob is a carrier only and does not feel the effects of the disease.
	var/affected_mob_is_only_carrier = FALSE

/datum/disease/Destroy()
	if(affected_mob)
		remove_disease()
	SSdisease.active_diseases.Remove(src)
	return ..()

//add this disease if the host does not already have too many
/datum/disease/proc/try_infect(mob/living/infectee, make_copy = TRUE)
	infect(infectee, make_copy)
	return TRUE

//add the disease with no checks
/datum/disease/proc/infect(mob/living/infectee, make_copy = TRUE)
	var/datum/disease/D = make_copy ? Copy() : src
	LAZYADD(infectee.diseases, D)
	D.affected_mob = infectee
	SSdisease.active_diseases += D //Add it to the active diseases list, now that it's actually in a mob and being processed.

	D.after_add()
	infectee.med_hud_set_status()

	var/turf/source_turf = get_turf(infectee)
	log_virus("[key_name(infectee)] was infected by virus: [src.admin_details()] at [loc_name(source_turf)]")

//Return a string for admin logging uses, should describe the disease in detail
/datum/disease/proc/admin_details()
	return "[src.name] : [src.type]"


///Proc to process the disease and decide on whether to advance, cure or make the sympthoms appear. Returns a boolean on whether to continue acting on the symptoms or not.
/datum/disease/proc/stage_act(delta_time, times_fired)
	if(can_cure_affected())
		if(DT_PROB(cure_chance, delta_time))
			update_stage(max(stage - 1, 1))

		if(DT_PROB(cure_chance, delta_time))
			force_cure()
			return FALSE

	else if(DT_PROB(stage_prob, delta_time))
		update_stage(min(stage + 1, max_stages))

	return !affected_mob_is_only_carrier

/// Setter for the stage var
/datum/disease/proc/update_stage(new_stage)
	stage = new_stage

/// Returns TRUE if the affected mob can be cured.
/datum/disease/proc/can_cure_affected()
	if(!(disease_flags & DISEASE_CURABLE))
		return FALSE

	. = cures.len
	for(var/C_id in cures)
		if(!affected_mob.reagents.has_reagent(C_id))
			.--

	if(!. || ((disease_flags & DISEASE_NEED_ALL_CURES) && (. < cures.len)))
		return FALSE

//Airborne spreading
/datum/disease/proc/spread(force_spread = 0)
	if(!affected_mob)
		return

	if(!(spread_flags & DISEASE_SPREAD_AIRBORNE) && !force_spread)
		return

	if(affected_mob.reagents.has_reagent(/datum/reagent/medicine/spaceacillin) || (affected_mob.satiety > 0 && prob(affected_mob.satiety/10)))
		return

	var/spread_range = 2

	if(force_spread)
		spread_range = force_spread

	var/turf/T = affected_mob.loc
	if(istype(T))
		for(var/mob/living/carbon/C in oview(spread_range, affected_mob))
			var/turf/V = get_turf(C)
			if(disease_air_spread_walk(T, V))
				C.AirborneContractDisease(src, force_spread)

/proc/disease_air_spread_walk(turf/start, turf/end)
	if(!start || !end)
		return FALSE
	while(TRUE)
		if(end == start)
			return TRUE
		var/turf/Temp = get_step_towards(end, start)
		var/air_blocked
		ATMOS_CANPASS_TURF(air_blocked, end, Temp)
		if(air_blocked & AIR_BLOCKED) //Don't go through a wall
			return FALSE
		end = Temp


/// Cure the disease and delete it.
/datum/disease/proc/force_cure(add_resistance = TRUE)
	if(affected_mob)
		if(add_resistance && (disease_flags & DISEASE_RESIST_ON_CURE))
			LAZYOR(affected_mob.disease_resistances, GetDiseaseID())

	qdel(src)
	return TRUE

/datum/disease/proc/IsSame(datum/disease/D)
	if(istype(D, type))
		return TRUE
	return FALSE


/datum/disease/proc/Copy()
	//note that stage is not copied over - the copy starts over at stage 1
	var/static/list/copy_vars = list(
		NAMEOF_STATIC(src, name),
		NAMEOF_STATIC(src, visibility_flags),
		NAMEOF_STATIC(src, disease_flags),
		NAMEOF_STATIC(src, spread_flags),
		NAMEOF_STATIC(src, form),
		NAMEOF_STATIC(src, desc),
		NAMEOF_STATIC(src, agent),
		NAMEOF_STATIC(src, spread_text),
		NAMEOF_STATIC(src, cure_text),
		NAMEOF_STATIC(src, max_stages),
		NAMEOF_STATIC(src, stage_prob),
		NAMEOF_STATIC(src, viable_mobtypes),
		NAMEOF_STATIC(src, cures),
		NAMEOF_STATIC(src, infectivity),
		NAMEOF_STATIC(src, cure_chance),
		NAMEOF_STATIC(src, bypasses_immunity),
		NAMEOF_STATIC(src, contraction_chance_modifier),
		NAMEOF_STATIC(src, severity),
		NAMEOF_STATIC(src, required_organs),
		NAMEOF_STATIC(src, infectable_biotypes),
		NAMEOF_STATIC(src, process_dead)
	)

	var/datum/disease/D = copy_type ? new copy_type() : new type()
	for(var/V in copy_vars)
		var/val = vars[V]
		if(islist(val))
			var/list/L = val
			val = L.Copy()
		D.vars[V] = val
	return D

/datum/disease/proc/after_add()
	return


/datum/disease/proc/GetDiseaseID()
	return "[type]"

/datum/disease/proc/remove_disease()
	LAZYREMOVE(affected_mob.diseases, src) //remove the datum from the list
	affected_mob.med_hud_set_status()
	affected_mob = null

/**
 * Checks the given typepath against the list of viable mobtypes.
 *
 * Returns TRUE if the mob_type path is derived from of any entry in the viable_mobtypes list.
 * Returns FALSE otherwise.
 *
 * Arguments:
 * * mob_type - Type path to check against the viable_mobtypes list.
 */
/datum/disease/proc/is_viable_mobtype(mob_type)
	for(var/viable_type in viable_mobtypes)
		if(ispath(mob_type, viable_type))
			return TRUE

	// Let's only do this check if it fails. Did some genius coder pass in a non-type argument?
	if(!ispath(mob_type))
		stack_trace("Non-path argument passed to mob_type variable: [mob_type]")

	return FALSE

//Use this to compare severities
/proc/get_disease_severity_value(severity)
	switch(severity)
		if(DISEASE_SEVERITY_POSITIVE)
			return 1
		if(DISEASE_SEVERITY_NONTHREAT)
			return 2
		if(DISEASE_SEVERITY_MINOR)
			return 3
		if(DISEASE_SEVERITY_MEDIUM)
			return 4
		if(DISEASE_SEVERITY_HARMFUL)
			return 5
		if(DISEASE_SEVERITY_DANGEROUS)
			return 6
		if(DISEASE_SEVERITY_BIOHAZARD)
			return 7
