

/datum/preference/color/eye_color
	explanation = "Eye Color"
	savefile_key = "eye_color"
	savefile_identifier = PREFERENCE_CHARACTER
	relevant_species_trait = EYECOLOR

/datum/preference/color/eye_color/apply_to_human(mob/living/carbon/human/target, value)
	var/hetero = target.eye_color_heterochromatic
	target.eye_color_left = value
	if(!hetero)
		target.eye_color_right = value

	var/obj/item/organ/eyes/eyes_organ = target.getorgan(/obj/item/organ/eyes)
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
	return "#000000"

/datum/preference/choiced/facial_hairstyle
	explanation = "Facial Hair"
	savefile_key = "facial_style_name"
	savefile_identifier = PREFERENCE_CHARACTER
	relevant_species_trait = FACEHAIR
	sub_preference = /datum/preference/color/facial_hair_color

/datum/preference/choiced/facial_hairstyle/init_possible_values()
	return GLOB.facial_hairstyles_list

/datum/preference/choiced/facial_hairstyle/apply_to_human(mob/living/carbon/human/target, value)
	target.facial_hairstyle = value
	target.update_body_parts()

/datum/preference/choiced/facial_hairstyle/create_default_value()
	return "Shaved"

/datum/preference/color/facial_hair_color
	explanation = "Facial Hair Color"
	savefile_key = "facial_hair_color"
	savefile_identifier = PREFERENCE_CHARACTER
	is_sub_preference = TRUE
	relevant_species_trait = FACEHAIRCOLOR

/datum/preference/color/facial_hair_color/apply_to_human(mob/living/carbon/human/target, value)
	target.facial_hair_color = value
	target.update_body_parts()

/datum/preference/color/facial_hair_color/create_default_value()
	return "#422f03"

/datum/preference/choiced/facial_hair_gradient
	explanation = "Facial Hair Gradient"
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
	explanation = "Facial Hair Gradient Color"
	is_sub_preference = TRUE
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
	explanation = "Hair Color"
	savefile_key = "hair_color"
	savefile_identifier = PREFERENCE_CHARACTER
	is_sub_preference = TRUE
	relevant_species_trait = HAIRCOLOR

/datum/preference/color/hair_color/apply_to_human(mob/living/carbon/human/target, value)
	target.hair_color = value

/datum/preference/color/hair_color/create_default_value()
	return "#422f03"

/datum/preference/choiced/hairstyle
	explanation = "Hairstyle"
	savefile_key = "hairstyle_name"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_HUMAN_HAIR
	relevant_species_trait = HAIR
	exclude_species_traits = list(NONHUMANHAIR)
	sub_preference = /datum/preference/color/hair_color

/datum/preference/choiced/hairstyle/init_possible_values()
	return GLOB.hairstyles_list

/datum/preference/choiced/hairstyle/apply_to_human(mob/living/carbon/human/target, value)
	target.hairstyle = value

/datum/preference/choiced/hairstyle/is_accessible(datum/preferences/preferences)
	if(!..(preferences))
		return FALSE
	return !ispath(preferences.read_preference(/datum/preference/choiced/species), /datum/species/moth)

/datum/preference/choiced/hairstyle/create_default_value()
	return "Bald"

/datum/preference/choiced/hair_gradient
	explanation = "Hairstyle Gradient"
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "hair_gradient"
	relevant_species_trait = HAIR
	sub_preference = /datum/preference/color/hair_gradient

/datum/preference/choiced/hair_gradient/init_possible_values()
	return assoc_to_keys(GLOB.hair_gradients_list)

/datum/preference/choiced/hair_gradient/apply_to_human(mob/living/carbon/human/target, value)
	LAZYSETLEN(target.grad_style, GRADIENTS_LEN)
	target.grad_style[GRADIENT_HAIR_KEY] = value
	target.update_body_parts()

/datum/preference/choiced/hair_gradient/create_default_value()
	return "None"

/datum/preference/choiced/hair_gradient/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE
	if(preferences.read_preference(/datum/preference/choiced/species) == /datum/species/moth)
		return FALSE

	return TRUE

/datum/preference/color/hair_gradient
	explanation = "Hairstyle Gradient Color"
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "hair_gradient_color"
	relevant_species_trait = HAIR
	is_sub_preference = TRUE

/datum/preference/color/hair_gradient/apply_to_human(mob/living/carbon/human/target, value)
	LAZYSETLEN(target.grad_color, GRADIENTS_LEN)
	target.grad_color[GRADIENT_HAIR_KEY] = value
	target.update_body_parts()

/datum/preference/color/hair_gradient/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE
	return preferences.read_preference(/datum/preference/choiced/hair_gradient) != "None"

/datum/preference/color/sclera
	explanation = "Sclera Color"
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "sclera_color"
	relevant_species_trait = SCLERA

/datum/preference/color/sclera/create_default_value()
	return "#f8ef9e"

/datum/preference/color/sclera/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.sclera_color = value
	target.update_eyes()
/datum/preference/tri_color
	abstract_type = /datum/preference/tri_color
	///dna.features["mutcolors"][color_key] = input
	var/color_key = ""

