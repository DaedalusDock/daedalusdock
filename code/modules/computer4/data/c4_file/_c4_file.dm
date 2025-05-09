/// Computer files.
/datum/c4_file

	var/name = "file"
	var/extension = "DAT"

	var/size = 2

	/// If the file is copyable by default.
	var/copyable = TRUE // Don't copy that floppy.

	/// Metadata about this thing
	var/datum/computer_metadata/metadata

	/// Drive this file is on.
	var/obj/item/disk/data/drive
	/// Folder the file is in, if any.
	var/datum/c4_file/folder/containing_folder

/datum/c4_file/New()
	metadata = new()
	metadata.date = stationdate2text()

/datum/c4_file/Destroy()
	if(!QDELETED(containing_folder))
		containing_folder.try_delete_file(src, TRUE)

	containing_folder = null

	if(drive)
		drive = null
	return ..()

/// Creates a copy of this file. Depth is used for folders to prevent copying gigantic folders from lagging the game.
/datum/c4_file/proc/copy(depth)
	RETURN_TYPE(/datum/c4_file)
	var/datum/c4_file/clone = new type
	clone.set_name(name)
	clone.extension = extension
	clone.size = size
	clone.copyable = copyable

	// Clone non-date metadata
	clone.metadata.owner = metadata.owner
	clone.metadata.group = metadata.group
	return clone

/// Setter for name for raising the paired event.
/datum/c4_file/proc/set_name(new_name)
	name = new_name
	SEND_SIGNAL(src, COMSIG_COMPUTER4_FILE_RENAMED)

/// Attempt to stringify the data.
/datum/c4_file/proc/to_string()
	return "Error: Cannot convert type 'unknown' to 'string'" //readable_corrupted_text() maybe?

/// Returns a string that is the file's path
/datum/c4_file/proc/path_to_string()
	var/list/out = list()
	if(containing_folder) // not root
		out += name

	var/datum/c4_file/folder/current_folder = containing_folder
	while(current_folder?.containing_folder) // Get every folder that isn't the root
		out.Insert(1, current_folder.name)
		current_folder = current_folder.containing_folder

	return "[drive.title]:/[jointext(out, "/")]"

/// Returns the computer this file is in, if any.
/datum/c4_file/proc/get_computer()
	RETURN_TYPE(/obj/machinery/computer4)
	return drive?.computer

/// Sanitize a file name.
/datum/c4_file/proc/sanitize_filename(file_name)
	return ckey(trim(file_name, 16))

/// Returns TRUE if a given file name is OK.
/datum/c4_file/proc/validate_file_name(file_name)
	return (ckey(file_name) == file_name) && (length(file_name) <= 16)

/datum/file_path
	var/directory
	var/file_name
	var/raw

/datum/c4_file/proc/text_to_filepath(text)
	if(!text)
		return

	var/list/split_path = splittext(text, "/")
	var/file_name = split_path[length(split_path)]
	var/directory = copytext(text, 1, length(text) - length(file_name) + 1)

	var/datum/file_path/path = new
	path.directory = directory
	path.file_name = file_name
	path.raw = text
	return path

/// Take a directory, vomit out a folder at that directory or null
/datum/c4_file/proc/parse_directory(text, datum/c4_file/folder/origin, create_if_missing = FALSE) as /datum/c4_file/folder
	RETURN_TYPE(/datum/c4_file/folder)

	if(!origin)
		origin = containing_folder

	if(!text)
		return origin

	var/datum/c4_file/folder/destination = origin

	if(text[1] == "/")
		destination = origin.drive.root
		text = copytext(text, 2)

	var/list/split_by_slash = splittext(text, "/")
	if (length(split_by_slash) && copytext(split_by_slash[1], 4, 5) == ":")
		var/prefix = lowertext(copytext(split_by_slash[1], 1, 4) )

		if (length(split_by_slash[1]) > 4)
			split_by_slash[1] = copytext(split_by_slash[1], 5)
		else
			split_by_slash.Cut(1,2)

		var/obj/machinery/computer4/computer = get_computer()
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

	// Account for trailing slash meaning "gimmie the folder."
	if(length(split_by_slash) && split_by_slash[length(split_by_slash)] == "")
		split_by_slash.len--

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
				if(!create_if_missing)
					return destination

		// End period handling

		var/found_next_folder = FALSE
		for(var/datum/c4_file/folder/F in destination.contents)
			if(ckey(F.name) == ckey(split_by_slash[1]))
				split_by_slash -= split_by_slash[1]
				destination = F
				found_next_folder = TRUE
				break

		if(!found_next_folder)
			if(!create_if_missing)
				return null

			if(!validate_file_name(split_by_slash[1]))
				return null

			var/datum/c4_file/folder/new_folder = new
			new_folder.set_name(split_by_slash[1])

			if(!destination.try_add_file(new_folder))
				qdel(new_folder)
				return null

			split_by_slash.Cut(1,2)
			destination = new_folder
