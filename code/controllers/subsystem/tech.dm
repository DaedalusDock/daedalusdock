SUBSYSTEM_DEF(tech)
	name = "Tech"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_TECH

	var/list/datum/design/designs
	var/list/datum/design/designs_by_type
	var/list/datum/design/designs_by_id
	var/list/designs_by_product

/datum/controller/subsystem/tech/Initialize(start_timeofday)
	. = ..()
	init_designs()

/datum/controller/subsystem/tech/proc/init_designs()
	designs_by_product = new /list()
	designs = list()
	designs_by_type = list()
	designs_by_id = list()

	for(var/datum/design/D as anything in subtypesof(/datum/design))
		D = new D
		if(D.id == DESIGN_ID_IGNORE)
			continue

		designs += D
		designs_by_type[D.type] = D
		designs_by_id[D.id] = D
		if(D.build_path)
			for(var/path in typesof(D.build_path))
				designs_by_product[path] = D

/// Used to turn a list of design types into instances.
/datum/controller/subsystem/tech/proc/fetch_designs(to_init)
	var/datum/design/D
	for(var/i in 1 to length(to_init))
		D = designs_by_type[to_init[i]]
		if(isnull(D))
			to_init[i] = null
			continue

		to_init[i] = designs_by_type[to_init[i]]

	list_clear_nulls(to_init)
	return to_init

/// Used by machinery for UI act sanitization
/datum/controller/subsystem/tech/proc/sanitize_design_id(obj/machinery/rnd/production/M, id)
	var/datum/design/found_design = designs_by_id[id]
	if(!found_design)
		return FALSE

	if(!(found_design.build_type & M.allowed_buildtypes))
		return FALSE

	if(!(found_design in M.internal_disk.read(DATA_IDX_DESIGNS)))
		return FALSE

	return found_design
