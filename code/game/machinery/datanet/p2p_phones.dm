//active_call indexes
#define CALLER_NETID 1
#define CALLER_NAME  2
//states
#define STATE_WAITING   0 //Idle
#define STATE_ORIGINATE 1 //Calling remote station
#define STATE_ANSWER    2 //Being called by remote station
#define STATE_CONNECTED   3 //Call active
#define STATE_HANGUP    4 //Far side hung up
#define STATE_FARBUSY   5 //Far side busy, Temporary state
//handset states
#define HANDSET_ONHOOK  0 //Handset is on the phone.
#define HANDSET_OFFHOOK 1 //Handset is off the phone, but still around
#define HANDSET_MISSING 2 //Handset missing or in invalid state

#define X_TELEPHONE_TESTING

#ifdef X_TELEPHONE_TESTING
#define TEL_TEST(str) message_admins("TELEPHONE: [str]")
#else
#define TEL_TEST(str) //Ignore it.
#endif

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
	var/state = STATE_WAITING
	var/handset_state = HANDSET_ONHOOK
	var/obj/item/p2p_phone_handset/handset
	var/datum/looping_sound/telephone/ring/ring_loop
	var/datum/looping_sound/telephone/busy/busy_loop
	var/datum/looping_sound/telephone/busy/hangup/hup_loop
	COOLDOWN_DECLARE(scan_cooldown)

/obj/machinery/networked/telephone/Initialize(mapload)
	. = ..()
	ping_addition = list("user_id"=friendly_name) //Preload this so we can staple this to the ping packet.
	name = "Phone - [friendly_name]"
	handset = new(src)
	handset.callstation = src
	//Parent these to the handset, but let US manage them.
	ring_loop = new(handset)
	busy_loop = new(handset)
	hup_loop = new(handset)

#warn TESTING TYPES
/obj/machinery/networked/telephone/test1
	friendly_name = "Test Station 1"
/obj/machinery/networked/telephone/test2
	friendly_name = "Test Station 2"
/obj/machinery/networked/telephone/test3
	friendly_name = "Test Station 3"

/obj/machinery/networked/telephone/Destroy()
	if(!QDELETED(handset))
		if(handset_state == HANDSET_OFFHOOK)
			var/M = get(handset, /mob)
			remove_handset(M)
		QDEL_NULL(handset)
	return ..()

/obj/machinery/networked/telephone/update_icon()
	if(handset_state == HANDSET_ONHOOK)
		if(state == STATE_ANSWER)
			icon_state = "phone_ringing"
		else
			icon_state = "phone"
	else
		icon_state = "phone_answer"
	return ..()

//Handset management

/obj/machinery/networked/telephone/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(handset_state == HANDSET_ONHOOK)
		toggle_handset(user)

/obj/machinery/networked/telephone/attackby(obj/item/weapon, mob/user, params)
	. = ..()
	if(weapon == src.handset)// Impolite hangup.
		if(handset_state == HANDSET_ONHOOK)
			CRASH("Tried to return a handset that was already on-hook???")
		toggle_handset(user) //Can't really happen if handset is on-hook.

/// Toggle the state of the handset.
/obj/machinery/networked/telephone/proc/toggle_handset(mob/user)
	switch(handset_state)
		if(HANDSET_ONHOOK)
			if(!user.put_in_hands(handset))
				// No hands free
				to_chat(user, span_warning("You need a free hand to grab the handset!"))
				return
			//Hands free, Register the handset as off-hook
			handset_statechange(HANDSET_OFFHOOK)
		if(HANDSET_OFFHOOK)
			remove_handset(user)
			handset_statechange(HANDSET_ONHOOK)
		if(HANDSET_MISSING)// Nothing to grab?
			to_chat(user, span_warning("The handset is completely missing!"))
			return

/obj/machinery/networked/telephone/proc/remove_handset(mob/user)//this prevent the bug with the handset when the phone move stole the i stole this from defib code is this funny yet
	if(ismob(handset.loc))
		var/mob/M = handset.loc
		M.dropItemToGround(handset, TRUE)
	return


