//This will probably get rolled into some sort of mainframe in the future. For now...

/obj/machinery/phone_director
	name = "A.S.T.E.R. IP-Phone Switchboard"
	desc = "The central registry for the station's phone system. The definition of over-budget and under-delivered."
	net_class = "PNET_SIPSERVER"
	var/list/yellowpages // "phoneid":list(netaddr, friendly_name, callstate)
	var/roundstart_server // Are we the original server?

/obj/machinery/phone_director/Initialize(mapload)
	. = ..()
	if(mapload)
		roundstart_server = TRUE

/obj/machinery/phone_director/LateInitialize()
	. = ..()
	if(roundstart_server)// We're the original server, so we need to find all our fucking phones.
	//Okay we're going to cheat a little bit here because it's worldstart and that's okay.


/obj/machinery/phone_director/receive_signal(datum/signal/signal)
	. = ..()
	if(.)
		return
