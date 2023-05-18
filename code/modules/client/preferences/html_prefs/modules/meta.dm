/datum/preference_group/body
	var/list/datum/display = list(
		/datum/preference/name/religion,
		/datum/preference/name/bible,
		/datum/preference/choiced/security_department,
		/datum/preference/choiced/uplink_location,
	)

/datum/preference_group/body/get_content(datum/preferences/prefs)
	. = ..()
	. += {"
	<fieldset class='computerPane' style='display: inline-block;min-width:32.23%;max-width:32.23%'>
		<legend class='computerLegend tooltip'>
			<b>Meta</b>
			<span class='tooltiptext'>Do not peer beyond the veil. You will not like what you see.</span>
		</legend>
	<table style='width:100%'>
	"}

	for(var/path in display)
		var/datum/preference/pref = GLOB.preference_entries[path]
		if(!pref.is_accessible(prefs))
			continue
		. += {"
			<tr>
				<td style='padding: 4px 8px'>[pref.explanation]</td>
				<td style='padding: 4px 8px'>[pref.get_button(prefs)]</td>
			</tr>
		"}
	. += "</table></fieldset>"
