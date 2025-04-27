//Just for transferring between genetics machines.
/obj/item/disk/data
	name = "data disk"
	desc = "A disk for storing device data."
	icon_state = "harddisk"
	custom_materials = list(/datum/material/iron =300, /datum/material/glass =100)
	item_flags = NOBLUDGEON

	/// Ref to the computer it may be contained in. This is handled by /obj/machinery/proc/set_internal_disk.
	var/obj/machinery/computer4/computer

	var/datum/c4_file/folder/root

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
	return INITIALIZE_HINT_LATELOAD

/obj/item/disk/data/Destroy(force)
	QDEL_NULL(root)
	computer = null
	return ..()

// Stub functions to ensure this shit still builds.
/obj/item/disk/data
	proc
		read()
		write()
		set_data()
		check_memory()
		remove()
		clear()

	var
		storage

#warn idk what fran did but these dont exist anymore so im leaving a warning here
/obj/item/disk/data/medium
/obj/item/disk/data/extra_large
