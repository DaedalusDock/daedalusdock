/datum/shell_command/medtrak/record/quit
	aliases = list("quit", "q",)

/datum/shell_command/medtrak/record/quit/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	system.println("Quitting...")
	program.get_computer().unload_program(program)

/datum/shell_command/medtrak/record/refresh
	aliases = list("R", "r", "refresh")

/datum/shell_command/medtrak/record/refresh/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/medtrak/medtrak = program
	medtrak.view_record(medtrak.current_record)

/datum/shell_command/medtrak/record/back
	aliases = list("back")

/datum/shell_command/medtrak/record/back/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/medtrak/medtrak = program
	medtrak.view_index()

/datum/shell_command/medtrak/record/delete
	aliases = list("D", "d", "del", "delete")

/datum/shell_command/medtrak/record/delete/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/medtrak/medtrak = program
	medtrak.view_record(medtrak.current_record)
	medtrak.await_input("Are you sure you want to delete '[medtrak.current_record.fields[DATACORE_NAME]]'?(Y/N)", CALLBACK(src, PROC_REF(confirm_delete), medtrak))

/datum/shell_command/medtrak/record/delete/proc/confirm_delete(datum/c4_file/terminal_program/medtrak/medtrak, datum/shell_stdin/stdin)
	switch(lowertext(jointext(stdin.raw, "")))
		if("y")
			medtrak.write_log("Record [medtrak.current_record.fields[DATACORE_ID]] deleted.")
			qdel(medtrak.current_record)
			medtrak.view_index()

		if("n")
			medtrak.view_index()

		else
			medtrak.await_input("Are you sure? (Y/N)", CALLBACK(src, PROC_REF(confirm_delete), medtrak))
