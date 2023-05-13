
///////////////////////////////////
/////Non-Board Computer Stuff//////
///////////////////////////////////

/datum/design/intellicard
	name = "Intellicard AI Transportation System"
	desc = "Allows for the construction of an intellicard."
	id = "intellicard"
	build_type = FABRICATOR
	materials = list(/datum/material/glass = 1000, /datum/material/gold = 200)
	build_path = /obj/item/aicard
	category = list("Electronics")
	mapload_design_flags = DESIGN_FAB_OMNI

/datum/design/paicard
	name = "Personal Artificial Intelligence Card"
	desc = "Allows for the construction of a pAI Card."
	id = "paicard"
	build_type = FABRICATOR
	materials = list(/datum/material/glass = 500, /datum/material/iron = 500)
	build_path = /obj/item/paicard
	category = list("Electronics")
	mapload_design_flags = DESIGN_FAB_OMNI


/datum/design/ai_cam_upgrade
	name = "AI Surveillance Software Update"
	desc = "A software package that will allow an artificial intelligence to 'hear' from its cameras via lip reading."
	id = "ai_cam_upgrade"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 5000, /datum/material/gold = 15000, /datum/material/silver = 15000, /datum/material/diamond = 20000, /datum/material/plasma = 10000)
	build_path = /obj/item/surveillance_upgrade
	category = list("Electronics")
	mapload_design_flags = DESIGN_FAB_OMNI

////////////////////////////////////////
//////////Disk Construction Disks///////
////////////////////////////////////////
/datum/design/data
	name = "Data Storage Disk"
	desc = "Produce additional disks for storing data."
	id = "design_disk"
	build_type = FABRICATOR  | AUTOLATHE
	materials = list(/datum/material/iron = 300, /datum/material/glass = 100)
	build_path = /obj/item/disk/data
	category = list("Electronics")
	mapload_design_flags = DESIGN_FAB_OMNI

/datum/design/data_adv
	name = "Advanced Design Storage Disk"
	desc = "Produce additional disks for storing device designs."
	id = "design_disk_adv"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 300, /datum/material/glass = 100, /datum/material/silver=50)
	build_path = /obj/item/disk/data/medium
	category = list("Electronics")
	mapload_design_flags = DESIGN_FAB_OMNI
