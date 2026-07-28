/obj/machinery/communications_dish
	name = "communications dish"
	icon = 'goon/icons/obj/comms_dish.dmi'
	icon_state = "commdish"

	use_power = NO_POWER_USE

	network_flags = NETWORK_FLAGS_STANDARD_CONNECTION
	net_class = NETCLASS_COMMS_DISH

/obj/machinery/communications_dish/Initialize(mapload)
	. = ..()
	SET_TRACKING(TRACKING_KEY_SHUTTLE_CALLER)
	SET_TRACKING(__TYPE__)

/obj/machinery/communications_dish/Destroy()
	UNSET_TRACKING(TRACKING_KEY_SHUTTLE_CALLER)
	UNSET_TRACKING(__TYPE__)
	SSshuttle.autoEvac()
	return ..()

/obj/machinery/communications_dish/receive_signal(datum/signal/signal)
	. = ..()
	if(. == RECEIVE_SIGNAL_FINISHED)
		return

	var/list/payload = signal.data[PKT_PAYLOAD]
	switch(payload[PKT_ARG_CMD])
		if(NET_COMMAND_CALL_SHUTTLE)
			call_shuttle(signal)
			return

		if(NET_COMMAND_RECALL_SHUTTLE)
			var/mob/probable_mob = get_mob_by_ckey(signal.logging_ckey)
			SSshuttle.cancelEvac(probable_mob)
			return

/obj/machinery/communications_dish/proc/call_shuttle(datum/signal/signal)
	var/mob/probable_user = get_mob_by_ckey(signal.logging_ckey)
	var/potential_error = SSshuttle.packetRequestEvac(probable_user, signal.data[PKT_PAYLOAD][PKT_ARG_CALL_REASON])

	var/list/payload = list()
	if(potential_error != TRUE)
		payload["commaster_failure"] = potential_error
	else
		payload["shuttle_called"] = 1

	var/datum/signal/packet = create_signal(signal.data[PKT_HEAD_SOURCE_ADDRESS], payload = payload)
	post_signal(packet)

/// Relay a packet through all communications dishes
/proc/comms_dish_relay_packet(datum/signal/packet)
	var/datum/radio_frequency/frequency = SSpackets.return_frequency(FREQ_STATUS_DISPLAYS)
	for(var/obj/machinery/communications_dish/dish in INSTANCES_OF(/obj/machinery/communications_dish))
		if(dish.is_operational)
			var/datum/signal/packet_copy = packet.Copy()
			packet_copy.author = WEAKREF(dish)
			packet_copy.data[PKT_HEAD_SOURCE_ADDRESS] = dish.net_id
			packet_copy.data[PKT_HEAD_NETCLASS] = dish.net_class
			frequency.post_signal(packet_copy)

