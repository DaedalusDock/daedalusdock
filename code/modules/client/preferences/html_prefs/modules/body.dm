/datum/preference_group/body
	///Prefs we display. Set TRUE to check if accessible
	var/list/datum/display = list(
		/datum/preference/name/real_name,
		/datum/preference/numeric/age,
		/datum/preference/choiced/gender,
		/datum/preference/choiced/body_type = TRUE,
		/datum/preference/choiced/species
	)

/datum/preference_group/body/get_content(datum/preferences/prefs)
	. = ..()
	. += {"
	<fieldset class='computerPane' style='display: inline-block;min-width:32.23%;max-width:32.23%'>
		<legend class='computerLegend tooltip'>
			<b>Who Am I</b>
			<span class='tooltiptext'>The eternal flame that is the soul.</span>
		</legend>
	<table style='width:100%'>
	"}

	for(var/path in display)
		var/datum/preference/pref = GLOB.preference_entries[path]
		if(display[path] && !pref.is_accessible(prefs))
			continue
		. += {"
			<tr>
				<td style='padding: 4px 8px'>[pref.explanation]</td>
				<td style='padding: 4px 8px'>[pref.get_button(prefs)]</td>
			</tr>
		"}
	. += "</table></fieldset>"
