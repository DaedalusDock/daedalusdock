/datum/preference/choiced/ipc_screen
	explanation = "Screen"
	savefile_key = "ipc_screen"
	savefile_identifier = PREFERENCE_CHARACTER
	relevant_external_organ = /obj/item/organ/ipc_screen

/datum/preference/choiced/ipc_screen/init_possible_values()
	return GLOB.ipc_screens_list

/datum/preference/choiced/ipc_screen/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["ipc_screen"] = value

/datum/preference/choiced/ipc_antenna
	explanation = "Antenna"
	savefile_key = "ipc_antenna"
	savefile_identifier = PREFERENCE_CHARACTER
	relevant_external_organ = /obj/item/organ/ipc_antenna
	sub_preference = /datum/preference/color/mutcolor/ipc_antenna

/datum/preference/choiced/ipc_antenna/init_possible_values()
	return GLOB.ipc_antenna_list

/datum/preference/choiced/ipc_antenna/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["ipc_antenna"] = value

/datum/preference/color/mutcolor/ipc_antenna
	explanation = "Antenna Color"
	savefile_key = "ipc_antenna_color"
	savefile_identifier = PREFERENCE_CHARACTER
	relevant_external_organ = /obj/item/organ/ipc_antenna
	is_sub_preference = TRUE

	color_key = MUTCOLORS_KEY_IPC_ANTENNA

/datum/preference/color/mutcolor/ipc_antenna/create_default_value()
	return "#b4b4b4"

