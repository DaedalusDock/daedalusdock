/datum/diagnosis_symptom
	abstract_type = /datum/diagnosis_condition
	/// The name of the symptom.
	var/name = ""
	/// Description of the symptom.
	var/desc = ""
	/// Category of symptom, like Heart
	var/category = ""

/datum/diagnosis_symptom/cyanosis
	name = "Cyanosis"
	desc = "The surface of the patient's skin contains blue or purple discoloration as a result of low oxygen presence in the blood."
	category = DIAGNOSIS_SYMPTOM_CATEGORY_CIRCULATION

#warn add cyanosis

/datum/diagnosis_symptom/unconscious
	name = "Loss of consciousness"
	desc = "The patient is unconscious and unresponsive."
	category = DIAGNOSIS_SYMPTOM_CATEGORY_BRAIN

/datum/diagnosis_symptom/no_pulse
	name = "Cardiac arrest"
	desc = "The patient has no pulse."
	category = DIAGNOSIS_SYMPTOM_CATEGORY_CIRCULATION

/datum/diagnosis_symptom/difficulty_breathing
	name = "Difficulty breathing"
	desc = "The patient is having trouble breathing and may be gasping for air."
	category = DIAGNOSIS_SYMPTOM_CATEGORY_CIRCULATION

/datum/diagnosis_symptom/syncope
	name = "Syncope"
	desc = "The patient suddenly lost consciousness."
	category = DIAGNOSIS_SYMPTOM_CATEGORY_CIRCULATION
