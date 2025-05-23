/datum/directive
	var/name = "Executive Order"
	var/desc = "Cock and ball torture (no erp)"

	var/severity = DIRECTIVE_SEVERITY_LOW

	/// The grace period before security is allowed to enforce it.
	var/enact_delay = 0 MINUTES

/// Determines if the directive is elligible to roll at this time.
/datum/directive/proc/can_roll()
	return TRUE

/// Announce the enaction of how fucked they are.
/datum/directive/proc/announce_start()
	var/delay_string = enact_delay ? "Citizens have [ceil(enact_delay / (60 SECONDS))] minute\s before this order takes effect." : "This order is effective immediately."
	priority_announce(
		get_announce_start_text(),
		"Executive Order",
		"An executive order has been issued. Failure to comply will result in punishment up to and including execution. [delay_string]",
		sound_type = ANNOUNCER_ATTENTION,
		send_to_newscaster = TRUE,
		do_not_modify = TRUE,
	)

/// Getter for the text used in announce_start()
/datum/directive/proc/get_announce_start_text()
	return ""

/// Announce the directive has
/datum/directive/proc/announce_end(successful)
	priority_announce(
		get_announce_start_text(),
		"Executive Order",
		"An executive order has been repealed and is no longer in affect.",
		sound_type = ANNOUNCER_ATTENTION,
		send_to_newscaster = TRUE,
		do_not_modify = TRUE,
	)

/// Getter for the text used in announce_end()
/datum/directive/proc/get_announce_end_text(successful)
	return ""

/// Called when a directive is enacted.
/datum/directive/proc/start()
	SHOULD_CALL_PARENT(TRUE)

/// Idk if this will ever be used but you never know!
/datum/directive/proc/end(successful)
	SHOULD_CALL_PARENT(TRUE)

/// Just so it doesnt call datum process and throw a runtime.
/datum/directive/process()
	return
