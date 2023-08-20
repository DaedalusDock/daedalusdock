// Since we can't assure that the PDA program is running at all times,
// We need to do this in "hardware"
//This is the definition of overdesigned, but the way it used to work was also awful, so eat shit.

#define GPRS_ENABLED TRUE
#define GPRS_DISABLED FALSE

/obj/item/computer_hardware/network_card/packetnet
	name = "\improper GPRS network card"
	desc = "A cheap network card with an attached GPRS Modem. Supports NTNet and GPRS Messaging."
	var/gprs_frequency = FREQ_COMMON
	var/datum/radio_frequency/radio_connection

	/// Stores up to [queue_max] messages until the PDA asks for them.
	VAR_PRIVATE/list/datum/signal/packet_queue
	/// Maximum amount of messages held by [packet_queue]
	var/queue_max = 5
	var/radio_state = GPRS_ENABLED

/obj/item/computer_hardware/network_card/packetnet/Initialize(mapload)
	. = ..()
	packet_queue = list()

/obj/item/computer_hardware/network_card/packetnet/on_install(obj/item/modular_computer/install_into, mob/living/user)
	. = ..()
	radio_connection = SSpackets.add_object(src, gprs_frequency, RADIO_PDAMESSAGE) //We only get packets if we're connected to a host.

/obj/item/computer_hardware/network_card/packetnet/on_remove(obj/item/modular_computer/remove_from, mob/living/user)
	. = ..()
	SSpackets.remove_object(src, gprs_frequency)
	radio_connection = null
	packet_queue.Cut() // Volatile memory~
	radio_state = GPRS_ENABLED // Default to back on to prevent frustration.


/obj/item/computer_hardware/network_card/packetnet/Destroy()
	. = ..()
	SSpackets.remove_object(src, gprs_frequency, RADIO_PDAMESSAGE)
	radio_connection = null
	packet_queue.Cut()

/obj/item/computer_hardware/network_card/packetnet/diagnostics(mob/user)
	..()
	to_chat(user, "GPRS - General Packet Radio Service")
	to_chat(user, "┗ TX/RX Band - [format_frequency(gprs_frequency)]")

/obj/item/computer_hardware/network_card/packetnet/examine_more(mob/user)
	. = ..()
	. += span_info("The silkscreen reads...")
	. += "\t[span_info("GPRS FREQ: [span_robot(format_frequency(gprs_frequency))]")]"
	. += "\t[span_info("GPRS DMEI: [span_robot(hardware_id)]")]"
	//. += "\t[span_info("IPX1 NID: [hardware_id]")]"

/obj/item/computer_hardware/network_card/packetnet/receive_signal(datum/signal/signal)
	if(!holder || !signal.data) //Basic checks
		return
	var/list/signal_data = signal.data //medium velocity silver hedgehog
	var/signal_d_addr = signal_data["d_addr"]
	if(signal_d_addr == NETID_PING) //Ping.
		var/datum/signal/outgoing = new(
			src,
			list(
				"d_addr" = signal_data["s_addr"],
				"command" = NETCMD_PINGREPLY,
				"netclass" = "NET_GPRS",
				"netaddr" = hardware_id
			)
		)
		post_signal(outgoing)
	//Either it's broadcast or directed to us.
	if(isnull(signal_d_addr) || signal_d_addr == hardware_id)
		//We don't really care what it is, just store it.
		push_signal(signal)


/obj/item/computer_hardware/network_card/packetnet/proc/post_signal(datum/signal/signal)
	if(!radio_connection || !signal)
		return FALSE // Something went wrong.
	radio_connection.post_signal(signal, RADIO_PDAMESSAGE)
	return TRUE //We at least tried.

/// Take a signal out of the queue.
/obj/item/computer_hardware/network_card/packetnet/proc/pop_signal()
	if(!length(packet_queue))
		return FALSE //Nothing left, chief.
	var/datum/signal/popped = packet_queue[1]
	packet_queue -= popped
	return popped

/// Push a signal onto the queue, Drop a packet if we're over the limit.
/obj/item/computer_hardware/network_card/packetnet/proc/push_signal(datum/signal/signal)
	PRIVATE_PROC(TRUE)
	if(signal.has_magic_data & MAGIC_DATA_MUST_DISCARD)
		return //We can't hold volatile signals.
	if(length(packet_queue) == queue_max)
		pop_signal() //Discard the first signal in the queue
	packet_queue += signal
	return

/// Get the length of the packet queue
/obj/item/computer_hardware/network_card/packetnet/proc/check_queue()
	return length(packet_queue)

/obj/item/computer_hardware/network_card/packetnet/proc/set_radio_state(new_state)
	if(radio_state == new_state)
		return
	radio_state = new_state
	if(radio_state)
		SSpackets.add_object(src, gprs_frequency, RADIO_PDAMESSAGE)
	else
		SSpackets.remove_object(src, gprs_frequency)



#undef GPRS_ENABLED
#undef GPRS_DISABLED
