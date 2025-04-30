/datum/c4_file/fab_design_bundle
	name = "fabrec"
	extension = "FDB"

	size = 16

	var/list/datum/design/included_designs = null

/datum/c4_file/fab_design_bundle/New(list/datum/design/designs_to_include)
	if(!designs_to_include)
		designs_to_include = list()
	included_designs = designs_to_include

/datum/c4_file/fab_design_bundle/to_string()
	return "--PLACEHOLDER--"
