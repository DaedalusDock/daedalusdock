/*

	Advance Disease is a system for Virologist to Engineer their own disease with symptoms that have effects and properties
	which add onto the overall disease.



*/
/datum/pathogen/advance
	name = "Unknown" // We will always let our Virologist name our disease.
	desc = "An engineered disease which can contain a multitude of symptoms."
	form = "Advanced Disease" // Will let med-scanners know that this disease was engineered.
	agent = "advance microbes"
	max_stages = 5
	spread_text = "Unknown"
	viable_mobtypes = list(/mob/living/carbon/human)

	/// If FALSE, prevent most in-game methods of altering the disease via virology
	var/mutable = TRUE

	/// A k:v list of properties, see GenerateProperties()
	VAR_FINAL/list/properties
	/// A list of symptom instances.
	VAR_FINAL/list/symptoms = list()
	/// Set to TRUE on first life process.
	VAR_FINAL/has_started = FALSE
	/// Keeps track of the old RESISTANCE property so that cures do not change unless the resistance changes
	VAR_FINAL/oldres
	/// see get_id()
	VAR_FINAL/id = ""

	// The order goes from easy to cure to hard to cure. Keep in mind that sentient diseases pick two cures from tier 6 and up, ensure they won't react away in bodies.
	var/static/list/advance_cures = list(
		list( // level 1
			/datum/reagent/copper, /datum/reagent/silver, /datum/reagent/iodine, /datum/reagent/iron, /datum/reagent/carbon
		),
		list( // level 2
			/datum/reagent/potassium, /datum/reagent/consumable/ethanol, /datum/reagent/lithium, /datum/reagent/silicon,
		),
		list( // level 3
			/datum/reagent/consumable/salt, /datum/reagent/consumable/sugar, /datum/reagent/consumable/orangejuice, /datum/reagent/consumable/tomatojuice, /datum/reagent/consumable/milk
		),
		list( //level 4
			/datum/reagent/medicine/spaceacillin, /datum/reagent/medicine/saline_glucose, /datum/reagent/medicine/epinephrine, /datum/reagent/medicine/dylovene
		),
		list( //level 5
			/datum/reagent/fuel/oil, /datum/reagent/medicine/synaptizine, /datum/reagent/medicine/alkysine, /datum/reagent/drug/space_drugs, /datum/reagent/cryptobiolin
		),
		list( // level 6
			/datum/reagent/medicine/inacusiate, /datum/reagent/medicine/imidazoline, /datum/reagent/medicine/antihol
		),
		list( // level 7
			/datum/reagent/medicine/leporazine, /datum/reagent/medicine/chlorpromazine,
		),
		list( // level 8
			/datum/reagent/medicine/haloperidol, /datum/reagent/medicine/ephedrine
		),
		list( // level 9
			/datum/reagent/toxin/lipolicide,
		),
		list( // level 10
			/datum/reagent/drug/aranesp, /datum/reagent/medicine/diphenhydramine
		),
		list( //level 11
			/datum/reagent/toxin/anacea
		)
	)

/*

	OLD PROCS

 */

/datum/pathogen/advance/New()
	update_properties()

/datum/pathogen/advance/Destroy()
	for(var/datum/symptom/S as anything in symptoms)
		remove_symptom(S, TRUE)
	return ..()

/datum/pathogen/advance/try_infect(mob/living/infectee, make_copy = TRUE)
	//see if we are more transmittable than enough diseases to replace them
	//diseases replaced in this way do not confer immunity
	var/list/advance_diseases = list()
	for(var/datum/pathogen/advance/P in infectee.diseases)
		advance_diseases += P

	var/replace_num = advance_diseases.len + 1 - PATHOGEN_LIMIT //amount of diseases that need to be removed to fit this one
	if(replace_num > 0)
		sortTim(advance_diseases, GLOBAL_PROC_REF(cmp_advdisease_resistance_asc))
		for(var/i in 1 to replace_num)
			var/datum/pathogen/advance/competition = advance_diseases[i]
			if(properties[PATHOGEN_PROP_TRANSMITTABLE] > competition.properties[PATHOGEN_PROP_RESISTANCE])
				competition.force_cure(add_resistance = FALSE)
			else
				return FALSE //we are not strong enough to bully our way in

	return ..()


