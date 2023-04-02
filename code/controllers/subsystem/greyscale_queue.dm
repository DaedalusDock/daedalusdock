SUBSYSTEM_DEF(greyscale_queue)
	name = "Greyscale Queue"
	init_order = INIT_ORDER_GREYSCALE_QUEUE
	wait = 1
	priority = FIRE_PRIORITY_SMOOTHING

	var/list/processing = list()
	var/list/current_run = list()

/datum/controller/subsystem/greyscale_queue/fire(resumed)
	if(!resumed)
		current_run = processing.Copy()
	else
		current_run = src.current_run //cache4speed


	while(length(current_run))
		var/turf/thing = current_run[length(current_run)]
		current_run.len--
		if(!QDELETED(thing))
			thing.update_greyscale()
		processing -= thing
		if (MC_TICK_CHECK)
			return
