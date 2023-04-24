SUBSYSTEM_DEF(tech)
	name = "Tech"
	flags = SS_NO_FIRE

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
