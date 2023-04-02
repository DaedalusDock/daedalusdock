SUBSYSTEM_DEF(greyscale_queue)
	name = "Greyscale Queue"
	init_order = INIT_ORDER_GREYSCALE_QUEUE
	wait = 1
	priority = FIRE_PRIORITY_GREYSCALE_QUEUE
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/list/processing = list()
	var/list/currentrun = list()

/datum/controller/subsystem/greyscale_queue/stat_entry(msg)
	. = ..()
	. += "P:[length(processing)]"

/datum/controller/subsystem/greyscale_queue/fire(resumed)
	var/list/current_run
	if(!resumed)
		currentrun = processing.Copy()
	else
		current_run = currentrun

	while(length(current_run))
		var/turf/thing = current_run[length(current_run)]
		current_run.len--
		if(!QDELETED(thing))
			thing.update_greyscale()
			thing.flags_2 &= ~GREYSCALE_QUEUED_2
		processing -= thing
		if (MC_TICK_CHECK)
			return
