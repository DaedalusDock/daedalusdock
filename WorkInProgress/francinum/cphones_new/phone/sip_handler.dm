/datum/packet_handler/sip_registration
	/// Cooldown for sending the next keepalive/heartbeat to the exchange to keep registered.
	COOLDOWN_DECLARE(keepalive_timeout)
	/// Cooldown for registration. We will always attempt to re-register if we go off-hook.
	COOLDOWN_DECLARE(registration_timeout)

	VAR_PRIVATE/office_code
	VAR_PRIVATE/auth_name
	VAR_PRIVATE/auth_secret

	/// Our authentication refresh token, think of it as a second, temporary password.
	/// if null, we are not registered at all. Start trying to register again with slowly increasing backoff.
	VAR_PRIVATE/auth_refresh_token
	/// Exponential backoff factor.
	VAR_PRIVATE/backoff_factor = 0


	/// Address of our server.
	VAR_PRIVATE/server_address
	VAR_PRIVATE/master_netid

	/* Master Interface:
	 *
	 * output: receive_sip_packet(datum/signal/varname)
	 * > Receives a data-complete SIP signalling packet.
	 * d_addr is already set, so it should mostly be sent
	 * straight out of post_signal.
	 *
	 * control:
	 * New(extension, officecode, auth_secret)
	 * > Load map-varedit and autoconf information.
	 * The phone still has to 'boot' and register itself.
	 * This just provides it the correct information to start with.
	 *
	*/


/datum/packet_handler/sip_registration/New(_ext, _office, _auth)
	. = ..()
	auth_name = _ext
	auth_secret = _auth
	office_code = _office

/datum/packet_handler/sip_registration/process(delta_time)
	if(COOLDOWN_FINISHED())

/datum/packet_handler/sip_registration/receive_signal(datum/signal/signal)



