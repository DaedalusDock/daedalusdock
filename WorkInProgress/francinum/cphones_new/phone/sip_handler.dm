/datum/packet_handler/sip_registration
	/// Cooldown for sending the next keepalive/heartbeat to the exchange to keep registered.
	COOLDOWN_DECLARE(keepalive_timeout)
	/// Cooldown for registration. We will always attempt to re-register if we go off-hook.
	COOLDOWN_DECLARE(registration_timeout)

	/// Office number to look for.
	VAR_PRIVATE/office_code
	/// Our extension number.
	VAR_PRIVATE/auth_name
	/// Our login secret.
	VAR_PRIVATE/auth_secret

	/// Our authentication refresh token, think of it as a second, temporary password.
	/// if null, we are not registered at all. Start trying to register again with slowly increasing backoff.
	VAR_PRIVATE/auth_refresh_token
	/// Exponential backoff factor.
	VAR_PRIVATE/backoff_factor = 0
	/// Secondary backoff factor for waiting for a ping. This curve starts shallow before getting very strong.
	VAR_PRIVATE/ping_backoff_factor = 0
	/// Reauth count, after some amount, just give up and assume de-registration.
	VAR_PRIVATE/reauth_attempts = 0

	/// Address of our server.
	VAR_PRIVATE/server_address
	/// Owner device address.
	VAR_PRIVATE/master_netid

	VAR_PRIVATE/datum/sip_call/current_call

	/// Scratch space for storing packet flow context keys.
	VAR_PRIVATE/list/sequence_keys

	/* Master Interface:
	 *
	 * output:
	 * receive_handler_update(datum/packet_handler/sender, datum/signal/signal, sip_state)
	 * > Receives a data-complete SIP signalling packet.
	 * d_addr is already set, so it should mostly be sent
	 * straight out of post_signal.
	 *
	 * > Can also send control state information via 'sip_state'
	 * as a list of 2 values, a code, and free additional data.
	 * list(SIP_STATE_CODE = $NUM, SIP_STATE_DATA = $WHATEVER)
	 *
	 *
	 * control:
	 * New(extension, officecode, auth_secret)
	 * > Load map-varedit and autoconf information.
	 * The phone still has to 'boot' and register itself.
	 * This just provides it the correct information to start with.
	 *
	 *
	 *
	*/


/datum/packet_handler/sip_registration/New(_master, _ext, _office, _auth)
	. = ..()
	auth_name = _ext
	auth_secret = _auth
	office_code = _office
	// Give us a random cooldown between 1 and 5 seconds in half-second increments. Just to spread out when these things fully wake up.
	COOLDOWN_START(src, registration_timeout, (rand(2,10)/2) SECONDS)

/datum/packet_handler/sip_registration/process(delta_time)
	// If we aren't registered and we're off cooldown for attempting to.
	if(!auth_refresh_token && COOLDOWN_FINISHED(src, registration_timeout))
		// Do we know which server to try to register to?
		if(!server_address)
			locate_server()
			return
		// If we do, try and connect to it.
		attempt_registration()
		return

	//We either have a token or the cooldown hasn't finished yet, if we do have one and the keepalive timeout is finished...
	else if(auth_refresh_token && COOLDOWN_FINISHED(src, keepalive_timeout))
		// If we've not tried this enough
		if(reauth_attempts < 10)
			do_keepalive()
		else
			// Give up.
			clear_registration()

// Send out a ping
/datum/packet_handler/sip_registration/proc/locate_server()

/datum/packet_handler/sip_registration/proc/attempt_registration()
	var/seq_key = rand(1000,5000)
	var/datum/signal/reg_packet = new(
		null,
		list(
			PACKET_DESTINATION_ADDRESS = master_netid,
			PACKET_FIELD_PROTOCOL = PACKET_PROTOCOL_SIP,
			PACKET_FIELD_VERB = PACKET_SIP_VERB_REGISTER,
			PACKET_SIP_FIELD_USER = auth_name,
			PACKET_SIP_FIELD_REGISTER_SECRET = auth_secret,
			PACKET_SIP_SEQUENCE_KEY = seq_key
		)
	)
	sequence_keys[seq_key] = list(master_netid, PACKET_SIP_VERB_REGISTER)
	master.receive_handler_packet(reg_packet)
	ping_backoff_factor++
	/* This factor will, after a few attmps, drastically slow down attempts to contact the exchange.
	 * https://www.desmos.com/calculator/hmctyrgrux
	 * For cases where the phone is physically disconnected from the exchange.
	 * These numbers were chosen through the advanced process of ass.pull()
	*/
	COOLDOWN_START(src, registration_timeout, (floor(0.5*(2.1**backoff_factor))) SECONDS)

/// Reset all state, start over.
/datum/packet_handler/sip_registration/proc/clear_registration()
	// Clear the registration.
	auth_refresh_token = null
	// Forget about our server.
	server_address = null
	// Reset our timeouts and scaling factors.
	ping_backoff_factor = 0
	backoff_factor = 0
	reauth_attempts = 0
	COOLDOWN_RESET(src, keepalive_timeout)
	COOLDOWN_RESET(src, registration_timeout)



