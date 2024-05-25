// Events are sent to the program by the computer.
// Always include a parent call when overriding an event.

/// Called when an ID card is added to the computer.
/datum/computer_file/program/proc/event_id_inserted(background, device_type)
	SHOULD_CALL_PARENT(TRUE)
	return
/// Called when an ID card is removed from computer.
/datum/computer_file/program/proc/event_id_removed(background, device_type)
	SHOULD_CALL_PARENT(TRUE)
	return

// Called when the computer fails due to power loss. Override when program wants to specifically react to power loss.
/datum/computer_file/program/proc/event_powerfailure(background)
	SHOULD_CALL_PARENT(TRUE)
	kill_program(forced = TRUE)

// Called when the network connectivity fails. Computer does necessary checks and only calls this when requires_ntnet_feature and similar variables are not met.
/datum/computer_file/program/proc/event_networkfailure(background)
	SHOULD_CALL_PARENT(TRUE)
	kill_program(forced = TRUE)
	if(background)
		computer.visible_message(
			span_alert("\The [computer]'s screen displays a \"Process [filename].[filetype] (PID [rand(100,999)]) terminated - Network Error\" error"),
			vision_distance = COMBAT_MESSAGE_RANGE,
		)
	else
		computer.visible_message(
			span_alert("\The [computer]'s screen briefly freezes and then shows \"NETWORK ERROR - NTNet connection lost. Please retry. If problem persists contact your system administrator.\" error."),
			vision_distance = COMBAT_MESSAGE_RANGE,
		)

/datum/computer_file/program/proc/event_hardware_changed(background)
	SHOULD_CALL_PARENT(TRUE)
	return
