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
	lore_text = "The Supermatter is a highly unstable fragment of exotic matter, \
		which reacts with the atmosphere around it relative to it's own internal charge. As part of it's use as a power generator, \
		the supermatter will release energy in the form of heat and radiation, along with shedding 'waste' gasses from it's mass. \
		These byproducts must be managed, and the heat captured and converted for use as electrical power."

