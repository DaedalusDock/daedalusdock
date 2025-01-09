//active_call indexes
#define CALLER_NETID 1
#define CALLER_NAME  2
//states
///Idle
#define STATE_WAITING   0
///Calling remote station
#define STATE_ORIGINATE 1
///Being called by remote station
#define STATE_ANSWER    2
///Call active
#define STATE_CONNECTED   3
///Far side hung up
#define STATE_HANGUP    4
///Far side busy, Temporary state
#define STATE_FARBUSY   5
//handset states
///Handset is on the phone.
#define HANDSET_ONHOOK  0
///Handset is off the phone, but still around
#define HANDSET_OFFHOOK 1
///Handset missing or in invalid state
#define HANDSET_MISSING 2

#define X_TELEPHONE_TESTING

#ifdef X_TELEPHONE_TESTING
#define TEL_TEST(str) message_admins("TELEPHONE: [str]")
#else
#define TEL_TEST(str) //Ignore it.
#endif

/obj/machinery/telephone
	name = "phone - UNINITIALIZED"
	desc = "It's a phone. You pick it up, select from the list of other phones, and scream at the other person. The voice quality isn't all that great."
	icon = 'goon/icons/obj/phones.dmi'
	icon_state = "phone"

	net_class = NETCLASS_P2P_PHONE
	network_flags = NETWORK_FLAGS_STANDARD_CONNECTION
	///friendly_name:netid
	var/list/discovered_phones
	/// The 'common name' of the station. Used in the UI.
	var/friendly_name = null
	/// Name 'placard', such as 'Special Hotline', gets appended to the end.
	var/placard_name
	/// Do we show netaddrs in the phone UI, or just the names?
	var/show_netids = FALSE

	/// list(netaddr,friendly_name) of active call
	var/list/active_caller
	var/state = STATE_WAITING
	var/handset_state = HANDSET_ONHOOK
	var/obj/item/p2p_phone_handset/handset
	var/datum/looping_sound/telephone/ring/ring_loop
	var/datum/looping_sound/telephone/busy/busy_loop
	var/datum/looping_sound/telephone/busy/hangup/hup_loop
	var/datum/looping_sound/telephone/ring/outgoing/outring_loop
	COOLDOWN_DECLARE(scan_cooldown)

/obj/machinery/telephone/Initialize(mapload)
	//These need to be above the supercall for color reasons
	handset = new(src)
	handset.callstation = src
	handset.add_atom_colour(color, FIXED_COLOUR_PRIORITY)
	. = ..()
	//Parent these to the handset, but let US manage them.
	ring_loop = new(handset)
	busy_loop = new(handset)
	hup_loop = new(handset)
	outring_loop = new(handset)
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/telephone/LateInitialize()
	. = ..()
	if(!friendly_name)
		friendly_name = get_area(src)
		friendly_name = format_text(friendly_name:name) //~
	recalculate_name()

///Recalculate our name.
/obj/machinery/telephone/proc/recalculate_name()
	ping_addition = list("user_id"=friendly_name) //Preload this so we can staple this to the ping packet.
	name = "phone - [friendly_name][placard_name ? " - [placard_name]" : null]"

/obj/machinery/telephone/Destroy()
	if(!QDELETED(handset))
		if(handset_state == HANDSET_OFFHOOK)
			var/M = get(handset, /mob)
			remove_handset(M)
		QDEL_NULL(handset)
	return ..()

/obj/machinery/telephone/update_icon()
	if(handset_state == HANDSET_ONHOOK)
		if(state == STATE_ANSWER)
			icon_state = "phone_ringing"
		else
			icon_state = "phone"
	else
		icon_state = "phone_answered"
	return ..()

//Handset management

/obj/machinery/telephone/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(handset_state == HANDSET_ONHOOK)
		toggle_handset(user)

/obj/machinery/telephone/attackby(obj/item/weapon, mob/user, params)
	. = ..()
	if(weapon == src.handset)// Impolite hangup.
		if(handset_state == HANDSET_ONHOOK)
			CRASH("Tried to return a handset that was already on-hook???")
		toggle_handset(user) //Can't really happen if handset is on-hook.

