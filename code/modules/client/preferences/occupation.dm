/// An associative list of job_name:employer_path
/datum/preference/choiced/employer
	explanation = "Employer"
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "employer"
	cyclable = FALSE

/datum/preference/choiced/employer/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/choiced/employer/create_default_value()
	var/datum/employer/daedalus = /datum/employer/daedalus
	return initial(daedalus.name)

/datum/preference/choiced/employer/init_possible_values()
	. = list()
	for(var/datum/employer/E as anything in subtypesof(/datum/employer))
		. += initial(E.name)

/datum/preference/choiced/employer/value_changed(datum/preferences/prefs, new_value, old_value)
	var/datum/preference/P = GLOB.preference_entries[/datum/preference/blob/job_priority]
	prefs.update_preference(P, P.create_default_value())

/// Associative list of job:integer, where integer is a priority between 1 and 4
/datum/preference/blob/job_priority
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "job_priority"

/datum/preference/blob/job_priority/create_default_value()
	return list()

/datum/preference/blob/job_priority/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
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

/datum/preference/blob/job_priority/user_edit(mob/user, datum/preferences/prefs, list/params)
	var/datum/job/job = SSjob.GetJob(params["job"])
	if(!job)
		return

	if (job.faction != FACTION_STATION)
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
