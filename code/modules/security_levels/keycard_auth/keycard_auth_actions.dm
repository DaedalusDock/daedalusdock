/datum/keycard_auth_action
	abstract_type = /datum/keycard_auth_action
	/// Display name of the action
	var/name = "Abstract KAD Action"
	/// FontAwesome Icon for TGUI display
	var/ui_icon = "exclamation-triangle"



	// I don't *PLAN* to do this right now, but it's easy as fuck to support so why not.
	/// Are we added to the actions list roundstart?
	var/available_roundstart = TRUE

/// Called by KAD upon successful 2-person auth,
/// You should probably call parent in this just to make sure it's safe.
/// Return value is discarded.
/datum/keycard_auth_action/proc/trigger()
	if(is_available())
		return TRUE
	return FALSE

/// Is this action available for use (Alert level, Time, Etc)
/datum/keycard_auth_action/proc/is_available()
	return TRUE

/datum/keycard_auth_action/red_alert
	name = "Red Alert"

/datum/keycard_auth_action/red_alert/trigger()
		set_security_level(SEC_LEVEL_RED)

/datum/keycard_auth_action/emergency_maintenance
	name = "Emergency Maintenance Access"
	ui_icon = "wrench"

/datum/keycard_auth_action/emergency_maintenance/trigger()
		make_maint_all_access()
