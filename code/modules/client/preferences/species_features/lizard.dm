/datum/preference/choiced/lizard_frills
	explanation = "Frills"
	savefile_key = "feature_lizard_frills"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/lizard_frills/init_possible_values()
	return GLOB.frills_list

/datum/preference/choiced/lizard_frills/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["frills"] = value

/datum/preference/choiced/lizard_horns
	explanation = "Horns"
	savefile_key = "feature_lizard_horns"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/lizard_horns/init_possible_values()
	return GLOB.horns_list

/datum/preference/choiced/lizard_horns/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["horns"] = value

/datum/preference/choiced/lizard_legs
	explanation = "Leg Type"
	savefile_key = "feature_lizard_legs"
	savefile_identifier = PREFERENCE_CHARACTER
	relevant_mutant_bodypart = "legs"

/datum/preference/choiced/lizard_legs/init_possible_values()
	return assoc_to_keys(GLOB.legs_list)

/datum/preference/choiced/lizard_legs/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["legs"] = value

/datum/preference/choiced/lizard_snout
	explanation = "Snout"
	savefile_key = "feature_lizard_snout"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/lizard_snout/init_possible_values()
	return GLOB.snouts_list

/datum/preference/choiced/lizard_snout/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["snout"] = value

/datum/preference/choiced/lizard_spines
	explanation = "Spines"
	savefile_key = "feature_lizard_spines"
	savefile_identifier = PREFERENCE_CHARACTER
	relevant_mutant_bodypart = "spines"

/datum/preference/choiced/lizard_spines/init_possible_values()
	return assoc_to_keys(GLOB.spines_list)

/datum/preference/choiced/lizard_spines/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["spines"] = value

/datum/preference/choiced/lizard_tail
	explanation = "Tail"
	savefile_key = "feature_lizard_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	relevant_external_organ = /obj/item/organ/tail/lizard

/datum/preference/choiced/lizard_tail/init_possible_values()
	return assoc_to_keys(GLOB.tails_list_lizard)

/datum/preference/choiced/lizard_tail/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["tail_lizard"] = value

/datum/preference/choiced/lizard_tail/create_default_value()
	var/datum/sprite_accessory/tails/lizard/smooth/tail = /datum/sprite_accessory/tails/lizard/smooth
	return initial(tail.name)
