/datum/shell_command/commaster/quit
	aliases = list("quit", "q", "exit")
	help_text = "Terminates the program.\nUsage: 'quit'"

/datum/shell_command/commaster/quit/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	system.println("Quitting...")
	system.unload_program(program)

/datum/shell_command/commaster/help
	aliases = list("help")
	help_text = "Lists all available commands. Use help \[command\] to view information about a specific command."

/datum/shell_command/commaster/help/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/list/output = generate_help(system, program, arguments, astype(program, /datum/c4_file/terminal_program/commaster).main_commands)
	if(output)
		system.println(jointext(output, "\n"))

/datum/shell_command/commaster/call_shuttle
	aliases = list("call")
	help_text = "Sends an emergency aid request to a nearby colony. Requires a connection to a communications array via wireline.\nUsage: 'call'"

/datum/shell_command/commaster/call_shuttle/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/commaster/commaster = program
	var/obj/machinery/power/data_terminal/netjack = commaster.get_netjack()

	if(!netjack)
		system.print_error("[ANSI_WRAP_BOLD("Error:")] Console is not connected to the wirenet.")
		return

	if(!length(arguments))
		system.print_error("[ANSI_WRAP_BOLD("Error:")] Must provide a call reason.")
		return

	var/reason = trim(jointext(arguments, " "))
	if (length(reason) < CALL_SHUTTLE_REASON_LENGTH)
		system.print_error("[ANSI_WRAP_BOLD("Error:")] Call reason must be longer than 12 characters.")
		return

	var/auth = system.current_user.get_auth()
	var/list/packet_data = packetv2(
		null,
		commaster.comms_dish_net_id,
		payload = list(
			PKT_ARG_CMD = NET_COMMAND_CALL_SHUTTLE,
			PKT_ARG_AUTH = auth,
			PKT_ARG_CALL_REASON = reason,
		)
	)
	var/datum/signal/packet = new(null, packet_data, transmission_method = TRANSMISSION_WIRE)
	packet.logging_ckey = usr?.ckey

	system.get_computer().post_signal(packet)
	system.println("Awaiting response...")
	commaster.awaiting_call_response_timer_id = addtimer(CALLBACK(commaster, TYPE_PROC_REF(/datum/c4_file/terminal_program/commaster, call_timed_out)), 5 SECONDS, TIMER_STOPPABLE|TIMER_DELETE_ME|TIMER_UNIQUE)

/datum/shell_command/commaster/connect
	aliases = list("connect", "c",)
	help_text = "Attempts to establish a connection to a communications array.\nUsage: 'connect'"

/datum/shell_command/commaster/connect/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	astype(program, /datum/c4_file/terminal_program/commaster).find_comms_dish(system)

/datum/shell_command/commaster/recall
	aliases = list("recall", "r")
	help_text = "Cancels an emergency aid request. Requires a connection to a communications array via wireline.\nUsage: 'recall'"

/datum/shell_command/commaster/recall/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/commaster/commaster = program
	var/obj/machinery/power/data_terminal/netjack = commaster.get_netjack()

	if(!netjack)
		system.print_error("[ANSI_WRAP_BOLD("Error:")] Console is not connected to the wirenet.")
		return

	var/auth = system.current_user.get_auth()
	var/list/packet_data = packetv2(
		null,
		commaster.comms_dish_net_id,
		payload = list(
			PKT_ARG_CMD = NET_COMMAND_RECALL_SHUTTLE,
			PKT_ARG_AUTH = auth,
		)
	)
	var/datum/signal/packet = new(null, packet_data, transmission_method = TRANSMISSION_WIRE)
	packet.logging_ckey = usr?.ckey

	system.get_computer().post_signal(packet)
	system.println("Sent!")

/datum/shell_command/commaster/change_sec_level
	aliases = list("security_level", "sl")
	help_text = "Changes the colony security level.\nUsage: 'security_level \[green|blue\]'"

/datum/shell_command/commaster/change_sec_level/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	if(!length(arguments))
		system.print_error("[ANSI_WRAP_BOLD("Error:")] No security level argument provided.")
		return

	var/new_level = lowertext(arguments[1])
	if(!(new_level in list("green", "blue")))
		system.print_error("[ANSI_WRAP_BOLD("Error:")] Invalid security level provided.")
		return

	if (SSsecurity_level.current_level == seclevel2num(new_level))
		return

	set_security_level(new_level)

	log_game("[key_name(usr)] has changed the security level to [new_level] with [src] at [AREACOORD(usr)].")
	message_admins("[ADMIN_LOOKUPFLW(usr)] has changed the security level to [new_level] with [src] at [AREACOORD(usr)].")
	deadchat_broadcast(" has changed the security level to [new_level] with [src] at [span_name("[get_area_name(usr, TRUE)]")].", span_name("[usr.real_name]"), usr, message_type=DEADCHAT_ANNOUNCEMENT)

/datum/shell_command/commaster/set_status_display
	aliases = list("status")
	help_text = "Changes the displayed content of evacuation shuttle displays.\nUsage: 'status \[command\] \[arguments?\]'"

	var/static/list/approved_pictures = list("blank", "biohazard", "default", "lockdown", "redalert")

/datum/shell_command/commaster/set_status_display/New()
	. = ..()
	var/list/help_list = list(
		"Changes the displayed content of evacuation shuttle displays.",
		"Usage: 'status \[command\] \[arguments?\]'\n",
	)

	help_text += "Sub-commands:"
	help_list += "[pad_text("message", 20, " ", TRUE)]Set a text message on displays. Usage: 'status message \"\[line one\]\" \"\[line two\]\"'"
	help_list += "[pad_text("picture", 20, " ", TRUE)]Set a picture on displays. Usage: 'status picture \[[jointext(approved_pictures, "|")]\]'"
	help_list += "[pad_text("shuttle", 20, " ", TRUE)]Set displays to show the arrival time of the emergency shuttle. Usage: 'status shuttle'"
	help_text = jointext(help_list, "\n")

	help_text = jointext(help_list, "\n")

