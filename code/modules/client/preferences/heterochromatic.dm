/datum/preference/color/heterochromatic
	explanation = "Heterochromia"
	savefile_key = "heterochromia"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_QUIRKS

/datum/preference/color/heterochromatic/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return "Heterochromia" in preferences.read_preference(/datum/preference/blob/quirks)

/datum/preference/color/heterochromatic/apply_to_human(mob/living/carbon/human/target, value)
	for(var/datum/quirk/heterochromatic/hetero_quirk in target.quirks)
		hetero_quirk.color = value
		hetero_quirk.link_to_holder()
