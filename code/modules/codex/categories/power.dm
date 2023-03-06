GLOBAL_LIST_EMPTY(power_codex_entries)

/datum/codex_category/power
	name = "Power"
	desc = "The station's power network and you"
	guide_name = "the Supermatter Engine"
	guide_html = "PLACEHOLDER"

/datum/codex_category/power/Populate()
	items = GLOB.power_codex_entries
	return ..()
