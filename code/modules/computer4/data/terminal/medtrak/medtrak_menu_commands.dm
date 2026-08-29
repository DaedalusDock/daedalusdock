/datum/shell_command/medtrak/home/quit
	aliases = list("quit", "0", "q", "exit")
	help_text = "Terminates the program.\nUsage: 'quit'"

/datum/shell_command/medtrak/home/quit/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	system.println("Quitting...")
	system.unload_program(program)

/datum/shell_command/medtrak/home/help
	aliases = list("help")
	help_text = "Lists all available commands. Use help \[command\] to view information about a specific command."

/datum/shell_command/medtrak/home/help/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/medtrak/medtrak = program
	noop(medtrak)
	var/list/all_commands = medtrak.home_commands
	var/list/output = generate_help(system, program, arguments, all_commands)
	if(output)
		system.println(jointext(output, "\n"))

/datum/shell_command/medtrak/home/index
	aliases = list("records", "1", "index", "view")
	help_text = "View stored records.\nUsage: 'records'"

/datum/shell_command/medtrak/home/index/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/medtrak/medtrak = program
	medtrak.view_index()

/datum/shell_command/medtrak/home/search
	aliases = list("search", "2")
	help_text = "Search stored records.\nUsage: 'search \[name or ID\]'"

/datum/shell_command/medtrak/home/search/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/medtrak/medtrak = program

	var/search_text = jointext(arguments, " ")
	if(!length(search_text))
		system.print_error("[ANSI_WRAP_BOLD("Error:")] No search query provided.")
		return

	var/list/results = list()
	for(var/datum/data/record/iter_record as anything in medtrak.medical_records.records)
		var/fields = iter_record.fields
		var/haystack = list(fields[DATACORE_NAME], fields[DATACORE_ID])
		if(findtext(jointext(haystack, " "), search_text))
			results += iter_record

	switch(length(results))
		if(0)
			medtrak.view_home()
			system.println("No results found.")
			return

		if(1)
			medtrak.view_record(results[1])
			return

		else
			var/list/out = list("Multiple results found:")
			var/i
			for(var/datum/data/record/found_record as anything in results)
				i++
				out += "[ANSI_WRAP_BOLD("\[[fit_with_zeros("[i]", 3)]\]")] [found_record.fields[DATACORE_ID]]: [found_record.fields[DATACORE_NAME]]"

			medtrak.await_input(jointext(out, "\n"), CALLBACK(src, PROC_REF(fulfill_search), results))
			return

/datum/shell_command/medtrak/home/search/proc/fulfill_search(list/results, datum/c4_file/terminal_program/medtrak/medtrak, datum/parsed_cmdline/stdin)
	var/number = text2num(ckey(stdin.raw))
	if(isnull(number) || !(number in 1 to length(results)))
		medtrak.view_home()
		medtrak.get_os().println("Search operation cancelled.")
		return

	medtrak.view_record(results[number])
