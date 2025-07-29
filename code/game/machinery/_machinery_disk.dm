/// Setter for internal disk.
/obj/machinery/proc/set_internal_disk(obj/item/disk/data/disk)
	internal_disk = disk

/// Setter for inserted disk.
/obj/machinery/proc/set_inserted_disk(obj/item/disk/data/disk)
	inserted_disk = disk

/// Gets the currently selected disk according to the selected disk var.
/obj/machinery/proc/get_selected_disk()
	RETURN_TYPE(/obj/item/disk/data)
	if(selected_disk == DISK_INTERNAL)
		return internal_disk

	return inserted_disk

/obj/machinery/proc/insert_disk(mob/user, obj/item/disk/data/disk)
	if(!istype(disk))
		return FALSE

	if(inserted_disk)
		to_chat(user, span_warning("The machine already has a disk inserted!"))
		return FALSE

	if(user && user.transferItemToLoc(disk, src))
		user.visible_message(
			span_notice("[user] inserts [disk] into [src]'s [disk.is_hard_drive ? "external drive slot" : "disk reader"]."),
		)
		set_inserted_disk(disk)
		updateUsrDialog()
		return TRUE

	set_inserted_disk(disk)
	playsound(loc, 'sound/machines/cardreader_insert.ogg', 50)
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
			set_inserted_disk(null)
		else
			return FALSE

	if(!.)
		inserted_disk.forceMove(drop_location())
		. = inserted_disk
		set_inserted_disk(null)

	if(.)
		playsound(loc, 'sound/machines/cardreader_desert.ogg', 50)
		selected_disk = DISK_INTERNAL
		updateUsrDialog()
	return .

/// Toggle the selected disk between internal and inserted.
/obj/machinery/proc/toggle_disk(mob/user)
	if(selected_disk == DISK_INTERNAL)
		if(inserted_disk)
			selected_disk = DISK_EXTERNAL
			updateUsrDialog()
			return
		else if(user)
			alert(user, "No disk inserted!","ERROR", "OK")
			return

	if(selected_disk == DISK_EXTERNAL)
		selected_disk = DISK_INTERNAL
		updateUsrDialog()
		return

/// Attempt to write a file to disk. May fail due to size limits.
/obj/machinery/proc/disk_write_file(datum/c4_file/new_file, obj/item/disk/data/target_disk)
	if(!target_disk)
		target_disk = get_selected_disk()

	return target_disk?.root.try_add_file(new_file)

/// Get a file by name. Caller must assure type.
/obj/machinery/proc/disk_get_file(file_name, obj/item/disk/data/target_disk) as /datum/c4_file
	RETURN_TYPE(/datum/c4_file)
	if(!target_disk)
		target_disk = get_selected_disk()

	return target_disk?.root.get_file(file_name)

/obj/machinery/proc/disk_delete_file(file_name, obj/item/disk/data/target_disk)
	if(!target_disk)
		target_disk = get_selected_disk()

	var/datum/c4_file/found_file = target_disk?.root.get_file(file_name)
	if(!found_file)
		return FALSE

	return found_file.containing_folder.try_delete_file(found_file)

// Meta-file access helpers. Does pre-processing and verification of file types.

/// Returns valid fabrication designs stored on the disk at the specified file. Returns the real list!
/obj/machinery/proc/disk_get_designs(file_name, obj/item/disk/data/target_disk)
	if(!file_name)
		return
	var/datum/c4_file/fab_design_bundle/fab_bundle = disk_get_file(file_name, target_disk)
	if(!istype(fab_bundle))
		return
	return fab_bundle.included_designs

/// Returns stored genetic mutations. Returns the real list!
/obj/machinery/proc/disk_get_gene_mutations(file_name, obj/item/disk/data/target_disk) as /list
	RETURN_TYPE(/list)
	if(!file_name)
		return
	var/datum/c4_file/gene_mutation_db/mut_db = disk_get_file(file_name, target_disk)
	if(!istype(mut_db))
		return
	return mut_db.stored_mutations

/// Returns stored genetic mutations. Returns the real list!
/obj/machinery/proc/disk_get_gene_buffer(file_name, obj/item/disk/data/target_disk) as /list
	RETURN_TYPE(/list)
	if(!file_name)
		return
	var/datum/c4_file/gene_buffer/gene_buffer = disk_get_file(file_name, target_disk)
	if(!istype(gene_buffer))
		return
	return gene_buffer.buffer_data
