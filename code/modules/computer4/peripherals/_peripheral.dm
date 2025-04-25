/obj/item/peripheral
	name = "Peripheral card"
	desc = "A computer circuit board."

	icon = 'icons/obj/module.dmi'
	icon_state = "blank_mod"
	inhand_icon_state = "electronic"

	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'

	custom_materials = list(/datum/material/glass = 1000)
	grind_results = list(/datum/reagent/silicon = 20)

	w_class = WEIGHT_CLASS_SMALL

	var/peripheral_type = ""

	/// Computer we're attached to.
	var/obj/machinery/computer4/master_pc

/// Called when a peripheral is attached to a computer
/obj/item/peripheral/proc/on_attach(obj/machinery/computer4/computer)
	SHOULD_CALL_PARENT(TRUE)
	master_pc = computer

/// Called when a peripheral is removed from a computer
/obj/item/peripheral/proc/on_detach(obj/machinery/computer4/computer)
	SHOULD_CALL_PARENT(TRUE)
	master_pc = null
