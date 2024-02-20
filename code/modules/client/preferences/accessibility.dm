/datum/preference/toggle/disable_pain_flash
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "disable_pain_flash"
	savefile_identifier = PREFERENCE_PLAYER
	default_value = FALSE

/datum/preference/toggle/motion_sickness
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "motion_sickness"
	savefile_identifier = PREFERENCE_PLAYER
	default_value = FALSE

/datum/preference/toggle/motion_sickness/apply_to_client(client/client, value)
	if(client.mob)
		SEND_SIGNAL(client.mob, COMSIG_MOB_MOTION_SICKNESS_UPDATE, value)
