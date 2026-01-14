/datum/c4_file/terminal_program/ansi_test
	name = "dbg_ansi"
	size = 1

/datum/c4_file/terminal_program/ansi_test/execute(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/parsed_cmdline/cmdline)
	. = ..()
	//Iterate and test all SGR parameters in standard form, or special form as needed.

	var/print_all = !!cmdline.options.Find("a")


	system.println("#----------#-----------#-----------#")
	for(var/param_id in 0 to 107)
		switch(param_id)
			//Unsupported/undefined
			if(5-7,20,25-27,50,52,56-57,60-72,76-89,98-99,)
				if(print_all)
					system.println("| SGR [fit_with_zeros("[param_id]", 3)]: |     NOT SUPPORTED     |")
				continue
			if(38,48,58)
				system.println("| SGR [fit_with_zeros("[param_id]", 3)]: |  Uses Extended Color  |")
			else
				system.println("| SGR [fit_with_zeros("[param_id]", 3)]: | Test Text | [ANSI_SGR(param_id)]Test Text[ANSI_FULL_RESET] |")
	system.println("#----------#-----------#-----------#")
	system.unload_program(src)
	return
