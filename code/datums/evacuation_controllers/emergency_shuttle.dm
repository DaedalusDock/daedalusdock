#define AUTOEVAC_MESSAGE "Automatically dispatching emergency shuttle due to crew death."

/datum/evacuation_controller/shuttle
	var/obj/docking_port/mobile/emergency/emergency
	var/obj/docking_port/mobile/emergency/backup
	var/emergency_call_time
	var/emergency_escape_time
	var/emergency_dock_time

/datum/evacuation_controller/shuttle/New()
	var/obj/effect/landmark/backup_mark = locate(/obj/effect/landmark/backup_escape_shuttle) in world
	if(backup_mark)
		register_backup_shuttle(new /obj/docking_port/mobile/emergency/backup(get_turf(backup_mark)))
		backup = new /obj/docking_port/mobile/emergency/backup(get_turf(backup_mark))
	else
		log_mapping("No /obj/docking_port/mobile/emergency/backup placed on the map!")

	var/obj/effect/landmark/main_mark = locate(/obj/effect/landmark/escape_shuttle) in world
	if(main_mark)
		register_emergency_shuttle(new /obj/docking_port/mobile/emergency(get_turf(main_mark)))
	else
		log_mapping("No /obj/docking_port/mobile/emergency placed on the map!")

/datum/evacuation_controller/shuttle/proc/register_backup_shuttle(obj/docking_port/mobile/emergency/backup/port)
	backup = port
	RegisterSignal(port, COMSIG_PARENT_QDELETING, PROC_REF(OnBackupShuttleDeleted))

/datum/evacuation_controller/shuttle/proc/register_emergency_shuttle(obj/docking_port/mobile/emergency/port)
	emergency = port
	RegisterSignal(port, COMSIG_PARENT_QDELETING, PROC_REF(OnEmergencyShuttleDeleted))

/datum/evacuation_controller/shuttle/proc/OnBackupShuttleDeleted(obj/docking_port/mobile/emergency/backup/port, force)
	if(force)
		backup = null

/datum/evacuation_controller/shuttle/proc/OnEmergencyShuttleDeleted(obj/docking_port/mobile/emergency/port, force)
	if(force)
		emergency = backup

/datum/evacuation_controller/shuttle/can_evac(mob/user)
	var/srd = CONFIG_GET(number/shuttle_refuel_delay)
	if(world.time - SSticker.round_start_time < srd)
		return "The emergency shuttle is refueling. Please wait [DisplayTimeText(srd - (world.time - SSticker.round_start_time))] before attempting to call."

	switch(emergency.mode)
		if(SHUTTLE_RECALL)
			return "The emergency shuttle may not be called while returning to CentCom."
		if(SHUTTLE_CALL)
			return "The emergency shuttle is already on its way."
		if(SHUTTLE_DOCKED)
			return "The emergency shuttle is already here."
		if(SHUTTLE_IGNITING)
			return "The emergency shuttle is firing its engines to leave."
		if(SHUTTLE_ESCAPE)
			return "The emergency shuttle is moving away to a safe distance."
		if(SHUTTLE_STRANDED)
			return "The emergency shuttle has been disabled by CentCom."

	return TRUE

/datum/evacuation_controller/shuttle/can_recall()
	if(!..())
		return FALSE
	if(!emergency || emergency.mode != SHUTTLE_CALL)
		return FALSE
	return FALSE

