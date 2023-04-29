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
	for(var/datum/design/D as anything in subtypesof(/datum/design))
		D = new D
		designs += D
		designs_by_type[D.type] = D
		designs_by_id[D.id] = D
		designs_by_product += typecacheof(D.build_path)

/// Used to populate stored_designs.
/datum/controller/subsystem/tech/proc/init_design_list(to_init)
	for(var/i in 1 to length(to_init))
		to_init[i] = designs_by_type[to_init[i]]

	return to_init