/datum/shell_command/commaster/set_status_display/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/commaster/commaster = program
	var/obj/item/peripheral/network_card/wireless/adapter = commaster.get_adapter()

	if(!adapter)
		system.print_error("[ANSI_WRAP_BOLD("Error:")] No wireless adapter installed.")
		return

	if(!(length(arguments)))
		system.print_error("[ANSI_WRAP_BOLD("Error:")] No argument(s) provided.")
		return

	switch(arguments[1])
		if("message")
			var/line_one
			var/line_two

			var/datum/signal/packet = new(
				null,
				packetv2(
					null,
					payload = list(
						PKT_ARG_CMD = NET_COMMAND_STATDISPLAY_SET,
						PKT_ARG_STATDISPLAY_MODE = "message",
					)
				)
			)

			if(length(arguments) <= 1)
				adapter.post_signal(packet)
				return

			// ok here goes
			var/list/messages = splittext(jointext(arguments, " ", 2), "\"")
			if(length(messages) == 1)
				// set status displays to no message (no quote-wrapped argument)
				adapter.post_signal(packet)
				return

			// Lop off everything other than up to 2 quote-enclosed arguments.
			messages = messages.Copy(2, min(length(messages), 5))

			if(length(messages))
				// If there were two messages in the command, there will be an entry representing any characters between the two enclosed arguments.
				// Remove it.
				if(length(messages) == 3)
					messages -= messages[2]

				line_one = reject_bad_text(messages[1] || "", MAX_STATUS_LINE_LENGTH)
				if(length(messages) == 2)
					line_two = reject_bad_text(messages[2] || "", MAX_STATUS_LINE_LENGTH)

			packet.data[PKT_PAYLOAD]["msg1"] = line_one
			packet.data[PKT_PAYLOAD]["msg2"] = line_two

			adapter.post_signal(packet, frequency = FREQ_STATUS_DISPLAYS)
			return

		if("picture")
			var/picture = jointext(arguments, " ", 2)
			if(!(picture in approved_pictures))
				system.print_error("[ANSI_WRAP_BOLD("Error:")] Invalid picture. Valid pictures: [english_list(approved_pictures)].")
				return

			var/datum/signal/packet = new(
				null,
				packetv2(
					null,
					payload = list(
						PKT_ARG_CMD = NET_COMMAND_STATDISPLAY_SET,
						PKT_ARG_STATDISPLAY_MODE = "alert",
					)
				)
			)

			if(picture == "blank")
				packet.data[PKT_PAYLOAD][PKT_ARG_STATDISPLAY_MODE] = "blank"
			else
				packet.data[PKT_PAYLOAD][PKT_ARG_STATDISPLAY_PICTURE] = picture

			adapter.post_signal(packet, frequency = FREQ_STATUS_DISPLAYS)
			return

		if("shuttle")
			var/datum/signal/packet = new(
				null,
				packetv2(
					null,
					payload = list(
						PKT_ARG_CMD = NET_COMMAND_STATDISPLAY_SET,
						PKT_ARG_STATDISPLAY_MODE = "shuttle",
					)
				)
			)

			adapter.post_signal(packet, frequency = FREQ_STATUS_DISPLAYS)
			return

		else
			system.print_error("[ANSI_WRAP_BOLD("Error:")] Unrecognized argument(s) \"[jointext(arguments.Copy(2), " ")]\".")
			return

/datum/shell_command/commaster/change_emergency_access
	aliases = list("emergency_access", "ea")
	help_text = "Changes the colony security level.\nUsage: 'emergency_access \[enable|disable\]'"

/datum/shell_command/commaster/change_emergency_access/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	if(!length(arguments))
		system.print_error("[ANSI_WRAP_BOLD("Error:")] Expected 1 argument.")
		return

	if(!(arguments[1] in list("enable", "disable")))
		system.print_error("[ANSI_WRAP_BOLD("Error:")] Invalid argument value.")
		return

	var/static/cooldown = 0
	if(world.time <= cooldown)
		system.print_error("[ANSI_WRAP_BOLD("Error:")] You must wait [DisplayTimeText(cooldown - world.time)] before changing emergency access again.")
		return

	if(arguments[1] == "enable" && !GLOB.emergency_access)
		cooldown = world.time + 30 SECONDS
		make_maint_all_access()
		log_game("[key_name(usr)] enabled emergency maintenance access.")
		message_admins("[ADMIN_LOOKUPFLW(usr)] enabled emergency maintenance access.")
		deadchat_broadcast(" enabled emergency maintenance access at [span_name("[get_area_name(usr, TRUE)]")].", span_name("[usr.real_name]"), usr, message_type = DEADCHAT_ANNOUNCEMENT)

	else if(arguments[1] == "disable" && GLOB.emergency_access)
		cooldown = world.time + 30 SECONDS
		revoke_maint_all_access()
		log_game("[key_name(usr)] disabled emergency maintenance access.")
		message_admins("[ADMIN_LOOKUPFLW(usr)] disabled emergency maintenance access.")
		deadchat_broadcast(" disabled emergency maintenance access at [span_name("[get_area_name(usr, TRUE)]")].", span_name("[usr.real_name]"), usr, message_type = DEADCHAT_ANNOUNCEMENT)

	else
		system.print_error("[ANSI_WRAP_BOLD("Error:")] Emergency access state already set.")
		return
