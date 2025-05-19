/datum/c4_file/terminal_program/netpage
	name = "NetPage"
	size = 4

	var/static/list/datum/pager_access_info/pager_info
	var/static/list/commands

/datum/c4_file/terminal_program/netpage/New()
	..()
	if(!pager_info)
		pager_info = list()
		for(var/path in subtypesof(/datum/pager_access_info))
			pager_info += new path

	if(!commands)
		commands = list()
		for(var/path as anything in subtypesof(/datum/shell_command/netpage))
			commands += new path

/datum/c4_file/terminal_program/netpage/execute(datum/c4_file/terminal_program/operating_system/thinkdos/system)
	. = ..()
	if(.)
		return

	var/title_text = list(
		@"<pre style='margin: 0px'>      ___ ___  __        __   ___</pre>",
		@"<pre style='margin: 0px'>|\ | |__   |  |__)  /\  / _` |__ </pre>",
		@"<pre style='margin: 0px'>| \| |___  |  |    /~~\ \__> |___</pre>",
	).Join("")
	system.println(title_text)

	check_for_errors()
	system.println("Available commands: help, post, networks, quit")

/datum/c4_file/terminal_program/netpage/std_in(text)
	. = ..()
	var/datum/shell_stdin/parsed_stdin = parse_std_in(text)

	var/datum/c4_file/terminal_program/operating_system/system = get_os()
	system.println(html_encode(text))

	for(var/datum/shell_command/potential_command as anything in commands)
		if(potential_command.try_exec(parsed_stdin.command, system, src, parsed_stdin.arguments, parsed_stdin.options))
			return TRUE

/datum/c4_file/terminal_program/netpage/proc/check_for_errors()
	var/datum/c4_file/terminal_program/operating_system/thinkdos/system = get_os()

	if(!get_adapter())
		system.println("<b>Error:</b> Unable to locate network adapter.")
		. = TRUE

	if(system.needs_login)
		return .

	if(!get_reader())
		system.println("<b>Error:</b> Unable to locate card reader.")
		return TRUE

	if(!get_reader().inserted_card)
		system.println("<b>Error:</b> No card inserted.")
		return TRUE

	return FALSE

/datum/c4_file/terminal_program/netpage/proc/get_reader()
	RETURN_TYPE(/obj/item/peripheral/card_reader)
	return get_computer().get_peripheral(PERIPHERAL_TYPE_CARD_READER)

/datum/c4_file/terminal_program/netpage/proc/get_adapter()
	RETURN_TYPE(/obj/item/peripheral/network_card/wireless)
	return get_computer().get_peripheral(PERIPHERAL_TYPE_WIRELESS_CARD)

/datum/c4_file/terminal_program/netpage/proc/get_options()
	var/list/card_access = list()
	var/datum/c4_file/terminal_program/operating_system/thinkdos/system = get_os()

	if(system.needs_login)
		card_access = system.current_user.access

	else
		var/obj/item/peripheral/card_reader/reader = get_reader()
		card_access = reader?.inserted_card?.GetAccess()

	var/list/options = list()

	if(!card_access)
		return options

	for(var/datum/pager_access_info/info as anything in pager_info)
		if(info.required_access in card_access)
			options += info
	return options

/datum/pager_access_info
	var/arg_name
	var/pager_class
	var/required_access

/datum/pager_access_info/aether
	arg_name = "aether"
	pager_class = PAGER_CLASS_AETHER
	required_access = ACCESS_CMO

/datum/pager_access_info/management
	arg_name = "gov"
	pager_class = PAGER_CLASS_MANAGEMENT
	required_access = ACCESS_CAPTAIN

/datum/pager_access_info/mars
	arg_name = "mpc"
	pager_class = PAGER_CLASS_MARS
	required_access = ACCESS_HOS
