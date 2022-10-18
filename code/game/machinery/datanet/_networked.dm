/obj/machinery/networked
	icon_state = "blackbox"
	var/obj/machinery/power/data_terminal/netjack
	var/net_id //This is probably conflictory with NTNet but FUCK EM
	var/master_id //Are we slaved to any particular device?
	var/net_class = "PNET_ABSTRACT" //A short string shown to players fingerprinting the device type.

/obj/machinery/networked/proc/send_data(destination_id, list/datagram)
	if(!netjack || !destination_id)
		return //Unfortunately /dev/null isn't network-scale.

	var/datum/signal/sig = new
	sig.source = src
	sig.transmission_method = TRANSMISSION_WIRE
	sig.data = datagram.Copy()
	sig.data["s_addr"] = src.net_id
	sig.data["d_addr"] = destination_id
	src.netjack.post_signal(src, sig)

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
	netjack.connected_machine = null
	netjack = null

/obj/machinery/networked/Destroy()
	. = ..()
	//Disconnect from the network
	unlink_from_jack()
