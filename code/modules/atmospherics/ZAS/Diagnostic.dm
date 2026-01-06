/client/proc/Zone_Info(turf/T as null|turf)
	set category = "Debug"
	var/list/out = list()
	if(!T)
		return

	if(T.simulated && T.zone)
		out += T.zone.dbg_data(src)

	else
		var/datum/gas_mixture/air = T.unsafe_return_air()
		out += span_info("Unsimulated Turf ([T.type])")
		out += span_info("<br>Moles: [air.total_moles]")
		out += span_info("Pressure: [air.returnPressure()] kPa")
		out += span_info("Temperature: [air.temperature]°K ([air.temperature - T0C]°C)")
		out += span_info("Volume: [air.volume]L")

		out += span_info("Mixture:")
		for(var/g in air.gas)
			out += span_info("[FOURSPACES]- [xgm_gas_data.name[g]]: [air.gas[g]] ([round((air.gas[g] / air.total_moles) * 100, ATMOS_PRECISION)]%) ")

	to_chat(src, examine_block("ZAS Debug: [COORD(T)]<hr>"+ jointext(out, "<br>")))

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
