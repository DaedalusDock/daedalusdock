#define VOX_BODY_COLOR "#C4DB1A" // Also in code\modules\mob\living\carbon\human\species_types\vox.dm
#define VOX_SNOUT_COLOR "#E5C04B"
#define VOX_HAIR_COLOR "#997C28"

/datum/preference/choiced/vox_hair
	explanation = "Quills"
	savefile_key = "feature_vox_hair"
	savefile_identifier = PREFERENCE_CHARACTER
	relevant_mutant_bodypart = "vox_hair"

	sub_preference = /datum/preference/color/hair_color

/datum/preference/choiced/vox_hair/init_possible_values()
	return GLOB.vox_hair_list

/datum/preference/choiced/vox_hair/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["vox_hair"] = value

/datum/preference/choiced/vox_facial_hair
	explanation = "Facial Quills"
	savefile_key = "feature_vox_facial_hair"
	savefile_identifier = PREFERENCE_CHARACTER
	relevant_mutant_bodypart = "vox_facial_hair"

/datum/preference/choiced/vox_facial_hair/init_possible_values()
	return GLOB.vox_facial_hair_list

/datum/preference/choiced/vox_facial_hair/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["vox_facial_hair"] = value

/datum/preference/choiced/tail_vox
	explanation = "Tail"
	savefile_key = "tail_vox"
	savefile_identifier = PREFERENCE_CHARACTER
	relevant_external_organ = /obj/item/organ/tail/vox

/datum/preference/choiced/tail_vox/init_possible_values()
	return GLOB.tails_list_vox

/datum/preference/choiced/tail_vox/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features["tail_vox"] = value

#undef VOX_BODY_COLOR
#undef VOX_SNOUT_COLOR
#undef VOX_HAIR_COLOR
