/datum/proximity_monitor/advanced/sound_tracking
	edge_is_a_field = TRUE

	var/datum/sound_token/token

/datum/proximity_monitor/advanced/sound_tracking/New(atom/_host, range, _ignore_if_not_on_turf, _token)
	..()
	token = _token
	recalculate_field(TRUE)

/datum/proximity_monitor/advanced/sound_tracking/setup_field_turf(turf/target)
	. = ..()
	for(var/mob/M in target)
		token.AddOrUpdateListener(M)

/datum/proximity_monitor/advanced/sound_tracking/field_turf_crossed(atom/movable/movable, turf/old_location, turf/new_location)
	. = ..()
	if(ismob(movable))
		token.AddOrUpdateListener(movable)

/datum/proximity_monitor/advanced/sound_tracking/field_turf_uncrossed(atom/movable/movable, turf/old_location, turf/new_location)
	. = ..()
	if(ismob(movable) && get_dist(movable, host) > current_range)
		token.UpdateListener(movable)
