/datum/preference/color/mutant_color
	savefile_key = "feature_mcolor"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_species_trait = MUTCOLORS

/datum/preference/color/mutant_color/create_default_value()
	return sanitize_hexcolor("[pick("7F", "FF")][pick("7F", "FF")][pick("7F", "FF")]")

/datum/preference/color/mutant_color/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["mcolor"] = value

/datum/preference/color/mutant_color/is_valid(value)
	if (!..(value))
		return FALSE

	if (is_color_dark(value))
		return FALSE

	return TRUE

/datum/preference/color/mutant_color_2
	savefile_key = "feature_mcolor2"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_species_trait = MUTCOLORS2

/datum/preference/color/mutant_color_2/create_default_value()
	return sanitize_hexcolor("[pick("7F", "FF")][pick("7F", "FF")][pick("7F", "FF")]")

/datum/preference/color/mutant_color_2/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["mcolor2"] = value

/datum/preference/color/mutant_color_2/is_valid(value)
	if (!..(value))
		return FALSE

	if (is_color_dark(value))
		return FALSE

	return TRUE

/datum/preference/color/mutant_color_3
	savefile_key = "feature_mcolor3"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_species_trait = MUTCOLORS3

/datum/preference/color/mutant_color_3/create_default_value()
	return sanitize_hexcolor("[pick("7F", "FF")][pick("7F", "FF")][pick("7F", "FF")]")

/datum/preference/color/mutant_color_3/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["mcolor3"] = value

/datum/preference/color/mutant_color_3/is_valid(value)
	if (!..(value))
		return FALSE

	if (is_color_dark(value))
		return FALSE

	return TRUE


