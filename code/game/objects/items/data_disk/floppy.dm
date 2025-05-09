/obj/item/disk/data/floppy
	name = "floppy disk"
	desc = "A portable storage device for voidcomputers."
	icon_state = "datadisk0"

/obj/item/disk/data/floppy/attack_self(mob/user)
	. = ..()
	if(.)
		return

	read_only = !read_only
	to_chat(user, span_notice("You flip the write-protect tab to [read_only ? "protected" : "unprotected"]."))
	return TRUE

/obj/item/disk/data/floppy/examine(mob/user)
	. = ..()
	. += span_notice("The write-protect tab is set to [read_only ? "protected" : "unprotected"].")

/// Comes loaded with ThinkDOS
/obj/item/disk/data/floppy/thinkdos
	name = "floppy disk - 'ThinkDOS'"
	desc = "A floppy disk containing the ThinkDOS operating system."

	preloaded_programs = list(/datum/c4_file/terminal_program/operating_system/thinkdos)

/obj/item/disk/data/floppy/medium
	icon_state = "datadisk2"
	custom_materials = list(/datum/material/iron =300, /datum/material/glass = 100, /datum/material/gold = 50)
	disk_capacity = 64

/obj/item/disk/data/floppy/large
	icon_state = "datadisk6"
	custom_materials = list(/datum/material/iron =300, /datum/material/glass = 100, /datum/material/gold = 50, /datum/material/diamond = 100)
	disk_capacity = 128

/obj/item/disk/data/floppy/extra_large
	icon_state = "datadisk7"
	custom_materials = list(/datum/material/iron =300, /datum/material/glass = 100, /datum/material/gold = 100, /datum/material/diamond = 200)
	disk_capacity = 256

/obj/item/disk/data/floppy/hyper
	icon_state = "datadisk8"
	disk_capacity = 512
