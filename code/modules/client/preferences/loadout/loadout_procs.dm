/// Resets current loadout slot
/datum/preferences/proc/reset_loadout()
	var/datum/preference/P = GLOB.preference_entries[/datum/preference/blob/loadout]
	update_preference(P, P.create_default_value())

/datum/preferences/proc/calculate_loadout_points(input)
	if(!input)
		input = read_preference(/datum/preference/blob/loadout)

	var/calculated_points = LOADOUT_POINTS_MAX
	for(var/datum/loadout_entry/entry as anything in input)
		var/datum/loadout_item/loadout_item = locate(entry.path) in GLOB.loadout_items
		calculated_points -= loadout_item.cost
	return calculated_points

/datum/preferences/proc/add_loadout_item(datum/loadout_item/loadout_item, list/loadout)
	if(!istype(loadout_item))
		return //Will happen with migrations
	if(get_loadout_entry_for_loadout_item(loadout_item, loadout))
		return
	if(!can_purchase_loadout_item(loadout_item, loadout))
		return

	if(!(loadout_item.category in list(LOADOUT_CATEGORY_BACKPACK, LOADOUT_CATEGORY_HANDS)))
		for(var/datum/loadout_entry/entry as anything in loadout)
			var/datum/loadout_item/existing_item = locate(entry.path) in GLOB.loadout_items
			if(existing_item.category == loadout_item.category)
				remove_loadout_item(existing_item, loadout)

	var/datum/preference/pref = GLOB.preference_entries[/datum/preference/blob/loadout]
	loadout += new /datum/loadout_entry(loadout_item.type)
	return update_preference(pref, loadout)

/datum/preferences/proc/remove_loadout_item(datum/loadout_item/loadout_item, list/loadout)
	if(!istype(loadout_item))
		return

	var/datum/loadout_entry/entry = get_loadout_entry_for_loadout_item(loadout_item, loadout)
	if(!entry)
		return

	var/datum/preference/pref = GLOB.preference_entries[/datum/preference/blob/loadout]
	loadout -= entry
	return update_preference(pref, loadout)

/datum/preferences/proc/get_loadout_entry_for_loadout_item(datum/loadout_item/loadout_item, list/loadout)
	for(var/datum/loadout_entry/entry as anything in loadout)
		if(entry.path == loadout_item.type)
			return entry

/datum/preferences/proc/can_purchase_loadout_item(datum/loadout_item/loadout_item, loadout)
	loadout_item = locate(loadout_item) in GLOB.loadout_items
	if(calculate_loadout_points(loadout) >= loadout_item.cost)
		return TRUE
	return FALSE

/datum/preferences/proc/change_loadout_item(datum/loadout_item/loadout_item, loadout)
	loadout_item = locate(loadout_item) in GLOB.loadout_items
	if(isnull(loadout_item))
		return
	if(get_loadout_entry_for_loadout_item(loadout_item, loadout))
		remove_loadout_item(loadout_item, loadout)
	else
		add_loadout_item(loadout_item, loadout)
