/obj/item/mcobject/messaging/signal_check
	name = "signal-check component"
	base_icon_state = "comp_check"

	var/replace_message = FALSE

/obj/item/mcobject/messaging/signal_check/Initialize(mapload)
	. = ..()
	MC_ADD_TRIGGER
	MC_ADD_INPUT("set trigger", set_trigger_comp)
	MC_ADD_INPUT("check string", check_str)
	MC_ADD_CONFIG("Invert Trigger", invert_trigger)
	MC_ADD_CONFIG("Toggle Signal Replacement", toggle_replace)

/obj/item/mcobject/messaging/signal_check/examine(mob/user)
	. = ..()
	. += {"<br><span class='notice'>[not ? "Component triggers when Signal is NOT found.":"Component triggers when Signal IS found."]<br>
		Replace Signal is [changesig ? "on.":"off."]<br>
		Currently checking for: [sanitize(html_encode(trigger))]</span>"}
