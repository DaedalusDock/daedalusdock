#define TESH_BODY_COLOR "#DEB887" // Also in code\modules\mob\living\carbon\human\species_types\teshari.dm
#define TESH_FEATHER_COLOR "#996633"

/datum/preference/choiced/teshari_feathers
	explanation = "Head Feathers"
	savefile_key = "teshari_feathers"
	savefile_identifier = PREFERENCE_CHARACTER
	relevant_external_organ = /obj/item/organ/teshari_feathers

	sub_preference = /datum/preference/color/hair_color

/datum/preference/choiced/teshari_feathers/init_possible_values()
	return GLOB.teshari_feathers_list

/datum/preference/choiced/teshari_feathers/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features["teshari_feathers"] = value

/datum/preference/choiced/teshari_ears
	explanation = "Ears"
	savefile_key = "teshari_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	relevant_external_organ = /obj/item/organ/teshari_ears

	sub_preference = /datum/preference/color/facial_hair_color

/datum/preference/choiced/teshari_ears/init_possible_values()
	return GLOB.teshari_ears_list

/datum/preference/choiced/teshari_ears/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features["teshari_ears"] = value

/datum/preference/choiced/teshari_body_feathers
	explanation = "Body Feathers"
	savefile_key = "teshari_body_feathers"
	savefile_identifier = PREFERENCE_CHARACTER
	relevant_external_organ = /obj/item/organ/teshari_body_feathers

	sub_preference = /datum/preference/tri_color/teshari_body_feathers

/datum/preference/choiced/teshari_body_feathers/init_possible_values()
	return GLOB.teshari_body_feathers_list

/datum/preference/choiced/teshari_body_feathers/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features["teshari_body_feathers"] = value

/datum/preference/choiced/tail_teshari
	explanation = "Tail"
	savefile_key = "tail_teshari"
	savefile_identifier = PREFERENCE_CHARACTER
	relevant_external_organ = /obj/item/organ/tail/teshari

	sub_preference = /datum/preference/tri_color/teshari_tail

/datum/preference/choiced/tail_teshari/init_possible_values()
	return GLOB.teshari_tails_list

/datum/preference/choiced/tail_teshari/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features["tail_teshari"] = value

/datum/preference/tri_color/teshari_tail
	is_sub_preference = TRUE
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "teshari_tail_colors"
	relevant_external_organ = /obj/item/organ/tail/teshari

	color_key = MUTCOLORS_KEY_TESHARI_TAIL

/datum/preference/tri_color/teshari_body_feathers
	is_sub_preference = TRUE
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "teshari_body_colors"
	relevant_external_organ = /obj/item/organ/teshari_body_feathers

	color_key = MUTCOLORS_KEY_TESHARI_BODY_FEATHERS

#undef TESH_BODY_COLOR
#undef TESH_FEATHER_COLOR
