//active_call indexes
#define CALLER_NETID 1
#define CALLER_NAME  2
//states
#define STATE_WAITING 0 //Idle
#define STATE_DIALING 1 //Calling remote station
#define STATE_RINGING 2 //Being called by remote station
#define STATE_TALKING 3 //Call active
#define STATE_HANGUP  4 //Far side hung up
#define STATE_FARBUSY 5 //Far side busy, Temporary state

/obj/machinery/networked/telephone
	name = "Phone - UNINITIALIZED"
	desc = "It's a phone. You pick it up, select from the list of other phones, and scream at the other person. The voice quality isn't all that great."
	net_class = "PNET_VCSTATION"
	icon = 'goon/icons/obj/phones.dmi'
	icon_state = "phone"
	var/list/discovered_phones // friendly_name:netid
	var/friendly_name = "Invalid Station"

	/// list(netaddr,friendly_name) of active call
	var/list/active_caller
	var/state = STATE_WAITING //Default State
	var/obj/item/p2p_phone_handset/handset
	COOLDOWN_DECLARE(scan_cooldown)

#warn TESTING TYPES
/obj/machinery/networked/telephone/test1
	friendly_name = "Test Station 1"
/obj/machinery/networked/telephone/test2
	friendly_name = "Test Station 2"
/obj/machinery/networked/telephone/test3
	friendly_name = "Test Station 3"


/obj/machinery/networked/telephone/Initialize(mapload)
	. = ..()
	ping_addition = list("user_id"=friendly_name) //Preload this so we can staple this to the ping packet.
	name = "Phone - [friendly_name]"
	handset = new(src)
	handset.callstation = src

/obj/machinery/networked/telephone/Destroy()
	QDEL_NULL(handset)
	return ..()


/// Find other stations on network
/obj/machinery/networked/telephone/proc/scan_for_stations()
	if(!COOLDOWN_FINISHED(src,scan_cooldown))
		return //Chill out, bro.
	discovered_phones = list() //Trash the existing list.
	post_signal("ping", list("data"="TEL_DISCOVER"))
	COOLDOWN_START(src,scan_cooldown,10 SECONDS)

/// Initiate a call with another station
/obj/machinery/networked/telephone/proc/start_call(station_name)
	if(!station_name || !discovered_phones[station_name])
		return //Who? Or more likely: HREF fuckery.
	active_caller = list(discovered_phones[station_name], station_name)
	state = STATE_DIALING
	post_signal(discovered_phones[station_name], list("command"="tel_ring","caller_id"=friendly_name))
	var/grabbed = usr.put_in_hands(handset)
	icon_state = "phone_answered"
	//if(!grabbed)
		//Fluff message about them knocking the handset to the floor

/// Ring the phone so someone can answer the call.
/obj/machinery/networked/telephone/proc/ring()
	state = STATE_RINGING
	icon_state = "phone_ringing"
	playsound(src, 'goon/sounds/phone/ring_incoming.ogg', 50) //TODO: Replace with loopingsound
	//TODO: Ring the phone

/// Pick up the call and enable talking
/// Originating - Are we the one calling? If so, we don't need to inform the remote side.
/obj/machinery/networked/telephone/proc/pick_up(originating = FALSE)
	if(!active_caller)
		return
	if(!originating)
		post_signal(active_caller[CALLER_NETID], list("command"="tel_ready")) //Inform originator we're ready.
		var/grabbed = usr.put_in_hands(handset) //Grab the handset too.
		icon_state = "phone_answered"
	else //We're originating.
		playsound(src, 'goon/sounds/phone/remote_answer.ogg', 50, extrarange=SILENCED_SOUND_EXTRARANGE)
	state = STATE_TALKING
	//Enable talking and stuff

/// Going on-hook
/obj/machinery/networked/telephone/proc/end_call()
	if((state == STATE_RINGING || state == STATE_WAITING) && !active_caller)// The handset should be
		return
	if(active_caller)
		post_signal(active_caller[CALLER_NETID], list("command"="tel_hup"))
	handset.forceMove(src)
	playsound(src, 'goon/sounds/phone/hang_up.ogg', 50, vary=TRUE, extrarange=MEDIUM_RANGE_SOUND_EXTRARANGE)
	icon_state = "phone"
	reset()

/// Far side busy, play the tone for 5 seconds and then reset.
/obj/machinery/networked/telephone/proc/line_busy()
	state = STATE_FARBUSY
	playsound(handset, 'goon/sounds/phone/phone_busy.ogg', 50, extrarange=SILENCED_SOUND_EXTRARANGE)
	//TODO: Play busy tone and such.

/// Reset to Idle
/obj/machinery/networked/telephone/proc/reset()
	//TODO: Stop busy tone.
	active_caller = null
	state = STATE_WAITING

