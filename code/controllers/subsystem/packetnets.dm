SUBSYSTEM_DEF(packets)
	name = "Packets"
	wait = 1
	priority = FIRE_PRIORITY_PACKETS
	flags = SS_NO_INIT|SS_KEEP_TIMING
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/list/saymodes = list()
	var/list/datum/radio_frequency/frequencies = list()

	///All the physical networks to process
	var/list/datum/powernet/queued_networks = list()
	///Radio packets to process
	var/list/queued_radio_packets = list()
	///Amount of radio packets processed last cycle
	var/last_processed_radio_packets = 0
	///Tablet messages to process
	var/list/queued_tablet_messages = list()
	///Amount of tabletmessage packets processed last cycle
	var/last_processed_tablet_message_packets = 0
	///Subspace/vocal packets to process
	var/list/queued_subspace_vocals = list()
	///Amount of subspace vocal packets processed last cycle
	var/last_processed_ssv_packets = 0


	///The current processing lists
	var/list/current_networks = list()
	var/list/current_radio_packets = list()
	var/list/current_tablet_messages = list()
	var/list/current_subspace_vocals = list()

	///Tick usage
	var/cached_cost = 0
	var/cost_networks = 0
	var/cost_radios = 0
	var/cost_tablets = 0
	var/cost_subspace_vocals = 0

	///What processing stage we're at
	var/stage = SSPACKETS_POWERNETS

/datum/controller/subsystem/packets/PreInit(timeofday)
	for(var/_SM in subtypesof(/datum/saymode))
		var/datum/saymode/SM = new _SM()
		saymodes[SM.key] = SM
	return ..()

/datum/controller/subsystem/packets/stat_entry(msg)
	msg += "RP: [length(queued_radio_packets)]{[last_processed_radio_packets]}|"
	msg += "TM: [length(queued_tablet_messages)]{[last_processed_tablet_message_packets]}|"
	msg += "SSV: [length(queued_subspace_vocals)]{[last_processed_ssv_packets]}|"
	msg += "C:{"
	msg += "CN:[round(cost_networks, 1)]|"
	msg += "CR:[round(cost_radios, 1)]|"
	msg += "CSSV:[round(cost_subspace_vocals, 1)]|"
	msg += "}"

	return ..()

/datum/controller/subsystem/packets/fire(resumed)
	if(!resumed)
		current_networks = queued_networks.Copy()
		current_radio_packets = queued_radio_packets.Copy()
		current_tablet_messages = queued_tablet_messages.Copy()
		current_subspace_vocals = queued_subspace_vocals.Copy()

	var/timer = TICK_USAGE_REAL

	///Network packets
	if(stage == SSPACKETS_POWERNETS)
		timer = TICK_USAGE_REAL
		if(!resumed)
			cached_cost = 0

		var/datum/powernet/net
		var/obj/machinery/power/poster
		while(length(current_networks))
			net = current_networks[length(current_networks)]
			if(QDELETED(net))
				current_networks.len--
				queued_networks -= net
				continue

			///Cycle the packet queue
			if(!length(net.current_packet_queue))
				net.current_packet_queue = net.next_packet_queue.Copy()
				net.next_packet_queue.Cut()

			///No packets no problem
			if(!length(net.current_packet_queue))
				current_networks.len--
				continue

			for(var/datum/signal/signal as anything in net.current_packet_queue)
				// Find the poster so we don't send the signal to it's author
				// A null is fine.
				poster = signal.author?.resolve()

				for(var/obj/machinery/power/client_machine as anything in net.data_nodes - poster)
					///This might need [set waitfor = FALSE] alongside a [CHECK_TICK]
					client_machine.receive_signal(signal)

				///Remove this signal from the queue and see if we're strangling the server
				net.current_packet_queue -= signal

				cached_cost += TICK_USAGE_REAL - timer

				if(MC_TICK_CHECK)
					return

			// Only cut it from the current run when it's done
			current_networks.len--

		cost_networks = MC_AVERAGE(cost_networks, TICK_DELTA_TO_MS(cached_cost))
		resumed = FALSE
		// Next up: Radios!
		stage = SSPACKETS_RADIOS

	if(stage == SSPACKETS_RADIOS)
		timer = TICK_USAGE_REAL
		if(!resumed)
			cached_cost = 0
			last_processed_radio_packets = 0

		var/datum/signal/packet
		while(length(current_radio_packets))
			packet = current_radio_packets[1]
			current_radio_packets.Cut(1,2)
			queued_radio_packets -= packet

			ImmediateRadioPacketSend(packet)
			cached_cost += TICK_USAGE_REAL - timer
			last_processed_radio_packets++
			if(MC_TICK_CHECK)
				return

		cost_radios = MC_AVERAGE(cost_radios, TICK_DELTA_TO_MS(cached_cost))
		resumed = FALSE
		stage = SSPACKETS_TABLETS

	if(stage == SSPACKETS_TABLETS)
		timer = TICK_USAGE_REAL
		if(!resumed)
			cached_cost = 0
			last_processed_tablet_message_packets = 0

		var/datum/signal/subspace/messaging/tablet_msg/packet
		while(length(current_tablet_messages))
			packet = current_tablet_messages[1]
			current_tablet_messages.Cut(1,2)
			queued_tablet_messages -= packet

			if (!packet.logged)  // Can only go through if a message server logs it
				continue

			for (var/obj/item/modular_computer/comp in packet.data["targets"])
				var/obj/item/computer_hardware/hard_drive/drive = comp.all_components[MC_HDD]
				for(var/datum/computer_file/program/messenger/app in drive.stored_files)
					app.receive_message(packet)

			cached_cost += TICK_USAGE_REAL - timer
			last_processed_tablet_message_packets++
			if(MC_TICK_CHECK)
				return

		cost_tablets = MC_AVERAGE(cost_tablets, TICK_DELTA_TO_MS(cached_cost))
		resumed = FALSE
		stage = SSPACKETS_SUBSPACE_VOCAL

	if(stage == SSPACKETS_SUBSPACE_VOCAL)
		timer = TICK_USAGE_REAL
		if(!resumed)
			cached_cost = 0
			last_processed_ssv_packets = 0

		var/datum/signal/subspace/vocal/packet
		while(length(current_subspace_vocals))
			packet = current_subspace_vocals[1]
			current_subspace_vocals.Cut(1,2)
			queued_subspace_vocals -= packet

			ImmediateSubspaceVocalSend(packet)
			cached_cost += TICK_USAGE_REAL - timer
			last_processed_ssv_packets++
			if(MC_TICK_CHECK)
				return


		cost_subspace_vocals = MC_AVERAGE(cost_subspace_vocals, TICK_DELTA_TO_MS(cached_cost))
		resumed = FALSE

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
	var/source = packet.author?.resolve()

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