// Randomly pick a symptom to activate.
/datum/pathogen/advance/on_process(delta_time, times_fired)
	. = ..()
	if(!.)
		return

	if(!length(symptoms))
		return

	if(!has_started)
		has_started = TRUE
		for(var/datum/symptom/symptom_datum as anything in symptoms)
			if(symptom_datum.on_start_processing(src)) //this will return FALSE if the symptom is neutered
				symptom_datum.update_next_activation()
			symptom_datum.on_stage_change(src)

	for(var/datum/symptom/symptom_datum as anything in symptoms)
		symptom_datum.on_process(src)

// Tell symptoms stage changed
/datum/pathogen/advance/set_stage(new_stage)
	. = ..()
	for(var/datum/symptom/S as anything in symptoms)
		S.on_stage_change(src)

// Compares type then ID.
/datum/pathogen/advance/IsSame(datum/pathogen/advance/D)
	if(!(istype(D, /datum/pathogen/advance)))
		return FALSE

	return ..()

// When copying an advance disease, keep in mind it begins from stage 1.
/datum/pathogen/advance/Copy()
	var/datum/pathogen/advance/A = ..()
	QDEL_LIST(A.symptoms)
	for(var/datum/symptom/S in symptoms)
		A.symptoms += S.Copy()
	A.properties = properties.Copy()
	A.id = id
	A.mutable = mutable
	A.oldres = oldres
	//this is a new disease starting over at stage 1, so processing is not copied
	return A

//Describe this disease to an admin in detail (for logging)
/datum/pathogen/advance/admin_details()
	var/list/name_symptoms = list()
	for(var/datum/symptom/S in symptoms)
		name_symptoms += S.name
	return "[name] sym:[english_list(name_symptoms)] r:[properties[PATHOGEN_PROP_RESISTANCE]] s:[properties[PATHOGEN_PROP_STEALTH]] ss:[properties[PATHOGEN_PROP_STAGE_RATE]] t:[properties[PATHOGEN_PROP_TRANSMITTABLE]]"

/*

	NEW PROCS

 */

// Mix the symptoms of two diseases (the src and the argument)
/datum/pathogen/advance/proc/Mix(datum/pathogen/advance/D)
	if(IsSame(D))
		return

	var/list/possible_symptoms = shuffle(D.symptoms)
	for(var/datum/symptom/S in possible_symptoms)
		add_symptom(S.Copy(), FALSE)

	update_properties()

/datum/pathogen/advance/proc/has_symptom(datum/symptom/S)
	for(var/datum/symptom/symp as anything in symptoms)
		if(symp.type == S.type)
			return TRUE
	return FALSE

// Will generate new unique symptoms, use this if there are none. Returns a list of symptoms that were generated.
/datum/pathogen/advance/proc/GenerateSymptoms(level_min, level_max, amount_get = 0)
	PRIVATE_PROC(TRUE)

	. = list() // Symptoms we generated.

	// Generate symptoms. By default, we only choose non-deadly symptoms.
	var/list/possible_symptoms = list()
	for(var/symp_type in SSpathogens.symptom_types)
		var/datum/symptom/S = new symp_type
		if(S.naturally_occuring && S.level >= level_min && S.level <= level_max && !has_symptom(S))
			possible_symptoms += S

	if(!possible_symptoms.len)
		return

	// Random chance to get more than one symptom
	var/number_of = amount_get
	if(!amount_get)
		number_of = 1
		while(prob(20))
			number_of += 1

	for(var/i = 1; number_of >= i && possible_symptoms.len; i++)
		. += pick_n_take(possible_symptoms)

