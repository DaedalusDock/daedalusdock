/// Species preference
/datum/preference/choiced/species
	explanation = "Species"
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "species"
	priority = PREFERENCE_PRIORITY_SPECIES
	randomize_by_default = FALSE

/datum/preference/choiced/species/deserialize(input, datum/preferences/preferences)
	return GLOB.species_list[sanitize_inlist(input, get_choices_serialized(), SPECIES_HUMAN)]

/datum/preference/choiced/species/serialize(input)
	var/datum/species/species = input
	return initial(species.id)

/datum/preference/choiced/species/create_default_value()
	return /datum/species/human

/datum/preference/choiced/species/create_random_value(datum/preferences/preferences)
	return pick(get_choices())

/datum/preference/choiced/species/init_possible_values()
	var/list/values = list()

	for (var/species_id in get_selectable_species())
		values += GLOB.species_list[species_id]

	return values

/datum/preference/choiced/species/apply_to_human(mob/living/carbon/human/target, value)
	target.set_species(value, icon_update = FALSE, pref_load = TRUE)

/datum/preference/choiced/species/user_edit(mob/user, datum/preferences/prefs)
	var/datum/species/existing = prefs.read_preference(type)
	existing = capitalize(initial(existing.id))

	var/list/choices = list()
	for(var/datum/species/S as anything in get_choices())
		choices[capitalize(initial(S.id))] = S
	choices -= existing

	var/input = input(user, "Change [explanation]",, existing) as null|anything in choices
	if(!choices[input])
		return
	return prefs.update_preference(src, choices[input])

/datum/preference/choiced/species/get_button(datum/preferences/prefs)
	var/datum/species/existing = prefs.read_preference(type)
	return button_element(prefs, capitalize(initial(existing.id)), "pref_act=[type]")

/datum/preference/choiced/species/compile_constant_data()
	var/list/data = list()

	for (var/species_id in get_selectable_species())
		var/species_type = GLOB.species_list[species_id]
		var/datum/species/species = new species_type()

		data[species_id] = list()
		data[species_id]["name"] = species.name
		data[species_id]["desc"] = species.get_species_description()
		data[species_id]["lore"] = species.get_species_lore()
		data[species_id]["icon"] = sanitize_css_class_name(species.name)
		data[species_id]["use_skintones"] = species.use_skintones
		data[species_id]["sexes"] = species.sexes
		data[species_id]["enabled_features"] = species.get_features()
		data[species_id]["perks"] = species.get_species_perks()
		data[species_id]["diet"] =  species.get_species_diet()

		qdel(species)

	return data
