/datum/codex_entry/power
	name = "You shouldn't see this!"
	abstract_type = /datum/codex_entry/power
	disambiguator = "power"

/datum/codex_entry/power/New(_display_name, list/_associated_paths, list/_associated_strings, _lore_text, _mechanics_text, _antag_text, _controls_text)
	. = ..()
	GLOB.power_codex_entries += name

/datum/codex_entry/power/supermatter
	name = "Supermatter Engine"
	associated_paths = list(/obj/machinery/power/supermatter)
	mechanics_text = "A mysterious crystal from deep space which produces a large amount of thermal energy with a small jolt of energy."
