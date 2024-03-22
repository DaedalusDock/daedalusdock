/datum/preference/blob/languages
	priority = PREFERENCE_PRIORITY_APPEARANCE_MODS //run after everything mostly
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "languages"

/datum/preference/blob/languages/deserialize(input, datum/preferences/preferences)
	if(!islist(input))
		return create_default_value()

	input &= GLOB.preference_language_types

	if(!check_legality(input))
		return create_default_value()

	return input

/datum/preference/blob/languages/create_default_value()
	return list()

/datum/preference/blob/languages/apply_to_human(mob/living/carbon/human/target, value)
	for(var/datum/language/path as anything in value)
		var/language_flags = value[path]
		target.grant_language(path, language_flags & LANGUAGE_UNDERSTAND, language_flags & LANGUAGE_SPEAK, LANGUAGE_MIND)

/datum/preference/blob/languages/user_edit(mob/user, datum/preferences/prefs, list/params)
	if(params["info"])
		var/datum/language/L = GET_LANGUAGE_DATUM(text2path(params["info"]))
		if(!L)
			return
		var/datum/browser/window = new(usr, "LanguageInfo", L.name, 400, 120)
		window.set_content(L.desc)
		window.open()
		return FALSE

	if(params["remove"])
		var/language_path = text2path(params["remove"])
		var/list/user_languages = prefs.read_preference(type)
		user_languages -= language_path
		return prefs.update_preference(src, user_languages)

	if(params["set_speak"])
		var/language_path = text2path(params["set_speak"])
		var/list/user_languages = prefs.read_preference(type)

		var/value = user_languages[language_path]
		if(value & LANGUAGE_SPEAK)
			value &= ~(LANGUAGE_SPEAK)
		else
			value |= (LANGUAGE_UNDERSTAND|LANGUAGE_SPEAK)

		if(value == NONE)
			user_languages -= language_path
		else
			user_languages[language_path] = value

		return prefs.update_preference(src, user_languages)

	if(params["set_understand"])
		var/language_path = text2path(params["set_understand"])
		var/list/user_languages = prefs.read_preference(type)

		var/value = user_languages[language_path]
		if(value & LANGUAGE_UNDERSTAND)
			value = NONE
		else
			value |= LANGUAGE_UNDERSTAND

		if(value == NONE)
			user_languages -= language_path
		else
			user_languages[language_path] = value

		return prefs.update_preference(src, user_languages)

/datum/preference/blob/languages/proc/tally_points(list/languages)
	var/point_tally = 0
	for(var/datum/language/path as anything in languages)
		var/value = languages[path]
		if(value & LANGUAGE_SPEAK)
			point_tally++
		if(value & LANGUAGE_UNDERSTAND)
			point_tally++

	return point_tally

/datum/preference/blob/languages/proc/check_legality(list/languages)
	return tally_points(languages) <= 3
