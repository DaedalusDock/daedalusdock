//Just for transferring between genetics machines.
/obj/item/disk/data
	name = "data disk"
	desc = "A disk for storing device data."
	icon_state = "harddisk"
	custom_materials = list(/datum/material/iron =300, /datum/material/glass =100)
	item_flags = NOBLUDGEON

	/// Ref to the computer it may be contained in. This is handled by /obj/machinery/proc/set_internal_disk.
	var/obj/machinery/computer4/computer

	/// The root folder of the disk. This is *in theory* indestructable. Please never qdel it outside of this disk's destructor.
	var/datum/c4_file/folder/root

	/// List of program typepaths to load on spawn.
	var/list/preloaded_programs

	/// Title of drive within a computer4 system.
	var/title = "sys"

	var/disk_capacity = 32

	var/read_only = FALSE //Well,it's still a floppy disk

/obj/item/disk/data/Initialize(mapload)
	. = ..()
	if(name != "data disk")
		name = "[disk_capacity] KB [name]"
	base_pixel_x = base_pixel_x + rand(-5, 5)
	base_pixel_y = base_pixel_y + rand(-5, 5)

	root = new
	root.drive = src
	root.set_name("root")

	for(var/path in preloaded_programs)
		root.try_add_file(new path)

	return INITIALIZE_HINT_LATELOAD

/obj/item/disk/data/Destroy(force)
	QDEL_NULL(root)
	computer = null
	return ..()

/// Comes loaded with ThinkDOS
/obj/item/disk/data/terminal_drive
	preloaded_programs = list(/datum/c4_file/terminal_program/operating_system/thinkdos)

// Stub functions to ensure this shit still builds.
// /obj/item/disk/data
// 	proc
// 		read()
// 		write()
// 		set_data()
// 		check_memory()
// 		remove()
// 		clear()

// 	var
// 		storage

#warn idk what fran did but these dont exist anymore so im leaving a warning here
#warn These just need to be given sizes, they were premade types that I moved up to floppies.
/obj/item/disk/data/medium
/obj/item/disk/data/extra_large
