/datum/preference_group/category/augments
	name = "Augments"

/datum/preference_group/category/augments/get_content(datum/preferences/prefs)
	. = ..()
	var/datum/species/S = prefs.read_preference(/datum/preference/choiced/species)
	S = new S()
	var/datum/preference/blob/augments/user_augs = prefs.read_preference(/datum/preference/blob/augments)

	. += {"
	<table width='100%' style='display:block'>
		<tr>
	"}

	for(var/category in GLOB.augment_categories_to_slots)
		. += {"
			<td valign='top' width='23%'>
				<h2>[category]</h2>
		"}
		var/list/slot_list = GLOB.augment_categories_to_slots[category]

		for(var/slot in slot_list)
			var/datum/augment_item/chosen_item
			var/button
			if(user_augs[slot])
				chosen_item = GLOB.augment_items[user_augs[slot]]

			if(prefs.chosen_augment_slot && prefs.chosen_augment_slot == slot)
				button = "<span class='linkOn'>[slot]</span>"
			else
				button = button_element(prefs, slot, "pref_act=/datum/preference/blob/augments;select_slot=[slot]")

			. += {"
				<table align='center' width='100%' height='100px' style='background-color:#7C5500'>
					<tr style='vertical-align:top'>
						<td width='300px' style='background-color:#533200'>
							[button]: <span style='color:#AAAAFF'>[chosen_item?.name]</span>
						</td>
					</tr>
					<tr style='vertical-align:top'>
						<td width='300px' height='100%'>
							<i>[chosen_item?.description]</i>
						</td>
					</tr>
				</table>
			"}

		. += "</td>"
	. += "<td valign='top' width='31%'>"
	if(prefs.chosen_augment_slot)
		var/list/augment_list = GLOB.augment_slot_to_items[prefs.chosen_augment_slot]
		if(augment_list)
			. += {"
			<table width=100%; class='zebraTable'>
				<center><h2>[prefs.chosen_augment_slot]</h2></center>
				<tr style='vertical-align:top;background-color:#533200'>
					<td width=40%>
						<b>Name</b>
					</td>
					<td width=60%>
						<b>Description</b>
					</td>
				</tr>
			"}

			for(var/type_thing in augment_list)
				var/datum/augment_item/aug_datum = GLOB.augment_items[type_thing]
				var/datum/augment_item/current
				if(!aug_datum.can_apply_to_species(S))
					continue

				if(user_augs[prefs.chosen_augment_slot])
					current = GLOB.augment_items[user_augs[prefs.chosen_augment_slot]]
				var/aug_link

				if(current == aug_datum)
					aug_link = button_element(prefs, "[aug_datum.name] (Remove)", "pref_act=/datum/preference/blob/augments;set_augment=[type_thing]")
				else
					aug_link = button_element(prefs, "[aug_datum.name]", "pref_act=/datum/preference/blob/augments;set_augment=[type_thing]")

				. += {"
					<tr>
						<td>
							<b>[aug_link]</b>
						</td>
						<td>
							<i>[aug_datum.description]</i>
						</td>
					</tr>
				"}
			. += "</table>"
	. += "</td></tr></table>"
