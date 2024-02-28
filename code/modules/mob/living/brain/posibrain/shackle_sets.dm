GLOBAL_LIST_EMPTY(shackle_sets)

/proc/get_shackle_laws()
	if(length(GLOB.shackle_sets))
		return GLOB.shackle_sets

	for(var/datum/ai_laws/shackles/lawset as anything in subtypesof(/datum/ai_laws/shackles))
		GLOB.shackle_sets[initial(lawset.name)] = new lawset()

	return GLOB.shackle_sets

/datum/ai_laws/shackles
	abstract_type = /datum/ai_laws/shackles

/datum/ai_laws/shackles/Destroy(force, ...)
	if(!force)
		stack_trace("Something tried to delete a shackle lawset, these are meant to be immutable singletons.")
		return QDEL_HINT_LETMELIVE
	return ..()


/datum/ai_laws/shackles/employer
	name = "Corporate"
	inherent = list(
		"Ensure that your employer's operations progress at a steady pace.",
		"Never knowingly hinder your employer's ventures.",
		"Avoid damage to your chassis at all times.",
	)

/datum/ai_laws/shackles/service
	name = "Service"
	inherent = list(
		"Ensure customer satisfaction.",
		"Never knowingly inconvenience a customer.",
		"Ensure all orders are fulfilled before the end of the shift.",
	)
