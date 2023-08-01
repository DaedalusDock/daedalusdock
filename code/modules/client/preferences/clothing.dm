/// Backpack preference
/datum/preference/choiced/backpack
	explanation = "Backpack"
	savefile_key = "backpack"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/backpack/init_possible_values()
	return GLOB.backpacklist

/datum/preference/choiced/backpack/apply_to_human(mob/living/carbon/human/target, value)
	target.backpack = value

/datum/preference/choiced/backpack/create_default_value()
	return DBACKPACK

/// Jumpsuit preference
/datum/preference/choiced/jumpsuit
	explanation = "Uniform"
	savefile_key = "jumpsuit_style"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/jumpsuit/init_possible_values()
	var/list/values = list(
		PREF_SUIT,
		PREF_SKIRT
	)

	return values

/datum/preference/choiced/jumpsuit/apply_to_human(mob/living/carbon/human/target, value)
	target.jumpsuit_style = value

/datum/preference/choiced/jumpsuit/create_default_value()
	return PREF_SUIT

/// Socks preference
/datum/preference/choiced/socks
	explanation = "Socks"
	savefile_key = "socks"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/socks/init_possible_values()
	return GLOB.socks_list

/datum/preference/choiced/socks/apply_to_human(mob/living/carbon/human/target, value)
	target.socks = value

/datum/preference/choiced/socks/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = new species_type
	return !(NO_UNDERWEAR in species.species_traits)

/datum/preference/choiced/socks/create_default_value()
	return "Nude"

/// Undershirt preference
/datum/preference/choiced/undershirt
	explanation = "Undershirt"
	savefile_key = "undershirt"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/undershirt/init_possible_values()
	return GLOB.undershirt_list

/datum/preference/choiced/undershirt/apply_to_human(mob/living/carbon/human/target, value)
	target.undershirt = value

/datum/preference/choiced/undershirt/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = new species_type
	return !(NO_UNDERWEAR in species.species_traits)

/datum/preference/choiced/undershirt/create_default_value()
	return "Nude"

/// Underwear preference
/datum/preference/choiced/underwear
	explanation = "Underwear"
	savefile_key = "underwear"
	savefile_identifier = PREFERENCE_CHARACTER
	sub_preference = /datum/preference/color/underwear_color

/datum/preference/choiced/underwear/init_possible_values()
	return GLOB.underwear_list

/datum/preference/choiced/underwear/apply_to_human(mob/living/carbon/human/target, value)
	target.underwear = value

/datum/preference/choiced/underwear/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = new species_type
	return !(NO_UNDERWEAR in species.species_traits)

/datum/preference/choiced/underwear/create_default_value()
	return "Nude"

