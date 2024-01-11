/// Whether or not to toggle ambient occlusion, the shadows around people
/datum/preference/toggle/glasses_color
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "glasses_color"
	savefile_identifier = PREFERENCE_PLAYER
	default_value = FALSE

/datum/preference/toggle/glasses_color/apply_to_client(client/client, value)
	if(ishuman(client.mob))
		var/mob/living/carbon/human/H = client.mob
		if(H.glasses)
			H.update_glasses_color(H.glasses, TRUE)
