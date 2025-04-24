
/obj/machinery/proc/insert_disk(mob/user, obj/item/disk/data/floppy/disk)
	if(!istype(disk))
		return FALSE

	if(inserted_disk)
		to_chat(user, span_warning("The machine already has a disk inserted!"))
		return FALSE

	if(user && user.transferItemToLoc(disk, src))
		user.visible_message(
			span_notice("[user] inserts [disk] into [src]."),
			span_notice("You insert [disk] into [src]."),
		)
		inserted_disk = disk
		updateUsrDialog()
		return TRUE

	inserted_disk = disk
	disk.forceMove(src)
	updateUsrDialog()
	return TRUE

/// Eject an inserted disk. Pass a user to put the disk in their hands.
/obj/machinery/proc/eject_disk(mob/user)
	if(!inserted_disk)
		return FALSE

	if(user)
		if(Adjacent(user) && user.put_in_active_hand(inserted_disk))
			. = inserted_disk
			inserted_disk = null
		else
			return FALSE

	if(!.)
		inserted_disk.forceMove(drop_location())
		. = inserted_disk

	if(.)
		selected_disk = internal_disk
		updateUsrDialog()
	return .

/// Toggle the selected disk between internal and inserted.
/obj/machinery/proc/toggle_disk(mob/user)
	if(selected_disk == internal_disk)
		if(inserted_disk)
			selected_disk = inserted_disk
			updateUsrDialog()
			return
		else if(user)
			alert(user, "No disk inserted!","ERROR", "OK")
			return

	if(selected_disk == inserted_disk)
		selected_disk = internal_disk
		updateUsrDialog()
		return

/// Attempt to write a file to disk. May fail due to size limits.
/obj/machinery/proc/disk_write_file(datum/c4_file/new_file, obj/item/disk/data/target_disk)
	if(!target_disk)
		target_disk = selected_disk
	return selected_disk.root.try_add_file(new_file)

/// Get a file by name. Caller must assure type.
/obj/machinery/proc/disk_get_file(file_name, obj/item/disk/data/target_disk) as /datum/c4_file
	RETURN_TYPE(/datum/c4_file)
	if(!target_disk)
		target_disk = selected_disk
	selected_disk.root.get_file(file_name)

/// Returns valid fabrication designs stored on the disk at the specified file.
/obj/machinery/proc/disk_get_designs(file_name, obj/item/disk/data/target_disk)
	if(!file_name)
		return
	var/datum/c4_file/fab_design_bundle/fab_bundle = disk_get_file(file_name)
	if(!istype(fab_bundle))
		return
	return fab_bundle.included_designs
