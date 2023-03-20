/datum/mcinterface
	var/obj/item/mcobject/owner

	///A list of mcinterfaces that we are recieving from
	var/list/datum/mcinterface/inputs = list()
	///A list of mcinterfaces that we are outputting to
	var/list/datum/mcinterface/outputs = list()

/datum/mcinterface/New(obj/item/mcobject/_owner)
	owner = _owner
	RegisterSignal()

/datum/mcinterface/Destroy(force, ...)
	owner = null
	ClearConnections()
	return ..()

/datum/mcinterface/proc/ClearConnections()
	if(length(inputs) || length(outputs))
		. = TRUE

	for(var/datum/mcinterface/I as anything in inputs)
		RemoveInput(I)
	for(var/datum/mcinterface/I as anything in outputs)
		RemoveOutput(I)

////
////// MESSAGES
////

///Add an interface to our inputs, and add us to their outputs. Origin is an arg used to prevent an infinite loop of add/remove
/datum/mcinterface/proc/AddInput(datum/mcinterface/target, act, origin)
	if(origin == src)
		return
	origin ||= src
	target.AddOutput(src, act, origin)
	inputs[target] = act

///Add an interface to our outputs, and add us to their inputs. Origin is an arg used to prevent an infinite loop of add/remove
/datum/mcinterface/proc/AddOutput(datum/mcinterface/target, act, origin)
	if(origin == src)
		return
	origin ||= src
	target.AddInput(src, act, origin)
	outputs[target] = act

///Remove an interface from our inputs, and remove us from their outputs. Origin is an arg used to prevent an infinite loop of add/remove
/datum/mcinterface/proc/RemoveInput(datum/mcinterface/target, origin)
	if(origin == src)
		return
	origin ||= src
	target.RemoveOutput(src, origin)
	inputs -= target

///Remove an interface from our outputs, and remove us from their inputs. Origin is an arg used to prevent an infinite loop of add/remove
/datum/mcinterface/proc/RemoveOutput(datum/mcinterface/target, origin)
	if(origin == src)
		return
	origin ||= src
	target.RemoveInput(src, origin)
	outputs -= target

///Send an mcmessage to our outputs
/datum/mcinterface/proc/Send(datum/mcmessage/message)
	SHOULD_NOT_SLEEP(TRUE)
	if(isnull(message))
		CRASH("Ahhhhhh null message aaaaaahhhhhh (dies)")

	if(istext(message))
		message = MC_WRAP_MESSAGE(message)

	if(message.CheckSender(src))
		return FALSE

	message.AddSender(src)

	for(var/datum/mcinterface/I as anything in outputs)
		var/action = SEND_SIGNAL(I, MCACT_PRE_RECEIVE_MESSAGE, message)
		//Note: a target not handling a signal returns 0.
		if(action == MCSEND_RETURN) //The component wants signal processing to stop NOW
			return .
		if(action == MCSEND_CANCEL) //The component wants this signal to be skipped
			continue
		var/obj/item/mcobject/O = I.owner
		call(O, O.inputs[outputs[I]])(message.Copy())
		. = 1
		if(action == MCSEND_RETURN_AFTER) //The component wants signal processing to stop AFTER this signal
			return .
	return .
