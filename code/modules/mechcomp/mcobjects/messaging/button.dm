/obj/item/mcobject/messaging/button
	name = "button component"
	desc = "A button. Its red hue entices you to press it."
	icon_state = "comp_button"
	var/icon_up = "comp_button"
	var/icon_down = "comp_button1"

/obj/item/mcobject/messaging/button/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	z_flick(icon_down, src)
	fire(stored_message)
	log_message("triggered by [key_name(user)]", LOG_MECHCOMP)
	return TRUE

/obj/item/mcobject/messaging/button/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/atom/target = interacting_with // Yes i am supremely lazy

	if(!isturf(target))
		return NONE

	if(!user.dropItemToGround(src))
		return NONE

	forceMove(target)

	if(isclosedturf(target))
		icon_up = "comp_switch"
		icon_down = "comp_switch2"
	else
		icon_up = "comp_button"
		icon_down = "comp_button2"
		update_icon_state()

	return ITEM_INTERACT_SUCCESS

/obj/item/mcobject/messaging/button/update_icon_state()
	. = ..()
	icon_state = icon_up
