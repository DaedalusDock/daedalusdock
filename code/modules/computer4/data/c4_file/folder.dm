/datum/c4_file/folder
	name = "folder"
	extension = ""

	// Folders do not take up any size inherently.
	size = 0

	/// This is used to prevent people from making a file system 100 folders deep.
	var/generation = 1
	/// Homework
	var/list/datum/computer/file/contents = list()

/datum/c4_file/folder/Destroy(force, ...)
	QDEL_LIST(contents)
	return ..()

/// Attempt to add a file to the folder.
/datum/c4_file/folder/proc/try_add_file(datum/c4_file/new_file)
	if(!can_add_file(new_file))
		return FALSE

	contents += new_file

	new_file.containing_folder = src
	new_file.drive = drive

	adjust_size(new_file.size)

	if(istype(new_file, /datum/c4_file/folder))
		var/datum/c4_file/folder/new_folder = new_file
		new_folder.generation = generation + 1

	SEND_SIGNAL(new_file, COMSIG_COMPUTER4_FILE_ADDED)
	return TRUE

/datum/c4_file/folder/proc/can_add_file(datum/c4_file/new_file)
	if(new_file == src)
		return FALSE

	if(drive.disk_capacity < (drive.root.size))
		return FALSE

	return TRUE

/// Attempt to remove a file from the disk. Does not qdel the file, use try_delete_file() for that.
/datum/c4_file/folder/proc/try_remove_file(datum/c4_file/file, force)
	if(file.containing_folder != src)
		CRASH("Dawg what the FUCK happened here?")

	if(!force && !can_delete_file(file))
		return FALSE

	contents -= file
	file.containing_folder = null
	file.drive = null

	adjust_size(-file.size)

	SEND_SIGNAL(file, COMSIG_COMPUTER4_FILE_REMOVED)

/datum/c4_file/folder/proc/can_remove_file(datum/c4_file/file)
	if(drive.read_only)
		return FALSE

	return TRUE

/// Attempt to remove a file from the folder and delete it.
/datum/c4_file/folder/proc/try_delete_file(datum/c4_file/file, force)
	if(!try_remove_file(file, force))
		return FALSE

	qdel(file)
	return TRUE

/// Adjusts the size of this folder and all parent folders.
/datum/c4_file/folder/proc/adjust_size(amt)
	size += amt
	containing_folder?.adjust_size(amt)

/datum/c4_file/folder/proc/get_file(file_name, include_folders = TRUE)
	for(var/datum/c4_file/file as anything in src.contents)
		if(istype(file, /datum/c4_file/folder) && !include_folders)
			continue

		if(ckey(file.name) == file_name)
			return file
