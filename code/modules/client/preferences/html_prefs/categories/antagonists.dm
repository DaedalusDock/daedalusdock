/datum/preference_group/category/antagonists
	name = "Antagonists"
	priority = 30

	modules = list(
		/datum/preference_group/antagonists
	)

/datum/preference_group/category/antagonists/get_content(datum/preferences/prefs)
	. = ..()
	for(var/datum/preference_group/module as anything in modules)
		. += module.get_content(prefs)

/datum/preference_group/antagonists

/datum/preference_group/antagonists/get_content(datum/preferences/prefs)
	. = ..()
	. += {"
	<fieldset class='computerPaneNested' style='display: inline-block;min-width:50%;max-width:50%;margin-left: auto;margin-right: auto'>
		<legend class='computerLegend tooltip'>
			<b>Antagonists</b>
			<span class='tooltiptext'>Trouble lurks in the tunnels... you.</span>
		</legend>
		<div style='text-align: center'>
			[button_element(prefs, "Select All", "pref_act=[/datum/preference/blob/antagonists];select_all=1")]
			[button_element(prefs, "Deselect All", "pref_act=[/datum/preference/blob/antagonists];deselect_all=1")]
		</div>
	<table style='width:100%'>
	"}
	var/list/client_antags = prefs.read_preference(/datum/preference/blob/antagonists)
	for(var/antagonist in client_antags)
		. += {"
		<tr>
			<td><span class='computerText'>[antagonist]</span><td>
			<td>[button_element(prefs, client_antags[antagonist] ? "ENABLED" : "DISABLED", "pref_act=[/datum/preference/blob/antagonists];toggle_antag=[antagonist]")]</td>
		</tr>
		"}
	. += "</table></fieldset>"
