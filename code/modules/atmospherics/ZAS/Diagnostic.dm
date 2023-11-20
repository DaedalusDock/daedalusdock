/client/proc/Zone_Info(turf/T as null|turf)
	set category = "Debug"
	if(T)
		if(T.simulated && T.zone)
			T.zone.dbg_data(src)
			if(length(T.zone.contents) < ZONE_MIN_SIZE)
				to_chat(mob, span_notice("This turf's zone is below the minimum size, and will merge over zone blockers."))

		else
			to_chat(mob, span_admin("ZASDBG: No zone here."))
			var/datum/gas_mixture/mix = T.unsafe_return_air()
			to_chat(mob,span_admin( "ZASDBG_MAIN: [mix.returnPressure()] kPa [mix.temperature] k"))
			for(var/g in mix.gas)
				to_chat(mob, span_admin("ZASDBG_GAS: [g]: [mix.gas[g]]\n"))
	else
		if(zone_debug_images)
			for(var/zone in  zone_debug_images)
				images -= zone_debug_images[zone]
			zone_debug_images = null

/client/var/list/zone_debug_images

/client/proc/Test_ZAS_Connection(turf/T as turf)
	set category = "Debug"

	var/direction_list = list(\
	"North" = NORTH,\
	"South" = SOUTH,\
	"East" = EAST,\
	"West" = WEST,\
	#ifdef MULTIZAS
	"Up" = UP,\
	"Down" = DOWN,\
	#endif
	"N/A" = null)
	var/direction = input("What direction do you wish to test?","Set direction") as null|anything in direction_list
	if(!direction)
		return

	if(direction == "N/A")
		to_chat(mob, "Testing self-blocking...")
		var/canpass_self
		ATMOS_CANPASS_TURF(canpass_self, T, T)
		if(!(canpass_self & AIR_BLOCKED))
			to_chat(mob, "The turf can pass air! :D")
		else
			to_chat(mob, "No air passage :x")
		return

	var/turf/other_turf = get_step(T, direction_list[direction])

	var/t_block
	ATMOS_CANPASS_TURF(t_block, T, other_turf)
	var/o_block
	ATMOS_CANPASS_TURF(o_block, other_turf, T)

	to_chat(mob, "Testing connection between ([T.x], [T.y], [T.z]) and ([other_turf.x], [other_turf.y], [other_turf.z])...")
	if(o_block & AIR_BLOCKED)
		if(t_block & AIR_BLOCKED)
			to_chat(mob, "Neither turf can connect. :(")

		else
			to_chat(mob, "The initial turf only can connect. :\\")
	else
		if(t_block & AIR_BLOCKED)
			to_chat(mob, "The other turf can connect, but not the initial turf. :/")

		else
			to_chat(mob, "Both turfs can connect! :)")

	to_chat(mob, "Additionally, \...")

	if(o_block & ZONE_BLOCKED)
		if(t_block & ZONE_BLOCKED)
			to_chat(mob, "neither turf can merge.")
		else
			to_chat(mob, "the other turf cannot merge.")
	else
		if(t_block & ZONE_BLOCKED)
			to_chat(mob, "the initial turf cannot merge.")
		else
			to_chat(mob, "both turfs can merge.")

/*
/client/proc/ZASSettings()
	set category = "Debug"

	zas_settings.SetDefault(mob)
*/
