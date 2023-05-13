/datum/preference_group/body
	///Prefs we display. Set TRUE to check if accessible
	var/list/datum/display = list(
		/datum/preference/name/real_name,
		/datum/preference/numeric/age,
		/datum/preference/choiced/gender,
		/datum/preference/choiced/body_type = TRUE,
	)

/datum/preference_group/body/get_content(datum/preferences/prefs)
	. = ..()
	. += {"
	<fieldset class='computerPane' style='display: inline-block;min-width:32.23%;max-width:32.23%'>
		<legend class='computerLegend tooltip'>
			<b>Who Am I</b>
			<span class='tooltiptext'>The eternal flame that is the soul.</span>
		</legend>
	<table>
	"}

	for(var/path in display)
		var/datum/preference/pref = GLOB.preference_entries[path]
		if(display[path] && !pref.is_accessible(prefs))
			continue
		var/result = prefs.read_preference(pref.type)
		. += {"
			<tr>
				<td>[pref.explanation]:</td>
				<td>[button_element(prefs, istext(result) ? capitalize(result) : result, "pref_act=[pref.type]")]</td>
			</tr>
		"}
	. += "</table></fieldset>"
