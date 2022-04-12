/datum/preferences/proc/load_character_pariah(savefile/S)
	READ_FILE(S["loadout_list"], loadout_list)


	loadout_list = sanitize_loadout_list(update_loadout_list(loadout_list))

	READ_FILE(S["alt_job_titles"], alt_job_titles)


/datum/preferences/proc/save_character_pariah(savefile/S)

	WRITE_FILE(S["loadout_list"], loadout_list)
	WRITE_FILE(S["alt_job_titles"], alt_job_titles)
