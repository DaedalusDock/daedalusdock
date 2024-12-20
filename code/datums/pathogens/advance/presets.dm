// Cold
/datum/pathogen/advance/cold
	copy_type = /datum/pathogen/advance

/datum/pathogen/advance/cold/New()
	name = "Cold"
	symptoms = list(new/datum/symptom/sneeze)
	..()

// Flu
/datum/pathogen/advance/flu
	copy_type = /datum/pathogen/advance

/datum/pathogen/advance/flu/New()
	name = "Flu"
	symptoms = list(new/datum/symptom/cough)
	..()

//Randomly generated Disease, for virus crates and events
/datum/pathogen/advance/random
	name = "Experimental Disease"
	copy_type = /datum/pathogen/advance

/datum/pathogen/advance/random/New(max_symptoms, max_level = 8)
	if(!max_symptoms)
		max_symptoms = rand(1, VIRUS_SYMPTOM_LIMIT)
	var/list/datum/symptom/possible_symptoms = list()
	for(var/symptom in subtypesof(/datum/symptom))
		var/datum/symptom/S = symptom
		if(initial(S.level) > max_level)
			continue
		if(initial(S.level) <= 0) //unobtainable symptoms
			continue
		possible_symptoms += S
	for(var/i in 1 to max_symptoms)
		var/datum/symptom/chosen_symptom = pick_n_take(possible_symptoms)
		if(chosen_symptom)
			var/datum/symptom/S = new chosen_symptom
			symptoms += S

	..()

	name = "Sample #[rand(1,10000)]"