/// Toggle the state of the handset.
/obj/machinery/telephone/proc/toggle_handset(mob/user)
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

/obj/machinery/telephone/proc/remove_handset(mob/user)//this prevent the bug with the handset when the phone move stole the i stole this from defib code is this funny yet
	if(ismob(handset.loc))
		var/mob/M = handset.loc
		M.dropItemToGround(handset, TRUE)
	return


/// Process the fact that the handset has changed states.
/obj/machinery/telephone/proc/handset_statechange(newstate)
	if(handset_state == newstate)
		return //This used to crash, fuck it, it's fine to let it slide.
	if(handset_state == HANDSET_MISSING)
		return //Makes no sense.
	switch(handset_state)
		if(HANDSET_ONHOOK)//We're taking the phone.
			playsound(src, 'goon/sounds/phone/pick_up.ogg', 50, extrarange=MEDIUM_RANGE_SOUND_EXTRARANGE)
			if(state == STATE_ANSWER)// Do we have a call waiting?
				accept_call()
			handset_state = HANDSET_OFFHOOK
			update_icon()

		if(HANDSET_OFFHOOK)//Returning the phone
			playsound(src, 'goon/sounds/phone/hang_up.ogg', 50, extrarange=MEDIUM_RANGE_SOUND_EXTRARANGE)
			handset_state = HANDSET_ONHOOK
			update_icon()
			if(state == STATE_WAITING)//We aren't doing anything more.
				return
			if(active_caller)// Do we have an active call? Ringing or not. If so, drop it.
				drop_call()
				return
			//else (We are in hangup/farbusy, We need to clean up)
			cleanup_residual_call()



/obj/machinery/telephone/multitool_act(mob/living/user, obj/item/tool)
	var/static/list/options_list = list("Set Caller ID", "Set Placard", "Reconnect to terminal", "Toggle Address Display")
	var/selected = input(user, null, "Reconfigure Station", null) as null|anything in options_list
	switch(selected)
		if("Set Caller ID")
			var/new_friendly_name = input(user, "New Name?", "Renaming [friendly_name]", friendly_name) as null|text
			if(!new_friendly_name)
				return TOOL_ACT_TOOLTYPE_SUCCESS
			friendly_name = new_friendly_name
			recalculate_name()

		if("Set Placard")
			var/new_placard_name = input(user, "New Placard?", "Re-writing [placard_name]", placard_name) as null|text
			if(!new_placard_name)
				return TOOL_ACT_TOOLTYPE_SUCCESS
			placard_name = new_placard_name

		if("Reconnect to terminal")
			switch(link_to_jack()) //Just in case something stupid happens to the jack.
				if(NETJACK_CONNECT_SUCCESS)
					to_chat(user, span_notice("Reconnect successful."))
				if(NETJACK_CONNECT_CONFLICT)
					to_chat(user, span_warning("Terminal connection conflict, something is already connected!"))
				if(NETJACK_CONNECT_NOTSAMETURF)
					to_chat(user, span_boldwarning("Reconnect failed! Your terminal is somehow not on the same tile??? Call a coder!"))
				if(NETJACK_CONNECT_NOT_FOUND)
					to_chat(user, span_warning("No terminal found!"))
				else
					to_chat(user, span_boldwarning("Reconnect failed, Invalid error code, call a coder!"))

		if("Toggle Address Display")
			show_netids = !show_netids
			if(show_netids)
				to_chat(user, span_notice("You enabled the display of network IDs."))
			else
				to_chat(user, span_notice("You disabled the display of network IDs."))
		//else fall through
	return TOOL_ACT_TOOLTYPE_SUCCESS




//Call Network Management

/obj/machinery/telephone/proc/scan_for_stations()
	set waitfor = FALSE //this is probably bad
	if(!COOLDOWN_FINISHED(src,scan_cooldown))
		return //Chill out, bro.
	discovered_phones = list() //Trash the existing list.
	post_signal(create_signal(NET_ADDRESS_PING, list("filter"=net_class)))
	COOLDOWN_START(src,scan_cooldown,10 SECONDS)
	sleep(2 SECONDS)
	updateUsrDialog()

