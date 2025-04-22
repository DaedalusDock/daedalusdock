/// The abstract concept of computer data, but it's not actually data, it's lower level than that.
/datum/computer4
	var/name = ""

	/// If the file is copyable by default.
	var/copyable = TRUE

	/// Metadata about this thing
	var/datum/computer_metadata/metadata
	/// TEMP, will likely end up it's own machine. Here to access machine shit while deving for now.
	var/obj/machinery/computer/computer

/datum/computer4/New()
	metadata = new()
	metadata.date = stationdate2text()

/// Attempt to stringify the data. Return can be flavorful datamosh.
/datum/computer/proc/to_string()
	return