/// Recaluculate the properties of the disease, and generate a new ID.
/datum/pathogen/advance/proc/update_properties(autogen_name = FALSE)
	GenerateProperties()
	AssignProperties()

	for(var/datum/symptom/S as anything in symptoms)
		if(!S.neutered)
			S.sync_properties(properties)

	id = null

	var/the_id = get_id()
	if(!SSpathogens.archive_pathogens[the_id])
		SSpathogens.archive_pathogens[the_id] = src // So we don't infinite loop
		SSpathogens.archive_pathogens[the_id] = Copy()
		if(autogen_name)
			AssignName()

// Randomly generate a symptom, has a chance to lose or gain a symptom.
/datum/pathogen/advance/proc/evolve(min_level, max_level, ignore_mutable = FALSE)
	if(!mutable && !ignore_mutable)
		return FALSE

	var/list/generated_symptoms = GenerateSymptoms(min_level, max_level, 1)
	if(!length(generated_symptoms))
		return FALSE

	var/datum/symptom/S = pick(generated_symptoms)
	add_symptom(S)
	return TRUE


// Randomly remove a symptom.
/datum/pathogen/advance/proc/devolve(ignore_mutable = FALSE)
	if(!mutable && !ignore_mutable)
		return

	if(length(symptoms) <= 1)
		return FALSE

	var/datum/symptom/S = pick(symptoms)
	remove_symptom(S)
	return TRUE

// Randomly neuter a symptom.
/datum/pathogen/advance/proc/neuter_random_symptom(ignore_mutable = FALSE)
	if(!mutable && !ignore_mutable)
		return
	if(length(symptoms))
		var/datum/symptom/S = pick(symptoms)
		if(S)
			neuter_symptom(S)

// Name the disease.
/datum/pathogen/advance/proc/AssignName(new_name = "Unknown")
	var/datum/pathogen/advance/A = SSpathogens.archive_pathogens[get_id()]
	A.name = new_name
	name = new_name

// Return a unique ID of the disease.
/datum/pathogen/advance/get_id()
	if(id)
		return id

	var/list/L = list()
	for(var/datum/symptom/S as anything in symptoms)
		if(S.neutered)
			L += "[S.id] (N)"
		else
			L += S.id

	L = sort_list(L) // Sort the list so it doesn't matter which order the symptoms are in.
	id = jointext(L, ":")
	return id


// Add a symptom, if it is over the limit we take a random symptom away and add the new one.
/datum/pathogen/advance/proc/add_symptom(datum/symptom/S, skip_prop_update)

	if(has_symptom(S))
		return

	if(symptoms.len >= VIRUS_SYMPTOM_LIMIT)
		remove_symptom(pick(symptoms), TRUE)

	symptoms += S
	S.on_add_to_pathogen(src)

	if(!skip_prop_update)
		update_properties(TRUE)

// Simply removes the symptom.
/datum/pathogen/advance/proc/remove_symptom(datum/symptom/S, skip_prop_update)
	symptoms -= S
	S.on_remove_from_pathogen(src)

	if(!skip_prop_update)
		update_properties(TRUE)

// Neuter a symptom, so it will only affect stats
/datum/pathogen/advance/proc/neuter_symptom(datum/symptom/S, skip_prop_update)
	if(S.neutered)
		return

	S.neutered = TRUE
	S.name += " (neutered)"
	S.on_remove_from_pathogen(src)

	if(!skip_prop_update)
		update_properties(TRUE)

//Generate disease properties based on the effects. Returns an associated list.
/datum/pathogen/advance/proc/GenerateProperties()
	PRIVATE_PROC(TRUE)

	properties = list(PATHOGEN_PROP_RESISTANCE = 0, PATHOGEN_PROP_STEALTH = 0, PATHOGEN_PROP_STAGE_RATE = 0, PATHOGEN_PROP_TRANSMITTABLE = 0, PATHOGEN_PROP_SEVERITY = 0)

	for(var/datum/symptom/S in symptoms)
		properties[PATHOGEN_PROP_RESISTANCE] += S.resistance
		properties[PATHOGEN_PROP_STEALTH] += S.stealth
		properties[PATHOGEN_PROP_STAGE_RATE] += S.stage_speed
		properties[PATHOGEN_PROP_TRANSMITTABLE] += S.transmittable
		if(!S.neutered)
			properties[PATHOGEN_PROP_SEVERITY] = max(properties[PATHOGEN_PROP_SEVERITY], S.severity) // severity is based on the highest severity non-neutered symptom

