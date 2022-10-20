#define VALIDATE_WIRED_SIGNAL if(!src.signal){return};if(signal.transmission_method != TRANSMISSION_WIRE){CRASH("Received signal with invalid transport mode for this media!")}

/obj/machinery/networked
	icon_state = "blackbox"
	var/obj/machinery/power/data_terminal/netjack
	var/net_id //This is probably conflictory with NTNet but FUCK EM
	var/master_id //Are we slaved to any particular device?
	var/net_class = "PNET_ABSTRACT" //A short string shown to players fingerprinting the device type.

/obj/machinery/networked/Initialize(mapload)
	. = ..()
	net_id = SSnetworks.get_next_HID() //Just going to parasite this.

/obj/machinery/networked/LateInitialize()
	. = ..()
	link_to_jack()

/obj/machinery/networked/proc/post_signal(destination_id, list/datagram)
	if(!netjack || !destination_id)
		return //Unfortunately /dev/null isn't network-scale.

	var/datum/signal/sig = new
	sig.source = src
	sig.transmission_method = TRANSMISSION_WIRE
	sig.data = datagram.Copy()
	sig.data["s_addr"] = src.net_id
	sig.data["d_addr"] = destination_id
	src.netjack.post_signal(src, sig)

/obj/machinery/networked/receive_signal(datum/signal/signal)
	SHOULD_CALL_PARENT(TRUE)
	. = TRUE //Should the subtype *probably* stop caring about this packet?
	if(!signal || !src.netjack)
		return
	if(signal.transmission_method != TRANSMISSION_WIRE)
		CRASH("Received signal with invalid transport mode for this media!")

	if(signal.data["d_addr"] != src.net_id)
		if(signal.data["s_addr"] == "ping")
			post_signal(signal.data["s_addr"], list("command"="ping_reply","netclass"=net_class,"netaddr"=src.net_id))
			return
	return 0 // We are the designated recipient of this packet.

//Handle the network jack

/obj/machinery/networked/proc/link_to_jack()
	var/new_transmission_terminal = locate(/obj/machinery/power/data_terminal) in get_turf(src)
	if(netjack == new_transmission_terminal)
		return
	unlink_from_jack()//If our new jack is null, then we've somehow lost it? Don't care and just go along with it.
	if(!new_transmission_terminal)
		return
	netjack = new_transmission_terminal
	netjack.connected_machine = src

/obj/machinery/networked/proc/unlink_from_jack()
	netjack?.connected_machine = null
	netjack = null

/obj/machinery/networked/Destroy()
	//Disconnect from the network
	unlink_from_jack()
	return ..()
