///////////////////Computer Boards///////////////////////////////////

/datum/design/board
	name = "Circuit Board ( NULL ENTRY )"
	id = DESIGN_ID_IGNORE
	desc = "I promise this doesn't give you syndicate goodies!"
	build_type = IMPRINTER | AWAY_IMPRINTER
	materials = list(/datum/material/glass = 1000)
	category = list(DCAT_CIRCUIT)

/datum/design/board/arcade_battle
	name = "Circuit Board (Battle Arcade Machine)"
	desc = "Allows for the construction of circuit boards used to build a new arcade machine."
	id = "arcade_battle"
	build_path = /obj/item/circuitboard/computer/arcade/battle
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/orion_trail
	name = "Circuit Board (Orion Trail Arcade Machine)"
	desc = "Allows for the construction of circuit boards used to build a new Orion Trail machine."
	id = "arcade_orion"
	build_path = /obj/item/circuitboard/computer/arcade/orion_trail
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/seccamera
	name = "Circuit Board (Security Camera)"
	desc = "Allows for the construction of circuit boards used to build security camera computers."
	id = "seccamera"
	build_path = /obj/item/circuitboard/computer/security
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/rdcamera
	name = "Circuit Board (Research Monitor)"
	desc = "Allows for the construction of circuit boards used to build research camera computers."
	id = "rdcamera"
	build_path = /obj/item/circuitboard/computer/research
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/xenobiocamera
	name = "Circuit Board (Xenobiology Console)"
	desc = "Allows for the construction of circuit boards used to build xenobiology camera computers."
	id = "xenobioconsole"
	build_path = /obj/item/circuitboard/computer/xenobiology
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/aiupload
	name = "Circuit Board (AI Upload)"
	desc = "Allows for the construction of circuit boards used to build an AI Upload Console."
	id = "aiupload"
	materials = list(/datum/material/glass = 1000, /datum/material/gold = 2000, /datum/material/diamond = 2000, /datum/material/bluespace = 2000)
	build_path = /obj/item/circuitboard/computer/aiupload
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/borgupload
	name = "Circuit Board (Cyborg Upload)"
	desc = "Allows for the construction of circuit boards used to build a Cyborg Upload Console."
	id = "borgupload"
	materials = list(/datum/material/glass = 1000, /datum/material/gold = 2000, /datum/material/diamond = 2000, /datum/material/bluespace = 2000)
	build_path = /obj/item/circuitboard/computer/borgupload
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/med_data
	name = "Circuit Board (Medical Records)"
	desc = "Allows for the construction of circuit boards used to build a medical records console."
	id = "med_data"
	build_path = /obj/item/circuitboard/computer/med_data
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/operating
	name = "Circuit Board (Operating Computer)"
	desc = "Allows for the construction of circuit boards used to build an operating computer console."
	id = "operating"
	build_path = /obj/item/circuitboard/computer/operating
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/pandemic
	name = "Circuit Board (PanD.E.M.I.C. 2200)"
	desc = "Allows for the construction of circuit boards used to build a PanD.E.M.I.C. 2200 console."
	id = "pandemic"
	build_path = /obj/item/circuitboard/computer/pandemic
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/scan_console
	name = "Circuit Board (DNA Console)"
	desc = "Allows for the construction of circuit boards used to build a new DNA console."
	id = "scan_console"
	build_path = /obj/item/circuitboard/computer/scan_consolenew
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/comconsole
	name = "Circuit Board (Communications)"
	desc = "Allows for the construction of circuit boards used to build a communications console."
	id = "comconsole"
	build_path = /obj/item/circuitboard/computer/communications
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/crewconsole
	name = "Circuit Board (Crew monitoring computer)"
	desc = "Allows for the construction of circuit boards used to build a Crew monitoring computer."
	id = "crewconsole"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/computer/crew
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/secdata
	name = "Circuit Board (Security Records Console)"
	desc = "Allows for the construction of circuit boards used to build a security records console."
	id = "secdata"
	build_path = /obj/item/circuitboard/computer/secure_data
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/atmosalerts
	name = "Circuit Board (Atmosphere Alert)"
	desc = "Allows for the construction of circuit boards used to build an atmosphere alert console."
	id = "atmosalerts"
	build_path = /obj/item/circuitboard/computer/atmos_alert
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/atmos_control
	name = "Circuit Board (Atmospheric Monitor)"
	desc = "Allows for the construction of circuit boards used to build an Atmospheric Monitor."
	id = "atmos_control"
	build_path = /obj/item/circuitboard/computer/atmos_control
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/robocontrol
	name = "Circuit Board (Robotics Control Console)"
	desc = "Allows for the construction of circuit boards used to build a Robotics Control console."
	id = "robocontrol"
	materials = list(/datum/material/glass = 1000, /datum/material/gold = 1000, /datum/material/silver = 1000, /datum/material/bluespace = 2000)
	build_path = /obj/item/circuitboard/computer/robotics
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/slot_machine
	name = "Circuit Board (Slot Machine)"
	desc = "Allows for the construction of circuit boards used to build a new slot machine."
	id = "slotmachine"
	build_path = /obj/item/circuitboard/computer/slot_machine
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/powermonitor
	name = "Circuit Board (Power Monitor)"
	desc = "Allows for the construction of circuit boards used to build a new power monitor."
	id = "powermonitor"
	build_path = /obj/item/circuitboard/computer/powermonitor
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/solarcontrol
	name = "Circuit Board (Solar Control)"
	desc = "Allows for the construction of circuit boards used to build a solar control console."
	id = "solarcontrol"
	build_path = /obj/item/circuitboard/computer/solar_control
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/prisonmanage
	name = "Circuit Board (Prisoner Management Console)"
	desc = "Allows for the construction of circuit boards used to build a prisoner management console."
	id = "prisonmanage"
	build_path = /obj/item/circuitboard/computer/prisoner
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/mechacontrol
	name = "Circuit Board (Exosuit Control Console)"
	desc = "Allows for the construction of circuit boards used to build an exosuit control console."
	id = "mechacontrol"
	build_path = /obj/item/circuitboard/computer/mecha_control
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/mechapower
	name = "Circuit Board (Mech Bay Power Control Console)"
	desc = "Allows for the construction of circuit boards used to build a mech bay power control console."
	id = "mechapower"
	build_path = /obj/item/circuitboard/computer/mech_bay_power_console
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/cargo
	name = "Circuit Board (Supply Console)"
	desc = "Allows for the construction of circuit boards used to build a Supply Console."
	id = "cargo"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/computer/cargo
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_FAB_SUPPLY