/obj/machinery/telephone/receive_signal(datum/signal/signal)
	. = ..()
	if(. == RECEIVE_SIGNAL_FINISHED)//Handled by default.
		return
	//Ping response handled in parent.
	switch(signal.data[PACKET_CMD])
		if(NET_COMMAND_PING_REPLY)//Add new phone to database
			if(signal.data["netclass"] == NETCLASS_P2P_PHONE) //Another phone!
				discovered_phones[signal.data[PACKET_SOURCE_ADDRESS]]=signal.data["user_id"]
				return RECEIVE_SIGNAL_FINISHED
		if("tel_ring")//Incoming ring
			if(active_caller || handset_state == HANDSET_OFFHOOK)//We're either calling, or about to call, Just tell them to fuck off.
				post_signal(create_signal(signal.data[PACKET_SOURCE_ADDRESS],list(PACKET_CMD="tel_busy"))) //Busy signal, Reject call.
				return RECEIVE_SIGNAL_FINISHED
			receive_call(list(signal.data[PACKET_SOURCE_ADDRESS],signal.data["caller_id"]))
			return RECEIVE_SIGNAL_FINISHED
		if("tel_ready")//Remote side pickup
			if(active_caller && signal.data[PACKET_SOURCE_ADDRESS] == active_caller[CALLER_NETID])// Ensure the packet is sensible
				call_connected()
				return RECEIVE_SIGNAL_FINISHED
		if("tel_busy")//Answering station busy
			if(active_caller && signal.data[PACKET_SOURCE_ADDRESS] == active_caller[CALLER_NETID])// Ensure the packet is sensible
				fuck_off_im_busy()
				return RECEIVE_SIGNAL_FINISHED
		if("tel_hup")//Remote side hangup
			if(active_caller && signal.data[PACKET_SOURCE_ADDRESS] == active_caller[CALLER_NETID])// Ensure the packet is sensible
				switch(state)
					if(STATE_ANSWER)
						drop_call()// Call never connected, just reset.
					if(STATE_CONNECTED)
						call_dropped()
					else
						return RECEIVE_SIGNAL_FINISHED// This makes no sense.
		if("tel_voicedata")
			if(active_caller && signal.data["s_addr"] == active_caller[CALLER_NETID])// Ensure the packet is sensible
				if(state != STATE_CONNECTED)
					return RECEIVE_SIGNAL_FINISHED//No.
				handset.handle_voicedata(signal)
				return RECEIVE_SIGNAL_FINISHED


// Telephone State Machine Hellscape
// Welcome to pain! : https://file.house/wRdQ.png

/// Register a new call
/// STATE_WAITING -> STATE_ORIGINATE
/obj/machinery/telephone/proc/place_call(target_phone)
	if(!target_phone || !discovered_phones[target_phone])
		return //Who? Or more likely: HREF fuckery.
	active_caller = list(target_phone, discovered_phones[target_phone])
	state = STATE_ORIGINATE
	post_signal(create_signal(target_phone, list("command"="tel_ring","caller_id"=friendly_name)))
	outring_loop.start()
	update_icon()

/// Receive the incoming call
/// STATE_WAITING -> STATE_ANSWER
/obj/machinery/telephone/proc/receive_call(list/incoming_call)
	if(state != STATE_WAITING)
		CRASH("Failed to busy-signal a call on a phone that was not waiting.")
	active_caller = incoming_call
	state = STATE_ANSWER
	ring_loop.start()
	update_icon()

/// Accept the incoming call, Inform Originator.
/// STATE_ANSWER -> STATE_CONNECTED
/obj/machinery/telephone/proc/accept_call()
	if(state != STATE_ANSWER)
		CRASH("Tried to accept a call on a phone that wasn't in STATE_ANSWER")
	//Handset in-hand, icon's already updated by grabbing the handset...
	ring_loop.stop()
	post_signal(create_signal(active_caller[CALLER_NETID], list("command"="tel_ready"))) //Inform originator we're ready.
	state = STATE_CONNECTED
	update_icon()

