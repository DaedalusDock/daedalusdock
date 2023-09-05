/datum/preference_group/category/general
	name = "General"
	priority = 100

	modules = list(
		/datum/preference_group/body,
		/datum/preference_group/species,
		/datum/preference_group/job_specific,
		/datum/preference_group/appearance_mods,
		/datum/preference_group/meta,
		/datum/preference_group/quirks
	)

/datum/preference_group/category/general/get_content(datum/preferences/prefs)
	. = ..()
	for(var/datum/preference_group/module as anything in modules)
		if(module.should_display(prefs))
			. += module.get_content(prefs)

