//Just for transferring between genetics machines.
TYPEINFO_DEF(/obj/item/disk/data)
	default_materials = list(/datum/material/iron =300, /datum/material/glass =100)

/obj/item/disk/data
	name = "hard disk drive"
	desc = "A device that stores data inside of machinery."
	icon_state = "harddisk"
	item_flags = NOBLUDGEON

	/// If TRUE, automagically pre-pend the size of the disk to the name.
	var/auto_name = TRUE

	/// If FALSE, it can be inserted into disk readers (Voidcomputers).
	var/is_hard_drive = TRUE

	/// How many arbitrary size units we can store. We call them KB because we are evil.
	var/disk_capacity = 32

	/// List of program typepaths to load on spawn.
	var/list/preloaded_programs

	/// Ref to the computer it may be contained in. This is handled by /obj/machinery/proc/set_internal_disk.
	var/obj/machinery/computer4/computer

	/// The root folder of the disk. This is *in theory* indestructable. Please never qdel it outside of this disk's destructor.
	var/datum/c4_file/folder/root

	/// Title of drive within a computer4 system.
	var/title = "sys"

	var/read_only = FALSE //Well,it's still a floppy disk

/obj/item/disk/data/Initialize(mapload)
	. = ..()

	if(auto_name)
		var/device_name
		if(name != /obj/item/disk/data::name) // Name has been changed, assume that we want to keep that change.
			device_name = name
		else
			device_name = is_hard_drive ? "hard disk drive" : "floppy disk"

		name = "[disk_capacity] KB [device_name]"

	base_pixel_x = base_pixel_x + rand(-5, 5)
	base_pixel_y = base_pixel_y + rand(-5, 5)

	root = new
	root.drive = src
	root.set_name("root")

	for(var/path in preloaded_programs)
		root.try_add_file(new path)

	if(isabstract(src))
		CRASH("Bad data disk [type] at [COORD(src)]")

/obj/item/disk/data/Destroy(force)
	QDEL_NULL(root)
	computer = null
	return ..()

/// Comes loaded with ThinkDOS
/obj/item/disk/data/drive/terminal_drive
	preloaded_programs = list(/datum/c4_file/terminal_program/operating_system/thinkdos)

TYPEINFO_DEF(/obj/item/disk/data/medium)
	default_materials = list(/datum/material/iron =300, /datum/material/glass = 100, /datum/material/gold = 50)

/obj/item/disk/data/medium
	disk_capacity = 64

TYPEINFO_DEF(/obj/item/disk/data/large)
	default_materials = list(/datum/material/iron =300, /datum/material/glass = 100, /datum/material/gold = 50, /datum/material/diamond = 100)

/obj/item/disk/data/large
	disk_capacity = 128

TYPEINFO_DEF(/obj/item/disk/data/extra_large)
	default_materials = list(/datum/material/iron =300, /datum/material/glass = 100, /datum/material/gold = 100, /datum/material/diamond = 200)

/obj/item/disk/data/extra_large
	disk_capacity = 256
