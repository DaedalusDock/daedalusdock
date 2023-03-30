/turf
	///Atmos sensitive atoms in our contents. lazylist.
	var/list/atmos_sensitive_contents

///This is your process() proc
/atom/proc/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	return

/turf/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	SEND_SIGNAL(src, COMSIG_TURF_EXPOSE, air, exposed_temperature)

/turf/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	if(arrived.flags_2 & ATMOS_SENSITIVE_2)
		LAZYDISTINCTADD(atmos_sensitive_contents, arrived)
		if(TURF_HAS_VALID_ZONE(src))
			if(isnull(zone.atmos_sensitive_contents))
				SSzas.zones_with_sensitive_contents += zone
			LAZYDISTINCTADD(zone.atmos_sensitive_contents, arrived)

/turf/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone.flags_2 & ATMOS_SENSITIVE_2)
		if(!isnull(atmos_sensitive_contents))
			LAZYREMOVE(atmos_sensitive_contents, gone)
		if(TURF_HAS_VALID_ZONE(src))
			LAZYREMOVE(zone.atmos_sensitive_contents, gone)
			if(isnull(zone.atmos_sensitive_contents))
				SSzas.zones_with_sensitive_contents -= zone

///allows this movable to know when it's container's temperature has changed
/atom/proc/become_atmos_sensitive()
	if(flags_2 & ATMOS_SENSITIVE_2)
		return
	flags_2 |= ATMOS_SENSITIVE_2

	var/turf/T = get_turf(src)
	if(T)
		LAZYDISTINCTADD(T.atmos_sensitive_contents, src)
		if(TURF_HAS_VALID_ZONE(T))
			if(isnull(T.zone.atmos_sensitive_contents))
				SSzas.zones_with_sensitive_contents += T.zone
			LAZYDISTINCTADD(T.zone.atmos_sensitive_contents, src)

///removes temperature sensitivity
/atom/proc/lose_atmos_sensitivity()
	if(!(flags_2 & ATMOS_SENSITIVE_2))
		return
	flags_2 &= ~ATMOS_SENSITIVE_2

	var/turf/T = get_turf(src)
	if(T)
		LAZYREMOVE(T.atmos_sensitive_contents, src)
		if(TURF_HAS_VALID_ZONE(T))
			LAZYREMOVE(T.zone.atmos_sensitive_contents, src)
			if(isnull(T.zone.atmos_sensitive_contents))
				SSzas.zones_with_sensitive_contents -= T.zone
