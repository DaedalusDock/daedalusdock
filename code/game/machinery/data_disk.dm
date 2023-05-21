//Just for transferring between genetics machines.
/obj/item/disk/data
	name = "data disk"
	desc = "A disk for storing device data."
	icon_state = "datadisk0"
	custom_materials = list(/datum/material/iron =300, /datum/material/glass =100)
	/// How many THIIINGGGS can we store in memory
	VAR_PROTECTED/storage = 32
	/// The actual storage of the disk.
	VAR_PROTECTED/list/memory[ALL_DATA_INDEXES]

	var/read_only = FALSE //Well,it's still a floppy disk

/obj/item/disk/data/Initialize(mapload)
	. = ..()
	if(name != "data disk")
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
	icon_state = "datadisk2"
	custom_materials = list(/datum/material/iron =300, /datum/material/glass = 100, /datum/material/gold = 50)
	storage = 64

/obj/item/disk/data/large
	icon_state = "datadisk6"
	custom_materials = list(/datum/material/iron =300, /datum/material/glass = 100, /datum/material/gold = 50, /datum/material/diamond = 100)
	storage = 128

/obj/item/disk/data/extra_large
	icon_state = "datadisk7"
	custom_materials = list(/datum/material/iron =300, /datum/material/glass = 100, /datum/material/gold = 100, /datum/material/diamond = 200)
	storage = 256

/obj/item/disk/data/hyper
	icon_state = "datadisk8"
	storage = 512

/obj/item/disk/data/hyper/preloaded

/obj/item/disk/data/hyper/preloaded/Initialize(mapload)
	. = ..()
	LAZYADD(memory[DATA_IDX_DESIGNS], SStech.fetch_designs(compile_designs()))

/obj/item/disk/data/hyper/preloaded/proc/compile_designs()
	RETURN_TYPE(/list)
	. = list()

/obj/item/disk/data/hyper/preloaded/fabricator
	var/build_type
	var/mapload_design_flags

/obj/item/disk/data/hyper/preloaded/fabricator/compile_designs()
	. = ..()
	for(var/datum/design/D as anything in SStech.designs)
		if((D.mapload_design_flags & mapload_design_flags) && (D.build_type & build_type))
			. += D.type

/obj/item/disk/data/hyper/preloaded/fabricator/omni
	build_type = FABRICATOR
	mapload_design_flags = DESIGN_FAB_OMNI

/obj/item/disk/data/hyper/preloaded/fabricator/robotics
	build_type = MECHFAB
	mapload_design_flags = DESIGN_FAB_ROBOTICS

/obj/item/disk/data/hyper/preloaded/fabricator/civ
	build_type = FABRICATOR
	mapload_design_flags = DESIGN_FAB_CIV

/obj/item/disk/data/hyper/preloaded/fabricator/engineering
	build_type = FABRICATOR
	mapload_design_flags = DESIGN_FAB_ENGINEERING

/obj/item/disk/data/hyper/preloaded/fabricator/medical
	build_type = FABRICATOR
	mapload_design_flags = DESIGN_FAB_MEDICAL

/obj/item/disk/data/hyper/preloaded/fabricator/offstation
	build_type = FABRICATOR
	mapload_design_flags = DESIGN_FAB_OFFSTATION

/obj/item/disk/data/hyper/preloaded/fabricator/supply
	build_type = FABRICATOR
	mapload_design_flags = DESIGN_FAB_SUPPLY

/obj/item/disk/data/hyper/preloaded/fabricator/security
	build_type = FABRICATOR
	mapload_design_flags = DESIGN_FAB_SECURITY

/obj/item/disk/data/hyper/preloaded/fabricator/service
	build_type = FABRICATOR
	mapload_design_flags = DESIGN_FAB_SERVICE

/obj/item/disk/data/hyper/preloaded/fabricator/imprinter
	build_type = IMPRINTER
	mapload_design_flags = DESIGN_IMPRINTER

/obj/item/disk/data/hyper/preloaded/fabricator/imprinter/offstation
	build_type = AWAY_IMPRINTER | IMPRINTER

/obj/item/disk/data/hyper/preloaded/fabricator/imprinter/robotics
	build_type = AWAY_IMPRINTER | IMPRINTER

/obj/item/disk/data/hyper/preloaded/fabricator/imprinter/robotics/compile_designs()
	. = list(
		/datum/design/board/ripley_main,
		/datum/design/board/ripley_peri,
		/datum/design/board/odysseus_main,
		/datum/design/board/odysseus_peri,
		/datum/design/board/gygax_main,
		/datum/design/board/gygax_peri,
		/datum/design/board/durand_main,
		/datum/design/board/durand_peri,
		/datum/design/board/durand_targ,
		/datum/design/board/honker_main,
		/datum/design/board/honker_peri,
		/datum/design/board/honker_targ,
		/datum/design/board/phazon_main,
		/datum/design/board/phazon_peri,
		/datum/design/board/phazon_targ,
		/datum/design/board/clarke_main,
		/datum/design/board/clarke_peri
	)
