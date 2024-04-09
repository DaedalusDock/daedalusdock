/datum/preference_group/category/languages
	name = "Languages"
	priority = 1

/datum/preference_group/category/languages/get_header(datum/preferences/prefs)
	. = ..()

	var/datum/preference/blob/languages/P = GLOB.preference_entries[/datum/preference/blob/languages]
	var/points = 3 - P.tally_points(prefs.read_preference(/datum/preference/blob/languages))
	. += {"
	<div style='width: 100%; text-align: center'>
		<span class='computerText'>
			<b>Balance</b>
			<br>
			[points] Points
		</span>
	</div>
	<hr>
	"}

/datum/preference_group/category/languages/get_content(datum/preferences/prefs)
	. = ..()
	var/datum/preference/blob/languages/P = GLOB.preference_entries[/datum/preference/blob/languages]

	var/list/all_languages = GLOB.preference_language_types
	var/list/user_languages = prefs.read_preference(P.type)
	var/list/datum/language/innate_languages = get_species_constant_data(prefs.read_preference(/datum/preference/choiced/species))[SPECIES_DATA_LANGUAGES]
	var/remaining_points = 3 - P.tally_points(user_languages)
	var/afford_speak = remaining_points >= 2
	var/afford_understand = remaining_points >= 1


	. += {"
	<fieldset class='computerPaneNested' style='display: inline-block;min-width:40%;max-width:40%;margin-left: auto;margin-right: auto'>
		<legend class='computerLegend tooltip'>
			<b>All Languages</b>
			<span class='tooltiptext'>I'm gettin' quirked up tonight.</span>
		</legend>
	<div class='zebraTable' style='display: flex; flex-direction: column; height: 560px;display: block;overflow-y: scroll'>
	"}


	for(var/datum/language/language_path as anything in all_languages - innate_languages - user_languages)
		var/can_understand = initial(language_path.flags) & LANGUAGE_SELECTABLE_UNDERSTAND
		var/can_speak = initial(language_path.flags) & LANGUAGE_SELECTABLE_SPEAK

		. += {"
		<div class='flexItem'>
			[initial(language_path.name)] - [button_element(prefs, "?", "pref_act=[P.type];info=[language_path]")] -
			[can_speak && afford_speak ? button_element(prefs, "SPEAK", "pref_act=[P.type];set_speak=[language_path]") : "<span class='linkOff'>SPEAK</span>"] -
			[can_understand && afford_understand ? button_element(prefs, "UNDERSTAND", "pref_act=[P.type];set_understand=[language_path]") : "<span class='linkOff'>UNDERSTAND</span>"]
		</div>
		"}


	. += "</div></fieldset>"

	. += {"
	<fieldset class='computerPaneNested' style='display: inline-block;min-width:40%;max-width:40%;margin-left: auto;margin-right: auto'>
		<legend class='computerLegend tooltip'>
			<b>Known Languages</b>
			<span class='tooltiptext'>I'm gettin' quirked up tonight.</span>
		</legend>
	<div class='zebraTable' style='display: flex; flex-direction: column; height: 560px;display: block;overflow-y: scroll'>
	"}

	for(var/datum/language/innate_language as anything in innate_languages)
		. += {"
		<div class='flexItem'>
			<b>[initial(innate_language.name)]</b> - <span class='linkOff'>INNATE</span>
			<br>
			[initial(innate_language.desc)]
		</div>
		"}

	for(var/datum/language/language_path as anything in user_languages)
		var/language_value = user_languages[language_path]
		var/speak_button

		if(language_value & LANGUAGE_SPEAK)
			speak_button = button_element(prefs, "SPEAK", "pref_act=[P.type];set_speak=[language_path]", "linkOn")
		else if(remaining_points && (initial(language_path.flags) & LANGUAGE_SELECTABLE_SPEAK))
			speak_button = button_element(prefs, "SPEAK", "pref_act=[P.type];set_speak=[language_path]")
		else
			speak_button = "<span class='linkOff'>SPEAK</span>"

		var/understand_button
		if(language_value & LANGUAGE_UNDERSTAND)
			understand_button = button_element(prefs, "UNDERSTAND", "pref_act=[P.type];set_understand=[language_path]", "linkOn")
		else
			understand_button = "<span class='linkOff'>UNDERSTAND</span>"


		. += {"
		<div class='flexItem'>
			<b>[initial(language_path.name)]</b> -
			[button_element(prefs, "REMOVE", "pref_act=[P.type];remove=[language_path]")] -
			[speak_button] -
			[understand_button]
			<br>
			[initial(language_path.desc)]
		</div>
		"}

	. += "</div></fieldset>"