/// Acknowledge accepted call
/// STATE_ORIGINATE -> STATE_CONNECTED
/obj/machinery/telephone/proc/call_connected()
	if(state != STATE_ORIGINATE)
		CRASH("Tried to acknowledge a call on a phone that wasn't originating")
	state = STATE_CONNECTED
	outring_loop.stop()
	handset.audible_message(span_notice("\the [handset] stops ringing. The other side picked up."), hearing_distance=1)
	update_icon()

/// End call immediately
/// STATE_CONNECTED(handset onhook)/STATE_ORIGINATE(handset onhook)/STATE_ANSWER(packet) -> STATE_WAITING
/obj/machinery/telephone/proc/drop_call()
	switch(state)
		if(STATE_CONNECTED,STATE_ORIGINATE) //Handset down, Reset equipment.
			post_signal(create_signal(active_caller[CALLER_NETID], list("command"="tel_hup")))
			outring_loop.stop()
		if(STATE_ANSWER) // WE got hanged up on, It's cleaner to put it here than use call_dropped
			ring_loop.stop()
		else
			CRASH("Tried to drop a call in an invalid state ID#[state]")
	active_caller = null
	state = STATE_WAITING
	update_icon()


/// Far side dropped us, Perform hangup stuff and wait until the handset is returned to fully reset and be ready to accept another call
/// STATE_CONNECTED -> STATE_HANGUP
/obj/machinery/telephone/proc/call_dropped()
	if(state != STATE_CONNECTED)
		CRASH("Tried to drop a call on a phone that wasn't connected")
	active_caller = null
	hup_loop.start()
	state = STATE_HANGUP
	handset.audible_message(span_warning("\the [handset] beeps in annoyance. The other side hung up."), hearing_distance=1)
	update_icon()


/// Remote phone can't answer due to busy, do the sound and wait until the handset is returned to reset.
/// STATE_ORIGINATE -> STATE_FARBUSY
/obj/machinery/telephone/proc/fuck_off_im_busy() //busy_ringback in diagram
	if(state != STATE_ORIGINATE)
		CRASH("Tried to busy-bump a call on a phone that wasn't originating")
	busy_loop.start()
	outring_loop.stop()
	active_caller = null //Drop the call, The other side never even knew about us.
	state = STATE_FARBUSY
	handset.audible_message(span_warning("\the [handset] beeps in annoyance. The other side is busy."), hearing_distance=1)
	update_icon()

/// We are listening to the buzzer telling us to hang up.
/// STATE_FARBUSY/STATE_HANGUP -> STATE_WAITING
/obj/machinery/telephone/proc/cleanup_residual_call()
	if(!(state == STATE_FARBUSY || state == STATE_HANGUP))
		CRASH("Attempted to cleanup a residual (busy ringback/hung up) call that wasn't actually residual!")
	busy_loop.stop()
	hup_loop.stop()
	//just in case
	active_caller = null
	state = STATE_WAITING //Just reset, the phone should be on-hook at this point.
	update_icon()

/// UI
/obj/machinery/telephone/proc/get_state_render()
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
			return "<span style='color:pink'>INVALID STATE [state]</span>"

