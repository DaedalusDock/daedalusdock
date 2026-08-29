/obj/machinery/door/airlock/alarmlock
	name = "glass alarm airlock"
	icon = 'icons/obj/doors/airlocks/station2/airlock.dmi'
	glass_fill_overlays = 'icons/obj/doors/airlocks/station2/glass_overlays.dmi'
	overlays_file = 'icons/obj/doors/airlocks/station2/overlays.dmi'
	opacity = FALSE
	assemblytype = /obj/structure/door_assembly/door_assembly_public
	glass = TRUE

	network_flags = NETWORK_FLAG_GEN_ID

	var/datum/radio_frequency/air_connection
	var/air_frequency = FREQ_ATMOS_ALARMS

	autoclose = FALSE

/obj/machinery/door/airlock/alarmlock/Destroy()
	SSpackets.remove_object(src,air_frequency)
	return ..()

/obj/machinery/door/airlock/alarmlock/Initialize(mapload)
	. = ..()
	SSpackets.remove_object(src, air_frequency)
	air_connection = SSpackets.add_object(src, air_frequency, RADIO_TO_AIRALARM)
	INVOKE_ASYNC(src, PROC_REF(open))

/obj/machinery/door/airlock/alarmlock/receive_signal(datum/signal/signal)
	..()
	if(!is_operational)
		return

	var/list/payload = signal.data[PKT_PAYLOAD]
	var/alarm_area = payload["zone"]
	var/alert = payload["alert"]

	if(alarm_area == get_area_name(src))
		switch(alert)
			if("severe")
				autoclose = TRUE
				close()
			if("minor", "clear")
				autoclose = FALSE
				open()
