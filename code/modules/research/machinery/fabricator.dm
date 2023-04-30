/obj/machinery/rnd/production/fabricator
	name = "fabricator"
	desc = "Converts raw materials into useful objects."
	icon_state = "protolathe"
	circuit = /obj/item/circuitboard/machine/fabricator
	categories = list(
		DESIGN_POWER,
		"Medical Designs",
		"Bluespace Designs",
		"Stock Parts",
		"Equipment",
		"Tool Designs",
		"Mining Designs",
		"Electronics",
		"Weapons",
		"Ammo",
		"Firing Pins",
		DESIGN_COMPUTER,
		"AI Modules",
		"Computer Boards",
		"Teleportation Machinery",
		"Medical Machinery",
		"Engineering Machinery",
		"Exosuit Modules",
		"Hydroponics Machinery",
		"Subspace Telecomms",
		"Research Machinery",
		"Misc. Machinery",
		DESIGN_COMPUTER,
		DESIGN_WIREMOD
	)

	production_animation = "protolathe_n"
	allowed_buildtypes = FABRICATOR | IMPRINTER

/obj/machinery/rnd/production/fabricator/deconstruct(disassembled)
	log_game("Fabricator of type [type] [disassembled ? "disassembled" : "deconstructed"] by [key_name(usr)] at [get_area_name(src, TRUE)]")

	return ..()

/obj/machinery/rnd/production/fabricator/Initialize(mapload)
	if(!mapload)
		log_game("Fabricator of type [type] constructed by [key_name(usr)] at [get_area_name(src, TRUE)]")

	return ..()

/// Special subtype fabricator for offstation use. Has a more limited available design selection.
/obj/machinery/rnd/production/fabricator/offstation
	name = "ancient fabricator"
	desc = "Converts raw materials into useful objects. Its ancient construction may limit its ability to print all known technology."
	circuit = /obj/item/circuitboard/machine/fabricator/offstation
	mapload_design_flags = DESIGN_FAB_OFFSTATION | DESIGN_FAB_OMNI

/obj/machinery/rnd/production/fabricator/omni
	name = "omni fabricator"
	desc = "A fabricator pre-loaded with every object design." // "Every" in player context, this is NOT a debug tool.
	circuit = /obj/item/circuitboard/machine/fabricator/omni
	mapload_design_flags = DESIGN_FAB_OMNI
