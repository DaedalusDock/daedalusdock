/datum/preference/choiced/moth_antennae
	explanation = "Antennae"
	savefile_key = "feature_moth_antennae"
	savefile_identifier = PREFERENCE_CHARACTER
	relevant_external_organ = "moth_antennae"

/datum/preference/choiced/moth_antennae/init_possible_values()
	return GLOB.moth_antennae_list

/datum/preference/choiced/moth_antennae/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["moth_antennae"] = value

/datum/preference/choiced/moth_markings
	explanation = "Body Markings"
	savefile_key = "feature_moth_markings"
	savefile_identifier = PREFERENCE_CHARACTER
	relevant_mutant_bodypart = "moth_markings"

/datum/preference/choiced/moth_markings/init_possible_values()
	return GLOB.moth_markings_list

/datum/preference/choiced/moth_markings/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["moth_markings"] = value

/datum/preference/choiced/moth_wings
	explanation = "Wings"
	savefile_key = "feature_moth_wings"
	savefile_identifier = PREFERENCE_CHARACTER
	relevant_external_organ = "moth_wings"

/datum/preference/choiced/moth_wings/init_possible_values()
	return GLOB.moth_wings_list

/datum/preference/choiced/moth_wings/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["moth_wings"] = value

/datum/preference/choiced/hairstyle_moth
	explanation = "Furstyle"
	savefile_key = "moth_hairstyle_name"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_NONHUMAN_HAIR
	relevant_species_trait = NONHUMANHAIR
	requires_accessible = TRUE

/datum/preference/choiced/hairstyle_moth/init_possible_values()
	return GLOB.moth_hairstyles_list

/datum/preference/choiced/hairstyle_moth/apply_to_human(mob/living/carbon/human/target, value)
	target.hairstyle = value

/datum/preference/choiced/hairstyle_moth/is_accessible(datum/preferences/preferences)
	if(!..(preferences))
		return FALSE
	return ispath(preferences.read_preference(/datum/preference/choiced/species), /datum/species/moth)

/datum/preference/choiced/hairstyle_moth/create_default_value()
	return "Bald"
