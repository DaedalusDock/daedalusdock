/datum/mcinterface
	var/obj/item/mcobject/owner
	///A kv list of mcinterface:actname. Tracks open inputs as well as for garbage collection
	var/list/datum/mcinterface/trigger_inputs = list()
	///A kv list of mcinterface:actname
	var/list/datum/mcinterface/trigger_outputs = list()


/datum/mcinterface/New(obj/item/mcobject/_owner)
	owner = _owner
	RegisterSignal()

/datum/mcinterface/Destroy(force, ...)
	owner = null
	ClearConnections()
	return ..()

///Add an interface to our inputs, and add us to their outputs. Origin is an arg used to prevent an infinite loop of add/remove
/datum/mcinterface/proc/AddTriggerInput(datum/mcinterface/target, act, origin)
	if(origin == src)
		return
	origin ||= src
	SEND_SIGNAL(src, MCACT_REMOVE_INPUT, target)
	target.AddTriggerOutput(src, act, origin)
	trigger_inputs[target] = act

///Add an interface to our outputs, and add us to their inputs. Origin is an arg used to prevent an infinite loop of add/remove
/datum/mcinterface/proc/AddTriggerOutput(datum/mcinterface/target, act, origin)
	if(origin == src)
		return
	origin ||= src
	SEND_SIGNAL(src, MCACT_ADD_OUTPUT, target)
	target.AddTriggerInput(src, act, origin)
	trigger_outputs[target] = act

/datum/mcinterface/proc/ClearConnections()
	if(length(trigger_inputs) || length(trigger_outputs))
		. = TRUE
	for(var/datum/mcinterface/I as anything in trigger_inputs)
		RemoveTriggerInput(I)
	for(var/datum/mcinterface/I as anything in trigger_outputs)
		RemoveTriggerOutput(I)

///Remove an interface from our inputs, and remove us to their outputs. Origin is an arg used to prevent an infinite loop of add/remove
/datum/mcinterface/proc/RemoveTriggerInput(datum/mcinterface/target, origin)
	if(origin == src)
		return
	origin ||= src
	SEND_SIGNAL(src, MCACT_REMOVE_INPUT, target)
	target.RemoveTriggerOutput(src, origin)
	trigger_inputs -= target

///Remove an interface from our outputs, and remove us to their inputs. Origin is an arg used to prevent an infinite loop of add/remove
/datum/mcinterface/proc/RemoveTriggerOutput(datum/mcinterface/target, origin)
	if(origin == src)
		return
	origin ||= src
	SEND_SIGNAL(src, MCACT_REMOVE_OUTPUT, target)
	target.RemoveTriggerInput(src, origin)
	trigger_outputs -= target

///Send an mcmessage to our outputs
/*
/datum/mcinterface/proc/Send(datum/mcmessage/message)
	for(var/datum/mcinterface/I as anything in outputs)
		SEND_SIGNAL(I, MCACT_RECEIVE_MESSAGE, message, src)
*/

///Do our simple trigger to act on all our outputs
/datum/mcinterface/proc/SendOutputActs()
	for(var/datum/mcinterface/I as anything in trigger_outputs)
		var/obj/item/mcobject/O = I.owner
		call(O, O.inputs[trigger_outputs[I]])(src)
