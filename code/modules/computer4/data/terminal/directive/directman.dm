/datum/c4_file/terminal_program/directman
	name = "directMAN"
	size = 2

	req_access = list(ACCESS_CAPTAIN)

	var/static/list/main_commands
	var/static/datum/shell_command/home_command

	var/datum/directive/viewing_directive

	var/current_menu = DIRECTMAN_MENU_HOME

/datum/c4_file/terminal_program/directman/New()
	..()

	if(!main_commands)
		main_commands = list()
		home_command = new /datum/shell_command/directman/home
		for(var/path as anything in subtypesof(/datum/shell_command/directman/main))
			main_commands += new path

/datum/c4_file/terminal_program/directman/execute(datum/c4_file/terminal_program/operating_system/thinkdos/system)
	. = ..()

	if(!system.get_computer().get_peripheral(PERIPHERAL_TYPE_WIRELESS_CARD))
		system.println("<b>Error:</b> Unable to locate wireless adapter.")

	view_home()

/datum/c4_file/terminal_program/directman/std_in(text)
	. = ..()
	var/datum/shell_stdin/parsed_stdin = parse_std_in(text)

	var/datum/c4_file/terminal_program/operating_system/system = get_os()
	system.println(html_encode(text))

	if(home_command.try_exec(parsed_stdin.command, system, src, parsed_stdin.arguments, parsed_stdin.options))
		return TRUE

	switch(current_menu)
		if(DIRECTMAN_MENU_HOME)
			for(var/datum/shell_command/potential_command as anything in main_commands)
				if(potential_command.try_exec(parsed_stdin.command, system, src, parsed_stdin.arguments, parsed_stdin.options))
					return TRUE

		if(DIRECTMAN_MENU_CURRENT)
			var/number = text2num(parsed_stdin.raw)
			if(lowertext(parsed_stdin.raw) == "b")
				system.clear_screen(TRUE)
				view_home()
				return TRUE

			if(!(number in 1 to length(SSdirectives.get_active_directives())))
				return

			view_directive(number)
			return TRUE

		if(DIRECTMAN_MENU_ACTIVE_DIRECTIVE)
			if(lowertext(parsed_stdin.raw) == "b")
				system.clear_screen(TRUE)
				view_current()
				return TRUE

		if(DIRECTMAN_MENU_NEW_DIRECTIVES)
			var/number = text2num(parsed_stdin.raw)
			if(!(number in 1 to length(SSdirectives.get_directives_for_selection())))
				return

			if(number == 0)
				view_home()
				return TRUE

			view_new_directive(number)
			return TRUE

		if(DIRECTMAN_MENU_NEW_DIRECTIVE)
			if(lowertext(parsed_stdin.raw) == "b")
				system.clear_screen(TRUE)
				if(!system.get_computer().get_peripheral(PERIPHERAL_TYPE_WIRELESS_CARD))
					view_home()
					system.println("<b>Error:</b> Unable to locate wireless adapter.")
					return
				view_new()
				return TRUE


			if(lowertext(parsed_stdin.raw) == "s")
				if(!system.get_computer().get_peripheral(PERIPHERAL_TYPE_WIRELESS_CARD))
					view_home()
					system.println("<b>Error:</b> Unable to locate wireless adapter.")
					return

				addtimer(CALLBACK(SSdirectives, TYPE_PROC_REF(/datum/controller/subsystem/directives, enact_directive), viewing_directive), rand(3, 10) SECONDS)
				SSdirectives.selectable_directives = null
				system.clear_screen(TRUE)
				view_home()
				return TRUE

/datum/c4_file/terminal_program/directman/proc/view_home()
	current_menu = DIRECTMAN_MENU_HOME

	var/list/out = list(
		@"<pre style='margin: 0px'> ┌┬┐┬┬─┐┌─┐┌─┐┌┬┐╔╦╗╔═╗╔╗╔</pre>",
		@"<pre style='margin: 0px'>  │││├┬┘├┤ │   │ ║║║╠═╣║║║</pre>",
		@"<pre style='margin: 0px'> ─┴┘┴┴└─└─┘└─┘ ┴ ╩ ╩╩ ╩╝╚╝</pre>",
		"Commands:<br>",
		"\[1\] View Current Directives<br>",
	)

	if(SSdirectives.get_directives_for_selection())
		out += "\[2\] View New Directives<br>"

	out += "<br>\[R\] Refresh"

	get_os().println(jointext(out, null))

/datum/c4_file/terminal_program/directman/proc/view_current()
	if(!get_os().get_computer().get_peripheral(PERIPHERAL_TYPE_WIRELESS_CARD))
		get_os().println("<b>Error:</b> Unable to locate wireless adapter.")
		return

	current_menu = DIRECTMAN_MENU_CURRENT

	var/list/out = list()

	var/i
	for(var/datum/directive/directive as anything in SSdirectives.get_active_directives())
		i++
		out += "\[[fit_with_zeros("[i]", 2)]\] [directive.name]"
	out += "<br>\[B\] Return"

	get_os().println(jointext(out, "<br>"))

/datum/c4_file/terminal_program/directman/proc/view_directive(index)
	if(!get_os().get_computer().get_peripheral(PERIPHERAL_TYPE_WIRELESS_CARD))
		get_os().println("<b>Error:</b> Unable to locate wireless adapter.")
		return

	current_menu = DIRECTMAN_MENU_ACTIVE_DIRECTIVE

	var/list/active_directives = SSdirectives.get_active_directives()
	var/datum/directive/directive = active_directives[1]
	var/list/out = list(
		"Name: [directive.name]",
		"Description: [directive.desc]",
		"Severity: [directive.severity]",
		"Time Given: [active_directives[directive]]",
		"<br>\[B\] Return",
	)

	get_os().println(jointext(out, "<br>"))

/datum/c4_file/terminal_program/directman/proc/view_new()
	if(!get_os().get_computer().get_peripheral(PERIPHERAL_TYPE_WIRELESS_CARD))
		get_os().println("<b>Error:</b> Unable to locate wireless adapter.")
		return

	if(!SSdirectives.get_directives_for_selection())
		get_os().println("<b>Error:</b> No new directives to display.")
		return

	current_menu = DIRECTMAN_MENU_NEW_DIRECTIVES

	var/list/out = list()

	var/i
	for(var/datum/directive/directive as anything in SSdirectives.get_directives_for_selection())
		i++
		out += "\[[fit_with_zeros("[i]", 2)]\] [directive.name]"
	out += "<br>\[B\] Return"

	get_os().println(jointext(out, "<br>"))

/datum/c4_file/terminal_program/directman/proc/view_new_directive(index)
	if(!get_os().get_computer().get_peripheral(PERIPHERAL_TYPE_WIRELESS_CARD))
		view_home()
		get_os().println("<b>Error:</b> Unable to locate wireless adapter.")
		return

	get_os().clear_screen(TRUE)

	current_menu = DIRECTMAN_MENU_NEW_DIRECTIVE

	viewing_directive = SSdirectives.get_directives_for_selection()[index]
	var/list/out = list(
		"Name: [viewing_directive.name]",
		"Description: [viewing_directive.desc]",
		"Payout: [viewing_directive.reward] mark\s",
		"Severity: [viewing_directive.severity]",
		"<br>\[B\] Return | \[S\] Select"
	)

	get_os().println(jointext(out, "<br>"))
