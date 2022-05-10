/datum/preference/choiced/body_size
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "body_size"

/datum/preference/choiced/body_size/init_possible_values()
	return list("Short", "Normal", "Tall")

/datum/preference/choiced/body_size/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["body_size"] = value
	target.dna.update_body_size()

/datum/preference/choiced/body_size/create_default_value()
	return "Normal"