/// Process the fact that the handset has changed states.
/obj/machinery/networked/telephone/proc/handset_statechange(newstate)
	if(handset_state == newstate)
		return //This used to crash, fuck it, it's fine to let it slide.
	if(handset_state == HANDSET_MISSING)
		return //Makes no sense.
	switch(handset_state)
		if(HANDSET_ONHOOK)//We're taking the phone.
			icon_state = "phone_answered"
			playsound(src, 'goon/sounds/phone/pick_up.ogg', 50, extrarange=MEDIUM_RANGE_SOUND_EXTRARANGE)
			if(state == STATE_ANSWER)// Do we have a call waiting?
				accept_call()
			handset_state = HANDSET_OFFHOOK

		if(HANDSET_OFFHOOK)//Returning the phone
			icon_state = "phone"
			playsound(src, 'goon/sounds/phone/hang_up.ogg', 50, extrarange=MEDIUM_RANGE_SOUND_EXTRARANGE)
			handset_state = HANDSET_ONHOOK
			if(state == STATE_WAITING)//We aren't doing anything more.
				return
			if(active_caller)// Do we have an active call? Ringing or not. If so, drop it.
				drop_call()
				return
			//else (We are in hangup/farbusy, We need to clean up)
			cleanup_residual_call()






//Call Network Management

/obj/machinery/networked/telephone/proc/scan_for_stations()
	set waitfor = FALSE //this is probably bad
	if(!COOLDOWN_FINISHED(src,scan_cooldown))
		return //Chill out, bro.
	discovered_phones = list() //Trash the existing list.
	post_signal("ping", list("data"="TEL_DISCOVER"))
	COOLDOWN_START(src,scan_cooldown,10 SECONDS)
	sleep(2 SECONDS)
	updateUsrDialog()

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
			if(active_caller || handset_state == HANDSET_OFFHOOK)//We're either calling, or about to call, Just tell them to fuck off.
				post_signal(signal.data["s_addr"],list("command"="tel_busy")) //Busy signal, Reject call.
				return
			receive_call(list(signal.data["s_addr"],signal.data["caller_id"]))
		if("tel_ready")//Remote side pickup
			if(active_caller && signal.data["s_addr"] == active_caller[CALLER_NETID])// Ensure the packet is sensible
				call_connected()
		if("tel_busy")//Answering station busy
			if(active_caller && signal.data["s_addr"] == active_caller[CALLER_NETID])// Ensure the packet is sensible
				fuck_off_im_busy()
		if("tel_hup")//Remote side hangup
			if(active_caller && signal.data["s_addr"] == active_caller[CALLER_NETID])// Ensure the packet is sensible
				switch(state)
					if(STATE_ANSWER)
						drop_call()// Call never connected, just reset.
					if(STATE_CONNECTED)
						call_dropped()
					else
						return // This makes no sense.


// Telephone State Machine Hellscape
// Welcome to pain! : https://file.house/wRdQ.png

/// Register a new call
/// STATE_WAITING -> STATE_ORIGINATE
/obj/machinery/networked/telephone/proc/place_call(target_phone)
	if(!target_phone || !discovered_phones[target_phone])
		return //Who? Or more likely: HREF fuckery.
	active_caller = list(discovered_phones[target_phone], target_phone)
	state = STATE_ORIGINATE
	post_signal(discovered_phones[target_phone], list("command"="tel_ring","caller_id"=friendly_name))

/// Receive the incoming call
/// STATE_WAITING -> STATE_ANSWER
/obj/machinery/networked/telephone/proc/receive_call(list/incoming_call)
	if(state != STATE_WAITING)
		CRASH("Failed to busy-signal a call on a phone that was not waiting.")
	active_caller = incoming_call
	state = STATE_ANSWER
	ring_loop.start()
	update_icon()

/// Accept the incoming call, Inform Originator.
/// STATE_ANSWER -> STATE_CONNECTED
/obj/machinery/networked/telephone/proc/accept_call()
	if(state != STATE_ANSWER)
		CRASH("Tried to accept a call on a phone that wasn't in STATE_ANSWER")
	//Handset in-hand, icon's already updated by grabbing the handset...
	ring_loop.stop()
	post_signal(active_caller[CALLER_NETID], list("command"="tel_ready")) //Inform originator we're ready.
	state = STATE_CONNECTED

/// Acknowledge accepted call
/// STATE_ORIGINATE -> STATE_CONNECTED
/obj/machinery/networked/telephone/proc/call_connected()
	if(state != STATE_ORIGINATE)
		CRASH("Tried to acknowledge a call on a phone that wasn't originating")
	state = STATE_CONNECTED

