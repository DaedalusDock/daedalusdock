/// An associative list of job_name:employer_path
/datum/preference/choiced/employer
	explanation = "Employer"
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "employer"
	cyclable = FALSE

/datum/preference/choiced/employer/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/choiced/employer/create_default_value()
	return /datum/employer/none

/datum/preference/choiced/employer/init_possible_values()
	return subtypesof(/datum/employer)

/datum/preference/choiced/employer/value_changed(datum/preferences/prefs, new_value, old_value)
	var/datum/preference/P = GLOB.preference_entries[/datum/preference/blob/job_priority]
	prefs.update_preference(P, P.create_default_value())

/datum/preference/choiced/employer/serialize(input)
	var/datum/employer/path = input
	return initial(path.name)

/datum/preference/choiced/employer/deserialize(input, datum/preferences/preferences)
	if(input in get_choices_serialized())
		return GLOB.employers_by_name[input]

	return create_default_value()

/datum/preference/choiced/employer/create_default_value()
	return /datum/employer/none

/datum/preference/choiced/employer/button_act(mob/user, datum/preferences/prefs, list/params)
	if(params["info"])
		var/datum/employer/employer = prefs.read_preference(type)
		if(!employer)
			return

		var/datum/browser/popup = new(user, "factioninfo", "[initial(employer.name)] ([initial(employer.short_name)])", 660, 270)
		popup.set_content(initial(employer.creator_info))
		popup.open()
		return FALSE

	return ..()

/// Associative list of job:integer, where integer is a priority between 1 and 4
/datum/preference/blob/job_priority
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "job_priority"

/datum/preference/blob/job_priority/create_default_value()
	return list()

/datum/preference/blob/job_priority/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/blob/job_priority/deserialize(input, datum/preferences/preferences)
	if(!islist(input))
		return create_default_value()

	for(var/thing in input)
		if(!istext(thing))
			input -= thing
			continue

		if(!isnum(input[thing]) || !(input[thing] in list(1, 2, 3)))
			input -= thing

	return input

/datum/preference/blob/job_priority/proc/can_play_job(datum/preferences/prefs, job_title)
	var/datum/job/J = SSjob.GetJob(job_title)
	if(!J)
		return FALSE

	if(is_banned_from(prefs.parent.ckey, job_title))
		return FALSE

	if(J.required_playtime_remaining(prefs.parent))
		return FALSE

	if(!J.player_old_enough(prefs.parent))
		return FALSE

	return TRUE

/datum/preference/blob/job_priority/user_edit(mob/user, datum/preferences/prefs, list/params)
	var/datum/job/job = SSjob.GetJob(params["job"])
	if(!job)
		return

	if (job.faction != FACTION_STATION)
		return FALSE

	if(!can_play_job(prefs, job.title))
		return FALSE

	var/list/job_prefs = prefs.read_preference(type)
	var/list/choices = list("Never", "Low", "Medium", "High")
	var/level = tgui_input_list(usr, "Change Priority",, choices, choices[job_prefs[job] + 1])
	if(!level)
		return

	level = choices.Find(level) - 1

	if (level == JP_HIGH)
		var/datum/job/overflow_role = SSjob.overflow_role
		var/overflow_role_title = initial(overflow_role.title)

		for(var/other_job in job_prefs)
			if(job_prefs[other_job] == JP_HIGH)
				// Overflow role needs to go to NEVER, not medium!
				if(other_job == overflow_role_title)
					job_prefs[other_job] = null
				else
					job_prefs[other_job] = JP_MEDIUM

	job_prefs[job.title] = level

	return prefs.update_preference(src, job_prefs)
