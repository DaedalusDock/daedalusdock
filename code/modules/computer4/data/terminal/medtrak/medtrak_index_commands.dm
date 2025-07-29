/datum/shell_command/medtrak/index/quit
	aliases = list("quit", "q", "exit")

/datum/shell_command/medtrak/index/quit/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	system.println("Quitting...")
	system.unload_program(program)

/datum/shell_command/medtrak/index/back
	aliases = list("back", "home")

/datum/shell_command/medtrak/index/back/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/medtrak/medtrak = program
	medtrak.view_home()

/datum/shell_command/medtrak/index/new_record
	aliases = list("new")

/datum/shell_command/medtrak/index/new_record/exec(datum/c4_file/terminal_program/operating_system/thinkdos/system, datum/c4_file/terminal_program/program, list/arguments, list/options)
	var/datum/c4_file/terminal_program/medtrak/medtrak = program
	var/datum/data/record/R = new /datum/data/record/medical()

	R.fields[DATACORE_NAME] = "New Record"
	R.fields[DATACORE_ID] = SSdatacore.next_record_id()
	R.fields[DATACORE_GENDER] = "Unknown"
	R.fields[DATACORE_AGE] = "Unknown"
	R.fields[DATACORE_SPECIES] = "Unknown"
	R.fields[DATACORE_BLOOD_TYPE] = "Unknown"
	R.fields[DATACORE_BLOOD_DNA] = "Unknown"
	R.fields[DATACORE_DISABILITIES] = "None"
	R.fields[DATACORE_PHYSICAL_HEALTH] = PHYSHEALTH_OK
	R.fields[DATACORE_MENTAL_HEALTH] = MENHEALTH_OK
	R.fields[DATACORE_ALLERGIES] = "None"
	R.fields[DATACORE_DISEASES] = "None"
	R.fields[DATACORE_NOTES] = "No notes."

	SSdatacore.inject_record(R, DATACORE_RECORDS_MEDICAL)
	medtrak.write_log("Created new record: [R.fields[DATACORE_ID]]")
	medtrak.view_index()
