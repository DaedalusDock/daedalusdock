GLOBAL_LIST_EMPTY(machine_codex_entries)

/datum/codex_category/machines
	name = "Machinery"
	desc = "Common workplace devices."

/datum/codex_category/machines/Populate()
	items = GLOB.machine_codex_entries
	return ..()

