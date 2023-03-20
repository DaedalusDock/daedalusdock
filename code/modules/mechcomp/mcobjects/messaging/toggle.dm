/obj/item/mcobject/messaging/toggle
	name = "toggle component"
	base_icon_state = "comp_toggle"

	var/on = FALSE
	var/on_signal = MC_BOOL_TRUE
	var/off_signal = MC_BOOL_FALSE

/obj/item/mcobject/messaging/toggle/examine(mob/user)
	. = ..()
	. += span_notice("Currently [on ? "ON":"OFF"]")
	. += span_notice("Current ON Message: [signal_on]")
	. += span_notice("Current OFF Message: [signal_off]")

/obj/item/mcobject/messaging/toggle/Initialize(mapload)
	. = ..()
	MC_ADD_INPUT("activate", activate)
	MC_ADD_INPUT("activate and send", activate_and_send)
	MC_ADD_INPUT("deactivate", deactivate)
	MC_ADD_INPUT("deactivate and send", deactivate_and_send)
	MC_ADD_INPUT("toggle", toggle)
	MC_ADD_INPUT("toggle and send", toggle_and_send)
	MC_ADD_INPUT("send", send)
	MC_ADD_CONFIG("Set On Message", set_on_message)
	MC_ADD_CONFIG("Set Off Message", set_off_message)
