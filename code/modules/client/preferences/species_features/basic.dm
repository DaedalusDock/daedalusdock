/proc/generate_possible_values_for_sprite_accessories_on_head(accessories)
	var/list/values = possible_values_for_sprite_accessory_list(accessories)

	var/icon/head_icon = icon('icons/mob/human_parts_greyscale.dmi', "human_head_m")
	head_icon.Blend(skintone2hex("caucasian1"), ICON_MULTIPLY)

	for (var/name in values)
		var/datum/sprite_accessory/accessory = accessories[name]
		if (accessory == null || accessory.icon_state == null)
			continue

		var/icon/final_icon = new(head_icon)

		var/icon/beard_icon = values[name]
		beard_icon.Blend(COLOR_DARK_BROWN, ICON_MULTIPLY)
		final_icon.Blend(beard_icon, ICON_OVERLAY)

		final_icon.Crop(10, 19, 22, 31)
		final_icon.Scale(32, 32)

		values[name] = final_icon

	return values

/datum/preference/color/eye_color
	savefile_key = "eye_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_species_trait = EYECOLOR

/datum/preference/color/eye_color/apply_to_human(mob/living/carbon/human/target, value)
	var/hetero = target.eye_color_heterochromatic
	target.eye_color_left = value
	if(!hetero)
		target.eye_color_right = value

	var/obj/item/organ/internal/eyes/eyes_organ = target.getorgan(/obj/item/organ/internal/eyes)
	if (!eyes_organ || !istype(eyes_organ))
		return

	if (!initial(eyes_organ.eye_color_left))
		eyes_organ.eye_color_left = value
	eyes_organ.old_eye_color_left = value

	if(hetero) // Don't override the snowflakes please
		return

	if (!initial(eyes_organ.eye_color_right))
		eyes_organ.eye_color_right = value
	eyes_organ.old_eye_color_right = value
	eyes_organ.refresh()

/datum/preference/color/eye_color/create_default_value()
	return random_eye_color()

/datum/preference/choiced/facial_hairstyle
	savefile_key = "facial_style_name"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Facial hair"
	should_generate_icons = TRUE
	relevant_species_trait = FACEHAIR

/datum/preference/choiced/facial_hairstyle/init_possible_values()
	return generate_possible_values_for_sprite_accessories_on_head(GLOB.facial_hairstyles_list)

/datum/preference/choiced/facial_hairstyle/apply_to_human(mob/living/carbon/human/target, value)
	target.facial_hairstyle = value
	target.update_body_parts()

/datum/preference/choiced/facial_hairstyle/compile_constant_data()
	var/list/data = ..()

	data[SUPPLEMENTAL_FEATURE_KEY] = "facial_hair_color"

	return data

/datum/preference/color/facial_hair_color
	savefile_key = "facial_hair_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	relevant_species_trait = FACEHAIRCOLOR

/datum/preference/color/facial_hair_color/apply_to_human(mob/living/carbon/human/target, value)
	target.facial_hair_color = value
	target.update_body_parts()

/datum/preference/choiced/facial_hair_gradient
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "facial_hair_gradient"
	relevant_species_trait = FACEHAIR

/datum/preference/choiced/facial_hair_gradient/init_possible_values()
	return assoc_to_keys(GLOB.facial_hair_gradients_list)

/datum/preference/choiced/facial_hair_gradient/apply_to_human(mob/living/carbon/human/target, value)
	LAZYSETLEN(target.grad_style, GRADIENTS_LEN)
	target.grad_style[GRADIENT_FACIAL_HAIR_KEY] = value
	target.update_body_parts()

/datum/preference/choiced/facial_hair_gradient/create_default_value()
	return "None"

/datum/preference/color/facial_hair_gradient
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "facial_hair_gradient_color"
	relevant_species_trait = FACEHAIR

/datum/preference/color/facial_hair_gradient/apply_to_human(mob/living/carbon/human/target, value)
	LAZYSETLEN(target.grad_color, GRADIENTS_LEN)
	target.grad_color[GRADIENT_FACIAL_HAIR_KEY] = value
	target.update_body_parts()

/datum/preference/color/facial_hair_gradient/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE
	return preferences.read_preference(/datum/preference/choiced/facial_hair_gradient) != "None"

/datum/preference/color/hair_color
	savefile_key = "hair_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	relevant_species_trait = HAIRCOLOR

/datum/preference/color/hair_color/apply_to_human(mob/living/carbon/human/target, value)
	target.hair_color = value

/datum/preference/choiced/hairstyle
	savefile_key = "hairstyle_name"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Hairstyle"
	should_generate_icons = TRUE
	relevant_species_trait = HAIR

/datum/preference/choiced/hairstyle/init_possible_values()
	return generate_possible_values_for_sprite_accessories_on_head(GLOB.hairstyles_list)

