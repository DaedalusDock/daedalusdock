////////////////////////////////////////
/////////////Stock Parts////////////////
////////////////////////////////////////

/datum/design/rped
	name = "Rapid Part Exchange Device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	id = "rped"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 5000) //hardcore
	build_path = /obj/item/storage/part_replacer
	category = list(DCAT_STOCK_PART)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

//Capacitors
/datum/design/basic_capacitor
	name = "Basic Capacitor"
	desc = "A stock part used in the construction of various devices."
	id = "basic_capacitor"
	build_type = FABRICATOR  | AUTOLATHE
	materials = list(/datum/material/iron = 100, /datum/material/glass = 100)
	build_path = /obj/item/stock_parts/capacitor
	category = list(DCAT_STOCK_PART)
	lathe_time_factor = 0.2
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/adv_capacitor
	name = "Advanced Capacitor"
	desc = "A stock part used in the construction of various devices."
	id = "adv_capacitor"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 150, /datum/material/glass = 150)
	build_path = /obj/item/stock_parts/capacitor/adv
	category = list(DCAT_STOCK_PART)
	lathe_time_factor = 0.2
	mapload_design_flags = DESIGN_FAB_OMNI

/datum/design/super_capacitor
	name = "Super Capacitor"
	desc = "A stock part used in the construction of various devices."
	id = "super_capacitor"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 200, /datum/material/glass = 200, /datum/material/gold = 100)
	build_path = /obj/item/stock_parts/capacitor/super
	category = list(DCAT_STOCK_PART)
	lathe_time_factor = 0.2
	mapload_design_flags = DESIGN_FAB_OMNI

//Scanning modules
/datum/design/basic_scanning
	name = "Basic Scanning Module"
	desc = "A stock part used in the construction of various devices."
	id = "basic_scanning"
	build_type = FABRICATOR  | AUTOLATHE
	materials = list(/datum/material/iron = 100, /datum/material/glass = 50)
	build_path = /obj/item/stock_parts/scanning_module
	category = list(DCAT_STOCK_PART)
	lathe_time_factor = 0.2
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/adv_scanning
	name = "Advanced Scanning Module"
	desc = "A stock part used in the construction of various devices."
	id = "adv_scanning"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 150, /datum/material/glass = 100)
	build_path = /obj/item/stock_parts/scanning_module/adv
	category = list(DCAT_STOCK_PART)
	lathe_time_factor = 0.2
	mapload_design_flags = DESIGN_FAB_OMNI

/datum/design/phasic_scanning
	name = "Phasic Scanning Module"
	desc = "A stock part used in the construction of various devices."
	id = "phasic_scanning"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 200, /datum/material/glass = 150, /datum/material/silver = 60)
	build_path = /obj/item/stock_parts/scanning_module/phasic
	category = list(DCAT_STOCK_PART)
	lathe_time_factor = 0.2
	mapload_design_flags = DESIGN_FAB_OMNI

//Maipulators
/datum/design/micro_mani
	name = "Micro Manipulator"
	desc = "A stock part used in the construction of various devices."
	id = "micro_mani"
	build_type = FABRICATOR  | AUTOLATHE
	materials = list(/datum/material/iron = 100)
	build_path = /obj/item/stock_parts/manipulator
	category = list(DCAT_STOCK_PART)
	lathe_time_factor = 0.2
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/nano_mani
	name = "Nano Manipulator"
	desc = "A stock part used in the construction of various devices."
	id = "nano_mani"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 150)
	build_path = /obj/item/stock_parts/manipulator/nano
	category = list(DCAT_STOCK_PART)
	lathe_time_factor = 0.2
	mapload_design_flags = DESIGN_FAB_OMNI

/datum/design/pico_mani
	name = "Pico Manipulator"
	desc = "A stock part used in the construction of various devices."
	id = "pico_mani"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 200)
	build_path = /obj/item/stock_parts/manipulator/pico
	category = list(DCAT_STOCK_PART)
	lathe_time_factor = 0.2
	mapload_design_flags = DESIGN_FAB_OMNI

//Micro-lasers
/datum/design/basic_micro_laser
	name = "Basic Micro-Laser"
	desc = "A stock part used in the construction of various devices."
	id = "basic_micro_laser"
	build_type = FABRICATOR  | AUTOLATHE
	materials = list(/datum/material/iron = 100, /datum/material/glass = 50)
	build_path = /obj/item/stock_parts/micro_laser
	category = list(DCAT_STOCK_PART)
	lathe_time_factor = 0.2
	mapload_design_flags = DESIGN_FAB_OMNI

/datum/design/high_micro_laser
	name = "High-Power Micro-Laser"
	desc = "A stock part used in the construction of various devices."
	id = "high_micro_laser"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 150, /datum/material/glass = 100)
	build_path = /obj/item/stock_parts/micro_laser/high
	category = list(DCAT_STOCK_PART)
	lathe_time_factor = 0.2
	mapload_design_flags = DESIGN_FAB_OMNI

