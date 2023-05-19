/datum/preference/choiced/ethereal_color
	explanation = "Bioluminescence"
	savefile_key = "feature_ethcolor"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/ethereal_color/init_possible_values()
	return GLOB.color_list_ethereal

/datum/preference/choiced/ethereal_color/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["ethcolor"] = GLOB.color_list_ethereal[value]

/datum/preference/choiced/ethereal_color/create_default_value()
	return GLOB.color_list_ethereal[1]
