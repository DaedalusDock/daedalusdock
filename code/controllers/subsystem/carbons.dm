SUBSYSTEM_DEF(carbons)
	name = "Carbons"
	priority = FIRE_PRIORITY_CARBONS
	flags = SS_KEEP_TIMING | SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 2 SECONDS

	var/list/processing = list()
	var/list/currentrun = list()

/datum/controller/subsystem/carbons/stat_entry(msg)
	msg = "P:[length(processing)]"
	return ..()

/datum/controller/subsystem/carbons/fire(resumed = FALSE)
	if (!resumed)
		src.currentrun = processing.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	var/times_fired = src.times_fired
	var/delta_time = wait / (1 SECONDS) // TODO: Make this actually responsive to stuff like pausing and resuming
	while(length(currentrun))
		var/mob/living/carbon/C = currentrun[length(currentrun)]
		currentrun.len--
		if(QDELETED(C))
			stack_trace("Qdeleted mob [C.type] {\ref[C]} in currentrun list.")
			continue
		C.Life(delta_time, times_fired)

		if (MC_TICK_CHECK)
			return
