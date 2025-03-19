/datum/diagnosis_condition
	abstract_type = /datum/diagnosis_condition
	/// The name of the condition.
	var/name = ""
	/// Description of the condition.
	var/desc = ""
	/// Treatment options, if any.
	var/possible_treatment = "No known treatment."

	/// Symptom typepaths.
	var/list/symptoms

/datum/diagnosis_condition/New()
	var/list/new_symptoms = list()
	for(var/symptom_path in symptoms)
		new_symptoms += new symptom_path

	symptoms = new_symptoms

// /datum/diagnosis_condition/test
// 	name = "Test Condition 1"
// 	desc = "A test condition"

// 	symptoms = list(
// 		/datum/diagnosis_symptom/test,
// 		/datum/diagnosis_symptom/test2,
// 		/datum/diagnosis_symptom/test3
// 	)

// /datum/diagnosis_symptom/test
// 	name = "Test Symptom"
// 	desc = "A test symptom"
// 	category = "Heart"

// /datum/diagnosis_symptom/test2
// 	name = "Test Symptom 2"
// 	desc = "A test symptom"
// 	category = "Heart"


// /datum/diagnosis_symptom/test3
// 	name = "Test Symptom 3"
// 	desc = "A test symptom"
// 	category = "Heart"


// /datum/diagnosis_condition/test2
// 	name = "Test Condition 2"
// 	desc = "A test condition"

// 	symptoms = list(
// 		/datum/diagnosis_symptom/test4,
// 		/datum/diagnosis_symptom/test5,
// 		/datum/diagnosis_symptom/test6
// 	)

// /datum/diagnosis_symptom/test4
// 	name = "Test Symptom 4"
// 	desc = "A test symptom"
// 	category = "Brain"

// /datum/diagnosis_symptom/test5
// 	name = "Test Symptom 5"
// 	desc = "A test symptom"
// 	category = "Brain"

// /datum/diagnosis_symptom/test6
// 	name = "Test Symptom 6"
// 	desc = "A test symptom"
// 	category = "Brain"

/datum/diagnosis_condition/asystole
	name = "Asystole"
	desc = "The patient's heart has ceased beating."
	symptoms = list(
		/datum/diagnosis_symptom/cyanosis,
		/datum/diagnosis_symptom/unconscious,
		/datum/diagnosis_symptom/difficulty_breathing,
		/datum/diagnosis_symptom/no_pulse,
		/datum/diagnosis_symptom/syncope,
	)
