/datum/c4_file/record
	name = "record"
	extension = "REC"

	/// The contained text
	var/datum/data/record/stored_record

/datum/c4_file/record/New()
	. = ..()
	stored_record = new

/datum/c4_file/record/to_string()
	var/list/out = list()
	for(var/field in stored_record.fields)
		out += field
		if(stored_record.fields[field])
			out += "=[stored_record.fields[field]]|n"
		else
			out += "|n"

	return jointext(out, "")
