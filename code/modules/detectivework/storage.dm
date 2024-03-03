/obj/item/storage/box/swabs
	name = "box of swab kits"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	illustration = null

/obj/item/storage/box/swabs/Initialize(mapload)
	. = ..()
	atom_storage.set_holdable(/obj/item/swab)
	atom_storage.max_slots = 14
	atom_storage.max_total_storage = /obj/item/swab::w_class * 14

/obj/item/storage/box/swabs/PopulateContents()
	for(var/i in 1 to 14)
		new /obj/item/swab(src)

/obj/item/storage/box/evidence
	name = "evidence bag box"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	illustration = null

/obj/item/storage/box/evidence/Initialize(mapload)
	. = ..()
	atom_storage.set_holdable(/obj/item/storage/evidencebag)
	atom_storage.max_slots = 7
	atom_storage.max_total_storage = /obj/item/storage/evidencebag::w_class * 7

/obj/item/storage/box/evidence/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/storage/evidencebag(src)

/obj/item/storage/box/fingerprints
	name = "box of fingerprint cards"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	illustration = null

/obj/item/storage/box/fingerprints/Initialize(mapload)
	. = ..()
	atom_storage.set_holdable(/obj/item/sample/print)
	atom_storage.max_slots = 14
	atom_storage.max_total_storage = /obj/item/sample/print::w_class * 14

/obj/item/storage/box/fingerprints/PopulateContents()
	for(var/i in 1 to 14)
		new /obj/item/sample/print(src)

/obj/item/storage/evidence
	name = "evidence case"
	desc = "A heavy steel case for storing evidence."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "case"
	inhand_icon_state = "lockbox"
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/evidence/Initialize(mapload)
	. = ..()
	atom_storage.max_slots = 10
	atom_storage.max_specific_storage = WEIGHT_CLASS_SMALL
	atom_storage.max_total_storage = 100
	atom_storage.allow_quick_empty = TRUE
	atom_storage.allow_quick_gather = TRUE

	atom_storage.set_holdable(list(
		/obj/item/sample,
		/obj/item/storage/evidencebag,
		/obj/item/photo,
		/obj/item/paper,
		/obj/item/folder,
		/obj/item/sample,
		/obj/item/sample_kit,
	))

//crime scene kit
/obj/item/storage/briefcase/crimekit
	name = "crime scene kit"
	desc = "A stainless steel-plated carrycase for all your forensic needs. Feels heavy."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "case"
	inhand_icon_state = "lockbox"

/obj/item/storage/briefcase/crimekit/Initialize()
	. = ..()
	atom_storage.set_holdable(list(
		/obj/item/storage/box/swabs,
		/obj/item/storage/box/fingerprints,
		/obj/item/storage/box/evidence,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/swab,
		/obj/item/sample/print,
		/obj/item/sample/fibers,
		/obj/item/taperecorder,
		/obj/item/tape,
		/obj/item/clothing/gloves,
		/obj/item/folder,
		/obj/item/paper,
		/obj/item/photo,
		/obj/item/sample_kit,
		/obj/item/camera,
		/obj/item/storage/scene_cards,
		/obj/item/modular_computer/tablet,
		/obj/item/storage/evidencebag,
		/obj/item/storage/scene_cards
	))

/obj/item/storage/briefcase/crimekit/PopulateContents()
	new /obj/item/storage/box/swabs(src)
	new /obj/item/storage/box/fingerprints(src)
	new /obj/item/sample_kit(src)
	new /obj/item/sample_kit/powder(src)
	new /obj/item/storage/scene_cards(src)
	new /obj/item/camera(src)
