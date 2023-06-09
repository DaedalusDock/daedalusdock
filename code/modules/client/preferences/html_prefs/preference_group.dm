/datum/preference_group
	var/name = ""
	/// Sort priority in the UI. Used to do things like place general before other categories.
	var/priority = 1

	var/abstract_type = /datum/preference_group


///Return a list of html data to be joined into a string
/datum/preference_group/proc/get_content(datum/preferences/prefs)
	SHOULD_CALL_PARENT(TRUE)
	. = list()

/datum/preference_group/proc/get_header(datum/preferences/prefs)
	SHOULD_CALL_PARENT(TRUE)
	. = list()

/datum/preference_group/proc/should_display(datum/preferences/prefs)
	return TRUE

/datum/preference_group/category
	abstract_type = /datum/preference_group/category

	var/list/modules