/obj/machinery/networked/telephone/receive_signal(datum/signal/signal)
	. = ..()
	if(.)//Handled by default.
		return
	//Ping response handled in parent.
	switch(signal.data["command"])
		if("ping_reply")//Add new phone to database
			if(signal.data["netclass"] == "PNET_VCSTATION") //Another phone!
				discovered_phones[signal.data["user_id"]]=signal.data["s_addr"]
		if("tel_ring")//Incoming ring
			if(active_caller)
				post_signal(signal.data["s_addr"],list("command"="tel_busy")) //Busy signal, Reject call.
				return
			active_caller = list(signal.data["s_addr"],signal.data["caller_id"])
			#warn DEBUG CODE
			say("Received incoming call, Data:\[[list2params(active_caller)]]")
			ring()
		if("tel_ready")//Remote side pickup
			if(signal.data["s_addr"] != active_caller[CALLER_NETID])
				return //Who are you?
			#warn DEBUG CODE
			say("Call Active")
			if(state == STATE_DIALING)//Remote station is ready to talk.
				post_signal(active_caller[CALLER_NETID], list("command"="tel_ready"))
				pick_up(TRUE)
		if("tel_busy")//Already talking/dialing
			//TODO: Play busy tone, reset.
			if(signal.data["s_addr"] != active_caller[CALLER_NETID])
				return //Why do we give a shit about you?
			#warn DEBUG CODE
			say("Line busy, resetting.")
			line_busy()
		if("tel_hup")//Remote side hangup
			if(signal.data["s_addr"] != active_caller[CALLER_NETID])
				return //Why do we give a shit about you?
			#warn DEBUG CODE
			say("Remote side hung up")
			active_caller = null //We no longer have an active call.
			if(state == STATE_RINGING)//We never answered, Immediately reset.
				reset()
				return
			state = STATE_HANGUP

/obj/machinery/networked/telephone/proc/get_state_render()
	switch(state)
		if(STATE_WAITING)
			return "<span style='color:green'>WAITING</span>"
		if(STATE_DIALING)
			return "<span style='color:orange'>RINGING</span>"
		if(STATE_RINGING)
			return "<span style='color:orange'>INCOMING CALL</span>"
		if(STATE_TALKING)
			return "<span style='color:blue'>OFF HOOK</span>"
		if(STATE_HANGUP)
			return "<span style='color:red'>CALL TERMINATED</span>"
		if(STATE_FARBUSY)
			return "<span style='color:red'>STATION BUSY</span>"
		else
			return "<span style='color:pink'>INVALID STATE</span>"

/obj/machinery/networked/telephone/ui_interact(mob/user) //THIS IS GONNA BE RAW HTML FUCKERY, *SUE ME BITCHBOOOYY*
	. = ..()
	var/list/dat = list()
	dat += "<center><div>Handset ID \[<span class='robot binarysay'>[net_id]</span>\]</div><br>"
	if(state == STATE_RINGING)
		dat += "<div><a href='?src=[REF(src)];pickup=1'>Pick Up</a>"
	if(state == STATE_DIALING || state == STATE_TALKING)
		dat += "<div><a href='?src=[REF(src)];hangup=1'>Hang Up</a>"
	if(state == STATE_HANGUP)
		dat += "<div><a href='?src=[REF(src)];reset=1'>Reset</a>"
	dat += "<hr>"
	dat += "Station State: [get_state_render()]<br>"
	dat += "<hr>"
	dat += "<table>"
	for(var/station_name in discovered_phones)
		var/far_id = discovered_phones[station_name]
		dat += "<tr>"
		dat += "<th>[station_name]</th><th><span class='robot'>[far_id]</span></th>"
		dat += "<th><a href='?src=[REF(src)];call=[url_encode(station_name)]'>Call</a></th>"
		dat += "</tr>"
	dat += "</table>"
	dat += "<hr>"
	dat += "<a href='?src=[REF(src)];scan=1'>Scan</a></center>"

	var/datum/browser/popup = new(user, "phonepad", "Phone", 500, 600)
	popup.set_content(dat.Join())
	popup.open()

/obj/machinery/networked/telephone/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	if(href_list["call"]) //Start call
		start_call(url_decode(href_list["call"]))
	if(href_list["hangup"]) // hangup
		end_call()
	if(href_list["pickup"])
		pick_up()
	if(href_list["reset"])
		if(state == STATE_HANGUP)
			reset()
	if(href_list["scan"])
		scan_for_stations()

/obj/machinery/networked/telephone/attackby(obj/item/weapon, mob/user, params)
	. = ..()
	if(weapon == src.handset)// Impolite hangup.
		end_call()

#undef CALLER_NETID
#undef CALLER_NAME

/obj/item/p2p_phone_handset
	name = "phone handset"
	desc = "You talk into this."
	icon = 'goon/icons/obj/phones.dmi'
	icon_state = "handset"
	/// Owner phone
	var/obj/machinery/networked/telephone/callstation

/obj/item/p2p_phone_handset/talk_into(mob/M, input, channel, spans, datum/language/language, list/message_mods)
	. = ..()
	if(callstation.state != STATE_TALKING)
		return

//TODO: Prevent the user from walking away with the handset.

#undef STATE_WAITING
#undef STATE_DIALING
#undef STATE_RINGING
#undef STATE_TALKING
#undef STATE_HANGUP
#undef STATE_FARBUSY
