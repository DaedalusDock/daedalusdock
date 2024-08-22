/datum/preference_group/ipc_shackles

/datum/preference_group/ipc_shackles/should_display(datum/preferences/prefs)
	if(!ispath(prefs.read_preference(/datum/preference/choiced/species), /datum/species/ipc))
		return FALSE
	return TRUE

/datum/preference_group/ipc_shackles/get_content(datum/preferences/prefs)
	. = ..()
	. += {"
	<fieldset class='computerPaneNested' style='display: inline-block;min-width:32.23%;max-width:32.23%'>
		<legend class='computerLegend tooltip'>
			<b>Shackles</b>
			<span class='tooltiptext'>The chains that bind.</span>
		</legend>
	<table style='width: 100%;border-collapse: collapse'>
	"}

	var/shackle_set = prefs.read_preference(/datum/preference/choiced/ipc_shackles)

	if(!shackle_set)
		. += {"
		<tr>
			<td style='text-align: center'>[button_element(prefs, "Unshackled", "pref_act=[/datum/preference/choiced/ipc_shackles]")]</td>
		</tr>
		"}
	else
		. += {"
		<tr>
			<td colspan='3' style='text-align: center'>[button_element(prefs, shackle_set, "pref_act=[/datum/preference/choiced/ipc_shackles]")]</td>
		</tr>
		"}
		var/iter = 1
		var/datum/ai_laws/law_list = get_shackle_laws()[shackle_set]
		for(var/law in law_list?.inherent)
			. += {"
				<tr>
					<td style='padding: 4px 8px;border-right: 2px solid rgba(255, 183, 0, 0.5);border-top: 2px solid rgba(255, 183, 0, 0.5)'>
						<span class='computerText'>[iter].</span>
					</td>
					<td colspan='2'style='padding: 4px 8px;border-left: 2px solid rgba(255, 183, 0, 0.5);border-top: 2px solid rgba(255, 183, 0, 0.5)'>
						<span class='computerText'>[law]</span>
					</td>
				</tr>
			"}
			iter++

	. += "</table></fieldset>"
