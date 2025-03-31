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

/datum/diagnosis_condition/asystole
	name = "Asystole"
	desc = "The patient's heart has ceased beating."
	symptoms = list(
		/datum/diagnosis_symptom/cyanosis,
		/datum/diagnosis_symptom/unconscious,
		/datum/diagnosis_symptom/difficulty_breathing,
		/datum/diagnosis_symptom/no_pulse,
		/datum/diagnosis_symptom/syncope,
		/datum/diagnosis_symptom/blurred_vision,
	)

/datum/diagnosis_condition/liver_failure
	name = "Liver Failure"
	desc = "The patient's liver is failing or has stopped functioning."
	symptoms = list(
		/datum/diagnosis_symptom/blurred_vision,
		/datum/diagnosis_symptom/jaundice,
		/datum/diagnosis_symptom/yellow_eyes,
		/datum/diagnosis_symptom/slurred_speech,
		/datum/diagnosis_symptom/confusion,
		/datum/diagnosis_symptom/nausea,
		/datum/diagnosis_symptom/chest_pain,
		/datum/diagnosis_symptom/drowsiness,
		/datum/diagnosis_symptom/unconscious,
	)

/datum/diagnosis_condition/intoxication
	name = "Alcohol Poisoning"
	desc = "The patient is physically and/or mentally impaired due to alcohol consumption."

	symptoms = list(
		/datum/diagnosis_symptom/slurred_speech,
		/datum/diagnosis_symptom/nausea,
		/datum/diagnosis_symptom/chest_pain,
		/datum/diagnosis_symptom/dizziness,
		/datum/diagnosis_symptom/jittering,
		/datum/diagnosis_symptom/confusion,
		/datum/diagnosis_symptom/blurred_vision,
		/datum/diagnosis_symptom/syncope,
		/datum/diagnosis_symptom/unconscious,
	)

/datum/diagnosis_condition/concussion
	name = "Concussion"
	desc = "The patient is experiencing reduced brain function due to physical trauma."

	symptoms = list(
		/datum/diagnosis_symptom/slurred_speech,
		/datum/diagnosis_symptom/nausea,
		/datum/diagnosis_symptom/blurred_vision,
		/datum/diagnosis_symptom/confusion,
		/datum/diagnosis_symptom/dizziness,
		/datum/diagnosis_symptom/syncope,
		/datum/diagnosis_symptom/unconscious,
	)
