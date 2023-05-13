/datum/preference_group/job_specific
	///Prefs we display. Set TRUE to check if accessible
	var/list/datum/display = list(
		/datum/preference/name/backup_human,
		/datum/preference/name/clown,
		/datum/preference/name/mime,
		/datum/preference/name/cyborg,
		/datum/preference/name/ai,
	)
	///Same as above but under a line
	var/list/display_under = list(
		/datum/preference/name/deity,
		/datum/preference/name/bible
	)

/datum/preference_group/job_specific/get_content(datum/preferences/prefs)
	. = ..()
	. += {"
	<fieldset class='computerPane' style='display: inline-block;min-width:32.23%;max-width:32.23%'>
		<legend class='computerLegend tooltip'>
			<b>Occupational</b>
			<span class='tooltiptext'>A mask will not hide who you are from us.</span>
		</legend>
	<table style='border-collapse: collapse;width: 100%'>
	"}
	var/i
	for(var/path in display)
		i++
		var/datum/preference/pref = GLOB.preference_entries[path]
		if(display[path] && !pref.is_accessible(prefs))
			continue
		var/result = prefs.read_preference(pref.type)
		. += {"
			<tr>
				<td style='padding: 4px 8px'>[pref.explanation]:</td>
				<td style='padding: 4px 8px'>[button_element(prefs, istext(result) ? capitalize(result) : result, "pref_act=[pref.type]")]</td>
			</tr>
		"}
		if(i == length(display)) //Insert an <hr> tag at the end
			. += "<tr><td colspan='2'><HR></td></tr>"

	for(var/path in display_under)
		var/datum/preference/pref = GLOB.preference_entries[path]
		if(display[path] && !pref.is_accessible(prefs))
			continue
		var/result = prefs.read_preference(pref.type)
		. += {"
			<tr>
				<td style='padding: 4px 8px'>[pref.explanation]:</td>
				<td style='padding: 4px 8px'>[button_element(prefs, istext(result) ? capitalize(result) : result, "pref_act=[pref.type]")]</td>
			</tr>
		"}


	. += "</table></fieldset>"
