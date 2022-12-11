/obj/machinery/callstation
	name = "Phone - UNINITIALIZED"
	desc = "It's a phone. You pick it up, select from the list of other phones, and scream at the other person. The voice quality isn't all that great."
	net_class = "PNET_SIPCLIENT"
	var/phoneid = "INVALID_STATION"
	var/friendly_name = "Invalid Phone"
	//master_id - Linked SIP server.
	var/list/local_directory // Local phone directory, assoc: phoneid:friendly_name
	var/last_synchronization_time //last world_time that the directory was synced
/*
Phone registration flow (Post-Roundstart):
//Find the SIP server
-GENERIC PING-
//Register with the SIP server
{
	"s_addr":$PHONE_ADDR
	"d_addr":$SIPSRV_ADDR
	"command":"sip_request_adopt"
}
--Roundstart flow starts here--
{
	"s_addr":$SIPSRV_ADDR
	"d_addr":$PHONE_ADDR
	"command":"sip_adopt"
}
{
	"s_addr":$PHONE_ADDR
	"d_addr":$SIPSRV_ADDR
	"command":"sip_adopt_accept"
	"data":list2params(list("friendly_name"=friendly_name,"phoneid"=phoneid))
}
-- Periodic --
{
	"s_addr":$SIPSRV_ADDR
	"d_addr":"MC_$SIPSRV_ADDR"
	"command":"sip_update"
	"data":list2params(directory)
}
*/
/obj/machinery/callstation/receive_signal(datum/signal/signal)
	. = ..()
	if(.)
		if(!master_id || signal.data["d_addr"] != "MC_[master_id]") //Hacky ugly terrible nasty multicast
			return
	switch(lowertext(signal.data["command"]))
		if("ping_reply")// A reply to our ping!
			if(signal.data["netclass"] != "PNET_SIPSERVER") //Not who we care about!
				return
			register_with_server(signal.data["s_addr"])// It's a server, link!
		if("sip_adopt")
			if(master_id && signal.data["s_addr"] != master_id) //You're not my dad!
				return
			//This technically allows an upstream server to readopt an existing device, this is fine in theory.
			master_id = signal.data["s_addr"]
			post_signal(master_id, list("command"="sip_adopt_accept","data"=list2params(list("friendly_name"=friendly_name,"phoneid"=phoneid))))
		if("sip_update")
			(!master_id || signal.data["s_addr"] != master_id) //You're not my dad, or, I have no dad!
				return
			directory = params2list(signal.data["data"])
			last_synchronization_time = world.time

/obj/machinery/callstation/register_with_server(new_master_id)
	post_signal(new_master_id, list("command"="sip_request_adopt"))
