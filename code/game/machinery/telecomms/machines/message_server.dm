/*
	The equivalent of the server, for PDA and request console messages.
	Without it, PDA and request console messages cannot be transmitted.
	PDAs require the rest of the telecomms setup, but request consoles only
	require the message server.
*/

// A decorational representation of SSblackbox, usually placed alongside the message server. Also contains a traitor theft item.
/obj/machinery/blackbox_recorder
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "blackbox"
	name = "Blackbox Recorder"
	density = TRUE
	armor = list(BLUNT = 25, PUNCTURE = 10, SLASH = 90, LASER = 10, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 50, ACID = 70)
	var/obj/item/stored

/obj/machinery/blackbox_recorder/Initialize(mapload)
	. = ..()
	stored = new /obj/item/blackbox(src)

/obj/machinery/blackbox_recorder/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(stored)
		stored.forceMove(drop_location())
		if(Adjacent(user))
			user.put_in_hands(stored)
		stored = null
		to_chat(user, span_notice("You remove the blackbox from [src]. The tapes stop spinning."))
		update_appearance()
		return
	else
		to_chat(user, span_warning("It seems that the blackbox is missing..."))
		return

/obj/machinery/blackbox_recorder/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/blackbox))
		if(HAS_TRAIT(I, TRAIT_NODROP) || !user.transferItemToLoc(I, src))
			to_chat(user, span_warning("[I] is stuck to your hand!"))
			return
		user.visible_message(span_notice("[user] clicks [I] into [src]!"), \
		span_notice("You press the device into [src], and it clicks into place. The tapes begin spinning again."))
		playsound(src, 'sound/machines/click.ogg', 50, TRUE)
		stored = I
		update_appearance()
		return
	return ..()

/obj/machinery/blackbox_recorder/Destroy()
	if(stored)
		stored.forceMove(loc)
		new /obj/effect/decal/cleanable/oil(loc)
	return ..()

/obj/machinery/blackbox_recorder/update_icon_state()
	icon_state = "blackbox[stored ? null : "_b"]"
	return ..()

/obj/item/blackbox
	name = "\proper the blackbox"
	desc = "A strange relic, capable of recording data on extradimensional vertices. It lives inside the blackbox recorder for safe keeping."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "blackcube"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

#define MESSAGE_SERVER_FUNCTIONING_MESSAGE "This is an automated message. The messaging system is functioning correctly."

// The message server itself.
/obj/machinery/telecomms/message_server
	icon_state = "message_server"
	name = "Messaging Server"
	desc = "A machine that processes and routes PDA and request console messages."
	telecomms_type = /obj/machinery/telecomms/message_server
	density = TRUE
	circuit = /obj/item/circuitboard/machine/telecomms/message_server

	network_flags = NETWORK_FLAG_GEN_ID
	net_class = NETCLASS_MESSAGE_SERVER

	var/list/datum/data_pda_message/pda_msgs = list()
	var/list/datum/data_rc_msg/rc_msgs = list()
	var/decryptkey = "password"
	var/calibrating = 15 MINUTES //Init reads this and adds world.time, then becomes 0 when that time has passed and the machine works

	var/datum/radio_frequency/common_freq

/obj/machinery/telecomms/message_server/Initialize(mapload)
	. = ..()
	if (!decryptkey)
		decryptkey = GenerateKey()

	if (calibrating)
		calibrating += world.time
		say("Calibrating... Estimated wait time: [rand(3, 9)] minutes.")
		pda_msgs += new /datum/data_pda_message("loopback", "loopback", "This is an automated message. System calibration started at [stationtime2text()].")
	else
		pda_msgs += new /datum/data_pda_message("loopback", "loopback", MESSAGE_SERVER_FUNCTIONING_MESSAGE)

/obj/machinery/telecomms/message_server/update_power()
	. = ..()
	if(on && !common_freq) //On, and don't have a radio connection (either we tossed it when turning !on, or we're initializing)
		common_freq = SSpackets.add_object(src, FREQ_COMMON, RADIO_PDAMESSAGE) //Might end up removing this filter one day, but for now, opts are opts.
	else if(!on) //Turned off, toss the frequency connection.
		SSpackets.remove_object(src, FREQ_COMMON)
		common_freq = null


/obj/machinery/telecomms/message_server/Destroy()
	for(var/obj/machinery/computer/message_monitor/monitor in GLOB.telecomms_list)
		if(monitor.linkedServer && monitor.linkedServer == src)
			monitor.linkedServer = null
	. = ..()

/obj/machinery/telecomms/message_server/examine(mob/user)
	. = ..()
	if(calibrating)
		. += span_warning("It's still calibrating.")

/obj/machinery/telecomms/message_server/proc/GenerateKey()
	var/newKey
	newKey += pick("the", "if", "of", "as", "in", "a", "you", "from", "to", "an", "too", "little", "snow", "dead", "drunk", "rosebud", "duck", "al", "le")
	newKey += pick("diamond", "beer", "mushroom", "assistant", "clown", "captain", "twinkie", "security", "nuke", "small", "big", "escape", "yellow", "gloves", "monkey", "engine", "nuclear", "ai")
	newKey += pick(GLOB.numerals)
	return newKey

/obj/machinery/telecomms/message_server/process()
	. = ..()
	if(calibrating && calibrating <= world.time)
		calibrating = 0
		pda_msgs += new /datum/data_pda_message("loopback", "loopback", MESSAGE_SERVER_FUNCTIONING_MESSAGE)


