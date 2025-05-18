// Proximity monitor applies forced gravity to all turfs in range.
/datum/proximity_monitor/advanced/gravity
	edge_is_a_field = TRUE
	var/gravity_value = 0
	var/list/modified_turfs = list()

/datum/proximity_monitor/advanced/gravity/New(atom/_host, range, _ignore_if_not_on_turf = TRUE, gravity)
	. = ..()
	gravity_value = gravity
	recalculate_field(full_recalc = TRUE)

/datum/proximity_monitor/advanced/gravity/setup_field_turf(turf/target)
	. = ..()
	if(!isnull(modified_turfs[target]))
		return
	if(HAS_TRAIT(target, TRAIT_FORCED_GRAVITY))
		return
	target.AddElement(/datum/element/forced_gravity, gravity_value, can_override = TRUE)
	modified_turfs[target] = gravity_value

/datum/proximity_monitor/advanced/gravity/cleanup_field_turf(turf/target)
	. = ..()
	if(isnull(modified_turfs[target]))
		return
	var/grav_value = modified_turfs[target] || 0
	target.RemoveElement(/datum/element/forced_gravity, grav_value, can_override = TRUE)
	modified_turfs -= target
