/datum/preference_group/category/loadout
	name = "Loadout"
	priority = 50

/datum/preference_group/category/loadout/get_header(datum/preferences/prefs)
	. = ..()
	. += {"
	<div style='width: 100%; text-align: center'>
			[button_element(prefs, prefs.loadout_show_equipped ? "Showing Equipped Items" : "Showing All Items", "pref_act=[/datum/preference/blob/loadout];toggle_show_equipped=1")]
			<br>
			<b><span class='computerText'>Remaining Points: [prefs.calculate_loadout_points()]</span></b>
	</div>
	<hr>
	"}

	if(prefs.loadout_show_equipped)
		return

	. += "<div style='width: 100%; text-align: center'>"
	for(var/category in GLOB.loadout_category_to_subcategory_to_items)
		if(prefs.loadout_category == category)
			. += "<span class='linkOn'>[category]</span>"
		else
			. += button_element(prefs, "[category]", "pref_act=[/datum/preference/blob/loadout];category_set=[category]")
	. += "</div>"
	. += "<HR>"

	if(prefs.loadout_category)
		. += "<div style='width: 100%; text-align: center'>"
		for(var/subcategory in GLOB.loadout_category_to_subcategory_to_items[prefs.loadout_category])
			if(prefs.loadout_subcategory == subcategory)
				. += "<span class='linkOn'>[subcategory]</span>"
			else
				. += button_element(prefs, "[subcategory]", "pref_act=[/datum/preference/blob/loadout];subcategory_set=[subcategory]")
		. += "</div>"
		. += "<HR>"

/datum/preference_group/category/loadout/get_content(datum/preferences/prefs)
	. = ..()
	if(!SSgreyscale.initialized)
		return "<span class='boldannounce'>Sorry, Greyscale is still setting up! Come back in a minute!</span>"

	var/list/loadout = prefs.read_preference(/datum/preference/blob/loadout)
	var/list/loadout_items_in_page


	if(prefs.loadout_show_equipped)
		loadout_items_in_page = list()
		for(var/datum/loadout_entry/entry as anything in loadout)
			loadout_items_in_page += locate(entry.path) in GLOB.loadout_items
	else
		loadout_items_in_page = GLOB.loadout_category_to_subcategory_to_items[prefs.loadout_category]?[prefs.loadout_subcategory]

	. += {"
	<table class='zebraTable' align='center'; width='100%'; height='100%'; style='background-color:#13171C'>
		<tr style='vertical-align:top'>
			<td width=28%><font size=2><b>Name</b></font></td>
			<td width=20%><font size=2><b>Customization</b></font></td>
			<td width=47%><font size=2><b>Description</b></font></td>
			<td width=5%><font size=2><center><b>Cost</b></center></font></td>
		</tr>
	"}

	var/even = FALSE
	for(var/datum/loadout_item/loadout_item as anything in loadout_items_in_page)
		even = !even
		var/datum/loadout_entry/loadout_entry = prefs.get_loadout_entry_for_loadout_item(loadout_item, loadout)
		var/item_button

		var/displayed_name
		var/displayed_desc
		var/change_name_button
		var/change_desc_button
		var/color_button = ""
		var/restricted_to = ""

		if(loadout_entry)
			if(loadout_item.customization_flags & CUSTOMIZE_NAME)
				change_name_button = " [button_element(prefs, "Change Name", "pref_act=[/datum/preference/blob/loadout];item=[loadout_item.type];customize=name")]"
			if(loadout_item.customization_flags & CUSTOMIZE_DESC)
				change_desc_button = " [button_element(prefs, "Change Desc", "pref_act=[/datum/preference/blob/loadout];item=[loadout_item.type];customize=desc")]"

			if(loadout_item.customization_flags & CUSTOMIZE_COLOR)
				if(loadout_item.gags_colors)
					var/gags_string = loadout_entry.custom_gags_colors || loadout_item.get_gags_string()
					var/list/gags_list = color_string_to_list(gags_string)
					for(var/i in 1 to loadout_item.gags_colors)
						var/iterated_color = gags_list[i]
						if(i != 1)
							color_button += "<BR>"
						color_button += "Color #[i]: <span class='color_holder_box' style='background-color:[iterated_color]'></span> [button_element(prefs, "Change", "pref_act=[/datum/preference/blob/loadout];item=[loadout_item.type];customize=gags;index=[i]")]"

				else
					var/shown_color = loadout_entry.custom_color ? loadout_entry.custom_color : "#FFFFFF"
					color_button += "Color: <span class='color_holder_box' style='background-color:[shown_color]'></span> [button_element(prefs, "Change", "pref_act=[/datum/preference/blob/loadout];item=[loadout_item.type];customize=color")]"
			// Color rotation is not compatible with non-gags color modifications
			if (loadout_item.customization_flags & CUSTOMIZE_COLOR_ROTATION)
				var/shown_rotation = loadout_entry.custom_color_rotation || 0
				if(color_button)
					color_button += "<BR>"
				color_button += "Color Rotation: [button_element(prefs, shown_rotation, "pref_act=[/datum/preference/blob/loadout];item=[loadout_item.type];customize=color_rotation")]"

		if(loadout_entry && loadout_entry.custom_name)
			displayed_name = "*[loadout_entry.custom_name]"
		else
			displayed_name = loadout_item.name

		if(loadout_entry && loadout_entry.custom_desc)
			displayed_desc = "*[loadout_entry.custom_desc]"
		else
			displayed_desc = loadout_item.description

		/// If we don't have an item in our loadout, show the user if it could be colorable
		if(!loadout_entry)
			color_button = "<i><font color='#6b6b6b'>"
			var/first_line = FALSE
			if(loadout_item.customization_flags & CUSTOMIZE_COLOR)
				first_line = TRUE
				if(loadout_item.gags_colors)
					color_button += "Adv. colors"
				else
					color_button += "Color"
			if (loadout_item.customization_flags & CUSTOMIZE_COLOR_ROTATION)
				if(first_line)
					color_button += " | "
				color_button += "Color Rotation "
			color_button += "</font></i>"

		if(length(loadout_item.restricted_roles))
			restricted_to = "<i><font color='#773b3b'>RESTRICTED: [english_list(restricted_to)]</i></font><br>"

		if(loadout_entry || prefs.can_purchase_loadout_item(loadout_item)) //We have this item purchased, but we can sell it
			item_button = button_element(prefs, displayed_name, "pref_act=[/datum/preference/blob/loadout];change_loadout=1;item=[loadout_item.type];")
		else
			item_button = "<span class='linkOff'>[displayed_name]</span>"

		. += {"
			<tr style='vertical-align:top'>
				<td>[item_button][change_name_button]</td>
				<td>[color_button]</td>
				<td>[restricted_to]<i>[displayed_desc]</i>[change_desc_button]</td>
				<td><center>[loadout_item.cost]</center></td>
			</tr>
		"}

	. += "</table>"
