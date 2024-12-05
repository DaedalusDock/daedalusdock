/datum/codex_entry/item
	abstract_type = /datum/codex_entry/item
	use_typesof = TRUE
	disambiguator = "item"

/datum/codex_entry/item/fire_extinguisher
	name = "Fire Extinguisher"
	associated_paths = list(/obj/item/extinguisher)
	controls_text = "Alt Click - Empty contents."

/datum/codex_entry/item/stack
	name = "Stack"
	associated_paths = list(/obj/item/stack)
	controls_text = "Right Click - Split stack."
