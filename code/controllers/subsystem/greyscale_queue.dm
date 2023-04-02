SUBSYSTEM_DEF(greyscale_queue)
	name = "Greyscale Queue"
	init_order = INIT_ORDER_GREYSCALE_QUEUE
	wait = 1
	priority = FIRE_PRIORITY_GREYSCALE_QUEUE
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/list/update_queue = list()
	var/list/deferred = list()

/datum/controller/subsystem/greyscale_queue/stat_entry(msg)
	msg += "P:[length(update_queue)]"
	return ..()

/datum/controller/subsystem/greyscale_queue/Initialize(start_timeofday)
	fire(FALSE, TRUE)

	return ..()

/datum/controller/subsystem/greyscale_queue/fire(resumed, initialization)
	var/list/cache_queue_ref = update_queue
	while(length(cache_queue_ref))
		var/turf/thing = cache_queue_ref[length(cache_queue_ref)]
		cache_queue_ref.len--
		if(!QDELETED(thing))
			if(thing.flags_1 & INITIALIZED_1)
				thing.update_greyscale()
				thing.flags_2 &= ~GREYSCALE_QUEUED_2
			else
				deferred += thing
		if(initialization)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return

	if(!length(cache_queue_ref))
		if(length(deferred))
			update_queue = deferred
			deferred = cache_queue_ref
		else
			can_fire = FALSE //We aren't going to be doing any work anyway