/obj/machinery/telephone/ui_interact(mob/user) //THIS IS GONNA BE RAW HTML FUCKERY, *SUE ME BITCHBOOOYY*
	. = ..()
	var/list/dat = list()
	dat += "<center><div>Handset ID \["
	if(show_netids)
		dat += "<span class='statusDisplay' style='font-family: monospace;'>[net_id]</span>|"
	dat += "<span class='statusDisplay' style='font-family: monospace;'>[friendly_name]</span>\]</div><br>"
	dat += "<hr>"
	dat += "Station State: [get_state_render()]<br>"
	dat += "<hr>"
	dat += "<table>"
	var/safe_to_call = (state == STATE_WAITING)
	for(var/far_id in discovered_phones)
		var/station_name = discovered_phones[far_id]
		dat += "<tr>"
		dat += "<th>[station_name]</th>"
		if(show_netids)
			dat += "<th><span class='statusDisplay' style='font-family: monospace;'>[far_id]</span></th>"
		if(safe_to_call)
			dat += "<th><a href='?src=[REF(src)];call=[url_encode(far_id)]'>Call</a></th>" //This should no longer technically *need* to be url encoded, but we're doing this just to be safe.
		else
			dat += "<th><a class='linkOff'>Call</a></th>"
		dat += "</tr>"
	dat += "</table>"
	dat += "<hr>"
	dat += "<a href='?src=[REF(src)];scan=1'>Scan</a></center>"

	var/datum/browser/popup = new(user, "phonepad", "Phone", 500, 600)
	popup.set_content(dat.Join())
	popup.open()

/obj/machinery/telephone/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	if(href_list["call"]) //Start call
		if(handset_state != HANDSET_OFFHOOK)
			to_chat(usr, span_warning("You can't make a call without holding the phone!"))
			return .
		if(state != STATE_WAITING)
			to_chat(usr, span_warning("You can't start a call right now!"))
			return .
		place_call(url_decode(href_list["call"]))
	if(href_list["scan"])
		scan_for_stations()




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
	var/obj/machinery/telephone/callstation
	/// Have we manually muted the mic?
	var/mic_muted = FALSE

/*
 * State handling boilerplate
 */

/obj/item/p2p_phone_handset/Destroy()
	if(!QDELETED(callstation))
		QDEL_NULL(callstation)
	return ..()

/obj/item/p2p_phone_handset/equipped(mob/user, slot)
	. = ..()
	if(!callstation)
		return
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(check_range))
	become_hearing_sensitive()//Start listening.

/obj/item/p2p_phone_handset/unequipped(mob/user)
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
	mic_muted = !mic_muted

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
	if(equipped_to)
		equipped_to.dropItemToGround(src, TRUE)
	forceMove(callstation)
	callstation.handset_statechange(HANDSET_ONHOOK)

/*
 * Audio Data Bullshit
 */

/obj/item/p2p_phone_handset/Hear(message, atom/movable/speaker, message_langs, raw_message, radio_freq, spans, list/message_mods = list(), sound_loc, message_range)
	if(callstation.state != STATE_CONNECTED || speaker == src) //Either disconnected, or we're hearing ourselves.
		return //This is far cheaper than a range check.
	var/atom/movable/checked_thing = sound_loc || speaker //If we have a location, we care about that, otherwise we're speaking directly from something.
	if(!IN_GIVEN_RANGE(src, checked_thing, 1))
		return
	. = ..() //The return value is never set, but we call and keep it anyways.
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

	talk_into(speaker, raw_message, , spans, language=message_langs, message_mods=filtered_mods)
	//END SHAMELESS RADIO CARGOCULTING

/obj/item/p2p_phone_handset/talk_into(atom/movable/talking_movable, message, channel, list/spans, datum/language/language, list/message_mods)
	//We can skip radio's restrained check because we aren't push-to-talk.

	if(callstation.state != STATE_CONNECTED)
		return //Still no use bothering if we aren't connected.

	if(!spans)
		spans = list(talking_movable.speech_span)
	if(!language)
		language = talking_movable.get_selected_language()

	if(istype(language, /datum/language/visual))
		return

	INVOKE_ASYNC(src, PROC_REF(talk_into_impl), talking_movable, message, channel, spans.Copy(), language, message_mods)
	return ITALICS | REDUCE_RANGE