/datum/design/board/cargorequest
	name = "Circuit Board (Supply Request Console)"
	desc = "Allows for the construction of circuit boards used to build a Supply Request Console."
	id = "cargorequest"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/computer/cargo/request
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/mining
	name = "Circuit Board (Outpost Status Display)"
	desc = "Allows for the construction of circuit boards used to build an outpost status display console."
	id = "mining"
	build_path = /obj/item/circuitboard/computer/mining
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/comm_monitor
	name = "Circuit Board (Telecommunications Monitoring Console)"
	desc = "Allows for the construction of circuit boards used to build a telecommunications monitor."
	id = "comm_monitor"
	build_path = /obj/item/circuitboard/computer/comm_monitor
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/comm_server
	name = "Circuit Board (Telecommunications Server Monitoring Console)"
	desc = "Allows for the construction of circuit boards used to build a telecommunication server browser and monitor."
	id = "comm_server"
	build_path = /obj/item/circuitboard/computer/comm_server
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/message_monitor
	name = "Circuit Board (Messaging Monitor Console)"
	desc = "Allows for the construction of circuit boards used to build a messaging monitor console."
	id = "message_monitor"
	build_path = /obj/item/circuitboard/computer/message_monitor
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/aifixer
	name = "Circuit Board (AI Integrity Restorer)"
	desc = "Allows for the construction of circuit boards used to build an AI Integrity Restorer."
	id = "aifixer"
	build_path = /obj/item/circuitboard/computer/aifixer
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/libraryconsole
	name = "Circuit Board (Library Console)"
	desc = "Allows for the construction of circuit boards used to build a new library console."
	id = "libraryconsole"
	build_path = /obj/item/circuitboard/computer/libraryconsole
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/apc_control
	name = "Circuit Board (APC Control)"
	desc = "Allows for the construction of circuit boards used to build a new APC control console."
	id = "apc_control"
	build_path = /obj/item/circuitboard/computer/apc_control
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/advanced_camera
	name = "Circuit Board (Advanced Camera Console)"
	desc = "Allows for the construction of circuit boards used to build advanced camera consoles."
	id = "advanced_camera"
	build_path = /obj/item/circuitboard/computer/advanced_camera
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/bountypad_control
	name = "Circuit Board (Civilian Bounty Pad Control)"
	desc = "Allows for the construction of circuit boards used to build a new civilian bounty pad console."
	id = "bounty_pad_control"
	build_path = /obj/item/circuitboard/computer/bountypad
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/exoscanner_console
	name = "Circuit Board (Scanner Array Control Console)"
	desc = "Allows for the construction of circuit boards used to build a new scanner array control console."
	id = "exoscanner_console"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/computer/exoscanner_console
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/exodrone_console
	name = "Circuit Board (Exploration Drone Control Console)"
	desc = "Allows for the construction of circuit boards used to build a new exploration drone control console."
	id = "exodrone_console"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/computer/exodrone_console
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/accounting_console
	name = "Circuit Board (Account Lookup Console)"
	desc = "Allows for the construction of circuit boards used to assess the wealth of crewmates on station."
	id = "account_console"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/computer/accounting
	category = list(DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER
