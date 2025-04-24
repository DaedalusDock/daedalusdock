
/obj/item/disk/data/hyper/preloaded
	disk_capacity = 512

/obj/item/disk/data/hyper/preloaded/Initialize(mapload)
	. = ..()
	var/datum/c4_file/fab_design_bundle/fab_bundle = new(SStech.fetch_designs(compile_designs()))
	fab_bundle.name = "fabrec"
	root.try_add_file(fab_bundle)


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
		/datum/design/board/gygax_targ,
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
