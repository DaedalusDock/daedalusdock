TYPEINFO_DEF(/obj/item/peripheral)
	default_materials = list(/datum/material/glass = 1000)

/obj/item/peripheral
	name = "peripheral card"
	desc = "A computer circuit board."

	icon = 'icons/obj/module.dmi'
	icon_state = "blank_mod"
	inhand_icon_state = "electronic"

	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'

	grind_results = list(/datum/reagent/silicon = 20)

	w_class = WEIGHT_CLASS_SMALL

	var/peripheral_type = ""

	/// Computer we're attached to.
	var/obj/machinery/computer4/master_pc

/obj/item/peripheral/Destroy(force)
	if(master_pc)
		master_pc.remove_peripheral(src)
	return ..()

/// Called when a peripheral is attached to a computer
/obj/item/peripheral/proc/on_attach(obj/machinery/computer4/computer)
	SHOULD_CALL_PARENT(TRUE)
	master_pc = computer

/// Called when a peripheral is removed from a computer
/obj/item/peripheral/proc/on_detach(obj/machinery/computer4/computer)
	SHOULD_CALL_PARENT(TRUE)
	master_pc = null

/obj/item/peripheral/proc/return_ui_data()
	return

/// Called when the peripheral's ui button is clicked.
/obj/item/peripheral/proc/on_ui_click(mob/user, list/params)
	return

/// Call peripheral_input after a specified amount of time
/obj/item/peripheral/proc/deferred_peripheral_input(command, datum/signal/packet, time, completed)
	if(!completed)
		addtimer(CALLBACK(src, PROC_REF(deferred_peripheral_input), command, packet, 0, TRUE), time)
		return

	master_pc?.peripheral_input(src, command, packet)
