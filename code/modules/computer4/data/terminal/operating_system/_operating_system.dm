/datum/c4_file/terminal_program/operating_system
	name = "operating system"
	extension = "TSYS"
	size = 0

	is_executable = FALSE

	/// Gotta be logged in to access anything.
	var/logged_in = FALSE

	/// Current directory being operated on.
	var/datum/c4_file/folder/current_directory

	/// The current focused program.
	var/tmp/datum/c4_file/terminal_program/active_program
	/// All programs currently running on the machine.
	var/tmp/list/datum/c4_file/terminal_program/processing_programs = list()

	/// Halt And Catch Fire (Prevents STDIN, closest we can get to a HALT state.)
	var/deadlocked = FALSE

	/// Associative list of "port_num" : socket_instance
	var/list/datum/pdp_socket/pdp_port_map = list()

/datum/c4_file/terminal_program/operating_system/Destroy()
	if(length(processing_programs))
		clean_up()
	return ..()

/// Should run this before executing any commands.
/datum/c4_file/terminal_program/operating_system/proc/is_operational()
	return (!!get_computer()?.is_operational) && (!deadlocked)

/// Write to the terminal.
/datum/c4_file/terminal_program/operating_system/proc/println(text, update_ui = TRUE)
	if(isnull(text) || !is_operational())
		return FALSE


	var/obj/machinery/computer4/computer = get_computer()
	computer.text_buffer += "[text]<br>"
	if(update_ui)
		SStgui.update_uis(computer)
	return TRUE

/// Clear the screen completely.
/datum/c4_file/terminal_program/operating_system/proc/clear_screen(fully = FALSE)
	if(!is_operational())
		return FALSE

	get_computer().text_buffer = ""
	if(!fully)
		println("Screen cleared.")
	return TRUE

/// Wrapper around handling text input to make sure we can actually handle it.
/datum/c4_file/terminal_program/operating_system/proc/try_std_in(text)
	if(!text || !is_operational())
		return FALSE

	return active_program?.std_in(text)

/// Unload everything including myself
/datum/c4_file/terminal_program/operating_system/proc/clean_up()
	for(var/datum/c4_file/terminal_program/program as anything in processing_programs - src)
		unload_program(program)

	if(src in processing_programs)
		unload_program(src)

	get_computer()?.text_buffer = ""
	get_computer()?.operating_system = null

	//Programs should clean these up, but just in case.
	QDEL_LIST_ASSOC_VAL(pdp_port_map)
	pdp_port_map.Cut()

/datum/c4_file/terminal_program/operating_system/execute(datum/c4_file/terminal_program/operating_system/system)
	if(system != src)
		//If we aren't executing ourselves, something is nasty and wrong.
		CRASH("System [system.type] tried to execute OS that isn't itself??")

	prepare_networking()

/datum/c4_file/terminal_program/operating_system/peripheral_input(obj/item/peripheral/invoker, command, datum/signal/packet)

	if(command == PERIPHERAL_CMD_RECEIVE_PDP_PACKET)
		pdp_incoming(packet)
		return

	for(var/datum/c4_file/terminal_program/program as anything in processing_programs)
		if(program == src)
			continue
		program.peripheral_input(invoker, command, packet)
