/// Species preference
/datum/preference/choiced/species
	explanation = "Species"
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "species"
	priority = PREFERENCE_PRIORITY_SPECIES

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

/datum/preference/choiced/species/get_button(datum/preferences/prefs)
	. = ..()
	. += button_element(prefs, "?", "pref_act=[type];info=1")

/datum/preference/choiced/species/button_act(mob/user, datum/preferences/prefs, list/params)
	if(params["info"])
		var/datum/species/S = prefs.read_preference(type)
		S = new S
		var/list/diet = S.get_species_diet()
		var/list/perks = get_species_constant_data(S.type)?[SPECIES_DATA_PERKS]
		var/list/content = list("<div style='text-align:center'>")
		content += S.get_species_lore()
		content += {"
		<br><br>
		<table style='min-width: 90%; margin: 0 auto; border: 2px solid white'>
			<th style='text-align: center;vertical-align: middle; width: 33.33%; border: 2px solid white'>
				<span style='color: #AAFFAA'>Liked Food</span>
			</th>
			<th style='text-align: center;vertical-align: middle; width: 33.33%; border: 2px solid white'>
				<span style='color: #AAAAFF'>Disliked Food</span>
			</th>
			<th style='text-align: center;vertical-align: middle; width: 33.33%; border: 2px solid white'>
				<span style='color: #FFAAAA'>Toxic Food</span>
			</th>
		"}
		content += "</tr><tr>"

		for(var/thing in diet)
			content += {"
				<td style='text-align: center;vertical-align: middle; border: 2px solid whit'>
					[english_list(diet[thing], "Nothing")]
				</td>
			"}
		content += {"
		</table>
		<br>
		<table class='zebraTable' style='min-width: 90%; margin 0 auto'>
		"}

		for(var/list/perk as anything in perks[SPECIES_NEUTRAL_PERK] + perks[SPECIES_POSITIVE_PERK] + perks[SPECIES_NEGATIVE_PERK])
			var/perk_type = ""
			switch(perk[SPECIES_PERK_TYPE])
				if(SPECIES_NEUTRAL_PERK)
					perk_type = "<span style='color: #AAAAFF'>Neutral</span>"
				if(SPECIES_POSITIVE_PERK)
					perk_type = "<span style='color: #AAFFAA'>Positive</span>"
				if(SPECIES_NEGATIVE_PERK)
					perk_type = "<span style='color: #FFAAAA'>Negative</span>"
			content += {"
				<tr>
					<td style='text-align: center'>
						[perk[SPECIES_PERK_NAME]]
						<br>
						[perk_type]
						<br>
						[perk[SPECIES_PERK_DESC]]
					</td>
				</tr>
			"}



		content += "</tr></table></div>"
		var/datum/browser/window = new(user, "SpeciesInfo", S.name, 400, 600)
		window.set_content(jointext(content, ""))
		window.open()
		return FALSE

	return ..()

/datum/preference/choiced/species/apply_to_human(mob/living/carbon/human/target, value)
	target.set_species(value, icon_update = FALSE, pref_load = TRUE)

/datum/preference/choiced/species/value_changed(datum/preferences/prefs, new_value, old_value)
	var/datum/preference/P = GLOB.preference_entries[/datum/preference/appearance_mods]
	prefs.update_preference(P, P.create_default_value())
