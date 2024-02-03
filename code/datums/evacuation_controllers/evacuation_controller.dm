/datum/evacuation_controller
	/// Name of the evacuation controller
	var/name = "Evacuation Controller"
	/// The current state of the evacuation
	var/state = EVACUATION_STATE_IDLE
	/// How many times was evacuation triggered
	var/evac_calls_count = 0
	/// Where was the last evacuation call
	var/area/last_evac_call_loc
	/// Did admins block the recall of evacuation
	var/cancel_disabled = FALSE
	/// Did admins block the evacuation
	var/evacuation_disabled = FALSE

/datum/evacuation_controller/proc/get_state()
	switch(state)
		if(EVACUATION_STATE_IDLE)
			return "Idle"
		if(EVACUATION_STATE_INITIATED)
			return "Initiadited"
		if(EVACUATION_STATE_AWAITING)
			return "Awaiting crew"
		if(EVACUATION_STATE_NORETURN)
			return "Past point of no return"
		if(EVACUATION_STATE_FINISHED)
			return "Finished"

/// Whether we can trigger evacuation sequence at the moment.
/// Returns either TRUE or a string with the reason why it's not possible
/datum/evacuation_controller/proc/can_evac(mob/user)
	if(evacuation_disabled)
		return "Evacuation is disabled"
	if(state >= EVACUATION_STATE_IDLE)
		return "Evacuation is already in progress"
	return TRUE

/// Triggers the evacuation sequence, if possible
/datum/evacuation_controller/proc/trigger_evacuation(mob/user, call_reason, admin)
	var/can_evac_or_fail_reason = can_evac(user)
	if(can_evac_or_fail_reason != TRUE)
		to_chat(user, span_alert("[can_evac_or_fail_reason]"))
		return FALSE
	start_evacuation(user, admin)
	return TRUE

/// Starts the evacuation sequence. Should not be called directly, use trigger_evacuation instead
/datum/evacuation_controller/proc/start_evacuation(mob/user, admin)
	CRASH("start_evacuation not implemented. Type: [type]")

/// Starts the automatic evacuation sequence
/// Called when round is going for too long, when most of the crew is dead, etc.
/datum/evacuation_controller/proc/start_automatic_evacuation(reason)
	CRASH("start_automatic_evacuation not implemented. Type: [type]")

/// Whether we can cancel the evacuation sequence at the moment
/datum/evacuation_controller/proc/can_cancel(mob/user)
	if(SSevacuation.cancel_blocked || cancel_disabled)
		return FALSE
	if(state == EVACUATION_STATE_IDLE || state >= EVACUATION_STATE_NORETURN)
		return FALSE
	return TRUE

/// Cancels the evacuation sequence, if possible
/datum/evacuation_controller/proc/trigger_cancel_evacuation(mob/user)
	if(!can_cancel(user))
		return FALSE
	cancel_evacuation(user)
	return TRUE

/// Cancels the evacuation sequence. Should not be called directly, use trigger_cancel_evacuation instead
/datum/evacuation_controller/proc/cancel_evacuation(mob/user)
	CRASH("trigger_cancel_evacuation not implemented. Type: [type]")

/// Returns a list of shuttles that can be replaced with a custom shuttle
/datum/evacuation_controller/proc/get_customizable_shuttles()
	return list()

/// Returns assoc list of evac areas = TRUE. E.g. escape pods, shuttles, etc. Doesn't include CentCom
/datum/evacuation_controller/proc/get_endgame_areas()
	return list()

/// Called when the evacuation is blocked for some reason
/datum/evacuation_controller/proc/evacuation_blocked()
	return

/// Called when the evacuation is unblocked
/datum/evacuation_controller/proc/evacuation_unblocked()
	return

/// Called when admins force-disable evacuation
/datum/evacuation_controller/proc/disable_evacuation()
	if(evacuation_disabled)
		return FALSE
	evacuation_disabled = TRUE
	return TRUE

/// Called when admins re-enable evacuation
/datum/evacuation_controller/proc/enable_evacuation()
	if(!evacuation_disabled)
		return FALSE
	evacuation_disabled = FALSE
	return TRUE

/// Called when admins force-disable evacuation cancellation
/datum/evacuation_controller/proc/block_cancel()
	if(cancel_disabled)
		return FALSE
	cancel_disabled = TRUE
	return TRUE

/// Called when admins allow cancellation of evacuation
/datum/evacuation_controller/proc/unblock_cancel()
	if(!cancel_disabled)
		return FALSE
	cancel_disabled = FALSE
	return TRUE

/// Called when you need to delay the evacuation for some reason.
/datum/evacuation_controller/proc/delay_evacuation()
	return

/// Called when admin cancels the evacuation through CentCom for RP reasons
/datum/evacuation_controller/proc/centcom_recall(message)
	return

/// Returns a list of strings to display in the evacuation status panel
/datum/evacuation_controller/proc/get_stat_data()
	return list()

/// Returns assoc list of world status
/datum/evacuation_controller/proc/get_world_topic_status()
	return list()

/// Returns a string with the current state of the evacuation for the Discord message
/datum/evacuation_controller/proc/get_discord_status()
	return ""

/datum/evacuation_controller/proc/emergency_status_display_process(obj/machinery/status_display/evac/display)
	return

/// Returns a list of strigns to display when examining the status display during evacuation
/datum/evacuation_controller/proc/status_display_examine(mob/user, obj/machinery/status_display/evac/display)
	return list()
