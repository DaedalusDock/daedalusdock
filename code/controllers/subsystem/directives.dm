SUBSYSTEM_DEF(directives)
	name = "Directives"
	flags = SS_BACKGROUND | SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME
	wait = 1 SECONDS

	/// world.time for the next time an edict should be pushed.
	COOLDOWN_DECLARE(next_directive_time)

	/// Directive singletons.
	var/list/datum/directive/all_directives = list()

	/// Currently active directives.
	var/list/datum/directive/active_directives = list()
	/// Finished directives, successful or unsuccessful.
	var/list/datum/directive/finished_directives = list()

	/// Directives awaiting selection via directMAN program.
	var/list/datum/directive/selectable_directives

	/// Determines the odds of rolling each category.
	var/list/severity_weights = list(
		DIRECTIVE_SEVERITY_LOW = 5,
		DIRECTIVE_SEVERITY_MED = 3,
		DIRECTIVE_SEVERITY_HIGH = 2,
	)

	/// After enacting a directive, sets next_direct_time to the value associated with the severity.
	var/list/directive_pick_cooldowns = list(
		DIRECTIVE_SEVERITY_LOW = 20 MINUTES,
		DIRECTIVE_SEVERITY_MED = 30 MINUTES,
		DIRECTIVE_SEVERITY_HIGH = 45 MINUTES,
	)

/datum/controller/subsystem/directives/Initialize(start_timeofday)
	for(var/datum/directive/directive_path as anything in subtypesof(/datum/directive))
		if(isabstract(directive_path))
			continue

		all_directives += new directive_path

	SSticker.OnRoundstart(CALLBACK(src, PROC_REF(on_roundstart)))
	next_directive_time = INFINITY
	return ..()

/datum/controller/subsystem/directives/fire(resumed)

	for(var/datum/directive/directive as anything in active_directives)
		directive.process(wait * 0.1)

	if(COOLDOWN_FINISHED(src, next_directive_time))
		choosing_time()
		next_directive_time = INFINITY

/datum/controller/subsystem/directives/proc/get_directives_for_selection()
	return selectable_directives

/datum/controller/subsystem/directives/proc/get_active_directives()
	return active_directives

/// Enact a directive, with all the bells and whistles.
/datum/controller/subsystem/directives/proc/enact_directive(datum/directive/to_enact)
	active_directives[to_enact] = stationtime2text("hh:mm")
	to_enact.start()

	if(to_enact.enact_delay)
		addtimer(CALLBACK(src, PROC_REF(announce_delayed_enaction), to_enact), to_enact.enact_delay)

	COOLDOWN_START(src, next_directive_time, directive_pick_cooldowns[to_enact.severity])

/datum/controller/subsystem/directives/proc/announce_delayed_enaction(datum/directive/enacted)
	if(!(enacted in active_directives))
		return

	priority_announce(
		"The executive order \"[enacted.name]\" is now in effect.",
		"Executive Order Now Effective",
		do_not_modify = TRUE,
	)

/// End an active directive
/datum/controller/subsystem/directives/proc/end_directive(datum/directive/to_end, successful)
	if(!(to_end in active_directives))
		return FALSE

	to_end.end(successful)
	active_directives -= to_end
	finished_directives += to_end
	return TRUE

/// Selects new selectable directives.
/datum/controller/subsystem/directives/proc/choosing_time()

	var/list/directive_pool = all_directives - active_directives - finished_directives
	var/list/severity_sort = list(
		DIRECTIVE_SEVERITY_LOW = list(),
		DIRECTIVE_SEVERITY_MED = list(),
		DIRECTIVE_SEVERITY_HIGH = list(),
	)

	for(var/datum/directive/D as anything in directive_pool)
		severity_sort[D.severity] += D

	var/list/local_severity_weights = severity_weights.Copy()

	var/list/new_choices = list()
	while(length(new_choices) < 3)
		if(!length(local_severity_weights))
			break

		var/sev = pick_weight(local_severity_weights)
		if(!length(severity_sort[sev]))
			local_severity_weights -= sev
			continue

		new_choices += pick_n_take(severity_sort[sev])

	selectable_directives = new_choices

	aas_radio_message("Higher orders received. New directives are available.", list(RADIO_CHANNEL_COMMAND))

/datum/controller/subsystem/directives/proc/on_roundstart()
	SIGNAL_HANDLER
	COOLDOWN_START(src, next_directive_time, 60 SECONDS)
