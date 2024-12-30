/datum/preference_group/job_specific
	///Prefs we display. Set TRUE to check if accessible
	var/list/datum/display = list(
		/datum/preference/name/backup_human,
		/datum/preference/name/clown,
		/datum/preference/name/cyborg,
		/datum/preference/name/ai,
	)

/datum/preference_group/job_specific/get_content(datum/preferences/prefs)
	. = ..()
	. += {"
	<fieldset class='computerPaneNested' style='display: inline-block;min-width:32.23%;max-width:32.23%'>
		<legend class='computerLegend tooltip'>
			<b>Aliases</b>
			<span class='tooltiptext'>A mask will not hide who you are from us.</span>
		</legend>
	<table style='border-collapse: collapse;width: 100%'>
	"}

	for(var/path in display)
		var/datum/preference/pref = GLOB.preference_entries[path]
		if(display[path] && !pref.is_accessible(prefs))
			continue
		. += {"
			<tr>
				<td style='padding: 4px 8px'><span class='computerText'>[pref.explanation]:</span></td>
				<td style='padding: 4px 8px'>[pref.get_button(prefs)]</td>
			</tr>
		"}

	. += "</table></fieldset>"
