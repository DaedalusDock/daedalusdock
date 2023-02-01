/datum/computer/file/embedded_program
	var/list/memory = list()
	var/state
	var/obj/machinery/embedded_controller/master

/datum/computer/file/embedded_program/Destroy()
	master = null
	. = ..()

/datum/computer/file/embedded_program/proc/post_signal(datum/signal/signal, comm_line)
	SHOULD_CALL_PARENT(FALSE) // This is more of a relay than anything else.
	if(master)
		master.post_signal(signal, comm_line)
	//Else, drop it. This used to delete signals. That's *b a d*

/datum/computer/file/embedded_program/proc/receive_user_command(command)

/datum/computer/file/embedded_program/receive_signal(datum/signal/signal)
	return null

/datum/computer/file/embedded_program/process()
	return 0

/obj/machinery/embedded_controller
	var/datum/computer/file/embedded_program/program

	name = "embedded controller"
	density = FALSE

	var/on = TRUE

/obj/machinery/embedded_controller/Destroy()
	if(program)
		QDEL_NULL(program)
	. = ..()

/obj/machinery/embedded_controller/ui_interact(mob/user)
	. = ..()
	user.set_machine(src)
	var/datum/browser/popup = new(user, "computer", name) // Set up the popup browser window
	popup.set_content(return_text())
	popup.open()

/obj/machinery/embedded_controller/proc/return_text()

/obj/machinery/embedded_controller/post_signal(datum/signal/signal, comm_line)
	SHOULD_CALL_PARENT(FALSE) //This... Probably has a reason... I guess??????
	return

/obj/machinery/embedded_controller/receive_signal(datum/signal/signal)
	SHOULD_CALL_PARENT(FALSE) // This is technically a relay so this is okay.
	if(istype(signal) && program)
		program.receive_signal(signal)

/obj/machinery/embedded_controller/Topic(href, href_list)
	. = ..()
	if(.)
		return

	process_command(href_list["command"])

	usr.set_machine(src)
	addtimer(CALLBACK(src, .proc/updateDialog), 5)

/obj/machinery/embedded_controller/proc/process_command(command)
	if(program)
		program.receive_user_command(command)
		addtimer(CALLBACK(program, /datum/computer/file/embedded_program.proc/process), 5)

/obj/machinery/embedded_controller/process(delta_time)
	if(program)
		program.process(delta_time)

	update_appearance()
	src.updateDialog()

/obj/machinery/embedded_controller/radio
	var/frequency
	var/datum/radio_frequency/radio_connection

/obj/machinery/embedded_controller/radio/Destroy()
	SSpackets.remove_object(src,frequency)
	return ..()

/obj/machinery/embedded_controller/radio/Initialize(mapload)
	. = ..()
	set_frequency(frequency)

/obj/machinery/embedded_controller/radio/post_signal(datum/signal/signal)
	signal.transmission_method = TRANSMISSION_RADIO
	if(radio_connection)
		return radio_connection.post_signal(signal)
	else
		signal = null

/obj/machinery/embedded_controller/radio/proc/set_frequency(new_frequency)
	SSpackets.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSpackets.add_object(src, frequency)
