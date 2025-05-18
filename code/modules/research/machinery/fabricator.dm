/obj/machinery/rnd/production/fabricator
	name = "fabricator"
	desc = "Converts raw materials into useful objects."
	icon = 'goon/icons/obj/manufacturer.dmi'
	icon_state = "fab-general"
	circuit = /obj/item/circuitboard/machine/fabricator

	allowed_buildtypes = FABRICATOR
	zmm_flags = ZMM_MANGLE_PLANES

/obj/machinery/rnd/production/fabricator/deconstruct(disassembled)
	log_game("Fabricator of type [type] [disassembled ? "disassembled" : "deconstructed"] by [key_name(usr)] at [get_area_name(src, TRUE)]")

	return ..()

/obj/machinery/rnd/production/fabricator/Initialize(mapload)
	if(!mapload)
		log_game("Fabricator of type [type] constructed by [key_name(usr)] at [get_area_name(src, TRUE)]")

	return ..()

/obj/machinery/rnd/production/fabricator/update_overlays()
	. = ..()
	if(panel_open)
		. += image(icon, "fab-panel")

	if(busy)
		. += image(icon, "fab-work3")
		. += image(icon, "light-working")
		. += emissive_appearance(icon, "light-working", alpha = 90)
	else
		. += image(icon, "light-ready")
		. += emissive_appearance(icon, "light-ready", alpha = 90)

/// Special subtype fabricator for offstation use. Has a more limited available design selection.
/obj/machinery/rnd/production/fabricator/offstation
	name = "ancient fabricator"
	desc = "Converts raw materials into useful objects. Its ancient construction may limit its ability to print all known technology."
	circuit = /obj/item/circuitboard/machine/fabricator/offstation

/obj/machinery/rnd/production/fabricator/omni
	name = "omni fabricator"
	icon_state = "fab-sci"
	desc = "A fabricator pre-loaded with every object design." // "Every" in player context, this is NOT a debug tool.
	circuit = /obj/item/circuitboard/machine/fabricator/omni
