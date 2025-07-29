/datum/shell_command/medtrak/comment/quit
	aliases = list("quit", "q", "exit")

/datum/shell_command/medtrak/index/quit/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	system.println("Quitting...")
	system.unload_program(program)

/datum/shell_command/medtrak/comment/back
	aliases = list("back", "home")

/datum/shell_command/medtrak/record/comment/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/medtrak/medtrak = program
	medtrak.view_record()

/datum/shell_command/medtrak/comment/new_comment
	aliases = list("n", "new")

/datum/shell_command/medtrak/comment/new_comment/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/medtrak/medtrak = program
	medtrak.await_input("Enter a new comment", CALLBACK(src, PROC_REF(fulfill_new_comment)))

/datum/shell_command/medtrak/comment/new_comment/proc/fulfill_new_comment(list/results, datum/c4_file/terminal_program/medtrak/medtrak, datum/shell_stdin/stdin)
	var/datum/c4_file/terminal_program/operating_system/thinkdos/system = medtrak.get_os()
	if(!length(stdin.raw))
		medtrak.view_comments()
		return

	medtrak.current_record.fields[DATACORE_COMMENTS] ||= list()
	medtrak.current_record.fields[DATACORE_COMMENTS] += "[system.current_user.registered_name] on [stationtime2text()] [time2text(world.realtime, "MMM DD")], '77: [html_encode(stdin.raw)]"
	medtrak.view_comments()
