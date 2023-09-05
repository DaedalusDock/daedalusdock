/datum/preference_group/appearance_mods

/datum/preference_group/appearance_mods/should_display(datum/preferences/prefs)
	var/datum/species/S = prefs.read_preference(/datum/preference/choiced/species)
	if(!length(global.ModManager.modnames_by_species[S]))
		return FALSE
	return TRUE

/datum/preference_group/appearance_mods/get_content(datum/preferences/prefs)
	. = ..()
	var/datum/preference/mod_pref = GLOB.preference_entries[/datum/preference/appearance_mods]
	. += {"
	<fieldset class='computerPaneNested' style='display: inline-block;min-width:32.23%;max-width:32.23%'>
		<legend class='computerLegend tooltip'>
			<b>Appearance Mods</b>
			<span class='tooltiptext'>Reality is yours, and yours alone.</span>
		</legend>
	<table style='width: 100%;border-collapse: collapse'>
	<tr>
		<td colspan='2' style='text-align: center'>[button_element(prefs, "Add Appearance Mod", "pref_act=[mod_pref];add=1")]</td>
	</tr>
	"}

	var/list/mods = prefs.read_preference(/datum/preference/appearance_mods):Copy()
	var/list/existing_mods = list()
	//All of pref code is written with the assumption that pref values about to be saved are serialized
	mods = mod_pref.serialize(mods)

	for(var/_type in mods)
		var/datum/appearance_modifier/path = mods[_type]["path"]
		path = text2path(path)
		existing_mods[initial(path.name)] = _type

	for(var/name in existing_mods)
		. += {"
		<tr>
			<td style='padding: 4px 8px;border-right: 2px solid rgba(255, 183, 0, 0.5);border-top: 2px solid rgba(255, 183, 0, 0.5)'><span class='computerText'>[name]</span></td>
			<td style='padding: 4px 8px;border-left: 2px solid rgba(255, 183, 0, 0.5);border-top: 2px solid rgba(255, 183, 0, 0.5)'>
				<span class='computerText'>
				[button_element(prefs, "Modify", "pref_act=[mod_pref];mod_name=[name];modify=1")]
				[button_element(prefs, "Remove", "pref_act=[mod_pref];mod_name=[name];remove=1")]
				</span>
			</td>
		</tr>
		"}
	. += "</table></fieldset>"
