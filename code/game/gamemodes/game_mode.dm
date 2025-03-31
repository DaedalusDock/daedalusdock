

/*
 * GAMEMODES (by Rastaf0)
 *
 * In the new mode system all special roles are fully supported.
 * You can have proper wizards/traitors/changelings/cultists during any mode.
 * Only two things really depends on gamemode:
 * 1. Starting roles, equipment and preparations
 * 2. Conditions of finishing the round.
 *
 */


/datum/game_mode
	abstract_type = /datum/game_mode
	datum_flags = DF_ISPROCESSING

	var/name = "oh god oh fuck what did you do"
	/// This is a WEIGHT not a PROBABILITY
	var/weight = GAMEMODE_WEIGHT_NEVER
	///Is the gamemode votable? !Not implimented!
	var/votable = FALSE

	///Dynamically set to what the problem(s) was/were.
	var/list/setup_error = list()

	///The minimum players this gamemode can roll
	var/min_pop = 1
	///The maximum players this gamemode can roll
	var/max_pop = INFINITY
	///The number of antag players required for this round type to be considered
	var/required_enemies = 1
	///The recommended number of antag players for this round type
	var/recommended_enemies = 0

	/// Even if the mode has no antag datum, force possible_antags to be built
	var/force_pre_setup_check = FALSE

	///A list of minds that are elligible to be given antagonist at roundstart
	var/list/datum/mind/possible_antags = list()
	///ALL antagonists, not just the roundstart ones
	var/list/datum/mind/antagonists = list()
	///A k:v list of mind:time of death.
	var/list/datum/mind/death_timers = list()
	///A list of names of antagonists who are permanantly. This list will be cut down to spend on midrounds.
	var/list/permadead_antag_pool = list()

///Pass in a list of players about to participate in roundstart, returns an error as a string if the round cannot start.
/datum/game_mode/proc/check_for_errors()
	SHOULD_CALL_PARENT(TRUE)
	if(length(SSticker.ready_players) < min_pop) //Population is too high or too low to run
		return "Not enough players, [min_pop] players needed."

	else if(length(SSticker.ready_players) > max_pop)
		return "Too many players, less than [max_pop + 1] players needed."

	return null

///Try to start this gamemode, called by SSticker. Returns FALSE if it fails.
/datum/game_mode/proc/execute_roundstart()
	SHOULD_CALL_PARENT(TRUE)
	if(!pre_setup())
		setup_error += "Failed pre_setup."
		return FALSE

	antagonists = GLOB.pre_setup_antags.Copy()
	GLOB.pre_setup_antags.Cut()
	var/number_of_antags = length(antagonists)
	if(number_of_antags < required_enemies)
		setup_error += "Not enough antagonists selected. Required [required_enemies], got [number_of_antags]."
		return FALSE

	return TRUE

///Populate the possible_antags list of minds, and any child behavior.
/datum/game_mode/proc/pre_setup()
	SHOULD_CALL_PARENT(TRUE)
	return TRUE

/// The absolute last thing called before the round starts. Setup gamemode info/antagonists.
/datum/game_mode/proc/setup_antags()
	SHOULD_CALL_PARENT(TRUE)

	for(var/datum/mind/M as anything in antagonists)
		RegisterSignal(M, COMSIG_MIND_TRANSFERRED, PROC_REF(handle_antagonist_mind_transfer))
		init_mob_signals(M.current)

///Clean up a mess we may have made during set up.
/datum/game_mode/proc/on_failed_execute()
	SHOULD_CALL_PARENT(TRUE)
	for(var/datum/mind/M in antagonists)
		M.special_role = null
		M.restricted_roles = null

	// Just to be sure
	GLOB.pre_setup_antags.Cut()

///Everyone should now be on the station and have their normal gear.  This is the place to give the special roles extra things
/datum/game_mode/proc/post_setup(report) //Gamemodes can override the intercept report. Passing TRUE as the argument will force a report.
	SHOULD_CALL_PARENT(TRUE)

	possible_antags = null // We don't need em anymore, don't let them hard del.

	if(!report)
		report = !CONFIG_GET(flag/no_intercept_report)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(display_roundstart_logout_report)), ROUNDSTART_LOGOUT_REPORT_TIME)

	if(CONFIG_GET(flag/reopen_roundstart_suicide_roles))
		var/delay = CONFIG_GET(number/reopen_roundstart_suicide_roles_delay)
		if(delay)
			delay = (delay SECONDS)
		else
			delay = (4 MINUTES) //default to 4 minutes if the delay isn't defined.
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(reopen_roundstart_suicide_roles)), delay)

	if(SSdbcore.Connect())
		var/list/to_set = list()
		var/arguments = list()
		if(SSticker.mode)
			to_set += "game_mode = :game_mode"
			arguments["game_mode"] = SSticker.mode
		if(GLOB.revdata.originmastercommit)
			to_set += "commit_hash = :commit_hash"
			arguments["commit_hash"] = GLOB.revdata.originmastercommit
		if(to_set.len)
			arguments["round_id"] = GLOB.round_id
			var/datum/db_query/query_round_game_mode = SSdbcore.NewQuery(
				"UPDATE [format_table_name("round")] SET [to_set.Join(", ")] WHERE id = :round_id",
				arguments
			)
			query_round_game_mode.Execute()
			qdel(query_round_game_mode)
	return TRUE


