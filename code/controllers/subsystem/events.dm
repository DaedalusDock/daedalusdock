SUBSYSTEM_DEF(events)
	name = "Events"
	init_order = INIT_ORDER_EVENTS
	runlevels = RUNLEVEL_GAME

	var/list/control = list() //list of all datum/round_event_control. Used for selecting events based on weight and occurrences.
	///List of all existing /datum/round_event
	var/list/running = list()
	var/list/currentrun = list()

	var/scheduled = 0 //The next world.time that a naturally occuring random event can be selected.
	///The minimum time between random events
	var/frequency_lower = 3 MINUTES
	///The maximum time between random events
	var/frequency_upper = 10 MINUTES

	var/wizardmode = FALSE

/datum/controller/subsystem/events/Initialize(time, zlevel)
	for(var/type in typesof(/datum/round_event_control))
		var/datum/round_event_control/E = new type()
		if(!E.typepath)
			continue //don't want this one! leave it for the garbage collector
		control += E //add it to the list of all events (controls)
	RegisterSignal(SSticker, COMSIG_TICKER_ROUND_STARTING, PROC_REF(reschedule))
	return ..()


/datum/controller/subsystem/events/fire(resumed = FALSE)
	if(!resumed)
		checkEvent() //only check these if we aren't resuming a paused fire
		src.currentrun = running.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/datum/round_event/thing = currentrun[currentrun.len]
		currentrun.len--
		if(thing)
			thing.process_event()
		else
			running.Remove(thing)
		if (MC_TICK_CHECK)
			return

//checks if we should select a random event yet, and reschedules if necessary
/datum/controller/subsystem/events/proc/checkEvent()
	if(scheduled <= world.time)
		spawnEvent()
		reschedule()

//decides which world.time we should select another random event at.
/datum/controller/subsystem/events/proc/reschedule()
	SIGNAL_HANDLER
	scheduled = world.time + rand(frequency_lower, max(frequency_lower,frequency_upper))

//selects a random event based on whether it can occur and it's 'weight'(probability)
/datum/controller/subsystem/events/proc/spawnEvent()
	set waitfor = FALSE //for the admin prompt
	if(!CONFIG_GET(flag/allow_random_events))
		return

	var/players_amt = get_active_player_count(alive_check = 1, afk_check = 1, human_check = 1)
	// Only alive, non-AFK human players count towards this.

	var/sum_of_weights = 0
	for(var/datum/round_event_control/E as anything in control)
		if(!E.canSpawnEvent(players_amt))
			continue
		if(E.weight < 0) //for round-start events etc.
			var/res = TriggerEvent(E)
			if(res == EVENT_INTERRUPTED)
				continue //like it never happened
			if(res == EVENT_CANT_RUN)
				return
		sum_of_weights += E.weight

	sum_of_weights = rand(0,sum_of_weights) //reusing this variable. It now represents the 'weight' we want to select

	for(var/datum/round_event_control/E in control)
		if(!E.canSpawnEvent(players_amt))
			continue
		sum_of_weights -= E.weight

		if(sum_of_weights <= 0) //we've hit our goal
			if(TriggerEvent(E))
				return

/datum/controller/subsystem/events/proc/TriggerEvent(datum/round_event_control/E)
	. = E.preRunEvent()
	if(. == EVENT_CANT_RUN)//we couldn't run this event for some reason, set its max_occurrences to 0
		E.max_occurrences = 0
	else if(. == EVENT_READY)
		E.runEvent(random = TRUE)

//allows a client to trigger an event
//aka Badmin Central
// > Not in modules/admin
// REEEEEEEEE
// Why the heck is this here! Took me so damn long to find!
/client/proc/forceEvent()
	set name = "Trigger Event"
	set category = "Admin.Events"

	if(!holder ||!check_rights(R_FUN))
		return

	holder.forceEvent()

/datum/admins/proc/forceEvent()
	var/dat = ""
	var/normal = ""
	var/magic = ""
	for(var/datum/round_event_control/E in SSevents.control)
		dat = "<BR><A href='?src=[REF(src)];[HrefToken()];forceevent=[REF(E)]'>[E]</A>"
		normal += dat

	dat = normal + "<BR>" + magic + "<BR>"

	var/datum/browser/popup = new(usr, "forceevent", "Force Random Event", 300, 750)
	popup.set_content(dat)
	popup.open()

/datum/controller/subsystem/events/proc/toggleWizardmode()
	wizardmode = !wizardmode
	message_admins("Summon Events has been [wizardmode ? "enabled, events will occur every [SSevents.frequency_lower / 600] to [SSevents.frequency_upper / 600] minutes" : "disabled"]!")
	log_game("Summon Events was [wizardmode ? "enabled" : "disabled"]!")


/datum/controller/subsystem/events/proc/resetFrequency()
	frequency_lower = initial(frequency_lower)
	frequency_upper = initial(frequency_upper)
