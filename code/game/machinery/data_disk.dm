//Just for transferring between genetics machines.
/obj/item/disk/data
	name = "data disk"
	desc = "A disk for storing device data."
	icon_state = "datadisk0"
	custom_materials = list(/datum/material/iron =300, /datum/material/glass =100)
	/// How many THIIINGGGS can we store in memory
	VAR_PROTECTED/storage = 8
	/// The actual storage of the disk.
	VAR_PROTECTED/list/memory = list()

	var/read_only = FALSE //Well,it's still a floppy disk

/obj/item/disk/data/Initialize(mapload)
	. = ..()
	name = "[storage] KB [name]"
	base_pixel_x = base_pixel_x + rand(-5, 5)
	base_pixel_y = base_pixel_y + rand(-5, 5)
	return INITIALIZE_HINT_LATELOAD

/obj/item/disk/data/LateInitialize()
	update_appearance(UPDATE_OVERLAYS)

/obj/item/disk/data/attack_self(mob/user)
	read_only = !read_only
	to_chat(user, span_notice("You flip the write-protect tab to [read_only ? "protected" : "unprotected"]."))

/obj/item/disk/data/examine(mob/user)
	. = ..()
	. += "The write-protect tab is set to [read_only ? "protected" : "unprotected"]."

/obj/item/disk/data/update_overlays()
	. = ..()
	if(length(read(DATA_IDX_MUTATIONS)))
		add_overlay("datadisk_gene")

///Return the amount of memory remaining
/obj/item/disk/data/proc/check_memory()
	for(var/list/L in memory)
		. += length(L)
	return max(0, storage - .)

///Write data to the disk, using the respective index. Unique will disctint add.
/obj/item/disk/data/proc/write(index, data, unique)
	if(read_only)
		return FALSE

	if(!islist(data))
		data = list(data)

	if(unique)
		data -= read(index)

	if(!length(data))
		return FALSE
	if(check_memory() - length(data) < 0)
		return FALSE

	LAZYADD(memory[index], data)
	update_appearance(UPDATE_OVERLAYS)
	return TRUE

///Read data from a memory index.
/obj/item/disk/data/proc/read(index)
	RETURN_TYPE(/list)
	if(memory.len < index)
		memory.len = index

	return LAZYACCESS(memory, index)

///Remove data from memory, returning what was removed.
/obj/item/disk/data/proc/remove(index, data)
	RETURN_TYPE(/list)
	if(memory.len < index)
		memory.len = index

	if(!islist(data))
		data = list(data)

	var/list/cache = LAZYACCESS(memory, index)
	if(cache)
		cache -= data
		update_appearance(UPDATE_OVERLAYS)
		return data & cache


/obj/item/disk/data/proc/set_data(index, data)
	if(memory.len < index)
		memory.len = index

	memory[index] = data

/obj/item/disk/data/proc/clear(index)
	if(memory.len < index)
		memory.len = index

	LAZYNULL(memory[index])
	update_appearance(UPDATE_OVERLAYS)

/obj/item/disk/data/medium
	desc = "A disk for storing device data. This one has extra storage space."
	icon_state = "datadisk7"
	custom_materials = list(/datum/material/iron =300, /datum/material/glass = 100, /datum/material/gold = 50)
	storage = 16

/obj/item/disk/data/large
	desc = "A disk for storing device data. This one has extremely large storage space."
	icon_state = "datadisk8"
	custom_materials = list(/datum/material/iron =300, /datum/material/glass = 100, /datum/material/gold = 100, /datum/material/diamond = 50)
	storage = 128

