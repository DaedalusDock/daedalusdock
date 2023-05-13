/datum/preference_group/religion

/datum/preference_group/religion/get_content(datum/preferences/prefs)
	. = ..()
	. += {"
		<fieldset class='computerPane' style='display: inline-block;min-width:32.23%;max-width:32.23%'>
		<legend class='computerLegend tooltip'>
			<b>Religion</b>
			<span class='tooltiptext'>That whom guides thy wandering flesh.</span>
		</legend>
	"}
	. += "</fieldset>"

	. += "<table>"
