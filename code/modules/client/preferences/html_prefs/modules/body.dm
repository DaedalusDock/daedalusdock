/datum/preference_group/body
	///Prefs we display. Set TRUE to check if accessible
	var/list/display = list(
		/datum/preference/name/real_name,
		/datum/preference/numeric/age,
		/datum/preference/choiced/gender,
		/datum/preference/choiced/body_type = TRUE,
		/datum/preference/choiced/species,
	)

	var/list/clothing = list(
		/datum/preference/choiced/jumpsuit,
		/datum/preference/choiced/backpack,
		/datum/preference/choiced/undershirt = TRUE,
		/datum/preference/choiced/underwear = TRUE,
		/datum/preference/choiced/socks = TRUE,
	)

/datum/preference_group/body/get_content(datum/preferences/prefs)
	. = ..()
	. += {"
	<fieldset class='computerPaneNested' style='display: inline-block;min-width:32.23%;max-width:32.23%'>
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
				<td style='padding: 4px 8px'><span class='computerText'>[pref.explanation]</span></td>
				<td style='padding: 4px 8px'>[pref.get_button(prefs)]</td>
			</tr>
		"}
	. += "<tr><td colspan='2'><HR></td></tr>"

	for(var/path in clothing)
		var/datum/preference/pref = GLOB.preference_entries[path]
		if(clothing[path] && !pref.is_accessible(prefs))
			continue
		var/button = pref.get_button(prefs)
		var/datum/preference/sub_pref = GLOB.preference_entries[pref.sub_preference]
		if(sub_pref)
			button += sub_pref.get_button(prefs)
		. += {"
			<tr>
				<td style='padding: 4px 8px'><span class='computerText'>[pref.explanation]</span></td>
				<td style='padding: 4px 8px'>[button]</td>
			</tr>
		"}

	. += "</table></fieldset>"
