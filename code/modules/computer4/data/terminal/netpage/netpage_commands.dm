/datum/shell_command/netpage/quit
	aliases = list("quit", "q", "exit")

/datum/shell_command/netpage/quit/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	system.println("Quitting...")
	system.unload_program(program)

/datum/shell_command/netpage/broadcast
	aliases = list("post", "broadcast")

/datum/shell_command/netpage/broadcast/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/netpage/netpage = program
	var/obj/item/peripheral/network_card/wireless/adapter = netpage.get_adapter()
	if(netpage.check_for_errors())
		return

	if(!options["network"])
		system.println("Syntax: post --network=\[network ID\] \[message\].<br>Type 'networks' to view networks you may broadcast on.")
		return

	var/list/valid_arg_options = list()
	for(var/datum/pager_access_info/info in netpage.get_options())
		valid_arg_options[info.arg_name] = info.pager_class

	if(!(options["network"] in valid_arg_options))
		system.println("<b>Error:</b> Invalid network ID.")
		return

	var/message = "[stationtime2text("hh:mm")] | [jointext(arguments, " ")]"
	var/pager_class = valid_arg_options[options["network"]]

	var/datum/signal/signal = new(src, list(PACKET_ARG_PAGER_CLASS = pager_class, PACKET_ARG_PAGER_MESSAGE = message))
	adapter.deferred_post_signal(signal, RADIO_PAGER_MESSAGE, rand(3, 10) SECONDS)
	system.println("Sent!")

/datum/shell_command/netpage/networks
	aliases = list("networks")

/datum/shell_command/netpage/networks/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/netpage/netpage = program
	if(netpage.check_for_errors())
		return

	var/list/valid_arg_options = list()
	for(var/datum/pager_access_info/info in netpage.get_options())
		valid_arg_options += info.arg_name

	system.println("Usable networks: [english_list(valid_arg_options, and_text = ", ")].")
