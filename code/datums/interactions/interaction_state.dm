/datum/interaction_state
	var/secondary = FALSE
	var/harm = FALSE
	var/alternate = FALSE
	var/control = FALSE
	var/blocking = FALSE

/datum/interaction_state/proc/reset()
	control = alternate = harm = secondary = blocking = FALSE

/datum/interaction_state/proc/logging()
	// This is pretty awful
	return "[harm ? "H" : ""][alternate ? "A" : ""][control ? "C" : ""][blocking ? "B" : ""]"

/datum/interaction_state/harm
	harm = TRUE
	blocking = TRUE