// Assign the properties that are in the list.
/datum/pathogen/advance/proc/AssignProperties()
	PRIVATE_PROC(TRUE)

	if(!length(properties))
		CRASH("Our properties were empty or null!")

	if(properties[PATHOGEN_PROP_STEALTH] >= 2)
		visibility_flags |= HIDDEN_SCANNER
	else
		visibility_flags &= ~HIDDEN_SCANNER

	if(properties[PATHOGEN_PROP_TRANSMITTABLE]>=11)
		SetSpread(PATHOGEN_SPREAD_AIRBORNE)
	else if(properties[PATHOGEN_PROP_TRANSMITTABLE]>=7)
		SetSpread(PATHOGEN_SPREAD_CONTACT_SKIN)
	else if(properties[PATHOGEN_PROP_TRANSMITTABLE]>=3)
		SetSpread(PATHOGEN_SPREAD_CONTACT_FLUIDS)
	else
		SetSpread(PATHOGEN_SPREAD_BLOOD)

	contraction_chance_modifier = max(CEILING(0.4 * properties[PATHOGEN_PROP_TRANSMITTABLE], 1), 1)
	cure_chance = clamp(7.5 - (0.5 * properties[PATHOGEN_PROP_RESISTANCE]), 5, 10) // can be between 5 and 10
	stage_prob = max(0.5 * properties[PATHOGEN_PROP_STAGE_RATE], 1)
	SetSeverity(properties[PATHOGEN_PROP_SEVERITY])
	GenerateCure(properties)

// Assign the spread type and give it the correct description.
/datum/pathogen/advance/proc/SetSpread(spread_id)
	PRIVATE_PROC(TRUE)
	switch(spread_id)
		if(PATHOGEN_SPREAD_NON_CONTAGIOUS)
			spread_flags = PATHOGEN_SPREAD_NON_CONTAGIOUS
			spread_text = "None"
		if(PATHOGEN_SPREAD_SPECIAL)
			spread_flags = PATHOGEN_SPREAD_SPECIAL
			spread_text = "None"
		if(PATHOGEN_SPREAD_BLOOD)
			spread_flags = PATHOGEN_SPREAD_BLOOD
			spread_text = "Blood"
		if(PATHOGEN_SPREAD_CONTACT_FLUIDS)
			spread_flags = PATHOGEN_SPREAD_BLOOD | PATHOGEN_SPREAD_CONTACT_FLUIDS
			spread_text = "Fluids"
		if(PATHOGEN_SPREAD_CONTACT_SKIN)
			spread_flags = PATHOGEN_SPREAD_BLOOD | PATHOGEN_SPREAD_CONTACT_FLUIDS | PATHOGEN_SPREAD_CONTACT_SKIN
			spread_text = "On contact"
		if(PATHOGEN_SPREAD_AIRBORNE)
			spread_flags = PATHOGEN_SPREAD_BLOOD | PATHOGEN_SPREAD_CONTACT_FLUIDS | PATHOGEN_SPREAD_CONTACT_SKIN | PATHOGEN_SPREAD_AIRBORNE
			spread_text = "Airborne"

/datum/pathogen/advance/proc/SetSeverity(level_sev)
	PRIVATE_PROC(TRUE)
	switch(level_sev)
		if(-INFINITY to 0)
			severity = PATHOGEN_SEVERITY_POSITIVE
		if(1)
			severity = PATHOGEN_SEVERITY_NONTHREAT
		if(2)
			severity = PATHOGEN_SEVERITY_MINOR
		if(3)
			severity = PATHOGEN_SEVERITY_MEDIUM
		if(4)
			severity = PATHOGEN_SEVERITY_HARMFUL
		if(5)
			severity = PATHOGEN_SEVERITY_DANGEROUS
		if(6 to INFINITY)
			severity = PATHOGEN_SEVERITY_BIOHAZARD
		else
			CRASH("Insane severity value: [level_sev]")