/obj/item/p2p_phone_handset/proc/talk_into_impl(atom/movable/talking_movable, message, channel, list/spans, datum/language/language, list/message_mods)
	if(!callstation)
		return //Nothing but garbage noise.
	if(!talking_movable || !message)
		return //But nobody spoke.
	if(mic_muted)
		return //One day the voice stopped.
	if(!talking_movable.IsVocal())
		return //No voice to order a pizza.
	if(callstation.state != STATE_CONNECTED)
		return //Are we . . .   Connected?

	// Yes, we are. Start cramming shit into a radio packet and tell our callstation to post it.
	// Is it a bad idea for the phone to be handling it? Probably. I think it's best to just have
	// all the speech related code on the handset, with the callstation dealing with state and shit.

	//The third var is the 'radio'. It's null. Go fuck yourself.
	var/atom/movable/virtualspeaker/v_speaker = new(null, talking_movable, null)
	if(isliving(talking_movable))
		v_speaker.voice_type = talking_movable:voice_type


	//Bundle up what we care about.
	var/datum/signal/v_signal = new(src, null, TRANSMISSION_WIRE)
	v_signal.has_magic_data = MAGIC_DATA_INVIOLABLE //We're sending a virtual speaker. This packet MUST be discarded.
	v_signal.data[PACKET_SOURCE_ADDRESS] = null  //(Set by post_signal), Just setting it to null means it's always first in the list.
	v_signal.data[PACKET_DESTINATION_ADDRESS] = callstation.active_caller[CALLER_NETID]
	v_signal.data["command"] = "tel_voicedata"
	v_signal.data["virtualspeaker"] = v_speaker //This is a REAL REFERENCE. Packet MUST be discarded.
	v_signal.data["message"] = message
	v_signal.data["spans"] = spans
	v_signal.data["language"] = language
	v_signal.data["message_mods"] = message_mods

	//Send it off to the next phone.
	callstation.post_signal(v_signal)
//Finally, the last steps...

/// Receive a voice packet from the callstation. These are just transparently passed to us.
/// This replicates the behaviour of `send_speech`, since we're being passed all the data in a signal.
/obj/item/p2p_phone_handset/proc/handle_voicedata(datum/signal/v_signal)
	if(!v_signal)
		CRASH("Handset was asked to handle a packet that didn't exist.")
	//cache for sanic speed :3
	var/list/v_sig_data = v_signal.data
	var/list/radio_bullshit_override = list("span"="radio", "name"=callstation.active_caller[CALLER_NAME])

	var/atom/movable/virtualspeaker/admission_of_defeat = v_sig_data["virtualspeaker"]
	var/sound/funnysound
	if(admission_of_defeat.voice_type)
		var/funnysound_index = copytext_char(v_sig_data["message"], -1)
		switch(funnysound_index)
			if("?")
				funnysound = voice_type2sound[admission_of_defeat.voice_type]["?"]
			if("!")
				funnysound = voice_type2sound[admission_of_defeat.voice_type]["!"]
			else
				funnysound = voice_type2sound[admission_of_defeat.voice_type][admission_of_defeat.voice_type]


	playsound(src, funnysound || 'modular_pariah/modules/radiosound/sound/radio/syndie.ogg', funnysound ? 300 : 30, TRUE, SHORT_RANGE_SOUND_EXTRARANGE, falloff_exponent = 0)
	var/rendered = compose_message(v_sig_data["virtualspeaker"], v_sig_data["language"], v_sig_data["message"], radio_bullshit_override, v_sig_data["spans"], v_sig_data["message_mods"])
	for(var/atom/movable/hearing_movable as anything in get_hearers_in_view(2, src)-src)
		if(!hearing_movable)//theoretically this should use as anything because it shouldnt be able to get nulls but there are reports that it does.
			stack_trace("somehow theres a null returned from get_hearers_in_view() in send_speech!")
			continue

		hearing_movable.Hear(rendered, v_sig_data["virtualspeaker"], v_sig_data["language"], v_sig_data["message"], radio_bullshit_override, v_sig_data["spans"], v_sig_data["message_mods"], speaker_location(), message_range = INFINITY)


#undef STATE_WAITING
#undef STATE_ORIGINATE
#undef STATE_ANSWER
#undef STATE_CONNECTED
#undef STATE_HANGUP
#undef STATE_FARBUSY
#undef CALLER_NETID
#undef CALLER_NAME
