/datum/preference/choiced/uplink_location
	explanation = "Uplink Location"
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "uplink_loc"
	can_randomize = FALSE

/datum/preference/choiced/uplink_location/init_possible_values()
	return list(UPLINK_PDA, UPLINK_RADIO, UPLINK_PEN, UPLINK_IMPLANT)

/datum/preference/choiced/uplink_location/create_default_value()
	return UPLINK_PDA

/datum/preference/choiced/uplink_location/apply_to_human(mob/living/carbon/human/target, value)
	return
