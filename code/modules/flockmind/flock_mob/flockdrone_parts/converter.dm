/datum/flockdrone_part/converter

/datum/flockdrone_part/converter/left_click_on(atom/target)
	if(isliving(target))
		return try_cage(target)

/datum/flockdrone_part/converter/proc/try_cage(mob/living/victim)
	if(isflockmob(victim))
		to_chat(drone, span_warning("ERROR: Unable to imprison substrate construct."))
		return FALSE

	var/datum/action/cooldown/flock/cage_mob/cage_action = locate() in drone.actions
	return cage_action.Trigger(target = victim)
