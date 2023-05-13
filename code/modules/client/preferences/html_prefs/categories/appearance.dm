/datum/preference_group/category/appearance
	name = "Appearance"
	priority = 99
	modules = list(
		/datum/preference_group/species
	)

/datum/preference_group/category/appearance/get_content(datum/preferences/prefs)
	. = ..()
	for(var/datum/preference_group/module as anything in modules)
		. += module.get_content(prefs)
