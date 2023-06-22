/datum/preference/blob/augments
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "augments"
	priority = PREFERENCE_PRIORITY_AUGMENTS

/datum/preference/blob/augments/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	var/datum/species/S = preferences.read_preference(/datum/preference/choiced/species)
	S = new S()

	for(var/slot in value)
		var/path = value[slot]
		var/datum/augment_item/A = GLOB.augment_items[path]
		A.apply_to_human(target, preferences, S)

/datum/preference/blob/augments/create_default_value()
	return list()

/datum/preference/blob/augments/deserialize(input, datum/preferences/preferences)
	var/datum/species/S = preferences.read_preference(/datum/preference/choiced/species)
	S = new S()
	for(var/slot in input)
		if(!GLOB.augment_slot_to_items[slot])
			input -= slot
			continue

		var/datum/augment_item/A = GLOB.augment_items[input[slot]]
		if(!A)
			input -= slot
			continue
		if(!A.can_apply_to_species(S))
			input -= slot
			continue

	return input

/datum/preference/blob/augments/user_edit(mob/user, datum/preferences/prefs, list/params)
	if(params["select_slot"])
		prefs.chosen_augment_slot = params["select_slot"]
		return TRUE

	if(params["set_augment"])
		var/path = params["set_augment"]
		path = text2path(path)
		if(!ispath(path))
			return

		var/datum/augment_item/desired = GLOB.augment_items[path]
		var/list/user_augs = prefs.read_preference(type)
		if(user_augs[desired.slot] == desired.path)
			user_augs -= desired.slot
		else
			user_augs[desired.slot] = path

		return prefs.update_preference(src, user_augs)





