/// Fully randomizes everything in the character.
/datum/preferences/proc/randomise_appearance_prefs(randomize_flags = ALL)
	for (var/datum/preference/preference as anything in get_preferences_in_priority_order())
		if(preference.savefile_identifier == PREFERENCE_PLAYER)
			continue
		if(istype(preference, /datum/preference/name/real_name) && !(randomize_flags & RANDOMIZE_NAME))
			continue
		if(istype(preference, /datum/preference/choiced/species) && !(randomize_flags & RANDOMIZE_SPECIES))
			continue

		if (preference.is_randomizable())
			write_preference(preference, preference.create_random_value(src))

/// Returns what job is marked as highest
/datum/preferences/proc/get_highest_priority_job()
	var/datum/job/preview_job
	var/highest_pref = 0
	var/list/job_prefs = read_preference(/datum/preference/blob/job_priority)
	for(var/job in job_prefs)
		if(job_prefs[job] > highest_pref)
			preview_job = SSjob.GetJob(job)
			highest_pref = job_prefs[job]

	return preview_job

/datum/preferences/proc/render_new_preview_appearance(mob/living/carbon/human/dummy/mannequin)
	var/datum/job/preview_job = get_highest_priority_job()

	// Set up the dummy for its photoshoot
	apply_prefs_to(mannequin, TRUE)

	switch(preview_pref)
		if(PREVIEW_PREF_JOB)
			if(preview_job) //PARIAH EDIT
				// Silicons only need a very basic preview since there is no customization for them.
				if (istype(preview_job, /datum/job/ai))
					return image('icons/mob/ai.dmi', icon_state = resolve_ai_icon(read_preference(/datum/preference/choiced/ai_core_display)), dir = SOUTH)
				if (istype(preview_job, /datum/job/cyborg))
					return image('icons/mob/robots.dmi', icon_state = "robot", dir = SOUTH)
				mannequin.job = preview_job.title
				mannequin.dress_up_as_job(preview_job, TRUE, src, TRUE)
		if(PREVIEW_PREF_LOADOUT)
			mannequin.equip_outfit_and_loadout(new /datum/outfit, src, TRUE)

	// Yes we do it every time because it needs to be done after job gear
	if(length(SSquirks.quirks))
		// And yes we need to clean all the quirk datums every time
		mannequin.cleanse_quirk_datums()
		for(var/quirk_name as anything in read_preference(/datum/preference/blob/quirks))
			var/datum/quirk/quirk_type = SSquirks.quirks[quirk_name]
			if(!(initial(quirk_type.quirk_flags) & QUIRK_CHANGES_APPEARANCE))
				continue
			mannequin.add_quirk(quirk_type, parent)

	mannequin.update_body()
	mannequin.add_overlay(mutable_appearance('icons/turf/floors.dmi', icon_state = "floor", layer = SPACE_LAYER))
	return mannequin.appearance

