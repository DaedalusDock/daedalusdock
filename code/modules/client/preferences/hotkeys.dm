/datum/preference/toggle/hotkeys
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "hotkeys"
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/hotkeys/apply_to_client(client/client, value)
	client.hotkeys = value
	if(SSinput.initialized)
		client.set_macros() //They've changed their preferences, We need to rewrite the macro set again.

/datum/preference/toggle/hotkeys_silence
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "hotkeys_silence"
	savefile_identifier = PREFERENCE_PLAYER