/datum/preference/tri_color/deserialize(input, datum/preferences/preferences)
	var/list/input_colors = input
	return list(sanitize_hexcolor(input_colors[1]), sanitize_hexcolor(input_colors[2]), sanitize_hexcolor(input_colors[3]))

/datum/preference/tri_color/create_default_value()
	return list("#FF0000", "#00FF00", "#0000FF")

/datum/preference/tri_color/is_valid(list/value)
	return islist(value) && value.len == 3 && (findtext(value[1], GLOB.is_color) && findtext(value[2], GLOB.is_color) && findtext(value[3], GLOB.is_color))

/datum/preference/tri_color/apply_to_human(mob/living/carbon/human/target, value)
	if (type == abstract_type)
		return ..()

	target.dna.mutant_colors["[color_key]_1"] = sanitize_hexcolor(value[1])
	target.dna.mutant_colors["[color_key]_2"] = sanitize_hexcolor(value[2])
	target.dna.mutant_colors["[color_key]_3"] = sanitize_hexcolor(value[3])

/datum/preference/tri_color/user_edit(mob/user, datum/preferences/prefs, list/params)
	var/list/colors = prefs.read_preference(type)
	var/index = text2num(params["color"])

	if(!index)
		return

	var/default = colors[index]

	var/input = input(user, "Change [explanation]",, default) as null|color
	if(!input)
		return
	colors[index] = input
	return prefs.update_preference(src, colors)

/datum/preference/tri_color/get_button(datum/preferences/prefs)
	var/list/colors = prefs.read_preference(type)
	. = ""
	. += color_button_element(prefs, colors[1], "pref_act=[type];color=1")
	. += color_button_element(prefs, colors[2], "pref_act=[type];color=2")
	. += color_button_element(prefs, colors[3], "pref_act=[type];color=3")

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


/datum/preference/appearance_mods/button_act(mob/user, datum/preferences/prefs, list/params)
	var/datum/preference/requested_preference = GLOB.preference_entries_by_key["appearance_mods"]
	if (isnull(requested_preference))
		return FALSE

	var/list/pref_mods = prefs.read_preference(/datum/preference/appearance_mods):Copy()
	var/species_type = prefs.read_preference(/datum/preference/choiced/species)
	var/list/existing_mods = list()
	//All of pref code is written with the assumption that pref values about to be saved are serialized
	pref_mods = requested_preference.serialize(pref_mods)

	for(var/_type in pref_mods)
		var/datum/appearance_modifier/path = pref_mods[_type]["path"]
		path = text2path(path)
		existing_mods[initial(path.name)] = _type


	if(params["add"])
		var/list/add_new = global.ModManager.modnames_by_species[species_type] ^ existing_mods
		var/choice = tgui_input_list(usr, "Add Appearance Mod", "Appearance Mods", add_new)
		if(!choice)
			return FALSE

		var/datum/appearance_modifier/mod = global.ModManager.mods_by_name[choice]
		var/list/new_mod_data = list(
			"path" = "[mod.type]",
			"color" = "#FFFFFF",
			"priority" = 0,
			"color_blend" = "[mod.color_blend_func]",
		)

		if(mod.colorable)
			var/color = input(usr, "Appearance Mod Color", "Appearance Mods", COLOR_WHITE) as null|color
			if(!color)
				return FALSE
			new_mod_data["color"] = color

		var/priority = input(usr, "Appearance Mod Priority", "Appearance Mods", 0) as null|num
		if(isnull(priority))
			return

		new_mod_data["priority"] = "[priority]"

		if(!global.ModManager.ValidateSerializedList(new_mod_data))
			return FALSE

		pref_mods[mod.type] = new_mod_data

		if(!prefs.update_preference(requested_preference, pref_mods))
			return FALSE

		return TRUE

	else if(params["remove"])
		var/index_to_remove = params["mod_name"]
		if(!index_to_remove)
			return FALSE
		var/safety = alert(user, "Are you sure you want to remove [index_to_remove]?", "Remove Appearance Mod", "Yes", "No")
		if(safety != "Yes")
			return FALSE

		pref_mods -= existing_mods[index_to_remove]
		if(!prefs.update_preference(requested_preference, pref_mods))
			return FALSE
		return TRUE

	else if(params["modify"])
		var/index_to_modify = params["mod_name"]
		if(!index_to_modify)
			return FALSE

		var/static/list/modifiable_values = list("priority")
		var/datum/appearance_modifier/type2check = text2path(existing_mods[index_to_modify])
		if(initial(type2check.colorable))
			modifiable_values += "color"

		var/value2modify = tgui_input_list(usr, "Select Var to Modify", "Appearance Mods", modifiable_values)
		if(!value2modify)
			return FALSE

		switch(value2modify)
			if("color")
				var/color = input(usr, "Appearance Mod Color", "Appearance Mods", COLOR_WHITE) as null|color
				if(!color)
					return FALSE

				pref_mods[existing_mods[index_to_modify]]["color"] = color

			if("priority")
				var/priority = input(usr, "Appearance Mod Priority", "Appearance Mods", 0) as null|num
				if(isnull(priority))
					return
				pref_mods[existing_mods[index_to_modify]]["priority"] = "[priority]"

		if(!prefs.update_preference(requested_preference, pref_mods))
			return FALSE
		return TRUE

