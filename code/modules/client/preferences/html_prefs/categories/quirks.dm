/datum/preference_group/category/quirks
	name = "Quirks"
	priority = 1

	var/list/associated_prefs = list(
		"Nearsighted" = /datum/preference/choiced/glasses,
		"Heterochromia" = /datum/preference/color/heterochromatic
	)

/datum/preference_group/category/quirks/get_header(datum/preferences/prefs)
	. = ..()
	var/datum/preference/blob/quirks/P = GLOB.preference_entries[/datum/preference/blob/quirks]
	var/balance = P.GetQuirkBalance(prefs.read_preference(P.type))
	. += {"
	<div style='width: 100%; text-align: center'>
		<span class='computerText'>
			<b>Balance</b>
			<br>
			[balance] Points
		</span>
	</div>
	<hr>
	"}

/datum/preference_group/category/quirks/get_content(datum/preferences/prefs)
	. = ..()
	var/datum/preference/P = GLOB.preference_entries[/datum/preference/blob/quirks]
	var/list/all_quirks = SSquirks.get_quirks()
	var/list/quirk_info = list()
	var/list/user_quirks = prefs.read_preference(P.type)

	for (var/quirk_name in all_quirks)
		var/datum/quirk/quirk = all_quirks[quirk_name]
		quirk_info[quirk_name] = list(
			"description" = initial(quirk.desc),
			"icon" = initial(quirk.icon),
			"name" = quirk_name,
			"value" = initial(quirk.value),
			"mood" = !!(initial(quirk.quirk_flags) & QUIRK_MOODLET_BASED)
		)

	. += {"
	<fieldset class='computerPaneNested' style='display: inline-block;min-width:40%;max-width:40%;margin-left: auto;margin-right: auto'>
		<legend class='computerLegend tooltip'>
			<b>All Quirks</b>
			<span class='tooltiptext'>I'm gettin' quirked up tonight.</span>
		</legend>
	<table class='zebraTable' style='min-width:100%;height: 560px;display: block;overflow-y: scroll'>
	"}

	for(var/quirk in all_quirks)
		if(quirk in user_quirks || (quirk_info[quirk]["mood"] && CONFIG_GET(flag/disable_human_mood)))
			continue
		var/quirk_type ="<span style='color: #AAAAFF'>Neuteral</span>"
		if(quirk_info[quirk]["value"])
			quirk_type = quirk_info[quirk]["value"] > 0 ? "<span style='color: #AAFFAA'>Positive</span>" : "<span style='color: #FFAAAA'>Negative</span>"

		. += {"
		<tr style='min-width=100%'>
			<td>
				[button_element(prefs, "[quirk] ([quirk_info[quirk]["value"]] pts)", "pref_act=[P.type];toggle_quirk=[quirk]")] - [button_element(prefs, "?", "pref_act=[P.type];info=[quirk]")] - [quirk_type]
			</td>
		</tr>
		"}


	. += "</table></fieldset>"

	. += {"
	<fieldset class='computerPaneNested' style='display: inline-block;min-width:40%;max-width:40%;margin-left: auto;margin-right: auto'>
		<legend class='computerLegend tooltip'>
			<b>Owned Quirks</b>
			<span class='tooltiptext'>I'm gettin' quirked up tonight.</span>
		</legend>
	<table class='zebraTable' style='min-width:100%;height: 560px;display: block;overflow-y: scroll'>
	"}

	for(var/quirk in user_quirks)
		. += {"
		<tr>
			<td>
				<b>[quirk]</b> -
				[button_element(prefs, "REMOVE ([quirk_info[quirk]["value"] * -1] pts)", "pref_act=[P.type];toggle_quirk=[quirk]")]
				<br>
				[quirk_info[quirk]["description"]]
			</td>
		</tr>
		"}

	. += "</table></fieldset>"
