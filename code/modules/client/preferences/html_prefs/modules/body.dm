/datum/preference_group/body

/datum/preference_group/body/get_content(datum/preferences/prefs)
	. = ..()
	. += {"
	<fieldset class='computerPane' style='display: inline-block;min-width:32.23%;max-width:32.23%'>
	<legend class='computerLegend tooltip'>
		<b>Who Am I</b>
		<span class='tooltiptext'>The eternal flame that is the soul.</span>
	</legend>
	"}
	var/datum/preference/name/pref = GLOB.preference_entries[/datum/preference/name/real_name]
	. += {"
	<table>
		<tr>
			<td>[pref.explanation]:</td>
			<td>[button_element(prefs, prefs.read_preference(pref.type), "pref_act=\ref[pref]")]</td>
		</tr>
	"}
	pref = GLOB.preference_entries[/datum/preference/numeric/age]
	. += {"
		<tr>
			<td>[pref.explanation]:</td>
			<td>[button_element(prefs, prefs.read_preference(pref.type), "pref_act=\ref[pref]")]</td>
		</tr>
	"}
	pref = GLOB.preference_entries[/datum/preference/choiced/gender]
	. += {"
		<tr>
			<td>[pref.explanation]:</td>
			<td>[button_element(prefs, capitalize(prefs.read_preference(pref.type)), "pref_act=\ref[pref]")]</td>
		</tr>
	"}
	pref = GLOB.preference_entries[/datum/preference/choiced/body_type]
	if(pref.is_accessible(prefs))
		. += {"
			<tr>
				<td>[pref.explanation]:</td>
				<td>[button_element(prefs, capitalize(prefs.read_preference(pref.type)), "pref_act=\ref[pref]")]</td>
			</tr>
		"}

	. += "</table></fieldset>"
