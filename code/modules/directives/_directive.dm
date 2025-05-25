/datum/directive
	abstract_type = /datum/directive
	var/name = "Executive Order"
	var/desc = "Cock and ball torture (no erp)"

	var/severity = DIRECTIVE_SEVERITY_LOW

	/// The grace period before security is allowed to enforce it.
	var/enact_delay = 0 MINUTES

	/// How many marks management gets for choosing this flavor of CBT.
	var/reward = 100

	/// A list of directive types this directive cannot coexist with.
	var/list/mutual_blacklist

/// Determines if the directive is elligible to roll at this time.
/datum/directive/proc/can_roll()
	SHOULD_CALL_PARENT(TRUE)
	for(var/path in mutual_blacklist)
		if(locate(path) in SSdirectives.active_directives)
			return FALSE
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
	announce_start()

	var/datum/bank_account/fed_account = SSeconomy.bank_accounts_by_id[ACCOUNT_GOV]
	fed_account.adjust_money(reward)
	aas_radio_message("[reward] marks have been deposited into the Federation account.", list(RADIO_CHANNEL_COMMAND))

/// Idk if this will ever be used but you never know!
/datum/directive/proc/end(successful)
	SHOULD_CALL_PARENT(TRUE)

/// Just so it doesnt call datum process and throw a runtime.
/datum/directive/process()
	SHOULD_CALL_PARENT(TRUE)
	. = 0 && ..()

	switch(check_completion())
		if(DIRECTIVE_SUCCESS)
			SSdirectives.end_directive(src, TRUE)
		if(DIRECTIVE_FAILURE)
			SSdirectives.end_directive(src, FALSE)

/datum/directive/proc/check_completion()
	return DIRECTIVE_CONTINUE
