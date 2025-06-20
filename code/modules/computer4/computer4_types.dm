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

/obj/machinery/computer4/medical/augur
	default_programs = list(
		/datum/c4_file/terminal_program/medtrak,
		/datum/c4_file/terminal_program/notepad,
		/datum/c4_file/terminal_program/netpage,
	)

	default_peripherals = list(
		/obj/item/peripheral/card_reader,
		/obj/item/peripheral/printer,
		/obj/item/peripheral/network_card/wireless,
	)

/obj/machinery/computer4/management/superintendent
	default_programs = list(
		/datum/c4_file/terminal_program/notepad,
		/datum/c4_file/terminal_program/netpage,
		/datum/c4_file/terminal_program/directman,
	)

	default_peripherals = list(
		/obj/item/peripheral/card_reader,
		/obj/item/peripheral/network_card/wireless,
	)
