///The messaging type. Use this to pass text data around between components.
/obj/item/mcobject/messaging
	///The message we're prepared to send
	var/message = MC_BOOL_TRUE

/obj/item/mcobject/messaging/Initialize(mapload)
	. = ..()
	configs += MC_CFG_OUTPUT_MESSAGE

/obj/item/mcobject/messaging/config_act(mob/user, action, obj/item/tool)
	. = ..()
	if(action == MC_CFG_OUTPUT_MESSAGE)
		var/msg = stripped_input(user, "Enter new message:", "Configure Component", message)

		if(isnull(msg))
			return

		message = msg
		to_chat(user, span_notice("Output message set to [message]"))
		return

///Relay our stored_message to all of our outputs
/obj/item/mcobject/messaging/proc/fire()
	SHOULD_CALL_PARENT(TRUE)
	interface.Send(message)

