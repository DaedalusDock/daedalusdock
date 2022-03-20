/datum/preferences
	/// Loadout prefs. Assoc list of [typepaths] to [associated list of item info].
	var/list/loadout_list

	/// Preference of how the preview should show the character.
	var/preview_pref = PREVIEW_PREF_JOB

	var/datum/species/pref_species