/// End call immediately
/// STATE_CONNECTED(handset onhook)/STATE_ORIGINATE(handset onhook)/STATE_ANSWER(packet) -> STATE_WAITING
/obj/machinery/networked/telephone/proc/drop_call()
	switch(state)
		if(STATE_CONNECTED,STATE_ORIGINATE) //Handset down, Reset equipment.
			post_signal(active_caller[CALLER_NETID], list("command"="tel_hup"))
		if(STATE_ANSWER) // WE got hanged up on, It's cleaner to put it here than use call_dropped
			ring_loop.stop()
			update_icon()
		else
			CRASH("Tried to drop a call in an invalid state ID#[state]")
	active_caller = null
	state = STATE_WAITING


/// Far side dropped us, Perform hangup stuff and wait until the handset is returned to fully reset and be ready to accept another call
/// STATE_CONNECTED -> STATE_HANGUP
/obj/machinery/networked/telephone/proc/call_dropped()
	if(state != STATE_CONNECTED)
		CRASH("Tried to drop a call on a phone that wasn't connected")
	active_caller = null
	hup_loop.start()
	state = STATE_HANGUP


/// Remote phone can't answer due to busy, do the sound and wait until the handset is returned to reset.
/// STATE_ORIGINATE -> STATE_FARBUSY
/obj/machinery/networked/telephone/proc/fuck_off_im_busy()
	if(state != STATE_ORIGINATE)
		CRASH("Tried to busy-bump a call on a phone that wasn't originating")
	busy_loop.start()
	active_caller = null //Drop the call, The other side did too.
	state = STATE_FARBUSY

/// We are listening to the buzzer telling us to hang up.
/// STATE_FARBUSY/STATE_CONNECTED -> STATE_WAITING
/obj/machinery/networked/telephone/proc/cleanup_residual_call()
	if(!(state == STATE_FARBUSY || state == STATE_HANGUP))
		CRASH("Attempted to cleanup a residual (busy ringback/hung up) call that wasn't actually residual!")
	busy_loop.stop()
	hup_loop.stop()
	//just in case
	active_caller = null
	state = STATE_WAITING //Just reset, the phone should be on-hook at this point.

/// UI
/obj/machinery/networked/telephone/proc/get_state_render()
	switch(state)
		if(STATE_WAITING)
			return "<span style='color:green'>WAITING</span>"
		if(STATE_ORIGINATE)
			return "<span style='color:orange'>RINGING</span>"
		if(STATE_ANSWER)
			return "<span style='color:orange'>INCOMING CALL</span>"
		if(STATE_CONNECTED)
			return "<span style='color:green'>CONNECTED</span>"
		if(STATE_HANGUP)
			return "<span style='color:red'>CALL TERMINATED</span>"
		if(STATE_FARBUSY)
			return "<span style='color:red'>STATION BUSY</span>"
		else
			return "<span style='color:pink'>INVALID STATE</span>"

/obj/machinery/networked/telephone/ui_interact(mob/user) //THIS IS GONNA BE RAW HTML FUCKERY, *SUE ME BITCHBOOOYY*
	. = ..()
	var/list/dat = list()
	dat += "<center><div>Handset ID \[<span class='statusDisplay' style='font-family: monospace;'>[net_id]</span>|<span class='statusDisplay' style='font-family: monospace;'>[friendly_name]</span>\]</div><br>"
	dat += "<hr>"
	dat += "Station State: [get_state_render()]<br>"
	dat += "<hr>"
	dat += "<table>"
	var/safe_to_call = (state == STATE_WAITING)
	for(var/station_name in discovered_phones)
		var/far_id = discovered_phones[station_name]
		dat += "<tr>"
		dat += "<th>[station_name]</th><th><span class='statusDisplay' style='font-family: monospace;'>[far_id]</span></th>"
		if(safe_to_call)
			dat += "<th><a href='?src=[REF(src)];call=[url_encode(station_name)]'>Call</a></th>"
		else
			dat += "<th><a class='linkOff'>Call</a></th>"
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
		if(handset_state != HANDSET_OFFHOOK)
			to_chat(usr, "You can't make a call without holding the phone!")
			return .
		if(state != STATE_WAITING)
			to_chat(usr, "You can't start a call right now!")
			return .
		place_call(url_decode(href_list["call"]))
	if(href_list["scan"])
		scan_for_stations()

#undef CALLER_NETID
#undef CALLER_NAME


/*
 * Handset
 */

