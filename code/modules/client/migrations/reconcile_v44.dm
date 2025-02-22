/datum/preferences/proc/reconcile_v44(current_version)
	//Due to unsafe edits to the v44 updater, I need to make sure that both states are safely reconciled..

	if(current_version < 44)
		//If we called the v44 handler in this same session, we have nothing to resolve.
		return

	var/list/migrate_jobs = list(
		// If my logic is correct, this state should never occur, but just to ensure all states are stable.
		"Medical Doctor" = JOB_ACOLYTE,
		// Pre-Aethering-II Doctor.
		"General Practitioner" = JOB_ACOLYTE
	)
	var/list/job_prefs = read_preference(/datum/preference/blob/job_priority)
	for(var/job in job_prefs)
		if(job in migrate_jobs)
			var/old_value = job_prefs[job]
			job_prefs -= job
			job_prefs[migrate_jobs[job]] = old_value
	var/datum/preference/blob/job_priority/actual_datum = GLOB.preference_entries[/datum/preference/blob/job_priority]
	write_preference(/datum/preference/blob/job_priority, actual_datum.serialize(job_prefs))

