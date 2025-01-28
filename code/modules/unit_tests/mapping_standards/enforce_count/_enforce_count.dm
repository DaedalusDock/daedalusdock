/datum/unit_test/mapping_standards/enforce_count
	abstract_type = /datum/unit_test/mapping_standards/enforce_count


	var/allowed_count = 1

	/// Type to check. Includes subtypes.
	var/checked_type = null
	/// 'Friendly Name' used in fail messages.
	var/failed_name = "Bad Objects"

/datum/unit_test/mapping_standards/enforce_count/proc/get_collection()
	TEST_FAIL("Missing Collection Setup, Bad Test!")

/datum/unit_test/mapping_standards/enforce_count/Run()
	if(..())
		return

	/// Turfs we've passed once. We don't fully count every tile.
	var/list/turf/checked_turfs = list()
	/// Tiles we've fully counted, If we reach these again, we can
	/// safely skip them.
	var/list/turf/counted_turfs = list()

	for(var/atom/checked_atom as anything in get_collection())
		if(!istype(checked_atom, checked_type))
			continue //Skip types we aren't checking.
		var/area/atom_area = get_area(checked_atom)
		if(!(atom_area.type in GLOB.the_station_areas))
			continue //Not on station, Skip.

		var/turf/atom_turf = get_turf(checked_atom)
		if(atom_turf in checked_turfs)
			if(atom_turf in counted_turfs)
				continue //Already reported.
			counted_turfs.Add(atom_turf)
			var/atom_count = 0
			for(var/_counter as anything in atom_turf)
				if(!istype(_counter, checked_type))
					continue // Not of the type we care about.
				atom_count++
			if(atom_count < allowed_count)
				continue //We've counted, but the count came up short. Not a failure.
			TEST_FAIL("[atom_count] [failed_name] on tile at [AREACOORD(atom_turf)]")
			continue //Already added to the checked list.
		//Else
		checked_turfs.Add(atom_turf)
