/obj/item/mcobject/messaging/relay
	name = "relay component"
	base_icon_state = "comp_relay"

	var/replace_message = FALSE

/obj/item/mcobject/messaging/relay/Initialize(mapload)
	. = ..()
	MC_ADD_INPUT("relay", relay)
	MC_ADD_CONFIG("Toggle Message Replacement", toggle_replace)

/obj/item/mcobject/messaging/relay/examine(mob/user)
	. = ..()
	. += span_notice("Message Replacement is [replace_message ? "on" : "off"].")

/obj/item/mcobject/messaging/relay/proc/relay(datum/mcmessage/input)
	flick("[anchored ? "u":""]comp_relay1", src)
	if(replace_message)
		fire(stored_message, input)
	else
		fire(input)

/obj/item/mcobject/messaging/relay/proc/toggle_replace(mob/user, obj/item/tool)
	replace_message = !replace_message
	to_chat(user, span_notice("You set [src] to [replace_message ? "replace the incoming message" : "relay the incoming message"]."))
	return TRUE
