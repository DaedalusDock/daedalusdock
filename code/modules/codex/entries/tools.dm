/datum/codex_entry/tool
	name = "You shouldn't see this!"
	abstract_type = /datum/codex_entry/tool
	disambiguator = "tool"

/datum/codex_entry/tool/New(_display_name, list/_associated_paths, list/_associated_strings, _lore_text, _mechanics_text, _antag_text, _controls_text)
	. = ..()
	GLOB.tool_codex_entries += name

/datum/codex_entry/tool/crowbar
	name = "Crowbar"
	mechanics_text = "Capable of removing floor tiles or forcing open unpowered doors. Used for construction."
