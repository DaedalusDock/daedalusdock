/*

	Advance Disease is a system for Virologist to Engineer their own disease with symptoms that have effects and properties
	which add onto the overall disease.

	If you need help with creating new symptoms or expanding the advance disease, ask for Giacom on #coderbus.

*/




/*

	PROPERTIES

 */

/datum/pathogen/advance
	name = "Unknown" // We will always let our Virologist name our disease.
	desc = "An engineered disease which can contain a multitude of symptoms."
	form = "Advanced Disease" // Will let med-scanners know that this disease was engineered.
	agent = "advance microbes"
	max_stages = 5
	spread_text = "Unknown"
	viable_mobtypes = list(/mob/living/carbon/human)

	var/id = ""

	var/list/properties = list()
	/// A list of symptom instances.
	var/list/symptoms = list()
	/// Set to TRUE on first life process.
	var/has_started = FALSE
	var/mutable = TRUE //set to FALSE to prevent most in-game methods of altering the disease via virology
	var/oldres //To prevent setting new cures unless resistance changes.

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
	Refresh()

/datum/pathogen/advance/Destroy()
	for(var/datum/symptom/S as anything in symptoms)
		RemoveSymptom(S)
	return ..()

/datum/pathogen/advance/try_infect(mob/living/infectee, make_copy = TRUE)
	//see if we are more transmittable than enough diseases to replace them
	//diseases replaced in this way do not confer immunity
	var/list/advance_diseases = list()
	for(var/datum/pathogen/advance/P in infectee.diseases)
		advance_diseases += P

	var/replace_num = advance_diseases.len + 1 - DISEASE_LIMIT //amount of diseases that need to be removed to fit this one
	if(replace_num > 0)
		sortTim(advance_diseases, GLOBAL_PROC_REF(cmp_advdisease_resistance_asc))
		for(var/i in 1 to replace_num)
			var/datum/pathogen/advance/competition = advance_diseases[i]
			if(totalTransmittable() > competition.totalResistance())
				competition.force_cure(add_resistance = FALSE)
			else
				return FALSE //we are not strong enough to bully our way in

	return ..()


// Randomly pick a symptom to activate.
/datum/pathogen/advance/stage_act(delta_time, times_fired)
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
	return "[name] sym:[english_list(name_symptoms)] r:[totalResistance()] s:[totalStealth()] ss:[totalStageSpeed()] t:[totalTransmittable()]"

/*

	NEW PROCS

 */

// Mix the symptoms of two diseases (the src and the argument)
/datum/pathogen/advance/proc/Mix(datum/pathogen/advance/D)
	if(!(IsSame(D)))
		var/list/possible_symptoms = shuffle(D.symptoms)
		for(var/datum/symptom/S in possible_symptoms)
			AddSymptom(S.Copy())

/datum/pathogen/advance/proc/HasSymptom(datum/symptom/S)
	for(var/datum/symptom/symp in symptoms)
		if(symp.type == S.type)
			return TRUE
	return FALSE

// Will generate new unique symptoms, use this if there are none. Returns a list of symptoms that were generated.
/datum/pathogen/advance/proc/GenerateSymptoms(level_min, level_max, amount_get = 0)

	. = list() // Symptoms we generated.

	// Generate symptoms. By default, we only choose non-deadly symptoms.
	var/list/possible_symptoms = list()
	for(var/symp in SSpathogens.symptom_types)
		var/datum/symptom/S = new symp
		if(S.naturally_occuring && S.level >= level_min && S.level <= level_max)
			if(!HasSymptom(S))
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
/datum/pathogen/advance/proc/Refresh(autogen_name = FALSE)
	GenerateProperties()
	AssignProperties()

	if(has_started && length(symptoms))
		for(var/datum/symptom/S as anything in symptoms)
			S.on_start_processing(src)
			S.on_stage_change(src)

	id = null

	var/the_id = get_id()
	if(!SSpathogens.archive_pathogens[the_id])
		SSpathogens.archive_pathogens[the_id] = src // So we don't infinite loop
		SSpathogens.archive_pathogens[the_id] = Copy()
		if(autogen_name)
			AssignName()

//Generate disease properties based on the effects. Returns an associated list.
/datum/pathogen/advance/proc/GenerateProperties()
	properties = list("resistance" = 0, "stealth" = 0, "stage_rate" = 0, "transmittable" = 0, "severity" = 0)

	for(var/datum/symptom/S in symptoms)
		properties["resistance"] += S.resistance
		properties["stealth"] += S.stealth
		properties["stage_rate"] += S.stage_speed
		properties["transmittable"] += S.transmittable
		if(!S.neutered)
			properties["severity"] = max(properties["severity"], S.severity) // severity is based on the highest severity non-neutered symptom

// Assign the properties that are in the list.
/datum/pathogen/advance/proc/AssignProperties()

	if(!length(properties))
		CRASH("Our properties were empty or null!")

	if(properties["stealth"] >= 2)
		visibility_flags |= HIDDEN_SCANNER
	else
		visibility_flags &= ~HIDDEN_SCANNER

	if(properties["transmittable"]>=11)
		SetSpread(DISEASE_SPREAD_AIRBORNE)
	else if(properties["transmittable"]>=7)
		SetSpread(DISEASE_SPREAD_CONTACT_SKIN)
	else if(properties["transmittable"]>=3)
		SetSpread(DISEASE_SPREAD_CONTACT_FLUIDS)
	else
		SetSpread(DISEASE_SPREAD_BLOOD)

	contraction_chance_modifier = max(CEILING(0.4 * properties["transmittable"], 1), 1)
	cure_chance = clamp(7.5 - (0.5 * properties["resistance"]), 5, 10) // can be between 5 and 10
	stage_prob = max(0.5 * properties["stage_rate"], 1)
	SetSeverity(properties["severity"])
	GenerateCure(properties)

