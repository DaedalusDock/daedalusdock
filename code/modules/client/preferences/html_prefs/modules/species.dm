/datum/preference_group/species

/datum/preference_group/species/get_content(datum/preferences/prefs)
	. = ..()
	. += {"
	<fieldset class='computerPaneNested' style='display: inline-block;min-width:32.23%;max-width:32.23%'>
		<legend class='computerLegend tooltip'>
			<b>Phenotype</b>
			<span class='tooltiptext'>Physiology drives psychology.</span>
		</legend>
	<table style='width:100%'>
	"}

	var/datum/species/pref_species = prefs.read_preference(/datum/preference/choiced/species)
	pref_species = new pref_species

	for(var/datum/preference/pref as anything in pref_species.get_features())
		pref = GLOB.preference_entries_by_key[pref]
		if(!pref.is_accessible(prefs) || (pref.is_sub_preference))
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
