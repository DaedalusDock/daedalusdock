/datum/codex_category/species
	name = "Species"
	desc = "Many species you may encounter on your journey."

/datum/codex_category/species/Populate()
	for (var/species_id in get_selectable_species())
		var/species_type = GLOB.species_list[species_id]
		var/datum/species/species = new species_type()
		var/_name = capitalize(codex_sanitize(species.plural_form))
		var/datum/codex_entry/entry = new(
			_display_name = _name,
			_lore_text = species.get_species_lore().Join("<br><br>"),
			_mechanics_text = species.get_species_mechanics()
		)
		items += entry
	return ..()
