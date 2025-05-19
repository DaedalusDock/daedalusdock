/datum/c4_file/fab_design_bundle
	name = FABRICATOR_FILE_NAME
	extension = "FDB"

	size = 16

	var/list/datum/design/included_designs = null

/datum/c4_file/fab_design_bundle/New(list/datum/design/designs_to_include)
	..()
	if(!designs_to_include)
		designs_to_include = list()
	included_designs = designs_to_include

/datum/c4_file/fab_design_bundle/copy()
	var/datum/c4_file/fab_design_bundle/clone = ..()
	clone.included_designs = included_designs.Copy()
	return clone
