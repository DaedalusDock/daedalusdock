/proc/generate_skrell_side_shots(list/sprite_accessories, key, list/sides)
	var/list/values = list()

	var/icon/skrell = icon('icons/mob/species/skrell/bodyparts.dmi', "skrell_head", EAST)
	var/icon/eyes = icon('icons/mob/species/skrell/eyes.dmi', "eyes", EAST)

	eyes.Blend(COLOR_ALMOST_BLACK, ICON_MULTIPLY)
	skrell.Blend(eyes, ICON_OVERLAY)

	for(var/name in sprite_accessories)
		var/datum/sprite_accessory/sprite_accessory = sprite_accessories[name]

		var/icon/final_icon = icon(skrell)

		if(sprite_accessory.icon_state != "none")
			for(var/side in sides)
				var/icon/accessory_icon = icon(sprite_accessory.icon, "m_[key]_[sprite_accessory.icon_state]_[side]", EAST)
				final_icon.Blend(accessory_icon, ICON_OVERLAY)

		final_icon.Crop(11, 20, 23, 32)
		final_icon.Scale(32, 32)
		final_icon.Blend(COLOR_BLUE_GRAY, ICON_MULTIPLY)

		values[name] = final_icon

	return values

/datum/preference/choiced/headtails
	savefile_key = "feature_headtails"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Headtails"
	should_generate_icons = TRUE

/datum/preference/choiced/headtails/init_possible_values()
	return generate_skrell_side_shots(GLOB.headtails_list, "headtails", list("ADJ", "FRONT"))

/datum/preference/choiced/headtails/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["headtails"] = value

/datum/preference/choiced/headtails/compile_constant_data()
	var/list/data = ..()
	data[SUPPLEMENTAL_FEATURE_KEY] = "hair_color"
	return data
