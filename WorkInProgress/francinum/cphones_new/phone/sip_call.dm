// Holds state about an individual SIP call.

/datum/sip_call

	/// The controlling SIP handler.
	var/datum/sip_handler/owner

	/// Are we originating this call?
	/// Behaviour basically flips if this is false.
	var/originating = TRUE

	/// Randomly generated call ID. Used for tracing and for identification. md5(world.time+ref(src))
	var/call_id

	/// ORIGINATE: The number we are calling.
	/// ANSWER: The number calling us.
	var/calling_number

	var/our_number

	/// Server address
	var/target_addr

	/* Call Setup */
	/// ORIGINATE: Call is being set up, Play no comfort noises. If timeout, cancel and terminate self.
	#define CALLSTATE_SETUP "CALLING"
	/// ORIGINATE: Far side is ringing, play ringback.
	/// ANSWER: We are ringing, Instruct the phone to start ringing.
	#define CALLSTATE_RINGING "CALL_RINGING"


	/// We are talking, Stop noises, instruct the SIP handler to get everything ready for audio.
	#define CALLSTATE_ESTABLISHED "CALL_ESTABLISHED"

	/* Call Teardown/Error */
	/// The connection was closed, check cause_code and go from there.
	#define CALLSTATE_TERMINATE "CALL_TERMINATE"

	/// Current call state.
	var/state = null

	/// Q.850 Cause Code (Beats coming up with my own system) for which our call was terminated.
	var/cause_code

	// Request data by cseq value
	var/list/sequence_keys
	/* Inside a Dialog, sequence numbers operate differently.
	 * The starting value is explicitly undefined, however, we start at 1 for simplicity.
	 *
	 */
	var/current_seq_number = 1
/datum/sip_call/New(_master, _our_number, _calling_number, _target_addr, _call_id)
	. = ..()
	call_id = _call_id || md5("[world.time][ref(src)]")
	our_number = _our_number
	calling_number = _calling_number
	target_addr = _target_addr
	if(_call_id)
		// Being supplied a call ID means we are NOT originating.
		originating = FALSE
	requests = list()


// gods nonexistent jump table
/datum/sip_call/receive_signal(datum/signal/signal)
	// We will only receive signalling packets matching our Call ID


	// Insert a general handler here maybe? Probably unnecessary.
	switch(state)
		if(CALLSTATE_SETUP)
			process_setup(signal)
		if(CALLSTATE_RINGING)
			process_ringing(signal)
		if(CALLSTATE_ESTABLISHED)
			process_established(signal)
		if(CALLSTATE_TERMINATE)
			process_terminate(signal)
	. = ..()

// https://www.tutorialspoint.com/session_initiation_protocol/images/sip_call_flow.jpg

/datum/sip_call/proc/process_setup(datum/signal/signal)
	var/list/data = signal.data



/datum/sip_call/proc/process_ringing(datum/signal/signal)
	//

/datum/sip_call/proc/process_established(datum/signal/signal)

/datum/sip_call/proc/process_terminate(datum/signal/signal)

//
/datum/sip_call/proc/place_call(destination = calling_number)
	if(!calling_number)
		calling_number = destination
	var/datum/signal/invite = new(
		null,
		list(
			PACKET_DESTINATION_ADDRESS = target_addr,
			PACKET_FIELD_PROTOCOL = PACKET_PROTOCOL_SIP,
			PACKET_FIELD_VERB = PACKET_SIP_VERB_INVITE,
			PACKET_SIP_INVITE_FIELD_FROM = our_number,
			PACKET_SIP_INVITE_FIELD_TO = calling_number,
			PACKET_SIP_FIELD_CALLID = call_id
		)
	)
	return invite
