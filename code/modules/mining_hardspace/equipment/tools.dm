///Contains all the code related to Hardspace tools, disposable equipment, and similar.

/obj/item/salvagecutter
	name = "Mark 2 Ionized Beam Cutter"
	desc = "A specialized salvage operations tool designed for cutting through ship hulls and delicate machinery alike, using ionizing streams of heated plasma. Do not lick."
	icon = 'icons/obj/tools.dmi'
	icon_state = "exwelder"
	tool_behaviour = TOOL_SALVAGECUTTER
	w_class = WEIGHT_CLASS_TINY //just for testing

/obj/item/salvageboltgun
	name = "Aeon Pneumatic Boltgun"
	desc = "A specialized salvage operations tool designed for swift removal of rivets, bolts, and other hardened fasteners for deconstruction using a hydraulic ram. Powered by an internal compressor, allowing for portability."
	icon = 'icons/obj/tools.dmi'
	icon_state = ""
	tool_behaviour = TOOL_SALVAGEBOLTGUN
	w_class = WEIGHT_CLASS_TINY

/obj/item/salvagesaw
	name = "OVERKILL Salvage Driver"
	desc = "A specialized salvage operations tool designed for destructive removal of hardened materials such as plasteel casings, radiation shielding, or durasteel using a hardened plasma-saw."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "esaw_on"
	tool_behaviour = TOOL_SALVAGESAW
	w_class = WEIGHT_CLASS_TINY

/obj/item/salvagewiretap
	name = "Salvation Mark 1 WIR3TAP"
	desc = "A specialized salvage operations digital omnitool designed for deactivation of authorized machinery, rendering said devices safe to handle for maintence or repairs."
	icon = 'icons/obj/device.dmi'
	icon_state = "multitool"
	tool_behaviour = TOOL_SALVAGEWIRETAP
	w_class = WEIGHT_CLASS_TINY

/// Called on an object when a tool with salvage cutter capabilities is used to left click on an object.
/atom/proc/salvagecutter_act(mob/living/user, obj/item/tool)
	return

/// Called on an object when a tool with salvage boltgun capabilities is used to left click on an object.
/atom/proc/salvageboltgun_act(mob/living/user, obj/item/tool)
	return

/// Called on an object when a tool with salvage saw capabilities is used to left click on an object.
/atom/proc/salvagesaw_act(mob/living/user, obj/item/tool)
	return

/// Called on an object when a tool with salvage wiretap capabilities is used to left click on an object.
/atom/proc/salvagewiretap_act(mob/living/user, obj/item/tool)
	return

/// Called on an object when a tool with salvage cutter capabilities is used to right click on an object.
/atom/proc/salvagecutter_act_secondary(mob/living/user, obj/item/tool)
	return

/// Called on an object when a tool with salvage boltgun capabilities is used to right click on an object.
/atom/proc/salvageboltgun_act_secondary(mob/living/user, obj/item/tool)
	return

/// Called on an object when a tool with salvage saw capabilities is used to right click on an object.
/atom/proc/salvagesaw_act_secondary(mob/living/user, obj/item/tool)
	return

/// Called on an object when a tool with salvage wiretap capabilities is used to right click on an object.
/atom/proc/salvagewiretap_act_secondary(mob/living/user, obj/item/tool)
	return