// Will generate a random cure, the more resistance the symptoms have, the harder the cure.
/datum/pathogen/advance/proc/GenerateCure()
	PRIVATE_PROC(TRUE)
	if(!length(properties)) // Only happens if the disease is borked
		return

	var/res = clamp(properties[PATHOGEN_PROP_RESISTANCE] - (symptoms.len / 2), 1, advance_cures.len)
	if(res == oldres)
		return
	cures = list(pick(advance_cures[res]))
	oldres = res
	// Get the cure name from the cure_id
	var/datum/reagent/D = SSreagents.chemical_reagents_list[cures[1]]
	cure_text = D.name


// Mix a list of advance diseases and return the mixed result.
/proc/Advance_Mix(list/D_list)
	var/list/diseases = list()

	for(var/datum/pathogen/advance/A in D_list)
		diseases += A.Copy()

	if(!diseases.len)
		return null
	if(diseases.len <= 1)
		return pick(diseases) // Just return the only entry.

	var/i = 0
	// Mix our diseases until we are left with only one result.
	while(i < 20 && diseases.len > 1)

		i++

		var/datum/pathogen/advance/D1 = pick(diseases)
		diseases -= D1

		var/datum/pathogen/advance/D2 = pick(diseases)
		D2.Mix(D1)

	// Should be only 1 entry left, but if not let's only return a single entry
	var/datum/pathogen/advance/to_return = pick(diseases)
	to_return.update_properties(TRUE)
	return to_return

/proc/SetViruses(datum/reagent/R, list/data)
	if(data)
		var/list/preserve = list()
		if(istype(data) && data["viruses"])
			for(var/datum/pathogen/A in data["viruses"])
				preserve += A.Copy()
			R.data = data.Copy()
		if(preserve.len)
			R.data["viruses"] = preserve

/proc/AdminCreateVirus(client/user)

	if(!user)
		return

	var/i = VIRUS_SYMPTOM_LIMIT

	var/datum/pathogen/advance/D = new()
	D.symptoms = list()

	var/list/symptoms = list()
	symptoms += "Done"
	symptoms += SSpathogens.symptom_types.Copy()
	do
		if(user)
			var/symptom = tgui_input_list(user, "Choose a symptom to add ([i] remaining)", "Choose a Symptom", sort_list(symptoms, GLOBAL_PROC_REF(cmp_typepaths_asc)))
			if(isnull(symptom))
				return
			else if(istext(symptom))
				i = 0
			else if(ispath(symptom))
				var/datum/symptom/S = new symptom
				if(!D.has_symptom(S))
					D.add_symptom(S, TRUE)
					i -= 1
	while(i > 0)

	if(D.symptoms.len > 0)

		var/new_name = tgui_input_text(user, "Name your new disease", "New Name", max_length = MAX_NAME_LEN)
		if(!new_name)
			return
		D.update_properties()
		D.AssignName(new_name)

		var/list/targets = list("Random")
		targets += sort_names(GLOB.human_list)
		var/target = tgui_input_list(user, "Viable human target", "Disease Target", targets)
		if(isnull(target))
			return
		var/mob/living/carbon/human/H
		if(target == "Random")
			for(var/human in shuffle(GLOB.human_list))
				H = human
				var/found = FALSE
				if(!is_station_level(H.z))
					continue
				if(!H.has_pathogen(D))
					found = H.try_contract_pathogen(D)
					break
				if(!found)
					to_chat(user, "Could not find a valid target for the disease.")
		else
			H = target
			if(istype(H) && D.infectable_biotypes & H.mob_biotypes)
				H.try_contract_pathogen(D)
			else
				to_chat(user, "Target could not be infected. Check mob biotype compatibility or resistances.")
				return

		message_admins("[key_name_admin(user)] has triggered a custom virus outbreak of [D.admin_details()] in [ADMIN_LOOKUPFLW(H)]")
		log_virus("[key_name(user)] has triggered a custom virus outbreak of [D.admin_details()] in [H]!")
