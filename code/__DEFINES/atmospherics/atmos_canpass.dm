///Enables profiling ATMOS_CANPASS_TURF. Profile data is stored in SSzas.
//#define PROFILE_ZAS_CANPASS

#ifdef PROFILE_ZAS_CANPASS
#warn zas_canpass profiling enabled
#endif

#if defined(MULTIZAS) && !defined(PROFILE_ZAS_CANPASS) //This will be used for multiZAS
///Can air move from B to A?
#define ATMOS_CANPASS_TURF(ret,A,B) \
	if ((A.blocks_air & AIR_BLOCKED) || (B.blocks_air & AIR_BLOCKED)) { \
		ret = AIR_BLOCKED|ZONE_BLOCKED; \
	} \
	else if (B.z != A.z) { \
		if(GetAbove(B) == A) { \
			ret = ((A.z_flags & Z_ATMOS_IN_DOWN) && (B.z_flags & Z_ATMOS_OUT_UP)) ? ZONE_BLOCKED : AIR_BLOCKED|ZONE_BLOCKED; \
		} \
		else if(GetBelow(B) == A){ \
			ret = ((A.z_flags & Z_ATMOS_IN_UP) && (B.z_flags & Z_ATMOS_OUT_DOWN)) ? ZONE_BLOCKED : AIR_BLOCKED|ZONE_BLOCKED; \
		} \
		else { \
			ret = AIR_BLOCKED|ZONE_BLOCKED; \
		} \
	} \
	else if ((A.blocks_air & ZONE_BLOCKED) || (B.blocks_air & ZONE_BLOCKED)) { \
		ret = ZONE_BLOCKED; \
	} \
	else if (length(A.contents)) { \
		ret = 0;\
		for (var/atom/movable/AM as anything in A) { \
			switch (AM.can_atmos_pass) { \
				if (CANPASS_ALWAYS) { \
					continue; \
				} \
				if (CANPASS_DENSITY) { \
					if (AM.density) { \
						ret |= AIR_BLOCKED|ZONE_BLOCKED; \
					} \
				} \
				if (CANPASS_PROC) { \
					ret |= AM.zas_canpass(B); \
				} \
				if (CANPASS_NEVER) { \
					ret = AIR_BLOCKED|ZONE_BLOCKED; \
				} \
			} \
			if (ret & AIR_BLOCKED) { \
				break;\
			}\
		}\
	}
#endif

#if !defined(MULTIZAS) && !defined(PROFILE_ZAS_CANPASS) //This will be used when multiZAS is disabled.
///Can air move from B to A?
#define ATMOS_CANPASS_TURF(ret,A,B) \
	if ((A.blocks_air & AIR_BLOCKED) || (B.blocks_air & AIR_BLOCKED)) { \
		ret = AIR_BLOCKED|ZONE_BLOCKED; \
	} \
	else if ((A.blocks_air & ZONE_BLOCKED || B.blocks_air & ZONE_BLOCKED)) { \
		ret = ZONE_BLOCKED; \
	} \
	else if (length(A.contents)) { \
		ret = 0;\
		for (var/atom/movable/AM as anything in A) { \
			switch (AM.can_atmos_pass) { \
				if (CANPASS_ALWAYS) { \
					continue; \
				} \
				if (CANPASS_DENSITY) { \
					if (AM.density) { \
						ret |= AIR_BLOCKED|ZONE_BLOCKED; \
					} \
				} \
				if (CANPASS_PROC) { \
					ret |= AM.zas_canpass(B); \
				} \
				if (CANPASS_NEVER) { \
					ret = AIR_BLOCKED|ZONE_BLOCKED; \
				} \
			} \
			if (ret & AIR_BLOCKED) { \
				break;\
			}\
		}\
	}
#endif

//////////////////////////////PROFILING//////////////////////////////
#ifdef PROFILE_ZAS_CANPASS
#define ATMOS_CANPASS_TURF(ret,A,B) ret = atmos_canpass_turf(A, B)
#define LOG_ZAS_CANPASS(step, time) \
	SSzas.canpass_step_usage[step]++; \
	SSzas.canpass_time_spent[step] += TICK_USAGE_TO_MS(time); \
	SSzas.canpass_time_average[step] = SSzas.canpass_time_spent[step] / SSzas.canpass_step_usage[step];
#endif

#if defined(MULTIZAS) && defined(PROFILE_ZAS_CANPASS) //This will be used for multiZAS
///Can air move from B to A?
/proc/atmos_canpass_turf(turf/A, turf/B)
	var/total_cost = TICK_USAGE
	var/clock

	if (A.blocks_air & AIR_BLOCKED || B.blocks_air & AIR_BLOCKED)
		LOG_ZAS_CANPASS("total", total_cost)
		return AIR_BLOCKED|ZONE_BLOCKED

	else if (B.z != A.z)
		clock = TICK_USAGE
		var/canpass_dir = get_dir_multiz_fast(B, A)
		if(canpass_dir)
			if (canpass_dir & UP)
				. = ((A.z_flags & Z_ATMOS_IN_DOWN) && (B.z_flags & Z_ATMOS_OUT_UP)) ? ZONE_BLOCKED : AIR_BLOCKED|ZONE_BLOCKED
			else
				. =  ((A.z_flags & Z_ATMOS_IN_UP) && (B.z_flags & Z_ATMOS_OUT_DOWN)) ? ZONE_BLOCKED : AIR_BLOCKED|ZONE_BLOCKED
		else
			. =  AIR_BLOCKED|ZONE_BLOCKED
		LOG_ZAS_CANPASS("multi-z", clock)
		LOG_ZAS_CANPASS("total", total_cost)
		return

	else if (A.blocks_air & ZONE_BLOCKED || B.blocks_air & ZONE_BLOCKED)
		LOG_ZAS_CANPASS("total", total_cost)
		return (A.z == B.z) ? ZONE_BLOCKED : AIR_BLOCKED|ZONE_BLOCKED

	else if (length(A.contents))
		. = 0
		clock = TICK_USAGE
		for (var/atom/movable/AM as anything in A)
			switch (AM.can_atmos_pass)
				if (CANPASS_ALWAYS)
					continue
				if (CANPASS_DENSITY)
					if (AM.density)
						. |= AIR_BLOCKED|ZONE_BLOCKED
				if (CANPASS_PROC)
					. |= AM.zas_canpass(B)
				if (CANPASS_NEVER)
					. = AIR_BLOCKED|ZONE_BLOCKED
			if (. & AIR_BLOCKED)
				LOG_ZAS_CANPASS("contents", clock)
				LOG_ZAS_CANPASS("total", total_cost)
				return .

		LOG_ZAS_CANPASS("contents", clock)
		LOG_ZAS_CANPASS("total", total_cost)
#endif


#if !defined(MULTIZAS) && defined(PROFILE_ZAS_CANPASS) //This will be used when multiZAS is disabled.
///Can air move from B to A?
#error Non-multiZAS canpass profiling doesn't exist!
#endif
