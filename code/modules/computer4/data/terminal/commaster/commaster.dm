/datum/c4_file/terminal_program/commaster
	name = "comMASTER"

	req_access = list(ACCESS_CAPTAIN)

	/// Network ID of the comms dish we're linked to
	var/comms_dish_net_id
	/// Timer ID used on start up.
	var/check_dish_timer_id

	// Awaiting console call response timer ID
	var/awaiting_call_response_timer_id

	// Status message

	var/static/list/main_commands

/datum/c4_file/terminal_program/commaster/New()
	..()

	if(!main_commands)
		main_commands = list()
		for(var/path as anything in subtypesof(/datum/shell_command/commaster))
			main_commands += new path

/datum/c4_file/terminal_program/commaster/on_close(datum/c4_file/terminal_program/operating_system/thinkdos/system)
	. = ..()
	comms_dish_net_id = null
	deltimer(check_dish_timer_id)
	check_dish_timer_id = null

	deltimer(awaiting_call_response_timer_id)
	awaiting_call_response_timer_id = null

/datum/c4_file/terminal_program/commaster/execute(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/parsed_cmdline/cmdline)
	. = ..()

	var/title_text = list(
		"                        __  ______   _____________________  ","\n",
		"  _________  ____ ___  /  |/  /   | / ___/_  __/ ____/ __ \\ ","\n",
		" / ___/ __ \\/ __ `__ \\/ /|_/ / /| | \\__ \\ / / / __/ / /_/ / ","\n",
		"/ /__/ /_/ / / / / / / /  / / ___ |___/ // / / /___/ _, _/  ","\n",
		"\\___/\\____/_/ /_/ /_/_/  /_/_/  |_/____//_/ /_____/_/ |_|   ","\n",
	).Join("")

	system.println(title_text)


	find_comms_dish(system)

/datum/c4_file/terminal_program/commaster/std_in(text)
	. = ..()
	var/datum/parsed_cmdline/parsed_cmdline = parse_cmdline(text)

	var/datum/c4_file/terminal_program/operating_system/system = get_os()
	system.println(text)

	for(var/datum/shell_command/potential_command as anything in main_commands)
		if(potential_command.try_exec(parsed_cmdline.command, system, src, parsed_cmdline.arguments, parsed_cmdline.options))
			return TRUE

	system.println("'[parsed_cmdline.raw]' is not recognized as a command.")

/datum/c4_file/terminal_program/commaster/receive_wireline_signal(datum/signal/packet, obj/machinery/power/packet_source)
	if(packet.data[PKT_PAYLOAD][PKT_ARG_CMD] == NET_COMMAND_PING_REPLY && packet.data[PKT_HEAD_NETCLASS] == NETCLASS_COMMS_DISH)
		comms_dish_net_id = packet.data[PKT_HEAD_SOURCE_ADDRESS]
		return RECEIVE_SIGNAL_FINISHED

	if(awaiting_call_response_timer_id)
		deltimer(awaiting_call_response_timer_id)
		awaiting_call_response_timer_id = null
		if(packet.data[PKT_PAYLOAD]["commaster_failure"])
			get_os().println(packet.data[PKT_PAYLOAD]["commaster_failure"])
			return RECEIVE_SIGNAL_FINISHED

		else if(packet.data[PKT_PAYLOAD]["shuttle_called"])
			get_os().println("Emergency request received, a shuttle has been dispatched.")
			return RECEIVE_SIGNAL_FINISHED

/datum/c4_file/terminal_program/commaster/proc/find_comms_dish(datum/c4_file/terminal_program/operating_system/thinkdos/system)
	if(check_dish_timer_id)
		return

	if(!get_netjack())
		system.print_error("[ANSI_WRAP_BOLD("Error:")] Console is not connected to the wirenet.")
		return

	comms_dish_net_id = null

	var/obj/machinery/computer4/computer = get_computer()
	system.println("Searching for communications array...")

	var/datum/signal/ping = computer.create_signal(NET_ADDRESS_PING)
	computer.post_signal(ping)

	check_dish_timer_id = addtimer(CALLBACK(src, PROC_REF(check_dish_exists)), 1 SECOND, TIMER_STOPPABLE|TIMER_DELETE_ME)

/// Called by callback on start up to see if we found a comms dish.
/datum/c4_file/terminal_program/commaster/proc/check_dish_exists()
	if(comms_dish_net_id)
		get_os().println("Successfully initialized communications array.")
	else
		astype(get_os(), /datum/c4_file/terminal_program/operating_system/thinkdos).print_error("[ANSI_WRAP_BOLD("Error:")] Unable to locate communications array.")

	check_dish_timer_id = null

/// Getter for a network adapter.
/datum/c4_file/terminal_program/commaster/proc/get_adapter() as /obj/item/peripheral/network_card
	return get_computer().get_peripheral(PERIPHERAL_TYPE_WIRELESS_CARD)

/datum/c4_file/terminal_program/commaster/proc/get_netjack() as /obj/machinery/power/data_terminal
	return get_computer().netjack

/// Called via timer when attempting to call the shuttle.
/datum/c4_file/terminal_program/commaster/proc/call_timed_out()
	if(isnull(awaiting_call_response_timer_id))
		return

	awaiting_call_response_timer_id = null
	get_os().println("Shuttle call request timed out.")
