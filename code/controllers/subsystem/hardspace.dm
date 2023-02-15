
SUBSYSTEM_DEF(hardspace)
	name = "Hardspace"
	flags = SS_NO_FIRE

	///Cache of all valid salvage step types
	var/list/datum/salvage_step/steptypes

/datum/controller/subsystem/hardspace/Initialize(start_timeofday)
	//Initialize the salvage steps, Surgery hotloads them and I don't know which is "faster" but it just seems like absurd churn.
	steptypes = list()
	for(var/datum/salvage_step/steptype in subtypesof(/datum/salvage_step))
		if(initial(steptype.abstract_type) == steptype)
			continue //Skip abstracts
		steptypes[steptype] = new steptype
	. = ..()