///Handles late-join antag assignments
/datum/game_mode/proc/make_antag_chance(mob/living/carbon/human/character)
	return

/// Returns a list of jobs that MUST roll.
/datum/game_mode/proc/get_required_jobs()
	return null

/datum/game_mode/proc/check_finished() //to be called by SSticker
	SHOULD_CALL_PARENT(TRUE)
	. = FALSE

	if(!SSticker.setup_done)
		return

	if(SSshuttle.emergency && (SSshuttle.emergency.mode == SHUTTLE_ENDGAME))
		return TRUE
	if(GLOB.station_was_nuked)
		return TRUE

/*
 * Generate a list of station goals available to purchase to report to the crew.
 *
 * Returns a formatted string all station goals that are available to the station.
 */
/datum/game_mode/proc/generate_station_goal_report()
	if(!GLOB.station_goals.len)
		return
	. = "<hr><b>Special Orders for [station_name()]:</b><BR>"
	for(var/datum/station_goal/station_goal as anything in GLOB.station_goals)
		station_goal.on_report()
		. += station_goal.get_report()
	return

/*
 * Generate a list of active station traits to report to the crew.
 *
 * Returns a formatted string of all station traits (that are shown) affecting the station.
 */
/datum/game_mode/proc/generate_station_trait_report()
	var/trait_list_string = ""
	for(var/datum/station_trait/station_trait as anything in SSstation.station_traits)
		if(!station_trait.show_in_report)
			continue
		trait_list_string += "[station_trait.get_report()]<BR>"
	if(trait_list_string != "")
		return "<hr><b>Identified shift divergencies:</b><BR>" + trait_list_string
	return

/proc/reopen_roundstart_suicide_roles()
	var/include_command = CONFIG_GET(flag/reopen_roundstart_suicide_roles_command_positions)
	var/list/reopened_jobs = list()

	for(var/mob/living/quitter in GLOB.suicided_mob_list)
		var/datum/job/job = SSjob.GetJob(quitter.job)
		if(!job || !(job.job_flags & JOB_REOPEN_ON_ROUNDSTART_LOSS))
			continue
		if(!include_command && (job.departments_bitflags & DEPARTMENT_BITFLAG_COMPANY_LEADER))
			continue

		job.current_positions = max(job.current_positions - 1, 0)
		reopened_jobs += quitter.job

	if(CONFIG_GET(flag/reopen_roundstart_suicide_roles_command_report))
		if(reopened_jobs.len)
			var/reopened_job_report_positions
			for(var/dead_dudes_job in reopened_jobs)
				reopened_job_report_positions = "[reopened_job_report_positions ? "[reopened_job_report_positions]\n":""][dead_dudes_job]"

			var/suicide_command_report = "<font size = 3><b>Central Command Human Resources Board</b><br>\
								Notice of Personnel Change</font><hr>\
								To personnel management staff aboard [station_name()]:<br><br>\
								Our medical staff have detected a series of anomalies in the vital sensors \
								of some of the staff aboard your station.<br><br>\
								Further investigation into the situation on our end resulted in us discovering \
								a series of rather... unforturnate decisions that were made on the part of said staff.<br><br>\
								As such, we have taken the liberty to automatically reopen employment opportunities for the positions of the crew members \
								who have decided not to partake in our research. We will be forwarding their cases to our employment review board \
								to determine their eligibility for continued service with the company (and of course the \
								continued storage of cloning records within the central medical backup server.)<br><br>\
								<i>The following positions have been reopened on our behalf:<br><br>\
								[reopened_job_report_positions]</i>"

			print_command_report(suicide_command_report, "Central Command Personnel Update")