/datum/packet_handler/sip_registration/proc/do_keepalive()
	var/datum/signal/reg_packet = new(
		null,
		list(
			PACKET_DESTINATION_ADDRESS = master_netid,
			PACKET_FIELD_PROTOCOL = PACKET_PROTOCOL_SIP,
			PACKET_FIELD_VERB = PACKET_SIP_VERB_REAUTH,
			PACKET_SIP_FIELD_USER = auth_name,
			PACKET_SIP_FIELD_AUTH_TOKEN = auth_refresh_token
		)
	)
	master.receive_handler_packet(reg_packet)
	// This does NOT get a backoff period, we re-attempt every 2 seconds for 20 seconds, and then give up, assuming de-registration.
	COOLDOWN_START(src, keepalive_timeout, 2 SECONDS)


/datum/packet_handler/sip_registration/receive_signal(datum/signal/signal)
	var/list/data = signal.data
	var/list/sequence_key = sequence_keys[data[PACKET_SIP_SEQUENCE_KEY]]

	if(data[PACKET_SIP_FIELD_CALLID] == current_call.call_id)
		current_call.receive_signal(signal)
		return

	//Were we talking to you?
	if(!sequence_key)
		// Are you here to start talking to us?
		if(data[PACKET_FIELD_VERB])
			incoming_conversation(data)
		else
			// Are you a ping reply?
			if(data[PACKET_CMD] == NET_COMMAND_PING_REPLY)
				#warn UNIMPLIMENTED: SERVER DISCOVERY
			return

	switch(sequence_keys[SEQ_KEY_VERB])
		if(PACKET_SIP_VERB_REGISTER)
			seq_handle_invite_reply(data, sequence_key)


	// Do you have a token for us?
	if((data[PACKET_SIP_FIELD_STATUS_CODE] == SIP_STATUS_OK) && (data[PACKET_SIP_FIELD_AUTH_TOKEN]))
		// Our registered server is issuing us an auth token, sweet.
		refresh_auth(data[PACKET_SIP_FIELD_AUTH_TOKEN])
		return

	// Do we have a token?
	if(!auth_refresh_token)
		//Non-OK from server before full auth? We probably did something wrong, Lock up and pass the cause up to the master to alert.
		if((data[PACKET_SIP_FIELD_STATUS_CODE] =! SIP_STATUS_OK) && (data[PACKET_SIP_FIELD_REASON]))
			COOLDOWN_START(src, registration_timeout, INFINITY)
			master.receive_handler_packet(src, null, list(SIP_STATE_REG_FAILURE, data[PACKET_SIP_FIELD_REASON]))
			return
		return

	// We have a registration, and the server isn't here to renew one. Do we have an active call? If so, pass the packet to it.
	if(current_call)
		current_call.receive_signal(signal)
		return
	// No current call, are they trying to place one?
	if((data[PACKET_FIELD_VERB] == PACKET_SIP_VERB_INVITE))
		incoming_call(signal)

	//Is this an *INCOMING* invite?
	if(data[PACKET_FIELD_VERB] == PACKET_SIP_VERB_ACKNOWLEDGE)

/// Incoming packets with a verb and no current sequence number.
/datum/packet_handler/sip_registration/proc/incoming_conversation(list/data)
	switch(data[PACKET_FIELD_VERB])
		// INVITE - Incoming Call
		if(PACKET_SIP_VERB_INVITE)
			incoming_call(data)
			sequence_keys[data[PACKET_SIP_SEQUENCE_KEY]] = list(data[PACKET_SOURCE_ADDRESS], PACKET_SIP_VERB_INVITE)
			return
		if(PACKET_SIP_VERB_SESSION)


/datum/packet_handler/sip_registration/proc/seq_handle_invite_reply(list/data, list/seq_key)

/// Fully refresh the keepalive timeout, usually as part of initial registration or during a timeout.
/datum/packet_handler/sip_registration/proc/refresh_auth(new_token)
	auth_refresh_token = new_token
	ping_backoff_factor = 0
	backoff_factor = 0
	reauth_attempts = 0
	COOLDOWN_START(src, keepalive_timeout, (2 MINUTES)+(rand(0,60) SECONDS))



/// Place a call to a designated extension, Sets the active call, and sends an INVITE packet out the master.
/datum/packet_handler/sip_registration/proc/place_call(destination)
	if(current_call)
		CRASH("what")
	current_call = new(
		src,
		auth_name,
		destination,
		server_address,
	)
	// Ask the call datum to 'place' the call, and give us the invite packet to send off.
	var/datum/signal/invite = current_call.place_call()
	master.receive_handler_packet(src, invite)

/datum/packet_handler/sip_registration/proc/incoming_call(list/data)
	current_call = new(
		src,
		auth_name,
		data[PACKET_SIP_INVITE_FIELD_FROM],
		server_address, //You think I'm gonna bother with direct media? You're high as fuck.
		data[PACKET_SIP_FIELD_CALLID]
	)
	//master.receive_handler_packet(src, invite)
