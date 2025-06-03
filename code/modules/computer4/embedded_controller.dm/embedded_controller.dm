/obj/machinery/c4_embedded_controller
	name = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"

	/// Ref to our magic internal computer :)
	var/tmp/obj/machinery/computer4/embedded_controller/internal_computer

	var/tmp/default_operating_system = /datum/c4_file/terminal_program/operating_system/thinkdos // temp lol
	var/radio_frequency

/obj/machinery/c4_embedded_controller/Initialize(mapload)
	. = ..()
	internal_computer = new(src)
	internal_computer.controller = src

	var/obj/item/peripheral/network_card/wireless/netcard = internal_computer.get_peripheral(PERIPHERAL_TYPE_WIRELESS_CARD)
	netcard.frequency = radio_frequency
	netcard.set_radio_connection(radio_frequency)

	var/obj/item/disk/data/floppy/floppy = new(internal_disk)
	floppy.root.try_add_file(new default_operating_system)

	internal_computer.set_inserted_disk(floppy) // Maybe this needs to be on src?
	setup_default_configuration()

	if(!mapload)
		internal_computer.post_system()

/obj/machinery/c4_embedded_controller/Destroy()
	QDEL_NULL(internal_computer)
	return ..()

/obj/machinery/c4_embedded_controller/ui_data(mob/user)
	return internal_computer.ui_data(user)

/obj/machinery/c4_embedded_controller/ui_static_data(mob/user)
	return internal_computer.ui_static_data(user)

/obj/machinery/c4_embedded_controller/proc/setup_default_configuration()
	return

/obj/machinery/computer4/embedded_controller
	default_operating_system = null
	default_programs = null
	default_peripherals = list(
		/obj/item/peripheral/network_card/wireless,
	)

	/// The parent.
	var/obj/machinery/c4_embedded_controller/controller

/obj/machinery/computer4/embedded_controller/Destroy()
	controller = null
	return ..()