/datum/design/ultra_micro_laser
	name = "Ultra-High-Power Micro-Laser"
	desc = "A stock part used in the construction of various devices."
	id = "ultra_micro_laser"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 200, /datum/material/glass = 150, /datum/material/uranium = 60)
	build_path = /obj/item/stock_parts/micro_laser/ultra
	category = list(DCAT_STOCK_PART)
	lathe_time_factor = 0.2
	mapload_design_flags = DESIGN_FAB_OMNI

/datum/design/basic_matter_bin
	name = "Basic Matter Bin"
	desc = "A stock part used in the construction of various devices."
	id = "basic_matter_bin"
	build_type = FABRICATOR  | AUTOLATHE
	materials = list(/datum/material/iron = 100)
	build_path = /obj/item/stock_parts/matter_bin
	category = list(DCAT_STOCK_PART)
	lathe_time_factor = 0.2
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/adv_matter_bin
	name = "Advanced Matter Bin"
	desc = "A stock part used in the construction of various devices."
	id = "adv_matter_bin"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 150)
	build_path = /obj/item/stock_parts/matter_bin/adv
	category = list(DCAT_STOCK_PART)
	lathe_time_factor = 0.2
	mapload_design_flags = DESIGN_FAB_OMNI

/datum/design/super_matter_bin
	name = "Super Matter Bin"
	desc = "A stock part used in the construction of various devices."
	id = "super_matter_bin"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 200)
	build_path = /obj/item/stock_parts/matter_bin/super
	category = list(DCAT_STOCK_PART)
	lathe_time_factor = 0.2
	mapload_design_flags = DESIGN_FAB_OMNI

//T-Comms devices
/datum/design/subspace_ansible
	name = "Subspace Ansible"
	desc = "A compact module capable of sensing extradimensional activity."
	id = "s-ansible"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 100, /datum/material/silver = 100)
	build_path = /obj/item/stock_parts/subspace/ansible
	category = list(DCAT_STOCK_PART)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/hyperwave_filter
	name = "Hyperwave Filter"
	desc = "A tiny device capable of filtering and converting super-intense radiowaves."
	id = "s-filter"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 100, /datum/material/silver = 100)
	build_path = /obj/item/stock_parts/subspace/filter
	category = list(DCAT_STOCK_PART)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/subspace_amplifier
	name = "Subspace Amplifier"
	desc = "A compact micro-machine capable of amplifying weak subspace transmissions."
	id = "s-amplifier"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 100, /datum/material/gold = 100, /datum/material/uranium = 100)
	build_path = /obj/item/stock_parts/subspace/amplifier
	category = list(DCAT_STOCK_PART)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/subspace_treatment
	name = "Subspace Treatment Disk"
	desc = "A compact micro-machine capable of stretching out hyper-compressed radio waves."
	id = "s-treatment"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 100, /datum/material/silver = 200)
	build_path = /obj/item/stock_parts/subspace/treatment
	category = list(DCAT_STOCK_PART)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/subspace_analyzer
	name = "Subspace Analyzer"
	desc = "A sophisticated analyzer capable of analyzing cryptic subspace wavelengths."
	id = "s-analyzer"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 100, /datum/material/gold = 100)
	build_path = /obj/item/stock_parts/subspace/analyzer
	category = list(DCAT_STOCK_PART)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/subspace_crystal
	name = "Ansible Crystal"
	desc = "A sophisticated analyzer capable of analyzing cryptic subspace wavelengths."
	id = "s-crystal"
	build_type = FABRICATOR
	materials = list(/datum/material/glass = 800, /datum/material/silver = 100, /datum/material/gold = 100)
	build_path = /obj/item/stock_parts/subspace/crystal
	category = list(DCAT_STOCK_PART)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/subspace_transmitter
	name = "Subspace Transmitter"
	desc = "A large piece of equipment used to open a window into the subspace dimension."
	id = "s-transmitter"
	build_type = FABRICATOR
	materials = list(/datum/material/glass = 100, /datum/material/silver = 100, /datum/material/uranium = 100)
	build_path = /obj/item/stock_parts/subspace/transmitter
	category = list(DCAT_STOCK_PART)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/card_reader
	name = "Card Reader"
	desc = "A small magnetic card reader, used for devices that take and transmit holocredits."
	id = "c-reader"
	build_type = FABRICATOR
	materials = list(/datum/material/iron=50, /datum/material/glass=10)
	build_path = /obj/item/stock_parts/card_reader
	category = list(DCAT_STOCK_PART)

/datum/design/water_recycler
	name = "Water Recycler"
	desc = "A small hydrostatic reclaimer, it takes moisture out of the air and returns it back to the source."
	id = "w-recycler"
	build_type = FABRICATOR  | AUTOLATHE
	materials = list(/datum/material/plastic = 200, /datum/material/iron = 50)
	build_path = /obj/item/stock_parts/water_recycler
	category = list(DCAT_STOCK_PART)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI | DESIGN_FAB_MEDICAL
