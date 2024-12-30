/datum/preference/blob/loadout
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "nu_loadout"

/datum/preference/blob/loadout/apply_to_human(mob/living/carbon/human/target, value)
	return //We handle this in job code.

/datum/preference/blob/loadout/create_default_value()
	return list()

/datum/preference/blob/loadout/deserialize(input, datum/preferences/preferences)
	for(var/datum/loadout_entry/entry as anything in input)
		var/datum/loadout_item/loadout_item = locate(entry.path) in GLOB.loadout_items
		// Entry doesn't point to an item, remove it
		if(!loadout_item)
			input -= entry
	var/points_in_slot = preferences.calculate_loadout_points(input)
	if(points_in_slot < 0)
		preferences.update_preference(src, create_default_value())
		return preferences.read_preference(type)

	return input

/datum/preference/blob/loadout/button_act(mob/user, datum/preferences/prefs, list/params)
	if(params["toggle_show_equipped"])
		prefs.loadout_show_equipped = !prefs.loadout_show_equipped
		return TRUE

	if(params["category_set"])
		var/category = params["category_set"]
		var/list/subs = GLOB.loadout_category_to_subcategory_to_items[category]
		if(!subs)
			return
		prefs.loadout_category = category
		prefs.loadout_subcategory = subs[1]
		return TRUE

	if(params["subcategory_set"])
		var/subcat = params["subcategory_set"]
		if(!GLOB.loadout_category_to_subcategory_to_items[prefs.loadout_category][subcat])
			return
		prefs.loadout_subcategory = subcat
		return TRUE


	var/datum/loadout_item/loadout_item = locate(text2path(params["item"])) in GLOB.loadout_items
	if(!loadout_item)
		return

	var/list/loadout = prefs.read_preference(type)
	if(params["change_loadout"])
		prefs.change_loadout_item(loadout_item, loadout)
		return TRUE

	var/datum/loadout_entry/entry = prefs.get_loadout_entry_for_loadout_item(loadout_item, loadout)
	if(!entry)
		return

	var/customization_type = params["customize"]
	if(!customization_type)
		return

	switch(customization_type)
		if("name")
			var/current_name_display = entry.custom_name ? entry.custom_name : loadout_item.name
			var/new_name = input(user, "Choose loadout item name: (empty to reset)", "Loadout Customization", current_name_display) as text|null
			if(isnull(new_name) || QDELETED(entry))
				return

			if(new_name == "" || new_name == loadout_item.name)
				entry.custom_name = null
				return TRUE

			new_name = strip_html(new_name, MAX_ITEM_NAME_LEN)
			entry.custom_name = new_name
			prefs.update_preference(src, loadout)
			return TRUE

		if("desc")
			var/current_desc_display = entry.custom_desc ? entry.custom_desc : loadout_item.description
			var/new_desc = input(user, "Choose loadout item description: (empty to reset)", "Loadout Customization", current_desc_display) as text|null
			if(isnull(new_desc) || QDELETED(entry))
				return

			if(new_desc == "" || new_desc == loadout_item.description)
				entry.custom_desc = null
				return TRUE

			new_desc = strip_html(new_desc, MAX_ITEM_DESC_LEN)
			entry.custom_desc = new_desc
			prefs.update_preference(src, loadout)
			return TRUE

		if("color")
			if(!(loadout_item.customization_flags & CUSTOMIZE_COLOR))
				return

			var/current_color_display = entry.custom_color ? entry.custom_color : "#FFFFFF"
			var/new_color = input(user, "Choose loadout item color:", "Loadout Customization", current_color_display) as color|null
			if(!new_color || QDELETED(entry))
				return

			new_color = sanitize_hexcolor(new_color, 6, TRUE)
			if(new_color == "#FFFFFF")
				entry.custom_color = null
				return

			entry.custom_color = new_color
			prefs.update_preference(src, loadout)
			return TRUE

		if("gags")
			var/gags_index = text2num(params["index"])
			if(!loadout_item.gags_colors || !gags_index)
				return

			var/gags_string = entry.custom_gags_colors || loadout_item.get_gags_string()
			var/list/gags_list = color_string_to_list(gags_string)
			var/current_color_display = gags_list[gags_index]
			var/new_color = input(user, "Choose loadout item color [gags_index]:", "Loadout Customization", current_color_display) as color|null
			if(!new_color || QDELETED(entry))
				return

			new_color = sanitize_hexcolor(new_color, 6, TRUE)
			if(new_color == "#FFFFFF")
				entry.custom_color = null
				return

			gags_list[gags_index] = new_color
			entry.custom_gags_colors = color_list_to_string(gags_list)
			prefs.update_preference(src, loadout)
			return TRUE

		if("color_rotation")
			var/current_rotation = entry.custom_color_rotation || 0
			var/new_rotation = input(user, "Choose loadout item color rotation (0-360) (This is incompatible with non advanced color customization):", "Loadout Customization", current_rotation) as num|null
			if(isnull(new_rotation) || QDELETED(entry))
				return

			new_rotation = sanitize_integer(new_rotation, 0, 360, 0)
			if(new_rotation == 0)
				entry.custom_color_rotation = null
				return

			entry.custom_color_rotation = new_rotation
			prefs.update_preference(src, loadout)
			return TRUE
