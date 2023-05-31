GLOBAL_LIST_EMPTY(tool_codex_entries)

/datum/codex_category/tools
	name = "Tools"
	desc = "Common tools you will find around the station."

/datum/codex_category/tools/Populate()
	items = GLOB.tool_codex_entries
	return ..()

