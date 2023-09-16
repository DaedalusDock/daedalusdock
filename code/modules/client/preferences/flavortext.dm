/datum/preference/text/flavor_text
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "flavor_text"

	explanation = "Flavor Text"

/datum/preference/text/flavor_text/get_button(datum/preferences/prefs)
	return button_element(prefs, "Set Examine Text", "pref_act=[type]")

/datum/preference/text/flavor_text/user_edit(mob/user, datum/preferences/prefs)
	var/input = tgui_input_text(user, "Describe your character in greater detail.",, serialize(prefs.read_preference(type)), MAX_FLAVOR_LEN, TRUE)
	if(!input)
		return
	. = prefs.update_preference(src, input)
	return .

/datum/preference/text/flavor_text/apply_to_human(mob/living/carbon/human/target, value)
	target.examine_text = value