//////////////////////////
//Reports player logouts//
//////////////////////////
/proc/display_roundstart_logout_report()
	var/list/msg = list("[span_boldnotice("Roundstart logout report")]\n\n")
	for(var/i in GLOB.mob_living_list)
		var/mob/living/L = i
		var/mob/living/carbon/C = L
		if (istype(C) && !C.last_mind)
			continue  // never had a client

		if(L.ckey && !GLOB.directory[L.ckey])
			msg += "<b>[L.name]</b> ([L.key]), the [L.job] (<font color='#ffcc00'><b>Disconnected</b></font>)\n"


		if(L.ckey && L.client)
			var/failed = FALSE
			if(L.client.inactivity >= (ROUNDSTART_LOGOUT_REPORT_TIME / 2)) //Connected, but inactive (alt+tabbed or something)
				msg += "<b>[L.name]</b> ([L.key]), the [L.job] (<font color='#ffcc00'><b>Connected, Inactive</b></font>)\n"
				failed = TRUE //AFK client
			if(!failed && L.stat)
				if(L.suiciding) //Suicider
					msg += "<b>[L.name]</b> ([L.key]), the [L.job] ([span_boldannounce("Suicide")])\n"
					failed = TRUE //Disconnected client
				if(!failed && (L.stat == UNCONSCIOUS))
					msg += "<b>[L.name]</b> ([L.key]), the [L.job] (Dying)\n"
					failed = TRUE //Unconscious
				if(!failed && L.stat == DEAD)
					msg += "<b>[L.name]</b> ([L.key]), the [L.job] (Dead)\n"
					failed = TRUE //Dead

			continue //Happy connected client
		for(var/mob/dead/observer/D in GLOB.dead_mob_list)
			if(D.mind && D.mind.current == L)
				if(L.stat == DEAD)
					if(L.suiciding) //Suicider
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] ([span_boldannounce("Suicide")])\n"
						continue //Disconnected client
					else
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (Dead)\n"
						continue //Dead mob, ghost abandoned
				else
					if(D.can_reenter_corpse)
						continue //Adminghost, or cult/wizard ghost
					else
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] ([span_boldannounce("Ghosted")])\n"
						continue //Ghosted while alive


	for (var/C in GLOB.admins)
		to_chat(C, msg.Join())

/datum/game_mode/proc/generate_station_goals(greenshift)
	var/goal_budget = greenshift ? INFINITY : CONFIG_GET(number/station_goal_budget)
	var/list/possible = subtypesof(/datum/station_goal)
	var/goal_weights = 0
	while(possible.len && goal_weights < goal_budget)
		var/datum/station_goal/picked = pick_n_take(possible)
		goal_weights += initial(picked.weight)
		GLOB.station_goals += new picked

//Set result and news report here
/datum/game_mode/proc/set_round_result()
	SSticker.mode_result = "undefined"
	if(GLOB.station_was_nuked)
		SSticker.news_report = STATION_DESTROYED_NUKE
	if(EMERGENCY_ESCAPED_OR_ENDGAMED)
		SSticker.news_report = STATION_EVACUATED
		if(SSshuttle.emergency.is_hijacked())
			SSticker.news_report = SHUTTLE_HIJACK

/// Mode specific admin panel.
/datum/game_mode/proc/admin_panel()
	return

///Stub for reference that gamemodes do infact, process.
/datum/game_mode/process(delta_time)
	datum_flags &= ~DF_ISPROCESSING

///Setup signals for the antagonist's mind and mob. Make sure it gets cleared in handle_antagonist_mind_transfer.
/datum/game_mode/proc/init_mob_signals(mob/M)
	RegisterSignal(M, COMSIG_LIVING_DEATH, PROC_REF(handle_antagonist_death))
	RegisterSignal(M, COMSIG_LIVING_REVIVE, PROC_REF(handle_antagonist_revival))
	RegisterSignal(M, COMSIG_PARENT_PREQDELETED, PROC_REF(handle_antagonist_qdel))

/datum/game_mode/proc/handle_antagonist_death(mob/source)
	SIGNAL_HANDLER
	death_timers[source.mind] = world.time

/datum/game_mode/proc/handle_antagonist_revival(mob/source)
	SIGNAL_HANDLER
	death_timers -= source.mind

/datum/game_mode/proc/handle_antagonist_mind_transfer(datum/mind/source, mob/old_body)
	SIGNAL_HANDLER
	if(isliving(source.current))
		var/mob/living/L = source.current
		init_mob_signals(L)
		if(L.stat != DEAD)
			death_timers -= source

	if(old_body)
		UnregisterSignal(old_body, list(COMSIG_LIVING_DEATH, COMSIG_LIVING_REVIVE, COMSIG_PARENT_PREQDELETED))

/datum/game_mode/proc/handle_antagonist_qdel(mob/source)
	SIGNAL_HANDLER
	permadead_antag_pool += source.real_name
