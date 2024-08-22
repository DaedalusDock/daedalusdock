/datum/preference_group/category/quirks
	name = "Traits"
	priority = 1

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
			"name" = quirk_name,
		)

	. += {"
	</script>
	<fieldset class='computerPaneNested' style='display: inline-block;min-width:40%;max-width:40%;margin-left: auto;margin-right: auto'>
		<legend class='computerLegend tooltip'>
			<b>All Traits</b>
			<span class='tooltiptext'>I'm gettin' quirked up tonight.</span>
		</legend>
	<div class='zebraTable' style='display: flex; flex-direction: column; height: 560px;display: block;overflow-y: scroll'>
	"}

	for(var/quirk in all_quirks)
		if(quirk in user_quirks)
			continue

		. += {"
		[clickable_element("div", "flexItem flexRow highlighter", "justify-content: space-between;", prefs, "pref_act=[P.type];toggle_quirk=[quirk]")]
			<span style='display: block'>
				<b>[quirk]</b>
			</span>
			<span style='display: block'>
				[button_element(prefs, "?", "pref_act=[P.type];info=[quirk]")]
			</span>
		</div>
		"}


	. += "</div></fieldset>"

	. += {"
	<fieldset class='computerPaneNested' style='display: inline-block;min-width:40%;max-width:40%;margin-left: auto;margin-right: auto'>
		<legend class='computerLegend tooltip'>
			<b>My Traits</b>
			<span class='tooltiptext'>I'm gettin' quirked up tonight.</span>
		</legend>
	<div class='zebraTable' style='display: flex; flex-direction: column; height: 560px;display: block;overflow-y: scroll'>
	"}

	for(var/quirk in user_quirks)
		. += {"
		[clickable_element("div", "flexItem highlighter", "", prefs, "pref_act=[P.type];toggle_quirk=[quirk]")]
			<b><u>[quirk]</b></u>
			<br>
			[quirk_info[quirk]["description"]]
		</div>
		"}

	. += "</div></fieldset>"
