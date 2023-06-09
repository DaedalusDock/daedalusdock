/datum/preference/choiced/headtails
	savefile_key = "feature_headtails"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/headtails/init_possible_values()
	return GLOB.headtails_list

/datum/preference/choiced/headtails/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["headtails"] = value
