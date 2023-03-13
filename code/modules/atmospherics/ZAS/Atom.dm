/atom
	var/simulated = TRUE
	var/can_atmos_pass = CANPASS_ALWAYS

///Tells ZAS to mark the tile the atom is in to update.
/atom/proc/zas_update_loc()
	var/turf/T = get_turf(src)
	if(T?.simulated)
		SSzas.mark_for_update(T)
		return TRUE
	return FALSE

/turf/zas_update_loc()
	if(simulated)
		SSzas.mark_for_update(src)
		return TRUE
	return FALSE


//Returns:
// 0 / AIR_ALLOWED - Not blocked. Air and zones can mingle with this turf as they please.
// AIR_BLOCKED - Blocked. Air cannot move into, out of, or over this turf.
// ZONE_BLOCKED - Air can flow in this turf, but zones may not merge over it.
///Checks whether or not ZAS can occupy this atom's turf. Invoked by the ATMOS_CANPASS_TURF macro.
/atom/proc/zas_canpass(turf/other)
	#ifdef ZASDBG
	ASSERT(isturf(other))
	#endif
	if(can_atmos_pass == CANPASS_PROC)
		CRASH("Atmos pass assigned proc when proc doesn't exist.")
	else
		CRASH("FUCK. zas_canpass() invoked when the atom doesn't even use it")

// This is a legacy proc only here for compatibility - you probably should just use ATMOS_CANPASS_TURF directly.
/turf/zas_canpass(turf/other)
	#ifdef ZASDBG
	ASSERT(isturf(other))
	#endif

	. = 0
	ATMOS_CANPASS_TURF(., src, other)
	stack_trace("Turf ZAS canpass invoked.")

