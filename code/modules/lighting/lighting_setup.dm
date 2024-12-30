
/proc/create_all_lighting_objects()
	for(var/area/A in GLOB.areas)
		if(A.area_lighting != AREA_LIGHTING_DYNAMIC)
			continue

		for(var/turf/T in A)
			if(T.always_lit)
				continue
			new/datum/lighting_object(T)
			CHECK_TICK
		CHECK_TICK
