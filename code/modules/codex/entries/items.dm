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

/datum/codex_entry/item/reagent_cart
	name = "Reagent Cartridge"
	associated_paths = list(/obj/item/reagent_containers/chem_cartridge)
	controls_text = "Use Pen - Change label."

/datum/codex_entry/item/pipe_dispenser
	name = "Rapid Pipe Dispenser"
	associated_paths = list(/obj/item/pipe_dispenser)
	controls_text = {"
	Right Click on Pipe - Set color and layer.<br>
	Scroll Wheel - Cycle pipe layer.
	"}
