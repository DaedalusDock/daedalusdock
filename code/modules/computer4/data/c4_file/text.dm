/datum/c4_file/text
	name = "text"
	extension = "TXT"

	/// The contained text
	var/data = ""

/datum/c4_file/text/to_string()
	return "[data]|n"
