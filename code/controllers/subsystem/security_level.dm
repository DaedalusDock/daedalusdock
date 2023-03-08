SUBSYSTEM_DEF(security_level)
	name = "Security Level"
	flags = SS_NO_FIRE
	/// Currently set security level
	var/datum/security_level/current_level
	var/list/datum/security_level/possible_levels

/datum/controller/subsystem/security_level/Initialize(start_timeofday)
	. = ..()
	possible_levels = list()
	var/list/level_types = subtypesof(/datum/security_level)
	for(var/datum/security_level/newlev as anything in level_types)
		if(newlev == initial(newlev.abstract_type))
			continue //Skip abstracts.
		//TODO: Add a way to select which levels are available?
		newlev = new newlev //This is correct as it currently contains as typepath.
		possible_levels[newlev.id] = newlev

/**
 * Sets a new security level as our current level
 *
 * Arguments:
 * * new_level The new security level datum that will become our current level
 */
/datum/controller/subsystem/security_level/proc/set_level(new_level)
	SSsecurity_level.current_level = new_level
	SEND_SIGNAL(src, COMSIG_SECURITY_LEVEL_CHANGED, new_level)
	SSnightshift.check_nightshift()
	SSblackbox.record_feedback("tally", "security_level_changes", 1, get_security_level())

//This should probably be a macro, but...
/// Get the value of a feature.
/datum/controller/subsystem/security_level/proc/check_active_feature(featureflag)
	return current_level.vars[featureflag]
