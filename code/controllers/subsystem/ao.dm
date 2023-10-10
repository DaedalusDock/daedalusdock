SUBSYSTEM_DEF(ao)
	name = "Ambient Occlusion"
	init_order = INIT_ORDER_AO
	wait = 0
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	flags = SS_HIBERNATE

	/// Stores image datums of AO for speed
	var/list/image_cache = list()

	var/list/queue = list()
	var/list/cache = list()

/datum/controller/subsystem/ao/stat_entry(msg)
	msg += "P:[length(queue)]"
	return ..()

/datum/controller/subsystem/ao/Initialize(start_timeofday)
	hibernate_checks = list(
		NAMEOF(src, queue),
	)
	fire(FALSE, TRUE)
	return ..()

/datum/controller/subsystem/ao/fire(resumed = 0, no_mc_tick = FALSE)
	var/list/curr = queue
	while (curr.len)
		var/turf/target = curr[curr.len]
		curr.len--

		if (!QDELETED(target))
			if (target.ao_queued == AO_UPDATE_REBUILD)
				var/old_n = target.ao_junction
				var/old_z = target.ao_junction_mimic
				target.calculate_ao_junction()
				if (old_n != target.ao_junction || old_z != target.ao_junction_mimic)
					target.update_ao()
			else
				target.update_ao()
			target.ao_queued = AO_UPDATE_NONE

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/ao/StartLoadingMap()
	suspend()

/datum/controller/subsystem/ao/StopLoadingMap()
	wake()