/datum/evacuation_controller/shuttle/start_evacuation(mob/user, call_reason)
	if(!..())
		return
	if(!emergency)
		WARNING("requestEvac(): There is no emergency shuttle, but the \
			shuttle was called. Using the backup shuttle instead.")
		if(!backup)
			CRASH("requestEvac(): There is no emergency shuttle, \
			or backup shuttle! The game will be unresolvable. This is \
			possibly a mapping error, more likely a bug with the shuttle \
			manipulation system, or badminry. It is possible to manually \
			resolve this problem by loading an emergency shuttle template \
			manually, and then calling register() on the mobile docking port. \
			Good luck.")
		register_emergency_shuttle(backup)

	call_reason = trim(html_encode(call_reason))

	if(length(call_reason) < CALL_SHUTTLE_REASON_LENGTH && seclevel2num(get_security_level()) > SEC_LEVEL_GREEN)
		to_chat(user, span_alert("You must provide a reason."))
		return

	SSevacuation.evac_calls_count++

	var/area/signal_origin = get_area(user)
	var/call_time = emergency_call_time
	var/message = "The emergency shuttle has been called."
	if(seclevel2num(get_security_level()) >= SEC_LEVEL_RED)
		call_time *= 0.5
		message += " Red Alert state confirmed: Dispatching priority shuttle."
	message += " It will arrive in [emergency.timeLeft(600)] minutes.\nNature of emergency:\n\n[html_decode(call_reason)]"

	if(prob(70))
		SSevacuation.last_evac_call_loc = signal_origin
	else
		SSevacuation.last_evac_call_loc = null

	if(SSevacuation.last_evac_call_loc)
		message += "\n\nCall signal traced. Results can be viewed on any communications console."
	if(SSevacuation.no_recall || SSevacuation.admin_no_recall)
		message += "\n\nWarning: Shuttle recall subroutines disabled; Recall not possible."

	emergency.request(null, call_time)
	state = EVACUATION_INITIATED
	RegisterSignal(SSsecurity_level, COMSIG_SECURITY_LEVEL_CHANGED, PROC_REF(sec_level_updated))
	// UnregisterSignal(SSsecurity_level, COMSIG_SECURITY_LEVEL_CHANGED)

	priority_announce(message, FLAVOR_CENTCOM_NAME, sound_type = ANNOUNCER_SHUTTLECALLED)

	var/datum/radio_frequency/frequency = SSpackets.return_frequency(FREQ_STATUS_DISPLAYS)
	var/datum/signal/status_signal = new(src, list("command" = "update")) // Start processing shuttle-mode displays to display the timer
	frequency.post_signal(status_signal)

	log_shuttle("[key_name(user)] has called the emergency shuttle.")
	deadchat_broadcast(" has called the shuttle at [span_name("[signal_origin.name]")].", span_name("[user.real_name]"), user, message_type=DEADCHAT_ANNOUNCEMENT)
	if(call_reason)
		SSblackbox.record_feedback("text", "shuttle_reason", 1, "[call_reason]")
		log_shuttle("Shuttle call reason: [call_reason]")
		SSticker.emergency_reason = call_reason
	message_admins("[ADMIN_LOOKUPFLW(user)] has called the shuttle. (<A HREF='?_src_=holder;[HrefToken()];trigger_centcom_recall=1'>TRIGGER CENTCOM RECALL</A>)")

/datum/evacuation_controller/shuttle/proc/sec_level_updated(datum/source, old_level, new_level)
	var/modifier_old = 1
	var/modifier_new = 1

	switch(old_level)
		if(SEC_LEVEL_GREEN)
			modifier_old = 1
		if(SEC_LEVEL_BLUE)
			modifier_old = 2
		if(SEC_LEVEL_RED, SEC_LEVEL_DELTA)
			modifier_old = 4

	switch(new_level)
		if(SEC_LEVEL_GREEN)
			modifier_new = 1
		if(SEC_LEVEL_BLUE)
			modifier_new = 2
		if(SEC_LEVEL_RED, SEC_LEVEL_DELTA)
			modifier_new = 4

	var/modifier_result = modifier_old / modifier_new
	if(modifier_result != 1)
		emergency.modTimer(modifier_result)

/datum/evacuation_controller/shuttle/cancel_evacuation(mob/user)
	if(!..())
		return FALSE
	emergency.cancel(get_area(user))
	state = EVACUATION_IDLE
	log_shuttle("[key_name(user)] has recalled the shuttle.")
	message_admins("[ADMIN_LOOKUPFLW(user)] has recalled the shuttle.")
	deadchat_broadcast(" has recalled the shuttle from [span_name("[get_area_name(user, TRUE)]")].", span_name("[user.real_name]"), user, message_type=DEADCHAT_ANNOUNCEMENT)
	return TRUE

/datum/evacuation_controller/shuttle/get_antag_panel()
	switch(SSevacuation.controller.state)
		if(EVACUATION_IDLE)
			return "<a href='?_src_=holder;[HrefToken()];start_evac=1'>Start Evacuation</a><br>"
		if(EVACUATION_INITIATED)
			var/timeleft = emergency.timeLeft()
			var/dat = "ETA: <a href='?_src_=holder;[HrefToken()];edit_shuttle_time=1'>[(timeleft / 60) % 60]:[add_leading(num2text(timeleft % 60), 2, "0")]</a><BR>"
			return dat + "<a href='?_src_=holder;[HrefToken()];start_evac=2'>Send Back</a><br>"
		if(EVACUATION_AWAITING, EVACUATION_NO_RETURN)
			var/timeleft = emergency.timeLeft()
			return "ETA: <a href='?_src_=holder;[HrefToken()];edit_shuttle_time=1'>[(timeleft / 60) % 60]:[add_leading(num2text(timeleft % 60), 2, "0")]</a><BR>"
		if(EVACUATION_FINISHED)
			return "Finished<BR>"

/datum/evacuation_controller/shuttle/get_evac_areas()
	return emergency.shuttle_areas

/datum/evacuation_controller/shuttle/get_stat_data()
	var/ETA = emergency.getModeStr()
	if(ETA)
		return list("[ETA] [emergency.getTimerStr()]")
	return list()

/datum/evacuation_controller/shuttle/get_world_status()
	return list(
		"shuttle_mode" = emergency.mode,
		"shuttle_timer" = emergency.timeLeft()
		)

/obj/effect/landmark/escape_shuttle
	name = "emergency shuttle"

/obj/effect/landmark/backup_escape_shuttle
	name = "backup emergency shuttle"

#undef AUTOEVAC_MESSAGE
