/datum/shell_command/medtrak/home/quit
	aliases = list("quit", "0", "q", "exit")

/datum/shell_command/medtrak/home/quit/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	system.println("Quitting...")
	system.unload_program(program)

/datum/shell_command/medtrak/home/index
	aliases = list("records", "1", "index", "view")

/datum/shell_command/medtrak/home/index/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/medtrak/medtrak = program
	medtrak.view_index()

/datum/shell_command/medtrak/home/search
	aliases = list("search", "2")

/datum/shell_command/medtrak/home/search/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/medtrak/medtrak = program
	medtrak.await_input("Enter target Name, or ID.", CALLBACK(src, PROC_REF(search_input)))

/datum/shell_command/medtrak/home/search/proc/search_input(datum/c4_file/terminal_program/medtrak/medtrak, datum/shell_stdin/stdin)
	var/search_text = stdin.raw
	if(isnull(search_text))
		medtrak.view_home()
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
			medtrak.get_os().println("No results found.")
			return

		if(1)
			medtrak.view_record(results[1])
			return

		else
			var/list/out = list("Multiple results found:")
			var/i
			for(var/datum/data/record/found_record as anything in results)
				i++
				out += "<b>\[[fit_with_zeros("[i]", 3)]\]</b> [found_record.fields[DATACORE_ID]]: [found_record.fields[DATACORE_NAME]]"

			medtrak.await_input(jointext(out, "<br>"), CALLBACK(src, PROC_REF(fulfill_search), results))
			return

/datum/shell_command/medtrak/home/search/proc/fulfill_search(list/results, datum/c4_file/terminal_program/medtrak/medtrak, datum/shell_stdin/stdin)
	var/number = text2num(ckey(stdin.raw))
	if(isnull(number) || !(number in 1 to length(results)))
		medtrak.view_home()
		medtrak.get_os().println("Search operation cancelled.")
		return

	medtrak.view_record(results[number])
