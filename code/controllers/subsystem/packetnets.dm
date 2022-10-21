SUBSYSTEM_DEF(packets)
	name = "Packets"
	wait = 0.5 SECONDS
	priority = FIRE_PRIORITY_PACKETS
	flags = SS_NO_INIT|SS_BACKGROUND|SS_POST_FIRE_TIMING

	var/list/saymodes = list()
	var/list/datum/radio_frequency/frequencies = list()

	///All the physical networks to process
	var/list/datum/powernet/networks = list()
	///Radio packets to process
	var/list/radio_packets = list()

	///The current processing lists
	var/list/current_networks = list()
	var/list/current_radio_packets = list()

	///What processing stage we're at
	var/stage = SSPACKETS_POWERNETS

/datum/controller/subsystem/packets/PreInit(timeofday)
	for(var/_SM in subtypesof(/datum/saymode))
		var/datum/saymode/SM = new _SM()
		saymodes[SM.key] = SM
	return ..()

/datum/controller/subsystem/packets/stat_entry(msg)
	msg += "Processing Packets: [length(current_radio_packets)]"
	msg += "Packet Queue: [length(radio_packets)]"
	return ..()

/datum/controller/subsystem/packets/fire(resumed)
	if(!resumed)
		current_networks = networks.Copy()
		current_radio_packets = radio_packets.Copy()

	///Network packets
	if(stage == SSPACKETS_POWERNETS)
		var/datum/powernet/net
		var/obj/machinery/power/poster
		while(length(current_networks))
			net = current_networks[length(current_networks)]

			///Cycle the packet queue
			if(!length(net.current_packet_queue))
				net.current_packet_queue = net.next_packet_queue.Copy()
				net.next_packet_queue.Cut()

			///No packets no problem
			if(!length(net.current_packet_queue))
				current_networks.len--
				continue

			for(var/datum/signal/signal as anything in net.current_packet_queue)
				///Find the poster so we don't send the signal to it's author
				poster = signal.author.resolve()

				for(var/obj/machinery/power/client_machine as anything in net.data_nodes - poster)
					///This might need [set waitfor = FALSE] alongside a [CHECK_TICK]
					client_machine.receive_signal(signal)

				///Remove this signal from the queue and see if we're strangling the server
				net.current_packet_queue -= signal
				if(MC_TICK_CHECK)
					return

			// Only cut it from the current run when it's done
			current_networks.len--
		// Next up: Radios!
		stage = SSPACKETS_RADIOS

	if(stage == SSPACKETS_RADIOS)
		var/datum/signal/packet
		while(length(current_radio_packets))
			packet = current_radio_packets[1]
			current_radio_packets -= packet

			ImmediateRadioPacketSend(packet)
			if(MC_TICK_CHECK)
				return

	///Reset to the first stage
	stage = SSPACKETS_POWERNETS




///Immediately send a packet to it's target(s). Used for high-importance packets.
/datum/controller/subsystem/packets/proc/ImmediatePacketSend(datum/signal/packet, datum/target)
	if(islist(target))
		for(var/datum/receiver as anything in target)
			receiver.receive_signal(packet)
	else
		target.receive_signal(packet)

/datum/controller/subsystem/packets/proc/ImmediateRadioPacketSend(datum/signal/packet)
	//If checking range, find the source turf
	var/source = packet.author.resolve()

	var/turf/start_point
	if(packet.range)
		start_point = get_turf(source)
		if(!start_point)
			return

	var/datum/radio_frequency/freq = packet.frequency_datum

	//Send the data
	for(var/current_filter in packet.filter_list)
		for(var/datum/weakref/device_ref as anything in freq.devices[current_filter])
			var/obj/device = device_ref.resolve()
			if(!device)
				freq.devices[current_filter] -= device_ref
				continue
			if(device == source)
				continue
			if(packet.range)
				var/turf/end_point = get_turf(device)
				if(!end_point)
					continue
				if(start_point.z != end_point.z || (packet.range > 0 && get_dist(start_point, end_point) > packet.range))
					continue
			device.receive_signal(packet)

/datum/controller/subsystem/packets/proc/add_object(obj/device, new_frequency as num, filter = null as text|null)
	var/f_text = num2text(new_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]
	if(!frequency)
		frequencies[f_text] = frequency = new(new_frequency)
	frequency.add_listener(device, filter)
	return frequency

/datum/controller/subsystem/packets/proc/remove_object(obj/device, old_frequency)
	var/f_text = num2text(old_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]
	if(frequency)
		frequency.remove_listener(device)
		// let's don't delete frequencies in case a non-listener keeps a reference
	return 1

/datum/controller/subsystem/packets/proc/return_frequency(new_frequency as num)
	var/f_text = num2text(new_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]
	if(!frequency)
		frequencies[f_text] = frequency = new(new_frequency)
	return frequency
