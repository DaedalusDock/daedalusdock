/// Change active directory.
/datum/c4_file/terminal_program/operating_system/proc/change_dir(datum/c4_file/folder/directory)
	current_directory = directory
	return TRUE

/// Move a file to another location.
/datum/c4_file/terminal_program/operating_system/proc/move_file(datum/c4_file/file, datum/c4_file/folder/destination, error_pointer, overwrite = FALSE, new_name = "")
	if(file.containing_folder == destination)
		*error_pointer = "Cannot move folder into itself."
		return FALSE

	if(!destination.can_add_file(file))
		*error_pointer = "Unable to move file to target."
		return FALSE

	var/datum/c4_file/file_at_dest = destination.get_file(new_name || file.name, TRUE)
	if(file_at_dest)
		if(!overwrite)
			*error_pointer = "Target in use."
			return FALSE

		if(!destination.can_remove_file(file_at_dest))
			*error_pointer = "Unable to delete target."
			return FALSE

	if(!file.containing_folder.can_remove_file(file))
		*error_pointer = "Unable to delete source."
		return FALSE

	if(file_at_dest)
		destination.try_delete_file(file_at_dest)

	file.containing_folder.try_remove_file(file)
	destination.try_add_file(file)

	file.set_name(new_name)
	return TRUE

/// Find a file by it's name in the given directory. Defaults to the current directory.
/datum/c4_file/terminal_program/operating_system/proc/get_file(file_name, datum/c4_file/folder/working_directory, include_folders = FALSE)
	if(!file_name)
		return

	if(!working_directory)
		working_directory = current_directory

	return working_directory.get_file(file_name, include_folders)

/// Returns a file or folder with the given name inside of the given filepath relative to the working directory.
/datum/c4_file/terminal_program/operating_system/proc/resolve_filepath(file_path, datum/c4_file/folder/working_directory)
	if(!file_path)
		return

	if(!working_directory)
		working_directory = current_directory

	var/list/split_path = splittext(file_path, "/")

	if(length(split_path) == 1)
		if(split_path[1] == ".")
			return working_directory
		return get_file(split_path[1], working_directory, include_folders = TRUE)

	var/datum/file_path/path_info = text_to_filepath(file_path)

	var/datum/c4_file/folder/found_folder = parse_directory(path_info.directory, working_directory)
	if(!found_folder)
		return null

	if(!path_info.file_name)
		return found_folder

	return get_file(path_info.file_name, found_folder, include_folders = TRUE)
