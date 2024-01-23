/datum/evacuation_controller
	var/state = EVACUATION_IDLE

	/// Where was the emergency shuttle last called from?
	var/area/emergency_last_call_loc
	/// How many times was the escape shuttle called?
	var/emergencyCallAmount = 0
	/// Do we prevent the recall of the shuttle?
	var/emergency_no_recall = FALSE
	/// Did admins force-prevent the recall of the shuttle?
	var/admin_emergency_no_recall = FALSE

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
