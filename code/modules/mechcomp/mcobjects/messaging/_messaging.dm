///The messaging type. Use this to pass text data around between components.
/obj/item/mcobject/messaging
	///The message we're prepared to send
	var/message = MC_BOOL_TRUE

/obj/item/mcobject/messaging/Initialize(mapload)
	. = ..()
	MC_ADD_CONFIG(MC_CFG_OUTPUT_MESSAGE, set_output)

/obj/item/mcobject/messaging/proc/set_output(mob/user, obj/item/tool)
	var/msg = stripped_input(user, "Enter new message:", "Configure Component", message)

	if(isnull(msg))
		return

	message = msg
	to_chat(user, span_notice("Output message set to [message]"))
	return TRUE

///Relay our stored_message to all of our outputs
/obj/item/mcobject/messaging/proc/fire()
	SHOULD_CALL_PARENT(TRUE)
	interface.Send(message)

