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

/datum/c4_file/folder/copy(depth)
	if(depth > 5) // Stop trying to break the server
		return null

	var/datum/c4_file/folder/clone = ..()
	clone.size = 0 // Size is dynamically generated.

	for(var/datum/c4_file/file as anything in contents)
		if(istype(file, /datum/c4_file/folder))
			var/datum/c4_file/inner_folder_clone = file.copy(depth + 1)
			if(!clone.try_add_file(inner_folder_clone))
				qdel(inner_folder_clone)
			continue

		var/datum/c4_file/file_clone = file.copy()
		if(!clone.try_add_file(file_clone))
			qdel(file_clone)

	return clone

/// Attempt to add a file to the folder.
/datum/c4_file/folder/proc/try_add_file(datum/c4_file/new_file)
	if(!can_add_file(new_file))
		return FALSE

	var/file_old_drive = new_file.drive

	contents += new_file

	new_file.containing_folder = src
	new_file.drive = drive

	adjust_size(new_file.size)

	if(istype(new_file, /datum/c4_file/folder))
		var/datum/c4_file/folder/new_folder = new_file
		new_folder.generation = generation + 1

		// If a folder is moved across drives, we need to make sure the childen have their drives set correctly.
		// No... the children yearn for the invalid pointer.
		if(file_old_drive != drive)
			new_folder.trickle_down_drive()

	SEND_SIGNAL(new_file, COMSIG_COMPUTER4_FILE_ADDED)
	return TRUE

/datum/c4_file/folder/proc/can_add_file(datum/c4_file/new_file)
	if(generation > 5)
		return FALSE

	if(new_file == src)
		return FALSE

	if(drive && drive.disk_capacity < (drive.root.size))
		return FALSE

	return TRUE

/// Attempt to remove a file from the disk. Does not qdel the file, use try_delete_file() for that.
/datum/c4_file/folder/proc/try_remove_file(datum/c4_file/file, force)
	if(file.containing_folder != src)
		CRASH("Dawg what the FUCK happened here?")

	if(!force && !can_remove_file(file))
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

		if(ckey(file.name) == ckey(file_name))
			return file

/// Update the drive value of all children to match our current drive.
/datum/c4_file/folder/proc/trickle_down_drive()
	for(var/datum/c4_file/file as anything in contents)
		file.drive = drive

		// Recursion, yum
		if(istype(file, /datum/c4_file/folder))
			var/datum/c4_file/folder/child_folder = file
			child_folder.trickle_down_drive()
