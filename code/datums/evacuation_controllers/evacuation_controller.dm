/datum/evacuation_controller
	var/state = EVACUATION_IDLE

/datum/evacuation_controller/proc/can_evac(mob/user)
	return TRUE

/datum/evacuation_controller/proc/start_evacuation(mob/user, call_reason)
	var/can_evac_or_fail_reason = can_evac(user)
	if(can_evac_or_fail_reason != TRUE)
		to_chat(user, span_alert("[can_evac_or_fail_reason]"))
		return FALSE
	return TRUE

/datum/evacuation_controller/proc/start_automatic_evacuation()
	return

/datum/evacuation_controller/proc/evac_allowed()
	return TRUE

/datum/evacuation_controller/proc/can_recall()
	if(SSevacuation.admin_no_recall || SSevacuation.no_recall)
		return FALSE
	if(state == EVACUATION_IDLE || state >= EVACUATION_NO_RETURN)
		return FALSE
	return TRUE

/datum/evacuation_controller/proc/cancel_evacuation()
	return can_recall()

/datum/evacuation_controller/proc/on_hostile_environment()
	return

/datum/evacuation_controller/proc/on_hostile_environment_cleared()
	return

/datum/evacuation_controller/proc/get_antag_panel()
	return "Something went horribly wrong<BR>"

/datum/evacuation_controller/proc/get_evac_areas()
	return list()

/datum/evacuation_controller/proc/get_stat_data()
	return list()

/datum/evacuation_controller/proc/get_world_status()
	return list()

/datum/evacuation_controller/proc/on_evacuation_disabled()
	return

/datum/evacuation_controller/proc/on_evacuation_enabled()
	return
