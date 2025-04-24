/datum/c4_file/folder
	name = "folder"
	extension = ""

	/// This is used to prevent people from making a file system 100 folders deep.
	var/generation = 1
	/// Homework
	var/list/datum/computer/file/contents = list()

	/// TEMP, will likely end up it's own machine. Here to access machine shit while deving for now.
	var/obj/machinery/computer4/computer

/datum/c4_file/folder/Destroy(force, ...)
	QDEL_LIST(contents)
	return ..()

/datum/c4_file/folder/proc/try_add_file(datum/c4_file/new_file)
	if(!can_add_file(new_file))
		return FALSE

	contents += new_file

	new_file.containing_folder = src
	new_file.drive = drive

	if(istype(new_file, /datum/c4_file/folder))
		var/datum/c4_file/folder/new_folder = new_file
		new_folder.generation = generation + 1

	SEND_SIGNAL(new_file, COMSIG_COMPUTER4_FILE_MOVED)
	return TRUE

/datum/c4_file/folder/proc/can_add_file(datum/c4_file/new_file)
	if(new_file == src)
		return FALSE

	if(drive.disk_capacity < (drive.disk_used + new_file.size))
		return FALSE

	return TRUE

/datum/c4_file/folder/proc/try_delete_file(datum/c4_file/file, force, qdel = TRUE)
	if(file.containing_folder != src)
		CRASH("Dawg what the FUCK happened here?")

	if(!force && !can_delete_file(file, force))
		return FALSE

	contents -= file
	size -= file.size
	drive.disk_used -= file.size
	if(qdel && !QDELING(file))
		qdel(file)

	return TRUE

/datum/c4_file/folder/proc/can_delete_file(datum/c4_file/file)
	if(drive.read_only)
		return FALSE

	return TRUE

/datum/c4_file/folder/proc/get_file(file_name, include_folders = TRUE)
	for(var/datum/c4_file/file as anything in src.contents)
		if(istype(file, /datum/c4_file/folder) && !include_folders)
			continue

		if(ckey(file.name) == file_name)
			return file