/datum/preference/choiced/hairstyle/apply_to_human(mob/living/carbon/human/target, value)
	target.hairstyle = value

/datum/preference/choiced/hairstyle/compile_constant_data()
	var/list/data = ..()

	data[SUPPLEMENTAL_FEATURE_KEY] = "hair_color"

	return data

/datum/preference/choiced/hair_gradient
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "hair_gradient"
	relevant_species_trait = HAIR

/datum/preference/choiced/hair_gradient/init_possible_values()
	return assoc_to_keys(GLOB.hair_gradients_list)

/datum/preference/choiced/hair_gradient/apply_to_human(mob/living/carbon/human/target, value)
	LAZYSETLEN(target.grad_style, GRADIENTS_LEN)
	target.grad_style[GRADIENT_HAIR_KEY] = value
	target.update_body_parts()

/datum/preference/choiced/hair_gradient/create_default_value()
	return "None"

/datum/preference/color/hair_gradient
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "hair_gradient_color"
	relevant_species_trait = HAIR

/datum/preference/color/hair_gradient/apply_to_human(mob/living/carbon/human/target, value)
	LAZYSETLEN(target.grad_color, GRADIENTS_LEN)
	target.grad_color[GRADIENT_HAIR_KEY] = value
	target.update_body_parts()

/datum/preference/color/hair_gradient/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE
	return preferences.read_preference(/datum/preference/choiced/hair_gradient) != "None"

/datum/preference/tri_color
	abstract_type = /datum/preference/tri_color
	///dna.features["mutcolors"][color_key] = input
	var/color_key = ""

/datum/preference/tri_color/deserialize(input, datum/preferences/preferences)
	var/list/input_colors = input
	return list(sanitize_hexcolor(input_colors[1]), sanitize_hexcolor(input_colors[2]), sanitize_hexcolor(input_colors[3]))

/datum/preference/tri_color/create_default_value()
	return list("#[random_color()]", "#[random_color()]", "#[random_color()]")

/datum/preference/tri_color/is_valid(list/value)
	return islist(value) && value.len == 3 && (findtext(value[1], GLOB.is_color) && findtext(value[2], GLOB.is_color) && findtext(value[3], GLOB.is_color))

/datum/preference/tri_color/apply_to_human(mob/living/carbon/human/target, value)
	if (type == abstract_type)
		return ..()

	target.dna.mutant_colors["[color_key]_1"] = sanitize_hexcolor(value[1])
	target.dna.mutant_colors["[color_key]_2"] = sanitize_hexcolor(value[2])
	target.dna.mutant_colors["[color_key]_3"] = sanitize_hexcolor(value[3])

/datum/preference/appearance_mods
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "appearance_mods"
	priority = PREFERENCE_PRIORITY_APPEARANCE_MODS

/datum/preference/appearance_mods/deserialize(input, datum/preferences/preferences)
	var/list/input_list = input:Copy()
	var/list/return_list = list()
	for(var/_type in input_list)
		var/list/mod_data = global.ModManager.DeserializeSavedMod(input_list[_type])
		if(!mod_data)
			continue
		return_list[_type] = mod_data

	return return_list

/datum/preference/appearance_mods/serialize(input)
	var/list/input_list = input:Copy()
	var/list/serialized_mods = list()
	for(var/_type in input_list)
		var/list/mod_data = input[_type]
		if(!mod_data)
			continue
		var/list/serial_mod_data = global.ModManager.SerializeModData(mod_data)
		if(!serial_mod_data)
			continue
		serialized_mods[serial_mod_data["path"]] = serial_mod_data
	return serialized_mods

/datum/preference/appearance_mods/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	var/list/deserialized_mods = value
	if(!value)
		return

	QDEL_LIST_ASSOC_VAL(target.appearance_mods)
	for(var/_type in deserialized_mods)
		var/list/mod_data = deserialized_mods[_type]
		var/new_color = mod_data["color"]
		var/new_priority = mod_data["priority"]
		var/new_blend_func = mod_data["color_blend"]

		var/datum/appearance_modifier/mod = LAZYACCESS(target.appearance_mods, _type)
		if(mod)
			if(!(mod.color == new_color) || !(mod.priority == new_priority) || !(mod.color_blend_func == new_blend_func))
				mod.SetValues(new_color, new_priority, new_blend_func)
				continue

		mod = global.ModManager.NewInstance(_type)
		mod.SetValues(new_color, new_priority, new_blend_func)
		mod.ApplyToMob(target)
		LAZYADDASSOC(target.appearance_mods, _type, mod)

	target.update_body_parts()

/datum/preference/appearance_mods/create_default_value()
	return list()

/datum/preference/appearance_mods/is_valid(value)
	if(!islist(value))
		return FALSE
	return TRUE


