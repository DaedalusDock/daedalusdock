/datum/preferences/proc/migrate_skyrat(savefile/S)
	if(features["flavor_text"])
		write_preference(GLOB.preference_entries[/datum/preference/text/flavor_text], features["flavor_text"])
