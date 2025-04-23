/datum/c4_file/folder
	name = "folder"
	extension = ""

	/// This is used to prevent people from making a file system 100 folders deep.
	var/generation = 1
	/// Homework
	var/list/datum/computer/file/contents = list()

/datum/c4_file/folder/Destroy(force, ...)
	QDEL_LIST(contents)
	return ..()

/datum/c4_file/folder/proc/try_add_file(datum/c4_file/new_file)
	// if(not_enough_space) TODO
	// 	return FALSE

	contents += new_file

	if(istype(new_file, /datum/c4_file/folder))
		var/datum/c4_file/folder/new_folder
		new_folder.generation = generation + 1

	return TRUE

/datum/c4_file/folder/proc/try_delete_file(datum/c4_file/file, force, qdel = TRUE)
	if(file.containing_folder != src)
		CRASH("Dawg what the FUCK happened here?")

	if(drive.read_only && !force)
		return FALSE

	contents -= file
	if(qdel)
		qdel(file)
