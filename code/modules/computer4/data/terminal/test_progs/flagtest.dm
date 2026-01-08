//Dumps the cmdline information it's called with.
/datum/c4_file/terminal_program/cmdline_test
	name = "dbg_cmdline"
	size = 1

/datum/c4_file/terminal_program/cmdline_test/execute(datum/c4_file/terminal_program/operating_system/thinkdos/system, cmdline)
	var/datum/parsed_cmdline/lines = cmdline
	//Assure that we have a parsed cmdline
	if(!istype(lines))
		lines = new /datum/parsed_cmdline(cmdline)

	//Print our cmdline data
	system.println(json_encode(list(
		"raw" = lines.raw,
		"command" = lines.command,
		"args" = lines.arguments,
		"opts" = lines.options
	), JSON_PRETTY_PRINT))
	//And exit.
	system.unload_program(src)
	return
