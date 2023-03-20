///The messaging type. Use this to pass text data around between components.
/obj/item/mcobject/messaging
	///The message we're prepared to send
	var/stored_message = MC_BOOL_TRUE

	///The message trigger field. Use MC_ADD_TRIGGER to utilize.
	var/trigger = MC_BOOL_TRUE

/obj/item/mcobject/messaging/Initialize(mapload)
	. = ..()
	MC_ADD_CONFIG(MC_CFG_OUTPUT_MESSAGE, set_output)

/obj/item/mcobject/messaging/proc/set_output(mob/user, obj/item/tool)
	var/msg = stripped_input(user, "Enter new message:", "Configure Component", stored_message)

	if(isnull(msg))
		return

	stored_message = msg
	to_chat(user, span_notice("You set [src]'s output message to [stored_message]"))
	return TRUE

/obj/item/mcobject/messaging/proc/set_trigger(mob/user, obj/item/tool)
	var/msg = stripped_input(user, "Enter trigger field:", "Configure Component", trigger)

	if(isnull(msg))
		return
	trigger = msg
	to_chat(user, span_notice("You set the trigger of [src] to [trigger]."))
	return TRUE

///Relay a message to our outputs.
/obj/item/mcobject/messaging/proc/fire(text, datum/mcmessage/relay)
	SHOULD_CALL_PARENT(TRUE)
	interface.Send(text, relay)

