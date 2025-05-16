/datum/c4_file/terminal_program/medtrak/proc/edit_name(datum/c4_file/terminal_program/medtrak/medtrak, datum/shell_stdin/stdin)
	var/new_name = trim(html_encode(stdin.raw), MAX_NAME_LEN)

	if(!(length(new_name)))
		medtrak.await_input("Enter a new Name (Max Length: [MAX_NAME_LEN])", CALLBACK(src, PROC_REF(edit_name)))
		return

	medtrak.update_record(DATACORE_NAME, "NAME", new_name)
	medtrak.view_record()

/datum/c4_file/terminal_program/medtrak/proc/edit_sex(datum/c4_file/terminal_program/medtrak/medtrak, datum/shell_stdin/stdin)
	var/new_sex = trim(html_encode(stdin.raw), MAX_NAME_LEN)

	if(!length(new_sex))
		await_input("Enter a new Sex (Max Length: [MAX_NAME_LEN])", CALLBACK(src, PROC_REF(edit_sex)))
		return

	medtrak.update_record(DATACORE_GENDER, "SEX", new_sex)
	medtrak.view_record()

/datum/c4_file/terminal_program/medtrak/proc/edit_age(datum/c4_file/terminal_program/medtrak/medtrak, datum/shell_stdin/stdin)
	var/new_age = text2num(ckey(stdin.raw))

	if(isnull(new_age) || !(new_age in 1 to 200))
		medtrak.await_input("Enter a new Age (1-200)", CALLBACK(src, PROC_REF(edit_age)))
		return

	medtrak.update_record(DATACORE_AGE, "AGE", "[new_age]")
	medtrak.view_record()

/datum/c4_file/terminal_program/medtrak/proc/edit_species(datum/c4_file/terminal_program/medtrak/medtrak, datum/shell_stdin/stdin)
	var/new_species = trim(html_encode(stdin.raw), MAX_NAME_LEN)

	if(!length(new_species))
		await_input("Enter a new Species (Max Length: [MAX_NAME_LEN])", CALLBACK(src, PROC_REF(edit_species)))
		return

	medtrak.update_record(DATACORE_SPECIES, "SPECIES", new_species)
	medtrak.view_record()

/datum/c4_file/terminal_program/medtrak/proc/edit_blood_type(datum/c4_file/terminal_program/medtrak/medtrak, datum/shell_stdin/stdin)
	var/new_blood_type = trim(html_encode(stdin.raw), MAX_NAME_LEN)

	if(!length(new_blood_type))
		await_input("Enter a new Blood Type (Max Length: [MAX_NAME_LEN])", CALLBACK(src, PROC_REF(edit_blood_type)))
		return

	medtrak.update_record(DATACORE_BLOOD_TYPE, "BLOOD_TYPE", new_blood_type)
	medtrak.view_record()

/datum/c4_file/terminal_program/medtrak/proc/edit_blood_dna(datum/c4_file/terminal_program/medtrak/medtrak, datum/shell_stdin/stdin)
	var/new_blood_dna = trim(html_encode(stdin.raw), MAX_NAME_LEN)

	if(!length(new_blood_dna))
		await_input("Enter new Blood DNA (Max Length: [MAX_NAME_LEN])", CALLBACK(src, PROC_REF(edit_blood_dna)))
		return

	medtrak.update_record(DATACORE_BLOOD_DNA, "BLOOD_DNA", new_blood_dna)
	medtrak.view_record()

/datum/c4_file/terminal_program/medtrak/proc/edit_disabilities(datum/c4_file/terminal_program/medtrak/medtrak, datum/shell_stdin/stdin)
	var/new_disabilities = trim(html_encode(stdin.raw), MAX_MESSAGE_LEN)

	if(!length(new_disabilities))
		await_input("Enter new Disabilities (Max Length: [MAX_MESSAGE_LEN])", CALLBACK(src, PROC_REF(edit_blood_dna)))
		return

	medtrak.update_record(DATACORE_DISABILITIES, "DISABILITIES", new_disabilities)
	medtrak.view_record()

/datum/c4_file/terminal_program/medtrak/proc/edit_diseases(datum/c4_file/terminal_program/medtrak/medtrak, datum/shell_stdin/stdin)
	var/new_diseases = trim(html_encode(stdin.raw), MAX_MESSAGE_LEN)

	if(!length(new_diseases))
		await_input("Enter new Diseases (Max Length: [MAX_MESSAGE_LEN])", CALLBACK(src, PROC_REF(edit_diseases)))
		return

	medtrak.update_record(DATACORE_DISEASES, "DISEASES", new_diseases)
	medtrak.view_record()

/datum/c4_file/terminal_program/medtrak/proc/edit_allergies(datum/c4_file/terminal_program/medtrak/medtrak, datum/shell_stdin/stdin)
	var/new_allergies = trim(html_encode(stdin.raw), MAX_MESSAGE_LEN)

	if(!length(new_allergies))
		await_input("Enter new Allergies (Max Length: [MAX_MESSAGE_LEN])", CALLBACK(src, PROC_REF(edit_allergies)))
		return

	medtrak.update_record(DATACORE_ALLERGIES, "ALLERGIES", new_allergies)
	medtrak.view_record()

/datum/c4_file/terminal_program/medtrak/proc/edit_physical_health(datum/c4_file/terminal_program/medtrak/medtrak, datum/shell_stdin/stdin)
	var/choice = text2num(stdin.raw)
	var/list/options = list(
		PHYSHEALTH_OK,
		PHYSHEALTH_CARE,
		PHYSHEALTH_DECEASED,
	)

	if(!(choice in 1 to length(options)))
		await_input(
			{"Edit Physical Status<br>
			\[1\] [PHYSHEALTH_OK]<br>
			\[2\] [PHYSHEALTH_CARE]<br>
			\[3\] [PHYSHEALTH_DECEASED]
			"},
			CALLBACK(src, PROC_REF(edit_physical_health))
		)
		return

	medtrak.update_record(DATACORE_PHYSICAL_HEALTH, "PHYSICAL_STATUS", options[choice])
	medtrak.view_record()

/datum/c4_file/terminal_program/medtrak/proc/edit_mental_health(datum/c4_file/terminal_program/medtrak/medtrak, datum/shell_stdin/stdin)
	var/choice = text2num(stdin.raw)
	var/list/options = list(
		MENHEALTH_OK,
		MENHEALTH_WATCH,
		MENHEALTH_UNSTABLE,
		MENHEALTH_INSANE,
	)

	if(!(choice in 1 to length(options)))
		await_input(
			{"Edit Mental Status<br>
			\[1\] [MENHEALTH_OK]<br>
			\[2\] [MENHEALTH_WATCH]<br>
			\[3\] [MENHEALTH_UNSTABLE]<br>
			\[4\] [MENHEALTH_INSANE]
			"},
			CALLBACK(src, PROC_REF(edit_mental_health))
		)
		return

	medtrak.update_record(DATACORE_MENTAL_HEALTH, "MENTAL_STATUS", options[choice])
	medtrak.view_record()

/datum/c4_file/terminal_program/medtrak/proc/edit_notes(datum/c4_file/terminal_program/medtrak/medtrak, datum/shell_stdin/stdin)
	var/new_notes = trim(html_encode(stdin.raw), MAX_MESSAGE_LEN)

	if(!length(new_notes))
		await_input("Enter new Notes (Max Length: [MAX_MESSAGE_LEN])", CALLBACK(src, PROC_REF(edit_diseases)))
		return

	medtrak.update_record(DATACORE_NOTES, "NOTES", new_notes)
	medtrak.view_record()
