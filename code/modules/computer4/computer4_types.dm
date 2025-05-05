/obj/machinery/computer4/debug

/obj/machinery/computer4/debug/Initialize(mapload)
	default_programs = subtypesof(/datum/c4_file/terminal_program) - typesof(/datum/c4_file/terminal_program/operating_system)
	default_peripherals = subtypesof(/obj/item/peripheral)
	. = ..()

/obj/machinery/computer4/medical
	default_programs = list(
		/datum/c4_file/terminal_program/medtrak,
		/datum/c4_file/terminal_program/notepad,
	)

	default_peripherals = list(
		/obj/item/peripheral/card_reader,
		/obj/item/peripheral/printer,
	)
