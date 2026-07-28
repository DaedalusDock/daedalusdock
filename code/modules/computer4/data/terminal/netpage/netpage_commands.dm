/datum/shell_command/netpage/quit
	aliases = list("quit", "q", "exit")
	help_text = "Terminates the program.\nUsage: 'quit'"

/datum/shell_command/netpage/quit/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	system.println("Quitting...")
	system.unload_program(program)

/datum/shell_command/netpage/help
	aliases = list("help")
	help_text = "Lists all available commands. Use help \[command\] to view information about a specific command."

/datum/shell_command/netpage/help/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/netpage/netpage = program
	noop(netpage)
	var/list/all_commands = netpage.commands
	var/list/output = generate_help(system, program, arguments, all_commands)
	if(output)
		system.println(jointext(output, "\n"))

/datum/shell_command/netpage/broadcast
	aliases = list("post", "broadcast")
	help_text = "Broadcasts a message to all pagers on the network.\nUsage: 'post --network=\[network ID\] \[message\]'\nUse 'networks' to view networks you may broadcast on."

/datum/shell_command/netpage/broadcast/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/netpage/netpage = program
	var/obj/item/peripheral/network_card/wireless/adapter = netpage.get_adapter()
	if(netpage.check_for_errors())
		return

	if(!options["network"])
		system.print_error("[ANSI_WRAP_BOLD("Error:")] No network argument provided.")
		return

	var/list/valid_arg_options = list()
	for(var/datum/pager_access_info/info in netpage.get_options())
		valid_arg_options[info.arg_name] = info.pager_class

	if(!(options["network"] in valid_arg_options))
		system.print_error("[ANSI_WRAP_BOLD("Error:")] Invalid network ID. Use 'networks' to view valid network IDs.")
		return

	var/message = "[stationtime2text("hh:mm")] | [jointext(arguments, " ")]"
	var/pager_class = valid_arg_options[options["network"]]

	var/datum/signal/signal = new(src, packetv2(net_class = pager_class, payload = list(PACKET_ARG_PAGER_MESSAGE = message)))
	adapter.deferred_post_signal(signal, RADIO_PAGER_MESSAGE, time = rand(3, 10) SECONDS)
	system.println("Sent!")

/datum/shell_command/netpage/networks
	aliases = list("networks")
	help_text = "View available networks to broadcast on.\nUsage: 'networks'"

/datum/shell_command/netpage/networks/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/netpage/netpage = program
	if(netpage.check_for_errors())
		return

	var/list/valid_arg_options = list()
	for(var/datum/pager_access_info/info in netpage.get_options())
		valid_arg_options += info.arg_name

	system.println("Usable networks: [english_list(valid_arg_options, and_text = ", ")].")
