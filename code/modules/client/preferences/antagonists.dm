/datum/preference/blob/antagonists
	savefile_key = "antagonists"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/blob/antagonists/create_default_value()
	. = list()
	for(var/antagonist in GLOB.special_roles)
		.[antagonist] = TRUE

/datum/preference/blob/antagonists/deserialize(input, datum/preferences/preferences)
	var/list/reference = create_default_value()
	input |= reference
	input &= reference
	for(var/antagonist in input)
		input[antagonist] = !!input[antagonist]
	return input

/datum/preference/blob/antagonists/user_edit(mob/user, datum/preferences/prefs, list/params)
	var/list/client_antags = prefs.read_preference(type)
	if(params["select_all"])
		for(var/antag in client_antags)
			client_antags[antag] = TRUE
		return prefs.update_preference(src, client_antags)

	if(params["deselect_all"])
		for(var/antag in client_antags)
			client_antags[antag] = FALSE
		return prefs.update_preference(src, client_antags)

	var/antag = params["toggle_antag"]
	if(!(antag in client_antags))
		return

	client_antags[antag] = !client_antags[antag]
	return prefs.update_preference(src, client_antags)

/datum/preferences/proc/get_antag_bans()
	var/list/antag_bans = list()

	for (var/datum/dynamic_ruleset/dynamic_ruleset as anything in subtypesof(/datum/dynamic_ruleset))
		var/antag_flag = initial(dynamic_ruleset.antag_flag)
		var/antag_flag_override = initial(dynamic_ruleset.antag_flag_override)

		if (isnull(antag_flag))
			continue

		if (is_banned_from(parent.ckey, list(antag_flag_override || antag_flag, ROLE_SYNDICATE)))
			antag_bans += antag_flag

	return antag_bans

/datum/preferences/proc/get_antag_days_left()
	if (!CONFIG_GET(flag/use_age_restriction_for_jobs))
		return

	var/list/antag_days_left = list()

	for (var/datum/dynamic_ruleset/dynamic_ruleset as anything in subtypesof(/datum/dynamic_ruleset))
		var/antag_flag = initial(dynamic_ruleset.antag_flag)
		var/antag_flag_override = initial(dynamic_ruleset.antag_flag_override)

		if (isnull(antag_flag))
			continue

		var/days_needed = parent?.get_remaining_days(
			GLOB.special_roles[antag_flag_override || antag_flag]
		)

		if (days_needed > 0)
			antag_days_left[antag_flag] = days_needed

	return antag_days_left
