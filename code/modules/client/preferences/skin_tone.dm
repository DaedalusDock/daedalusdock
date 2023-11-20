/datum/preference/choiced/skin_tone
	explanation = "Skin Tone"
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "skin_tone"

/datum/preference/choiced/skin_tone/init_possible_values()
	return GLOB.skin_tones

/datum/preference/choiced/skin_tone/create_default_value()
	return "caucasian1"

/datum/preference/choiced/skin_tone/apply_to_human(mob/living/carbon/human/target, value)
	target.skin_tone = value

/datum/preference/choiced/skin_tone/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	var/datum/species/species_type = preferences.read_preference(/datum/preference/choiced/species)
	return initial(species_type.use_skintones)
