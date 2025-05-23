SUBSYSTEM_DEF(directives)
	name = "Directives"
	flags = SS_BACKGROUND | SS_KEEP_TIMING

	wait = 1 SECONDS

	/// world.timeofday for the next time an edict should be pushed.
	var/next_directive_time

	/// Directive singletons.
	var/list/datum/directive/all_directives = list()

	/// Currently active directives.
	var/list/datum/directive/active_directives = list()
	/// Directives awaiting selection via directMAN program.
	var/list/datum/directive/selectable_directives

/datum/controller/subsystem/directives/Initialize(start_timeofday)
	for(var/datum/directive/directive_path as anything in subtypesof(/datum/directive))
		if(isabstract(directive_path))
			continue

		all_directives += new directive_path

	selectable_directives = all_directives.Copy()
	return ..()

/datum/controller/subsystem/directives/fire(resumed)
	for(var/datum/directive/directive as anything in active_directives)
		directive.process(wait * 0.1)

/// Enact a directive, with all the bells and whistles.
/datum/controller/subsystem/directives/proc/enact_directive(datum/directive/to_enact, clear_selection = TRUE)
	active_directives[to_enact] = stationtime2text("hh:mm")

	to_enact.announce_start()

	if(to_enact.enact_delay)
		addtimer(CALLBACK(src, PROC_REF(announce_delayed_enaction), to_enact), to_enact.enact_delay)

/datum/controller/subsystem/directives/proc/announce_delayed_enaction(datum/directive/enacted)
	if(!(enacted in active_directives))
		return

	priority_announce(
		"The executive order \"[enacted.name]\" is now in effect.",
		"Executive Order Now Effective",
		do_not_modify = TRUE,
	)
