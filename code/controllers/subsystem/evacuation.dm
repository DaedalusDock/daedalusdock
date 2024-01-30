SUBSYSTEM_DEF(evacuation)
	name = "Evacuation"
	wait = 1 SECONDS
	init_order = INIT_ORDER_EVACUATION
	flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME
	/// Controller that handles the evacuation of the station
	var/datum/evacuation_controller/controller
	/// Things blocking evacuation
	var/list/hostile_environments = list()
	/// Where was the emergency shuttle last called from?
	var/area/last_evac_call_loc
	/// How many times was the escape shuttle called?
	var/evac_calls_count = 0
	/// Do we prevent the recall of evacuation
	var/no_recall = FALSE
	/// Did admins force-prevent the recall of evacuation
	var/admin_no_recall = FALSE

/datum/controller/subsystem/evacuation/fire(resumed)
	if(!SSticker.HasRoundStarted() || length(hostile_environments) || controller.evac_allowed())
		return

	var/threshold = CONFIG_GET(number/evacuation_autocall_threshold)
	if(!threshold)
		return

	var/alive = 0
	for(var/mob/M as anything in GLOB.player_list)
		if(M.stat != DEAD)
			++alive

	var/total = length(GLOB.joined_player_list)
	if(total <= 0)
		return //no players no autoevac

	if(alive / total <= threshold)
		var/msg = "Automatically starting evacuation sequence due to crew death."
		message_admins(msg)
		log_shuttle("[msg] Alive: [alive], Roundstart: [total], Threshold: [threshold]")
		no_recall = TRUE
		controller.start_evacuation()

/datum/controller/subsystem/evacuation/proc/auto_end()
	controller.start_automatic_evacuation()

/datum/controller/subsystem/evacuation/proc/add_hostile_environment(datum/bad)
	hostile_environments[bad] = TRUE
	check_hostile_environment()

/datum/controller/subsystem/evacuation/proc/remove_hostile_environment(datum/bad)
	hostile_environments -= bad
	check_hostile_environment()

/datum/controller/subsystem/evacuation/proc/check_hostile_environment()
	if(controller.state >= EVACUATION_NO_RETURN)
		return // We can't do anything about evacuation now anyway
	for(var/datum/d in hostile_environments)
		//This is hack and should be removed. I didn't touch it because it might break too much stuff
		if(!istype(d) || QDELETED(d))
			hostile_environments -= d

	if(length(hostile_environments))
		controller.on_evacuation_blocked()
	else
		controller.on_evacuation_unblocked()
