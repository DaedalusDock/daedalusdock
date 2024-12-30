GLOBAL_LIST_EMPTY(mechcomp_codex_entries)
/datum/codex_category/mechcomp
	name = "MechComp"
	desc = "Mechanical Components and You."

/datum/codex_category/mechcomp/Populate()
	items = GLOB.mechcomp_codex_entries
	return ..()
