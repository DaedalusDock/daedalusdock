/// Computer files.
/datum/c4_file

	var/name = "file"
	var/extension = "DAT"

	var/size = 0

	/// If the file is copyable by default.
	var/copyable = TRUE // Don't copy that floppy.

	/// Metadata about this thing
	var/datum/computer_metadata/metadata

	/// Drive this file is on.
	var/obj/item/disk/data/drive
	/// Folder the file is in, if any.
	var/datum/c4_file/folder/containing_folder
	/// TEMP, will likely end up it's own machine. Here to access machine shit while deving for now.
	var/obj/machinery/computer4/computer

/datum/c4_file/New()
	metadata = new()
	metadata.date = stationdate2text()

/datum/c4_file/Destroy()
	if(containing_folder)
		var/datum/c4_file/folder/dont_recursively_delete_thanks = containing_folder
		containing_folder = null
		dont_recursively_delete_thanks.try_delete_file(src, TRUE)

	return ..()

/// Attempt to stringify the data.
/datum/c4_file/proc/to_string()
	return "Error: Cannot convert type 'unknown' to 'string'"

/datum/file_path
	var/directory
	var/file_name

/datum/c4_file/proc/text_to_filepath(text)
	if(!text)
		return

	var/list/split_path = splittext(text, "/")
	var/file_name = split_path[length(split_path)]
	var/directory = copytext(text, 1, length(text) - length(file_name) + 1)

	var/datum/file_path/path = new
	path.directory = directory
	path.file_name = file_name
	return path

/// Take a directory, vomit out a folder at that directory or null
/datum/c4_file/proc/parse_directory(text, datum/c4_file/folder/origin) as /datum/c4_file/folder
	RETURN_TYPE(/datum/c4_file/folder)

	if(!text)
		return

	if(!origin)
		origin = containing_folder

	var/datum/c4_file/folder/destination = origin

	if(copytext(text, 1) == "/")
		destination = origin.drive.root
		text = copytext(text, 2)

	var/list/split_by_slash = splittext(text,"/")
	if (length(split_by_slash) && copytext(split_by_slash[1], 4, 5) == ":")
		var/prefix = lowertext(copytext(split_by_slash[1], 1, 4) )

		if (length(split_by_slash[1]) > 4)
			split_by_slash[1] = copytext(split_by_slash[1], 5)
		else
			split_by_slash.Cut(1,2)

		switch (prefix)
			if ("hd0") // Magic value for "the hard drive"
				if(computer.internal_disk)
					destination = computer.internal_disk.root
				else
					return null

			if ("fd0") // Magic value for "the floppy"
				if(computer.inserted_disk)
					destination = computer.inserted_disk.root
				else
					return null

	while(destination)
		if(!length(split_by_slash))
			return destination

		// This handles ../../ shit
		switch(split_by_slash[1])
			if("..")
				if(!destination.containing_folder) // current folder is the root folder
					return

				destination = destination.containing_folder
				split_by_slash.Cut(1, 2)
				continue

			// Remain at current directory
			if(".")
				split_by_slash.Cut(1, 2)
				continue

			if("")
				return destination

		// End period handling

		var/found_next_folder = FALSE
		for(var/datum/c4_file/folder/F in destination.contents)
			if(F.name == ckey(split_by_slash[1]))
				split_by_slash -= split_by_slash[1]
				destination = F
				found_next_folder = TRUE
				break

		if(!found_next_folder)
			return null