/obj/item/p2p_phone_handset
	name = "phone handset"
	desc = "You talk into this."
	icon = 'goon/icons/obj/phones.dmi'
	icon_state = "handset"
	item_flags = ABSTRACT
	/// Owner phone
	var/obj/machinery/networked/telephone/callstation
	/// Have we manually muted the mic?
	var/mic_muted = FALSE

/obj/item/p2p_phone_handset/Destroy()
	if(!QDELETED(callstation))
		QDEL_NULL(callstation)
	return ..()

/obj/item/p2p_phone_handset/equipped(mob/user, slot)
	. = ..()
	if(!callstation)
		return
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, .proc/check_range)
	become_hearing_sensitive()//Start listening.

/obj/item/p2p_phone_handset/dropped(mob/user)
	. = ..()
	if(user)
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
		lose_hearing_sensitivity()//Stop listening.
		mic_muted = FALSE //And make sure we sync this state.
	if(callstation)
		if(user)
			to_chat(user, span_notice("[src] snaps back onto [callstation]."))
		snap_back()

/obj/item/p2p_phone_handset/attack_self(mob/user, modifiers)
	. = ..()
	if(.)
		return
	if(mic_muted)
		to_chat(user, span_notice("You press the mute button, the light turns off."))
		become_hearing_sensitive()
	else
		to_chat(user, span_notice("You press the mute button, a small red light glows from under it."))
		lose_hearing_sensitivity()
	mic_muted != mic_muted

/obj/item/p2p_phone_handset/examine(mob/user)
	. = ..()
	//mic mute
	if(mic_muted)
		. += span_warning("The mute button is glowing red.")
	else
		. += span_notice("The mute button is dark.")
	//Are we somehow missing our callstation?
	if(!callstation)
		. += span_boldwarning("It isn't connected to anything? Call a coder. Or a priest.")
		//Definitely a priest.

/obj/item/p2p_phone_handset/proc/check_range()
	SIGNAL_HANDLER

	if(!callstation)
		return
	if(!in_range(src,callstation))
		if(isliving(loc))
			var/mob/living/user = loc
			to_chat(user, span_warning("[callstation]'s cable overextends and come out of your hands!"))
		else
			visible_message(span_notice("[src] snap back onto [callstation]."))
		snap_back()

/obj/item/p2p_phone_handset/proc/snap_back()
	if(!callstation)
		return
	if(ismob(loc))
		var/mob/M = loc
		M.dropItemToGround(src, TRUE)
	forceMove(callstation)
	callstation.handset_statechange(HANDSET_ONHOOK)

/obj/item/p2p_phone_handset/Hear(message, atom/movable/speaker, message_langs, raw_message, radio_freq, spans, list/message_mods = list())
	// if(!IN_GIVEN_RANGE(src, speaker_location.speaker_location(), 1))
	// 	return
	. = ..() //The return value is never set.
	if(!IN_GIVEN_RANGE(src, speaker, 2))// Current tile and immediately adjacent.
		return //Too far away for us to care.
	//START SHAMELESS RADIO CARGOCULTING
	var/filtered_mods = list()
	if (message_mods[MODE_CUSTOM_SAY_EMOTE])
		filtered_mods[MODE_CUSTOM_SAY_EMOTE] = message_mods[MODE_CUSTOM_SAY_EMOTE]
		filtered_mods[MODE_CUSTOM_SAY_ERASE_INPUT] = message_mods[MODE_CUSTOM_SAY_ERASE_INPUT]
	if(message_mods[RADIO_EXTENSION] == MODE_L_HAND || message_mods[RADIO_EXTENSION] == MODE_R_HAND)
		// try to avoid being heard double
		if (loc == speaker && ismob(speaker))
			var/mob/M = speaker
			var/idx = M.get_held_index_of_item(src)
			// left hands are odd slots
			if (idx && (idx % 2) == (message_mods[RADIO_EXTENSION] == MODE_L_HAND))
				return

	talk_into(speaker, raw_message, , spans, language=message_language, message_mods=filtered_mods)
	//END SHAMELESS RADIO CARGOCULTING

/obj/item/p2p_phone_handset/talk_into(mob/M, input, channel, spans, datum/language/language, list/message_mods)
	. = ..()

//TODO: Prevent the user from walking away with the handset.

#undef STATE_WAITING
#undef STATE_ORIGINATE
#undef STATE_ANSWER
#undef STATE_CONNECTED
#undef STATE_HANGUP
#undef STATE_FARBUSY