/datum/controller/subsystem/packets/proc/ImmediateSubspaceVocalSend(datum/signal/subspace/vocal/packet)
	// Perform final composition steps on the message.
	var/message = copytext_char(packet.data["message"], 1, MAX_BROADCAST_LEN)
	if(!message)
		return
	var/compression = packet.data["compression"]
	if(compression > 0)
		message = Gibberish(message, compression >= 30)

	var/list/signal_reaches_every_z_level = packet.levels

	var/atom/movable/virtualspeaker/virt = packet.virt
	var/list/data = packet.data
	var/datum/language/language = packet.language

	if(0 in packet.levels)
		signal_reaches_every_z_level = RADIO_NO_Z_LEVEL_RESTRICTION

	var/frequency = packet.frequency

	// Assemble the list of radios
	var/list/radios = list()
	switch (packet.transmission_method)
		if (TRANSMISSION_SUBSPACE)
			// Reaches any radios on the levels
			var/list/all_radios_of_our_frequency = GLOB.all_radios["[frequency]"]
			radios = all_radios_of_our_frequency.Copy()

			for(var/obj/item/radio/subspace_radio in radios)
				if(!subspace_radio.can_receive(frequency, signal_reaches_every_z_level))
					radios -= subspace_radio

			// Syndicate radios can hear all well-known radio channels
			if (num2text(frequency) in GLOB.reverseradiochannels)
				for(var/obj/item/radio/syndicate_radios in GLOB.all_radios["[FREQ_SYNDICATE]"])
					if(syndicate_radios.can_receive(FREQ_SYNDICATE, RADIO_NO_Z_LEVEL_RESTRICTION))
						radios |= syndicate_radios

		if (TRANSMISSION_RADIO)
			// Only radios not currently in subspace mode
			for(var/obj/item/radio/non_subspace_radio in GLOB.all_radios["[frequency]"])
				if(!non_subspace_radio.subspace_transmission && non_subspace_radio.can_receive(frequency, signal_reaches_every_z_level))
					radios += non_subspace_radio

		if (TRANSMISSION_SUPERSPACE)
			// Only radios which are independent
			for(var/obj/item/radio/independent_radio in GLOB.all_radios["[frequency]"])
				if(independent_radio.independent && independent_radio.can_receive(frequency, signal_reaches_every_z_level))
					radios += independent_radio

	// From the list of radios, find all mobs who can hear those.
	var/list/receive = get_hearers_in_radio_ranges(radios)
	var/list/globally_receiving = list()

	// Add observers who have ghost radio enabled.
	for(var/mob/dead/observer/ghost in GLOB.player_list)
		if(ghost.client.prefs?.chat_toggles & CHAT_GHOSTRADIO)
			globally_receiving |= ghost

	// Render the message and have everybody hear it.
	// Always call this on the virtualspeaker to avoid issues.
	var/spans = data["spans"]
	var/list/message_mods = data["mods"]
	var/rendered = virt.compose_message(virt, language, message, frequency, spans)

	for(var/obj/item/radio/radio as anything in receive)
		for(var/atom/movable/hearer as anything in receive[radio])
			if(!hearer)
				stack_trace("null found in the hearers list returned by the spatial grid. this is bad")
				continue

			hearer.Hear(rendered, virt, language, message, frequency, spans, message_mods, sound_loc = radio.speaker_location())

	// Let the global hearers (ghosts, etc) hear this message
	for(var/atom/movable/hearer as anything in globally_receiving)
		hearer.Hear(rendered, virt, language, message, frequency, spans, message_mods)

	// This following recording is intended for research and feedback in the use of department radio channels
	if(length(receive))
		SSblackbox.LogBroadcast(frequency)

	var/spans_part = ""
	if(length(spans))
		spans_part = "(spans:"
		for(var/S in spans)
			spans_part = "[spans_part] [S]"
		spans_part = "[spans_part] ) "

	var/lang_name = data["language"]
	var/log_text = "\[[get_radio_name(frequency)]\] [spans_part]\"[message]\" (language: [lang_name])"

	var/mob/source_mob = virt.source

	if(ismob(source_mob))
		source_mob.log_message(log_text, LOG_TELECOMMS)
	else
		log_telecomms("[virt.source] [log_text] [loc_name(get_turf(virt.source))]")

	QDEL_IN(virt, 50)  // Make extra sure the virtualspeaker gets qdeleted

/datum/controller/subsystem/packets/proc/add_object(obj/device, new_frequency as num, filter = null as text|null)
	if(QDELETED(device))
		CRASH("Attempted to add a qdeleting or nonexistent object to radio frequency!")
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
