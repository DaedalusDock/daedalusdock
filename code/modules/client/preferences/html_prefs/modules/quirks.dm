/datum/preference_group/quirks
	var/list/quirk_prefs = list(
		"Nearsighted" = /datum/preference/choiced/glasses,
		"Heterochromia" = /datum/preference/color/heterochromatic,
		"Phobia" = /datum/preference/choiced/phobia
	)

/datum/preference_group/quirks/should_display(datum/preferences/prefs)
	var/list/user_quirks = prefs.read_preference(/datum/preference/blob/quirks)
	return length(quirk_prefs & user_quirks)


/datum/preference_group/quirks/get_content(datum/preferences/prefs)
	. = ..()
	. += {"
	<fieldset class='computerPaneNested' style='display: inline-block;min-width:32.23%;max-width:32.23%'>
		<legend class='computerLegend tooltip'>
			<b>Quirks</b>
			<span class='tooltiptext'>Getting a little quirky.</span>
		</legend>
	<table style='width:100%'>
	"}

	var/list/user_quirks = prefs.read_preference(/datum/preference/blob/quirks)
	for(var/quirk_name in user_quirks)
		var/datum/preference/associated_pref = quirk_prefs[quirk_name]
		if(!associated_pref)
			continue

		associated_pref = GLOB.preference_entries[associated_pref]

		. += {"
			<tr>
				<td style='padding: 4px 8px'><span class='computerText'>[associated_pref.explanation]</span></td>
				<td style='padding: 4px 8px'>[associated_pref.get_button(prefs)]</td>
			</tr>
		"}

	. += "</table></fieldset>"
