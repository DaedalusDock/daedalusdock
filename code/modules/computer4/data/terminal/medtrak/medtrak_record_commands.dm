/datum/shell_command/medtrak/record/quit
	aliases = list("quit", "q",)

/datum/shell_command/medtrak/record/quit/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	system.println("Quitting...")
	system.unload_program(program)

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

/datum/shell_command/medtrak/record/home
	aliases = list("home")

/datum/shell_command/medtrak/index/home/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/medtrak/medtrak = program
	medtrak.view_home()

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
			medtrak.await_input("Are you sure? (Y/N)", CALLBACK(src, PROC_REF(confirm_delete)))

/datum/shell_command/medtrak/record/print
	aliases = list("print", "p", "P")

/datum/shell_command/medtrak/record/print/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/medtrak/medtrak = program
	var/obj/item/peripheral/printer/printer = system.get_computer().get_peripheral(PERIPHERAL_TYPE_PRINTER)
	if(!printer)
		system.println("<b>Error:</b> Unable to locate printer.")
		return

	if(printer.busy)
		system.println("<b>Error:</b> Printer is busy.")
		return

	var/list/fields = medtrak.current_record.fields
	var/list/out = list(
		"<center><b>Medical Record: [fields[DATACORE_NAME]]</b></center><br>",
		"ID: [fields[DATACORE_ID]]",
		"Sex: [fields[DATACORE_GENDER]]",
		"Age: [fields[DATACORE_AGE]]",
		"Species: [fields[DATACORE_SPECIES]]",
		"Blood Type: [fields[DATACORE_BLOOD_TYPE]]",
		"Blood DNA: [fields[DATACORE_BLOOD_DNA]]",
		"Disabilities: [fields[DATACORE_DISABILITIES]]",
		"Diseases: [fields[DATACORE_DISEASES]]",
		"<br>Important Notes:",
		"<br>&emsp;[fields[DATACORE_NOTES]]"
	)

	printer.print(jointext(out, "<br>"), "Medical Record")

	medtrak.write_log("Printed record: [fields[DATACORE_ID]]")
	system.println("Printing...")

/datum/shell_command/medtrak/record/view_comments
	aliases = list("comments", "c")

/datum/shell_command/medtrak/record/view_comments/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/medtrak/medtrak = program
	medtrak.view_comments()
