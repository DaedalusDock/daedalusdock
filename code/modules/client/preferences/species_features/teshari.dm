#define TESH_BODY_COLOR "#DEB887" // Also in code\modules\mob\living\carbon\human\species_types\teshari.dm
#define TESH_FEATHER_COLOR "#996633"

/datum/preference/choiced/teshari_feathers
	savefile_key = "teshari_feathers"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Feathers"
	should_generate_icons = TRUE

/datum/preference/choiced/teshari_feathers/init_possible_values()
	var/list/values = list()

	var/icon/teshari_head = icon('icons/mob/species/teshari/bodyparts.dmi', "teshari_head")
	var/icon/eyes = icon('icons/mob/species/teshari/eyes.dmi', "eyes")
	teshari_head.Blend(TESH_BODY_COLOR, ICON_MULTIPLY)
	eyes.Blend(COLOR_BLACK, ICON_MULTIPLY)
	teshari_head.Blend(eyes, ICON_OVERLAY)

	for(var/name in GLOB.teshari_feathers_list)
		var/datum/sprite_accessory/feather_style = GLOB.teshari_feathers_list[name]

		var/icon/icon_with_feathers = icon(teshari_head)
		var/icon/icon_adj = icon(feather_style.icon, "m_teshari_feathers_[feather_style.icon_state]_ADJ")
		icon_adj.Blend(TESH_FEATHER_COLOR, ICON_MULTIPLY)

		icon_with_feathers.Blend(icon_adj, ICON_OVERLAY)
		icon_with_feathers.Scale(64, 64)
		icon_with_feathers.Crop(17, 58, 17 + 31, 58 - 31)

		values[feather_style.name] = icon_with_feathers

	return values

/datum/preference/choiced/teshari_feathers/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features["teshari_feathers"] = value

/datum/preference/choiced/teshari_feathers/compile_constant_data()
	var/list/data = ..()
	data[SUPPLEMENTAL_FEATURE_KEY] = "hair_color"
	return data

/datum/preference/choiced/teshari_ears
	savefile_key = "teshari_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Ears"
	should_generate_icons = TRUE

/datum/preference/choiced/teshari_ears/init_possible_values()
	var/list/values = list()

	var/icon/teshari_head = icon('icons/mob/species/teshari/bodyparts.dmi', "teshari_head")
	var/icon/eyes = icon('icons/mob/species/teshari/eyes.dmi', "eyes")
	teshari_head.Blend(TESH_BODY_COLOR, ICON_MULTIPLY)
	eyes.Blend(COLOR_BLACK, ICON_MULTIPLY)
	teshari_head.Blend(eyes, ICON_OVERLAY)

	for(var/name in GLOB.teshari_ears_list)
		var/datum/sprite_accessory/ear_type = GLOB.teshari_ears_list[name]

		var/icon/icon_with_ears = icon(teshari_head)
		if(ear_type.icon_state != "none")
			var/icon/ears = icon(ear_type.icon, "m_teshari_ears_[ear_type.icon_state]_ADJ")
			var/icon/inner_ears = icon(ear_type.icon, "m_teshari_earsinner_[ear_type.icon_state]_ADJ")
			ears.Blend(TESH_BODY_COLOR, ICON_MULTIPLY)
			ears.Blend(inner_ears, ICON_OVERLAY)
			icon_with_ears.Blend(ears, ICON_OVERLAY)

		icon_with_ears.Scale(64, 64)
		icon_with_ears.Crop(17, 58, 17 + 31, 58 - 31)

		values[ear_type.name] = icon_with_ears

	return values

/datum/preference/choiced/teshari_ears/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features["teshari_ears"] = value

/datum/preference/choiced/teshari_body_feathers
	savefile_key = "teshari_body_feathers"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Body feathers"
	should_generate_icons = TRUE

/datum/preference/choiced/teshari_body_feathers/init_possible_values()
	var/list/values = list()

	// Build-a-bird
	var/icon/teshari_body = icon('icons/blanks/32x32.dmi', "nothing")
	for(var/body_part in list("chest", "l_arm", "r_arm", "l_hand", "r_hand", "l_leg", "r_leg"))
		teshari_body.Blend(icon('icons/mob/species/teshari/bodyparts.dmi', "teshari_[body_part]"), ICON_OVERLAY)
	teshari_body.Blend(TESH_BODY_COLOR, ICON_MULTIPLY)

	for(var/name in GLOB.teshari_body_feathers_list)
		var/datum/sprite_accessory/feather_style = GLOB.teshari_body_feathers_list[name]

		var/icon/icon_with_feathers = icon(teshari_body)

		if(feather_style.icon_state != "none")
			var/icon/body_feathers_icon = icon('icons/mob/species/teshari/body_feathers.dmi', "m_teshari_body_feathers_[feather_style.icon_state]_ADJ")
			// Limb markings
			for(var/limb in list("l_arm", "r_arm", "l_leg", "r_leg"))
				icon_with_feathers.Blend(icon('icons/mob/species/teshari/body_feathers.dmi', "m_teshari_body_feathers_[feather_style.icon_state]_ADJ_[limb]"), ICON_OVERLAY)

			icon_with_feathers.Blend(body_feathers_icon, ICON_OVERLAY)

		icon_with_feathers.Scale(64, 64)
		icon_with_feathers.Crop(17, 7, 17 + 31, 7 + 31)

		values[feather_style.name] = icon_with_feathers

	return values

/datum/preference/choiced/teshari_body_feathers/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features["teshari_body_feathers"] = value

/datum/preference/choiced/teshari_body_feathers/compile_constant_data()
	var/list/data = ..()
	data[SUPPLEMENTAL_FEATURE_KEY] = "facial_hair_color"
	return data

/datum/preference/choiced/tail_teshari
	savefile_key = "tail_teshari"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Tails"
	relevant_mutant_bodypart = "tail_teshari"
	should_generate_icons = TRUE

/datum/preference/choiced/tail_teshari/init_possible_values()
	var/list/values = list()

	for(var/name in GLOB.teshari_tails_list)
		var/datum/sprite_accessory/teshari_tail = GLOB.teshari_tails_list[name]

		var/icon/tail_icon = icon(teshari_tail.icon, "m_tail_teshari_[teshari_tail.icon_state]_BEHIND", EAST)
		tail_icon.Blend(TESH_BODY_COLOR, ICON_MULTIPLY)
		tail_icon.Scale(64, 64)
		tail_icon.Crop(1, 5, 1 + 31, 5 + 31)

		values[teshari_tail.name] = tail_icon

	return values

/datum/preference/choiced/tail_teshari/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features["tail_teshari"] = value


#undef TESH_BODY_COLOR
#undef TESH_FEATHER_COLOR
