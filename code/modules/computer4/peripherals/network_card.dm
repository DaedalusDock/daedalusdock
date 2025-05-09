/obj/item/peripheral/network_card
	/// Network ID for the network.
	var/network_id

/obj/item/peripheral/network_card/Initialize(mapload)
	. = ..()
	network_id = SSpackets.generate_net_id(src)

/obj/item/peripheral/network_card/wireless
	name = "wireless card"
	desc = "A wireless computer card. It has a bit of a limited range."
	icon_state = "radio"

	peripheral_type = PERIPHERAL_TYPE_WIRELESS_CARD

	COOLDOWN_DECLARE(ping_cooldown)

	/// Use set_frequency()
	var/frequency = FREQ_COMMON

	/// If TRUE, will sniff any packet that it receives. Otherwise, filters by net addr.
	var/listen_all = TRUE

	/// Ref to the radio connection.
	var/datum/radio_frequency/radio_connection

/obj/item/peripheral/network_card/wireless/on_attach(obj/machinery/computer4/computer)
	. = ..()
	set_radio_connection(frequency)

/obj/item/peripheral/network_card/wireless/on_detach(obj/machinery/computer4/computer)
	. = ..()
	set_radio_connection(null)

/// Sets the radio connection to the desired frequency.
/obj/item/peripheral/network_card/wireless/proc/set_radio_connection(new_frequency)
	if(radio_connection)
		if(new_frequency == radio_connection.frequency)
			return

		SSpackets.remove_object(src, radio_connection.frequency)
		radio_connection = null

	if(isnull(new_frequency))
		return

	new_frequency = sanitize_frequency(new_frequency, free = TRUE)

	radio_connection = SSpackets.add_object(src, new_frequency)

/// Post a signal. Has safety checks, so calling this with a timer is OK.
/obj/item/peripheral/network_card/wireless/proc/post_signal(datum/signal/packet, filter)
	if(!master_pc?.is_operational || !radio_connection)
		return

	packet.data[PACKET_SOURCE_ADDRESS] = network_id
	radio_connection.post_signal(packet, filter)

/obj/item/peripheral/network_card/wireless/proc/deferred_post_signal(datum/signal/packet, filter, time)
	addtimer(CALLBACK(src, PROC_REF(post_signal), packet, filter), time)

/obj/item/peripheral/network_card/wireless/receive_signal(datum/signal/signal)
	if(!master_pc)
		CRASH("Peripheral somehow got a wireless signal while not having a master")

	if(!master_pc.is_operational)
		return

	if(!listen_all)
		// Isn't meant for us, but could be a ping
		if(signal.data[PACKET_DESTINATION_ADDRESS] != network_id)
			if(!signal.data[PACKET_SOURCE_ADDRESS] || (signal.data[PACKET_DESTINATION_ADDRESS] != NET_ADDRESS_PING))
				return // Is not a ping, bye bye!

			var/list/data = list(
				PACKET_SOURCE_ADDRESS = network_id,
				PACKET_DESTINATION_ADDRESS = signal.data[PACKET_SOURCE_ADDRESS],
				PACKET_CMD = NET_COMMAND_PING_REPLY,
				PACKET_NETCLASS = "WNET_ADAPTER",
			)

			var/datum/signal/packet = new(src, data, TRANSMISSION_RADIO)
			addtimer(CALLBACK(src, PROC_REF(post_signal), packet), 1 SECOND)
			return

	var/datum/signal/clone = signal.Copy()
	master_pc.peripheral_input(src, PERIPHERAL_CMD_RECEIVE_PACKET, clone)

/obj/item/peripheral/network_card/wireless/proc/ping()
	if(!COOLDOWN_FINISHED(src, ping_cooldown))
		return FALSE

	COOLDOWN_START(src, ping_cooldown, 2 SECONDS)
	var/list/data = list(
		PACKET_SOURCE_ADDRESS = network_id,
		PACKET_DESTINATION_ADDRESS = NET_ADDRESS_PING,
	)

	var/datum/signal/packet = new(src, data)
	post_signal(packet)
	return TRUE