// Assign the spread type and give it the correct description.
/datum/pathogen/advance/proc/SetSpread(spread_id)
	switch(spread_id)
		if(DISEASE_SPREAD_NON_CONTAGIOUS)
			spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
			spread_text = "None"
		if(DISEASE_SPREAD_SPECIAL)
			spread_flags = DISEASE_SPREAD_SPECIAL
			spread_text = "None"
		if(DISEASE_SPREAD_BLOOD)
			spread_flags = DISEASE_SPREAD_BLOOD
			spread_text = "Blood"
		if(DISEASE_SPREAD_CONTACT_FLUIDS)
			spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_CONTACT_FLUIDS
			spread_text = "Fluids"
		if(DISEASE_SPREAD_CONTACT_SKIN)
			spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_CONTACT_FLUIDS | DISEASE_SPREAD_CONTACT_SKIN
			spread_text = "On contact"
		if(DISEASE_SPREAD_AIRBORNE)
			spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_CONTACT_FLUIDS | DISEASE_SPREAD_CONTACT_SKIN | DISEASE_SPREAD_AIRBORNE
			spread_text = "Airborne"

/datum/pathogen/advance/proc/SetSeverity(level_sev)

	switch(level_sev)

		if(-INFINITY to 0)
			severity = DISEASE_SEVERITY_POSITIVE
		if(1)
			severity = DISEASE_SEVERITY_NONTHREAT
		if(2)
			severity = DISEASE_SEVERITY_MINOR
		if(3)
			severity = DISEASE_SEVERITY_MEDIUM
		if(4)
			severity = DISEASE_SEVERITY_HARMFUL
		if(5)
			severity = DISEASE_SEVERITY_DANGEROUS
		if(6 to INFINITY)
			severity = DISEASE_SEVERITY_BIOHAZARD
		else
			severity = "Unknown"


// Will generate a random cure, the more resistance the symptoms have, the harder the cure.
/datum/pathogen/advance/proc/GenerateCure()
	if(!length(properties)) // Only happens if the disease is borked
		return

	var/res = clamp(properties["resistance"] - (symptoms.len / 2), 1, advance_cures.len)
	if(res == oldres)
		return
	cures = list(pick(advance_cures[res]))
	oldres = res
	// Get the cure name from the cure_id
	var/datum/reagent/D = SSreagents.chemical_reagents_list[cures[1]]
	cure_text = D.name

// Randomly generate a symptom, has a chance to lose or gain a symptom.
/datum/pathogen/advance/proc/Evolve(min_level, max_level, ignore_mutable = FALSE)
	if(!mutable && !ignore_mutable)
		return

	var/list/generated_symptoms = GenerateSymptoms(min_level, max_level, 1)
	if(length(generated_symptoms))
		var/datum/symptom/S = pick(generated_symptoms)
		AddSymptom(S)
		Refresh(TRUE)

// Randomly remove a symptom.
/datum/pathogen/advance/proc/Devolve(ignore_mutable = FALSE)
	if(!mutable && !ignore_mutable)
		return
	if(length(symptoms) > 1)
		var/datum/symptom/S = pick(symptoms)
		if(S)
			RemoveSymptom(S)
			Refresh(TRUE)

// Randomly neuter a symptom.
/datum/pathogen/advance/proc/Neuter(ignore_mutable = FALSE)
	if(!mutable && !ignore_mutable)
		return
	if(length(symptoms))
		var/datum/symptom/S = pick(symptoms)
		if(S)
			NeuterSymptom(S)
			Refresh(TRUE)

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
/datum/pathogen/advance/proc/AddSymptom(datum/symptom/S)

	if(HasSymptom(S))
		return

	if(symptoms.len >= VIRUS_SYMPTOM_LIMIT)
		RemoveSymptom(pick(symptoms))
	symptoms += S
	S.on_add_to_pathogen(src)

// Simply removes the symptom.
/datum/pathogen/advance/proc/RemoveSymptom(datum/symptom/S)
	symptoms -= S
	S.on_remove_from_pathogen(src)

// Neuter a symptom, so it will only affect stats
/datum/pathogen/advance/proc/NeuterSymptom(datum/symptom/S)
	if(S.neutered)
		return

	S.neutered = TRUE
	S.name += " (neutered)"
	S.on_remove_from_pathogen(src)

/*

	Static Procs

*/

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
	to_return.Refresh(TRUE)
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
				if(!D.HasSymptom(S))
					D.AddSymptom(S)
					i -= 1
	while(i > 0)

	if(D.symptoms.len > 0)

		var/new_name = tgui_input_text(user, "Name your new disease", "New Name", max_length = MAX_NAME_LEN)
		if(!new_name)
			return
		D.Refresh()
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


/datum/pathogen/advance/proc/totalStageSpeed()
	return properties["stage_rate"]

/datum/pathogen/advance/proc/totalStealth()
	return properties["stealth"]

/datum/pathogen/advance/proc/totalResistance()
	return properties["resistance"]

/datum/pathogen/advance/proc/totalTransmittable()
	return properties["transmittable"]
