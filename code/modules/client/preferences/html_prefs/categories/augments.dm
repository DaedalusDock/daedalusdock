/datum/preference_group/category/augments
	name = "Augments"

/datum/preference_group/category/augments/get_content(datum/preferences/prefs)
	. = ..()
	var/list/user_augs = prefs.read_preference(/datum/preference/blob/augments)

	for(var/category in GLOB.augment_categories_to_slots - AUGMENT_CATEGORY_IMPLANTS)
		. += {"
	<fieldset class='computerPaneNested' style='display: inline-block;min-width:32.23%;max-width:32.23%'>
		<legend class='computerLegend'>
			<b>[category]</b>
		</legend>
	<table style='width: 100%;border-collapse: collapse'>
	<tr>
		<td colspan='2' style='text-align: center'>[button_element(prefs, "Add Augment", "pref_act=/datum/preference/blob/augments;add_augment=[category]")]</td>
	"}

		for(var/slot in GLOB.augment_categories_to_slots[category])
			if(isnull(user_augs[slot]))
				continue

			var/datum/augment_item/augment = GLOB.augment_items[user_augs[slot]]
			if(!augment)
				continue

			. += {"
			<tr>
				<td style='padding: 4px 8px;border-right: 2px solid rgba(255, 183, 0, 0.5);border-top: 2px solid rgba(255, 183, 0, 0.5)'>
					<span class='computerText'>[augment.name] [augment.slot]</span>
				</td>
				<td style='padding: 4px 8px;border-left: 2px solid rgba(255, 183, 0, 0.5);border-top: 2px solid rgba(255, 183, 0, 0.5)'>
					[button_element(prefs, "Switch Augment", "pref_act=/datum/preference/blob/augments;switch_augment=[slot]")]
					[button_element(prefs, "Remove Augment", "pref_act=/datum/preference/blob/augments;remove_augment=[slot]")]
				</td>
			</tr>
			"}

		. += "</table></fieldset>"

	// Special handling for implants :)
	if(!length(get_species_augments(prefs.read_preference(/datum/preference/choiced/species))?[AUGMENT_CATEGORY_IMPLANTS]?[AUGMENT_SLOT_IMPLANTS]))
		return

	. += {"
	<fieldset class='computerPaneNested' style='display: inline-block;min-width:32.23%;max-width:32.23%'>
		<legend class='computerLegend'>
			<b>Implants</b>
		</legend>
	<table style='width: 100%;border-collapse: collapse'>
	<tr>
		<td colspan='2' style='text-align: center'>[button_element(prefs, "Add Implant", "pref_act=/datum/preference/blob/augments;add_implant=1")]</td>
	"}

	for(var/path in user_augs[AUGMENT_SLOT_IMPLANTS])
		var/datum/augment_item/implant = GLOB.augment_items[path]
		if(!implant)
			continue
		. += {"
		<tr>
			<td style='padding: 4px 8px;border-right: 2px solid rgba(255, 183, 0, 0.5);border-top: 2px solid rgba(255, 183, 0, 0.5)'>
				<span class='computerText'>[implant.name]</span>
			</td>
			<td style='padding: 4px 8px;border-left: 2px solid rgba(255, 183, 0, 0.5);border-top: 2px solid rgba(255, 183, 0, 0.5)'>
				[button_element(prefs, "Modify Implant", "pref_act=/datum/preference/blob/augments;modify_implant=[implant.type]")]
				[button_element(prefs, "Remove Implant", "pref_act=/datum/preference/blob/augments;remove_implant=[implant.type]")]
			</td>
		</tr>
		"}

	. += "</table></fieldset>"
