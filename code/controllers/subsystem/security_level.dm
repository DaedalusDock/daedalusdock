SUBSYSTEM_DEF(security_level)
	name = "Security Level"
	flags = SS_NO_FIRE
	/// Pre-baked package of default security levels to load
	var/datum/security_state/info_package = /datum/security_state/default


/datum/controller/subsystem/security_level/Initialize(start_timeofday)
	/*
	//Commented out because I don't want to support this yet.
		if(SSmapping.config.securitystate) //If overriding the default order of things, load it.
			info_package = SSmapping.config.securitystate
	*/
	. = ..()


/**
 * Sets a new security level as our current level
 *
 * Arguments:
 * * new_level The new security level that will become our current level
 */
/datum/controller/subsystem/security_level/proc/set_level(new_level)
	SSsecurity_level.current_level = new_level
	SEND_SIGNAL(src, COMSIG_SECURITY_LEVEL_CHANGED, new_level)
	SSnightshift.check_nightshift()
	SSblackbox.record_feedback("tally", "security_level_changes", 1, get_security_level())
