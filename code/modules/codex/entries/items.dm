/datum/codex_entry/item
	abstract_type = /datum/codex_entry/item
	use_typesof = TRUE
	disambiguator = "item"

/datum/codex_entry/item/id_card
	name = "Identification Card"
	associated_paths = list(/obj/item/card/id)

	controls_text = "Alt Click - Set bank account information."

/datum/codex_entry/item/fire_extinguisher
	name = "Fire Extinguisher"
	associated_paths = list(/obj/item/extinguisher)
	controls_text = "Alt Click - Empty contents."
