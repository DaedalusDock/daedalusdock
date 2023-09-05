/// Augments!
/*
	expected format:
	list(
		AUGMENT_SLOT_R_ARM = /datum/augment_item/bodypart/r_arm/amputated
	)

	The AUGMENT_SLOT_IMPLANTS slot expects a list in the format of:
	list(
		/datum/augment_item/implant/cat_ears = "Cat"
	)
*/

/datum/preference/blob/augments
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "augments"
	priority = PREFERENCE_PRIORITY_AUGMENTS

/datum/preference/blob/augments/apply_to_human(mob/living/carbon/human/target, value)
	var/datum/species/S = target.dna.species

	for(var/slot in value - AUGMENT_SLOT_IMPLANTS)
		var/path = value[slot]
		var/datum/augment_item/A = GLOB.augment_items[path]
		if(!A.can_apply_to_species(S))
			continue
		A.apply_to_human(target, S)

	for(var/datum/augment_item/A as anything in value[AUGMENT_SLOT_IMPLANTS])
		A = GLOB.augment_items[A]
		if(!A.can_apply_to_species(S))
			continue
		A.apply_to_human(target, S, value[AUGMENT_SLOT_IMPLANTS][A.type])

/datum/preference/blob/augments/create_default_value()
	return list()

/datum/preference/blob/augments/deserialize(input, datum/preferences/preferences)
	var/datum/species/S = preferences.read_preference(/datum/preference/choiced/species)
	S = new S()
	var/list/species_tree = get_species_augments(S)

	for(var/slot in input)
		if(slot == AUGMENT_SLOT_IMPLANTS)
			continue // handled later
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

	var/list/implants = input[AUGMENT_SLOT_IMPLANTS]
	if(implants)
		if(!islist(implants))
			input -= AUGMENT_SLOT_IMPLANTS
		else
			for(var/path as anything in implants)
				var/datum/augment_item/implant/A = GLOB.augment_items[path]
				if(!A)
					implants -= path
					continue
				if(!A.can_apply_to_species(S))
					implants -= path
					continue
				if(!(A.type in species_tree?[AUGMENT_CATEGORY_IMPLANTS][AUGMENT_SLOT_IMPLANTS]))
					implants -= path
					continue
				if(!(implants[path] in A.get_choices()))
					implants -= path
					continue


	return input

/datum/preference/blob/augments/user_edit(mob/user, datum/preferences/prefs, list/params)
	var/list/user_augs = prefs.read_preference(type)
	var/datum/species/S = prefs.read_preference(/datum/preference/choiced/species)
	var/list/species_augment_tree = get_species_augments(S)

	if(params["switch_augment"])
		var/datum/augment_item/old = GLOB.augment_items[user_augs[params["switch_augment"]]]
		if(!old)
			return

		var/list/datum/options = list()
		for(var/datum/augment_item/A as anything in GLOB.augment_slot_to_items[old.slot])
			A = GLOB.augment_items[A]
			options[A.name] = A.type

		var/input = tgui_input_list(user, "Switch Augment", "Augments", options)
		if(!input)
			return

		user_augs[old.slot] = options[input]
		return prefs.update_preference(src, user_augs)

	if(params["remove_augment"])
		var/datum/augment_item/removing = GLOB.augment_items[user_augs[params["remove_augment"]]]
		user_augs -= removing.slot
		return prefs.update_preference(src, user_augs)

	if(params["add_augment"])
		var/category = params["add_augment"]
		var/slot = tgui_input_list(user, "Add Augment", "Augments", species_augment_tree?[category])
		if(!slot)
			return

		var/list/choices = list()

		for(var/datum/augment_item/path as anything in species_augment_tree?[category][slot])
			choices[initial(path.name)] = path

		var/augment = tgui_input_list(user, "Add [slot] Augment", "Augments", choices)
		if(!augment)
			return

		user_augs[slot] = choices[augment]
		return prefs.update_preference(src, user_augs)


	if(params["add_implant"])
		var/list/choices = list()
		for(var/datum/augment_item/implant/path as anything in species_augment_tree?[AUGMENT_CATEGORY_IMPLANTS][AUGMENT_SLOT_IMPLANTS])
			choices[initial(path.name)] = path

		var/datum/augment_item/implant/implant = tgui_input_list(user, "Add Implant", "Implants", choices)
		if(!implant)
			return

		implant = GLOB.augment_items[choices[implant]]
		LAZYADDASSOC(user_augs[AUGMENT_SLOT_IMPLANTS], implant.type, implant.get_choices()[1])
		return prefs.update_preference(src, user_augs)

	if(params["modify_implant"])
		var/datum/augment_item/implant/I = text2path(params["modify_implant"])
		if(!ispath(I))
			return
		if(!(I in user_augs[AUGMENT_SLOT_IMPLANTS]))
			return

		I = GLOB.augment_items[I]
		var/new_look = tgui_input_list(user, "Modify Implant", "Implants", I.get_choices() - SPRITE_ACCESSORY_NONE, user_augs[AUGMENT_SLOT_IMPLANTS][I.type])
		if(!new_look)
			return

		user_augs[AUGMENT_SLOT_IMPLANTS][I.type] = new_look

		return prefs.update_preference(src, user_augs)

	if(params["remove_implant"])
		var/path = params["remove_implant"]
		path = text2path(path)
		if(!ispath(path))
			return

		var/datum/augment_item/removing = GLOB.augment_items[path]
		user_augs -= removing.slot
		return prefs.update_preference(src, user_augs)
