/datum/c4_file/terminal_program/medtrak/proc/edit_name(datum/c4_file/terminal_program/medtrak/medtrak, datum/shell_stdin/stdin)
	var/new_name = trim(html_encode(stdin.raw), MAX_NAME_LEN)

	if(!(length(new_name)))
		medtrak.await_input("Enter a new Name (Max Length: [MAX_NAME_LEN])")
		return

	medtrak.update_record(DATACORE_NAME, "NAME", new_name)
	medtrak.view_record()

/datum/c4_file/terminal_program/medtrak/proc/edit_sex(datum/c4_file/terminal_program/medtrak/medtrak, datum/shell_stdin/stdin)
	var/new_sex = trim(html_encode(stdin.raw), MAX_NAME_LEN)

	if(!length(new_sex))
		medtrak.await_input("Enter a new Sex")
		return

	medtrak.update_record(DATACORE_GENDER, "SEX", new_sex)
	medtrak.view_record()

/datum/c4_file/terminal_program/medtrak/proc/edit_age(datum/c4_file/terminal_program/medtrak/medtrak, datum/shell_stdin/stdin)
	var/new_age = text2num(ckey(stdin.raw))

	if(isnull(new_age) || !(new_age in 1 to 200))
		medtrak.await_input("Enter a new Age (1-200)", PROC_REF(edit_age))
		return

	medtrak.update_record(DATACORE_AGE, "AGE", "[new_age]")
	medtrak.view_record()

