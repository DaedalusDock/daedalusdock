/datum/preference/choiced/body_size
	explanation = "Body Size"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_BODY_TYPE
	savefile_key = "body_size"
	relevant_species_trait = BODY_RESIZABLE

/datum/preference/choiced/body_size/init_possible_values()
	return list("Short", "Normal", "Tall")

/datum/preference/choiced/body_size/apply_to_human(mob/living/carbon/human/target, value)
	if(BODY_RESIZABLE in target.dna.species.species_traits)
		target.dna.features["body_size"] = value
	else
		target.dna.features["body_size"] = "Normal"
	target.dna.update_body_size()

/datum/preference/choiced/body_size/create_default_value()
	return "Normal"
