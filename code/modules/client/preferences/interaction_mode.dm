/datum/preference/choiced/interaction_mode
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "client_interaction_mode_choice"
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/choiced/interaction_mode/init_possible_values()
	return available_interaction_modes

/datum/preference/choiced/interaction_mode/create_default_value()
	return IMODE_COMBAT_MODE

/datum/preference/choiced/interaction_mode/apply_to_client(client/client, value)
	var/mob/host = client.mob
	var/datum/interaction_mode/IM
	IM = host?.forced_interaction_mode
	IM ||= available_interaction_modes[value]
	client.imode = new IM(client)

/datum/preference/choiced/interaction_mode/is_valid(value)
	return value in available_interaction_modes
