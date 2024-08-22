/datum/computer_file/program/records
	filename = "ntrecords"
	filedesc = "Records"
	extended_desc = "Allows the user to view several basic records from the crew."
	category = PROGRAM_CATEGORY_MISC
	program_icon = "clipboard"
	program_icon_state = "crew"
	tgui_id = "NtosRecords"
	size = 4
	usage_flags = PROGRAM_TABLET | PROGRAM_LAPTOP
	available_on_ntnet = FALSE

	var/mode

/datum/computer_file/program/records/medical
	filedesc = "Medical Records"
	filename = "medrecords"
	program_icon = "book-medical"
	extended_desc = "Allows the user to view several basic medical records from the crew."
	transfer_access = list(ACCESS_MEDICAL, ACCESS_FLAG_COMMAND)
	available_on_ntnet = TRUE
	mode = "medical"

/datum/computer_file/program/records/security
	filedesc = "Security Records"
	filename = "secrecords"
	extended_desc = "Allows the user to view several basic security records from the crew."
	transfer_access = list(ACCESS_SECURITY, ACCESS_FLAG_COMMAND)
	available_on_ntnet = TRUE
	mode = "security"

/datum/computer_file/program/records/proc/GetRecordsReadable()
	var/list/all_records = list()

	switch(mode)
		if("security")
			for(var/datum/data/record/person in SSdatacore.get_records(DATACORE_RECORDS_STATION))
				var/datum/data/record/security_person = SSdatacore.find_record("id", person.fields[DATACORE_ID], DATACORE_RECORDS_SECURITY)
				var/list/current_record = list()

				if(security_person)
					current_record["wanted"] = security_person.fields[DATACORE_CRIMINAL_STATUS]

				current_record["id"] = person.fields[DATACORE_ID]
				current_record["name"] = person.fields[DATACORE_NAME]
				current_record["rank"] = person.fields[DATACORE_RANK]
				current_record["gender"] = person.fields[DATACORE_GENDER]
				current_record["age"] = person.fields[DATACORE_AGE]
				current_record["species"] = person.fields[DATACORE_SPECIES]
				current_record["fingerprint"] = person.fields[DATACORE_FINGERPRINT]

				all_records += list(current_record)
		if("medical")
			for(var/datum/data/record/person in SSdatacore.get_records(DATACORE_RECORDS_MEDICAL))
				var/list/current_record = list()

				current_record["name"] = person.fields[DATACORE_NAME]
				current_record["bloodtype"] = person.fields[DATACORE_BLOOD_TYPE]
				current_record["ma_dis"] = person.fields[DATACORE_DISABILITIES]
				current_record["notes"] = person.fields[DATACORE_NOTES]
				current_record["cnotes"] = person.fields[DATACORE_NOTES_DETAILS]

				all_records += list(current_record)

	return all_records



/datum/computer_file/program/records/ui_data(mob/user)
	var/list/data = get_header_data()
	data["records"] = GetRecordsReadable()
	data["mode"] = mode
	return data
