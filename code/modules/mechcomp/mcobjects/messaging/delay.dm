/obj/item/mcobject/messaging/delay
	name = "delay component"
	base_icon_state = "comp_wait"
	icon_state = "comp_wait"

	var/on = FALSE
	var/delay = 1 SECOND
	var/replace_message

/obj/item/mcobject/messaging/delay/Initialize(mapload)
	. = ..()
	MC_ADD_INPUT("delay", delay)
	MC_ADD_CONFIG("Set Delay", set_delay)
	MC_ADD_CONFIG("Toggle Message Replacement", toggle_replace)

/obj/item/mcobject/messaging/delay/update_icon_state()
	. = ..()
	icon_state = on ? "[icon_state]1" : icon_state

/obj/item/mcobject/messaging/delay/examine(mob/user)
	. = ..()
	. += span_notice("Delay: [delay] tenths of a second.")
	. += span_notice("Message Replacement is [replace_message ? "on" : "off"].")

/obj/item/mcobject/messaging/delay/proc/set_delay(mob/user, obj/item/tool)
	var/time = input(user, "Enter delay in tenths of a second", "Configure Component", delay) as null|num
	if(!time)
		return

	delay = time
	to_chat(user, span_notice("You set the delay on [src] to [delay]."))
	log_message("delay set tp [delay] by [key_name(user)]", LOG_MECHCOMP)
	return TRUE

/obj/item/mcobject/messaging/delay/proc/toggle_replace(mob/user, obj/item/tool)
	replace_message = !replace_message
	to_chat(user, span_notice("You set [src] to [replace_message ? "replace the incoming message" : "relay the incoming message"]."))
	log_message("replacement set to [replace_message] by [key_name(user)]", LOG_MECHCOMP)
	return TRUE

/obj/item/mcobject/messaging/delay/proc/delay(datum/mcmessage/input)
	set waitfor = FALSE
	if(on)
		return

	on = TRUE
	update_icon_state()
	sleep(delay)
	if(replace_message)
		fire(stored_message, input)
	else
		fire(input)
	on = FALSE
	update_icon_state()




