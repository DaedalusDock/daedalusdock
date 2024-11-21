/datum/pathogen
	/// The mob affected by this disease. Can be null.
	var/mob/living/carbon/affected_mob = null
	//Flags
	var/visibility_flags = 0
	var/pathogen_flags = PATHOGEN_CURABLE | PATHOGEN_RESIST_ON_CURE | PATHOGEN_NEED_ALL_CURES | PATHOGEN_REGRESS_TO_CURE
	var/spread_flags = PATHOGEN_SPREAD_AIRBORNE | PATHOGEN_SPREAD_CONTACT_FLUIDS | PATHOGEN_SPREAD_CONTACT_SKIN

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
	var/severity = PATHOGEN_SEVERITY_NONTHREAT
	/// If TRUE, the mob is a carrier only and does not feel the effects of the disease.
	var/affected_mob_is_only_carrier = FALSE

/datum/pathogen/Destroy()
	if(affected_mob)
		remove_disease_from_host()
	SSpathogens.active_pathogens.Remove(src)
	return ..()

/// Removes the disease from the host mob.
/datum/pathogen/proc/remove_disease_from_host()
	PROTECTED_PROC(TRUE)
	SHOULD_CALL_PARENT(TRUE)

	LAZYREMOVE(affected_mob.diseases, src) //remove the datum from the list
	affected_mob.med_hud_set_status()
	affected_mob = null

/// Attempt to infect a mob with this disease. Currently, only advance diseases can fail this. Returns TRUE on success.
/datum/pathogen/proc/try_infect(mob/living/infectee, make_copy = TRUE)
	force_infect(infectee, make_copy)
	return TRUE

/// Infect a mob with absolutely no safety checks.
/datum/pathogen/proc/force_infect(mob/living/infectee, make_copy = TRUE)
	var/datum/pathogen/D = make_copy ? Copy() : src

	LAZYADD(infectee.diseases, D)
	D.affected_mob = infectee
	SSpathogens.active_pathogens += D //Add it to the active diseases list, now that it's actually in a mob and being processed.

	D.on_infect_mob()

	var/turf/source_turf = get_turf(infectee)
	log_virus("[key_name(infectee)] was infected by virus: [admin_details()] at [loc_name(source_turf)]")

/// Called by force_infect() upon infecting a mob.
/datum/pathogen/proc/on_infect_mob()
	SHOULD_CALL_PARENT(TRUE)
	affected_mob.med_hud_set_status()

/// Cure the disease and delete it.
/datum/pathogen/proc/force_cure(add_resistance = TRUE)
	if(affected_mob)
		if(add_resistance && (pathogen_flags & PATHOGEN_RESIST_ON_CURE))
			LAZYOR(affected_mob.disease_resistances, get_id())

		log_virus("[key_name(affected_mob)] was cured from virus: [admin_details()] at [loc_name(get_turf(affected_mob))]")

	qdel(src)
	return TRUE

/// Return a string for admin logging uses, should describe the disease in detail
/datum/pathogen/proc/admin_details()
	return "[src.name] : [src.type]"

/// Proc to process the disease and decide on whether to advance, cure or make the sympthoms appear.
/// Returns a boolean on whether to continue acting on the symptoms or not.
/datum/pathogen/proc/on_process(delta_time, times_fired)
	if(can_cure_affected())
		if(stage == 1 || !(pathogen_flags & PATHOGEN_REGRESS_TO_CURE))
			if(DT_PROB(cure_chance, delta_time))
				force_cure()
				return FALSE

		if(stage > 1 && DT_PROB(cure_chance, delta_time))
			set_stage(stage - 1)

	else if(stage < max_stages && DT_PROB(stage_prob, delta_time))
		set_stage(stage + 1)

	return !affected_mob_is_only_carrier

/// Setter for the stage var, returns the old stage.
/datum/pathogen/proc/set_stage(new_stage)
	. = stage
	stage = new_stage

/// Returns TRUE if the affected mob can be cured.
/datum/pathogen/proc/can_cure_affected()
	if(!(pathogen_flags & PATHOGEN_CURABLE))
		return FALSE

	. = cures.len
	for(var/C_id in cures)
		if(!affected_mob.reagents.has_reagent(C_id))
			.--

	if(!. || ((pathogen_flags & PATHOGEN_NEED_ALL_CURES) && (. < cures.len)))
		return FALSE

/// Attempt to spread to nearby mobs through the air.
/datum/pathogen/proc/airborne_spread(force_spread = 0, check_mob_spreadability = TRUE)
	if(!affected_mob)
		return

	if(!isturf(affected_mob.loc))
		return

	if(!(spread_flags & PATHOGEN_SPREAD_AIRBORNE) && !force_spread)
		return

	if(check_mob_spreadability && !affected_mob.can_spread_airborne_pathogens())
		return

	if(affected_mob.reagents.has_reagent(/datum/reagent/medicine/spaceacillin) || (affected_mob.satiety > 0 && prob(affected_mob.satiety/10)))
		return

	var/turf/T = affected_mob.loc
	var/spread_range = force_spread || 2

	for(var/mob/living/carbon/C in oview(spread_range, affected_mob))
		var/turf/V = get_turf(C)
		if(disease_air_spread_walk(T, V))
			C.try_airborne_contract_pathogen(src, force_spread)

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

/datum/pathogen/proc/IsSame(datum/pathogen/D)
	if(get_id() == D.get_id())
		return TRUE
	return FALSE


/datum/pathogen/proc/Copy()
	//note that stage is not copied over - the copy starts over at stage 1
	var/static/list/copy_vars = list(
		NAMEOF_STATIC(src, name),
		NAMEOF_STATIC(src, visibility_flags),
		NAMEOF_STATIC(src, pathogen_flags),
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

	var/datum/pathogen/D = copy_type ? new copy_type() : new type()
	for(var/V in copy_vars)
		var/val = vars[V]
		if(islist(val))
			var/list/L = val
			val = L.Copy()
		D.vars[V] = val
	return D

/datum/pathogen/proc/get_id()
	return "[type]"


/**
 * Checks the given typepath against the list of viable mobtypes.
 *
 * Returns TRUE if the mob_type path is derived from of any entry in the viable_mobtypes list.
 * Returns FALSE otherwise.
 *
 * Arguments:
 * * mob_type - Type path to check against the viable_mobtypes list.
 */
/datum/pathogen/proc/is_viable_mobtype(mob_type)
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
		if(PATHOGEN_SEVERITY_POSITIVE)
			return 1
		if(PATHOGEN_SEVERITY_NONTHREAT)
			return 2
		if(PATHOGEN_SEVERITY_MINOR)
			return 3
		if(PATHOGEN_SEVERITY_MEDIUM)
			return 4
		if(PATHOGEN_SEVERITY_HARMFUL)
			return 5
		if(PATHOGEN_SEVERITY_DANGEROUS)
			return 6
		if(PATHOGEN_SEVERITY_BIOHAZARD)
			return 7