// Handle RC Messages. I'll packetize these eventually I swear
/obj/machinery/telecomms/message_server/receive_information(datum/signal/subspace/messaging/signal, obj/machinery/telecomms/machine_from)
	// can't log non-message signals
	if(!istype(signal) || !signal.data["message"] || !on || calibrating)
		return

	// log the signal
	if(istype(signal, /datum/signal/subspace/messaging/rc))
		var/datum/data_rc_msg/msg = new(signal.data["rec_dpt"], signal.data["send_dpt"], signal.data["message"], signal.data["stamped"], signal.data["verified"], signal.data["priority"])
		signal.logged = msg
		if(signal.data["send_dpt"]) // don't log messages not from a department but allow them to work
			rc_msgs += msg
	signal.data["reject"] = FALSE

	// pass it along to either the hub or the broadcaster
	if(!relay_information(signal, /obj/machinery/telecomms/hub))
		relay_information(signal, /obj/machinery/telecomms/broadcaster)

/obj/machinery/telecomms/message_server/receive_signal(datum/signal/signal)
	. = ..()
	//Let upstream deal with the pings. But ignore the return value for now, we're here to sniff every packet we can.
	if(calibrating) // If we're calibrating, just return, the fancy part of us isn't ready yet.
		return
	var/list/sig_data = signal.data //cachemere sweater
	switch(signal.data[PACKET_CMD])
		if(NETCMD_PDAMESSAGE)
			var/datum/data_pda_message/log_unit = new(sig_data[PACKET_DESTINATION_ADDRESS], sig_data[PACKET_SOURCE_ADDRESS], sig_data["message"])
			pda_msgs += log_unit
			return RECEIVE_SIGNAL_FINISHED
		else
			//It's not a PDA message, just abort.
			return RECEIVE_SIGNAL_CONTINUE

/obj/machinery/telecomms/message_server/post_signal(datum/signal/sending_signal, preserve_s_addr)
	if(isnull(sending_signal)) //nullcheck for sanic speed
		return //You need a pipe and something to send down it, though.
	if(!preserve_s_addr)
		sending_signal.data[PACKET_SOURCE_ADDRESS] = src.net_id
	sending_signal.transmission_method = TRANSMISSION_RADIO
	sending_signal.author = WEAKREF(src) // Override the sending signal author.

/obj/machinery/telecomms/message_server/update_overlays()
	. = ..()

	if(calibrating)
		. += "message_server_calibrate"


// Root messaging signal datum
/datum/signal/subspace/messaging
	frequency = FREQ_COMMON
	server_type = /obj/machinery/telecomms/message_server
	var/datum/logged

/datum/signal/subspace/messaging/New(init_source, init_data)
	author = WEAKREF(init_source)
	data = init_data
	var/turf/T = get_turf(init_source)
	if(!T)
		CRASH("Uh oh, no source turf!")
	levels = list(T.z)
	if(!("reject" in data))
		data["reject"] = TRUE

/datum/signal/subspace/messaging/copy()
	var/datum/signal/subspace/messaging/copy = new type(author.resolve(), data.Copy())
	copy.original = src
	copy.levels = levels
	return copy

// Request Console signal datum
/datum/signal/subspace/messaging/rc/broadcast()
	if (!logged)  // Like /pda, only if logged
		return
	var/rec_dpt = ckey(data["rec_dpt"])
	for (var/obj/machinery/requests_console/Console as anything in INSTANCES_OF(/obj/machinery/requests_console))
		if(ckey(Console.department) == rec_dpt || (data["ore_update"] && Console.receive_ore_updates))
			Console.createmessage(data["sender"], data["send_dpt"], data["message"], data["verified"], data["stamped"], data["priority"], data["notify_freq"])

// Log datums stored by the message server.
/datum/data_pda_message
	var/sender = "Unspecified"
	var/recipient = "Unspecified"
	var/message = "Blank"  // transferred message

/datum/data_pda_message/New(param_rec, param_sender, param_message)
	if(param_rec)
		recipient = param_rec
	if(param_sender)
		sender = param_sender
	if(param_message)
		message = param_message

/datum/data_rc_msg
	var/rec_dpt = "Unspecified"  // receiving department
	var/send_dpt = "Unspecified"  // sending department
	var/message = "Blank"
	var/stamp = "Unstamped"
	var/id_auth = "Unauthenticated"
	var/priority = "Normal"

/datum/data_rc_msg/New(param_rec, param_sender, param_message, param_stamp, param_id_auth, param_priority)
	if(param_rec)
		rec_dpt = param_rec
	if(param_sender)
		send_dpt = param_sender
	if(param_message)
		message = param_message
	if(param_stamp)
		stamp = param_stamp
	if(param_id_auth)
		id_auth = param_id_auth
	if(param_priority)
		switch(param_priority)
			if(REQ_NORMAL_MESSAGE_PRIORITY)
				priority = "Normal"
			if(REQ_HIGH_MESSAGE_PRIORITY)
				priority = "High"
			if(REQ_EXTREME_MESSAGE_PRIORITY)
				priority = "Extreme"
			else
				priority = "Undetermined"

#undef MESSAGE_SERVER_FUNCTIONING_MESSAGE

/obj/machinery/telecomms/message_server/preset
	id = "Messaging Server"
	network = "tcommsat"
	autolinkers = list("messaging")
	decryptkey = null //random
	calibrating = 0
