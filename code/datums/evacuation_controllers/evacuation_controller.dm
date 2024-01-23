/datum/evacuation_controller
	var/state = EVACUATION_IDLE

/datum/evacuation_controller/proc/start_evacuation(no_recall)
	return FALSE

/datum/evacuation_controller/proc/start_automatic_evacuation()
	return

/datum/evacuation_controller/proc/evac_allowed()
	return TRUE

/datum/evacuation_controller/proc/on_evacuation_blocked()
	return

/datum/evacuation_controller/proc/on_evacuation_unblocked()
	return

/datum/evacuation_controller/proc/get_antag_panel()
	return "Something went horribly wrong<BR>"
