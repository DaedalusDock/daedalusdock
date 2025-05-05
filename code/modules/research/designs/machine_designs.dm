////////////////////////////////////////
//////////////MISC Boards///////////////
////////////////////////////////////////
/datum/design/board/electrolyzer
	name = "Machine Board (Electrolyzer Board)"
	desc = "The circuit board for an electrolyzer."
	id = "electrolyzer"
	build_path = /obj/item/circuitboard/machine/electrolyzer
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/smes
	name = "Machine Board (SMES Board)"
	desc = "The circuit board for a SMES."
	id = "smes"
	build_path = /obj/item/circuitboard/machine/smes
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/announcement_system
	name = "Machine Board (Automated Announcement System Board)"
	desc = "The circuit board for an automated announcement system."
	id = "automated_announcement"
	build_path = /obj/item/circuitboard/machine/announcement_system
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/emitter
	name = "Machine Board (Emitter Board)"
	desc = "The circuit board for an emitter."
	id = "emitter"
	build_path = /obj/item/circuitboard/machine/emitter
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/thermomachine
	name = "Machine Board (Thermomachine Board)"
	desc = "The circuit board for a thermomachine."
	id = "thermomachine"
	build_path = /obj/item/circuitboard/machine/thermomachine
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/space_heater
	name = "Machine Board (Space Heater Board)"
	desc = "The circuit board for a space heater."
	id = "space_heater"
	build_path = /obj/item/circuitboard/machine/space_heater
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/teleport_station
	name = "Machine Board (Teleportation Station Board)"
	desc = "The circuit board for a teleportation station."
	id = "tele_station"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/machine/teleporter_station
	mapload_design_flags = NONE

/datum/design/board/teleport_hub
	name = "Machine Board (Teleportation Hub Board)"
	desc = "The circuit board for a teleportation hub."
	id = "tele_hub"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/machine/teleporter_hub
	mapload_design_flags = NONE

/datum/design/board/quantumpad
	name = "Machine Board (Quantum Pad Board)"
	desc = "The circuit board for a quantum telepad."
	id = "quantumpad"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/machine/quantumpad
	mapload_design_flags = NONE

/datum/design/board/launchpad
	name = "Machine Board (Bluespace Launchpad Board)"
	desc = "The circuit board for a bluespace Launchpad."
	id = "launchpad"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/machine/launchpad
	mapload_design_flags = NONE
/datum/design/board/launchpad_console
	name = "Machine Board (Bluespace Launchpad Console Board)"
	desc = "The circuit board for a bluespace launchpad Console."
	id = "launchpad_console"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/computer/launchpad_console
	mapload_design_flags = NONE

/datum/design/board/teleconsole
	name = "Computer Design (Teleporter Console)"
	desc = "Allows for the construction of circuit boards used to build a teleporter control console."
	id = "teleconsole"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/computer/teleporter
	mapload_design_flags = NONE

/datum/design/board/cryotube
	name = "Machine Board (Cryotube Board)"
	desc = "The circuit board for a cryotube."
	id = "cryotube"
	build_path = /obj/item/circuitboard/machine/cryo_tube
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/chem_dispenser
	name = "Machine Board (Chem Dispenser Board)"
	desc = "The circuit board for a chem dispenser."
	id = "chem_dispenser"
	build_path = /obj/item/circuitboard/machine/chem_dispenser
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/mini_chem_dispenser
	name = "Machine Board (Mini Chem Dispenser Board)"
	desc = "The circuit board for a mini chem dispenser."
	id = "chem_dispenser"
	build_path = /obj/item/circuitboard/machine/chem_dispenser/mini
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/chem_dispenser
	name = "Machine Board (Big Chem Dispenser Board)"
	desc = "The circuit board for a big chem dispenser."
	id = "chem_dispenser"
	build_path = /obj/item/circuitboard/machine/chem_dispenser/big
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/chem_master
	name = "Machine Board (Chem Master Board)"
	desc = "The circuit board for a Chem Master 3000."
	id = "chem_master"
	mapload_design_flags = DESIGN_IMPRINTER
	build_path = /obj/item/circuitboard/machine/chem_master

/datum/design/board/chem_heater
	name = "Machine Board (Chemical Heater Board)"
	desc = "The circuit board for a chemical heater."
	id = "chem_heater"
	mapload_design_flags = DESIGN_IMPRINTER
	build_path = /obj/item/circuitboard/machine/chem_heater

/datum/design/board/smoke_machine
	name = "Machine Board (Smoke Machine)"
	desc = "The circuit board for a smoke machine."
	id = "smoke_machine"
	build_path = /obj/item/circuitboard/machine/smoke_machine
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/reagentgrinder
	name = "Machine Board (All-In-One Grinder)"
	desc = "The circuit board for an All-In-One Grinder."
	id = "reagentgrinder"
	build_path = /obj/item/circuitboard/machine/reagentgrinder

/datum/design/board/hypnochair
	name = "Machine Board (Enhanced Interrogation Chamber)"
	desc = "Allows for the construction of circuit boards used to build an Enhanced Interrogation Chamber."
	id = "hypnochair"
	mapload_design_flags = NONE
	build_path = /obj/item/circuitboard/machine/hypnochair
	category = list(DCAT_CIRCUIT)

/datum/design/board/biogenerator
	name = "Machine Board (Biogenerator Board)"
	desc = "The circuit board for a biogenerator."
	id = "biogenerator"
	build_path = /obj/item/circuitboard/machine/biogenerator
	category = list (DCAT_CIRCUIT)
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/hydroponics
	name = "Machine Board (Hydroponics Tray Board)"
	desc = "The circuit board for a hydroponics tray."
	id = "hydro_tray"
	build_path = /obj/item/circuitboard/machine/hydroponics
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/destructive_analyzer
	name = "Machine Board (Destructive Analyzer Board)"
	desc = "The circuit board for a destructive analyzer."
	id = "destructive_analyzer"
	build_path = /obj/item/circuitboard/machine/destructive_analyzer
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/fabricator
	name = "Machine Board (Fabricator Board)"
	desc = "The circuit board for a fabricator."
	id = "protolathe"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/machine/fabricator
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/fabricator/offstation
	name = "Machine Board (Ancient Fabricator Board)"
	desc = "The circuit board for an ancient fabricator."
	id = "protolathe_offstation"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/machine/fabricator/offstation
	mapload_design_flags = AWAY_IMPRINTER

/datum/design/board/circuit_imprinter
	name = "Machine Board (Circuit Imprinter Board)"
	desc = "The circuit board for a circuit imprinter."
	id = "circuit_imprinter"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/machine/circuit_imprinter
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/circuit_imprinter/offstation
	name = "Machine Board (Ancient Circuit Imprinter Board)"
	desc = "The circuit board for an ancient circuit imprinter."
	id = "circuit_imprinter_offstation"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/machine/circuit_imprinter/offstation
	mapload_design_flags = DESIGN_FAB_OFFSTATION

/datum/design/board/cyborgrecharger
	name = "Machine Board (Cyborg Recharger Board)"
	desc = "The circuit board for a Cyborg Recharger."
	id = "cyborgrecharger"
	build_path = /obj/item/circuitboard/machine/cyborgrecharger
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/mech_recharger
	name = "Machine Board (Mechbay Recharger Board)"
	desc = "The circuit board for a Mechbay Recharger."
	id = "mech_recharger"
	build_path = /obj/item/circuitboard/machine/mech_recharger
	mapload_design_flags = DESIGN_IMPRINTER

// /datum/design/board/dnascanner
// 	name = "Machine Board (DNA Scanner)"
// 	desc = "The circuit board for a DNA Scanner."
// 	id = "dnascanner"
// 	mapload_design_flags = DESIGN_IMPRINTER
// 	build_path = /obj/item/circuitboard/machine/dnascanner

/datum/design/board/doppler_array
	name = "Machine Board (Tachyon-Doppler Research Array Board)"
	desc = "The circuit board for a tachyon-doppler research array"
	id = "doppler_array"
	build_path = /obj/item/circuitboard/machine/doppler_array
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/anomaly_refinery
	name = "Machine Board (Anomaly Refinery Board)"
	desc = "The circuit board for an anomaly refinery"
	id = "anomaly_refinery"
	build_path = /obj/item/circuitboard/machine/anomaly_refinery
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/tank_compressor
	name = "Machine Board (Tank Compressor Board)"
	desc = "The circuit board for a tank compressor"
	id = "tank_compressor"
	build_path = /obj/item/circuitboard/machine/tank_compressor
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/microwave
	name = "Machine Board (Microwave Board)"
	desc = "The circuit board for a microwave."
	id = "microwave"
	build_path = /obj/item/circuitboard/machine/microwave
	mapload_design_flags = DESIGN_IMPRINTER


/datum/design/board/gibber
	name = "Machine Board (Gibber Board)"
	desc = "The circuit board for a gibber."
	id = "gibber"
	build_path = /obj/item/circuitboard/machine/gibber
	mapload_design_flags = DESIGN_IMPRINTER //oh god

/datum/design/board/smartfridge
	name = "Machine Board (Smartfridge Board)"
	desc = "The circuit board for a smartfridge."
	id = "smartfridge"
	build_path = /obj/item/circuitboard/machine/smartfridge
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/monkey_recycler
	name = "Machine Board (Monkey Recycler Board)"
	desc = "The circuit board for a monkey recycler."
	id = "monkey_recycler"
	build_path = /obj/item/circuitboard/machine/monkey_recycler
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/seed_extractor
	name = "Machine Board (Seed Extractor Board)"
	desc = "The circuit board for a seed extractor."
	id = "seed_extractor"
	build_path = /obj/item/circuitboard/machine/seed_extractor
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/processor
	name = "Machine Board (Food/Slime Processor Board)"
	desc = "The circuit board for a processing unit. Screwdriver the circuit to switch between food (default) or slime processing."
	id = "processor"
	build_path = /obj/item/circuitboard/machine/processor
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/soda_dispenser
	name = "Machine Board (Portable Soda Dispenser Board)"
	desc = "The circuit board for a portable soda dispenser."
	id = "soda_dispenser"
	build_path = /obj/item/circuitboard/machine/chem_dispenser/drinks
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/beer_dispenser
	name = "Machine Board (Portable Booze Dispenser Board)"
	desc = "The circuit board for a portable booze dispenser."
	id = "beer_dispenser"
	build_path = /obj/item/circuitboard/machine/chem_dispenser/drinks/beer
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/recycler
	name = "Machine Board (Recycler Board)"
	desc = "The circuit board for a recycler."
	id = "recycler"
	build_path = /obj/item/circuitboard/machine/recycler
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/scanner_gate
	name = "Machine Board (Scanner Gate)"
	desc = "The circuit board for a scanner gate."
	id = "scanner_gate"
	build_path = /obj/item/circuitboard/machine/scanner_gate
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/holopad
	name = "Machine Board (AI Holopad Board)"
	desc = "The circuit board for a holopad."
	id = "holopad"
	build_path = /obj/item/circuitboard/machine/holopad
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/autolathe
	name = "Machine Board (Autolathe Board)"
	desc = "The circuit board for an autolathe."
	id = "autolathe"
	build_path = /obj/item/circuitboard/machine/autolathe
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/recharger
	name = "Machine Board (Weapon Recharger Board)"
	desc = "The circuit board for a Weapon Recharger."
	id = "recharger"
	materials = list(/datum/material/glass = 1000, /datum/material/gold = 2000)
	build_path = /obj/item/circuitboard/machine/recharger
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/vendor
	name = "Machine Board (Vendor Board)"
	desc = "The circuit board for a Vendor."
	id = "vendor"
	build_path = /obj/item/circuitboard/machine/vendor
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/ore_redemption
	name = "Machine Board (Ore Redemption Board)"
	desc = "The circuit board for an Ore Redemption machine."
	id = "ore_redemption"
	build_path = /obj/item/circuitboard/machine/ore_redemption
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/mining_equipment_vendor
	name = "Machine Board (Mining Rewards Vendor Board)"
	desc = "The circuit board for a Mining Rewards Vendor."
	id = "mining_equipment_vendor"
	build_path = /obj/item/circuitboard/machine/mining_equipment_vendor
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/tesla_coil
	name = "Machine Board (Tesla Coil Board)"
	desc = "The circuit board for a tesla coil."
	id = "tesla_coil"
	build_path = /obj/item/circuitboard/machine/tesla_coil
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/grounding_rod
	name = "Machine Board (Grounding Rod Board)"
	desc = "The circuit board for a grounding rod."
	id = "grounding_rod"
	build_path = /obj/item/circuitboard/machine/grounding_rod
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/ntnet_relay
	name = "Machine Board (NTNet Relay Board)"
	desc = "The circuit board for a wireless network relay."
	id = "ntnet_relay"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/machine/ntnet_relay
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/limbgrower
	name = "Machine Board (Limb Grower Board)"
	desc = "The circuit board for a limb grower."
	id = "limbgrower"
	build_path = /obj/item/circuitboard/machine/limbgrower
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/harvester
	name = "Machine Board (Organ Harvester Board)"
	desc = "The circuit board for an organ harvester."
	id = "harvester"
	build_path = /obj/item/circuitboard/machine/harvester
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/deepfryer
	name = "Machine Board (Deep Fryer)"
	desc = "The circuit board for a Deep Fryer."
	id = "deepfryer"
	build_path = /obj/item/circuitboard/machine/deep_fryer
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/griddle
	name = "Machine Board (Griddle)"
	desc = "The circuit board for a Griddle."
	id = "griddle"
	build_path = /obj/item/circuitboard/machine/griddle
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/oven
	name = "Machine Board (Oven)"
	desc = "The circuit board for a Oven."
	id = "oven"
	build_path = /obj/item/circuitboard/machine/oven
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/donksofttoyvendor
	name = "Machine Board (Donksoft Toy Vendor Board)"
	desc = "The circuit board for a Donksoft Toy Vendor."
	id = "donksofttoyvendor"
	build_path = /obj/item/circuitboard/machine/vending/donksofttoyvendor


/datum/design/board/cell_charger
	name = "Machine Board (Cell Charger Board)"
	desc = "The circuit board for a cell charger."
	id = "cell_charger"
	build_path = /obj/item/circuitboard/machine/cell_charger
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/dish_drive
	name = "Machine Board (Dish Drive)"
	desc = "The circuit board for a dish drive."
	id = "dish_drive"
	build_path = /obj/item/circuitboard/machine/dish_drive
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/stacking_unit_console
	name = "Machine Board (Stacking Machine Console)"
	desc = "The circuit board for a Stacking Machine Console."
	id = "stack_console"
	build_path = /obj/item/circuitboard/machine/stacking_unit_console
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/stacking_machine
	name = "Machine Board (Stacking Machine)"
	desc = "The circuit board for a Stacking Machine."
	id = "stack_machine"
	build_path = /obj/item/circuitboard/machine/stacking_machine
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/ore_silo
	name = "Machine Board (Ore Silo)"
	desc = "The circuit board for an ore silo."
	id = "ore_silo"
	build_path = /obj/item/circuitboard/machine/ore_silo
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/fat_sucker
	name = "Machine Board (Lipid Extractor)"
	desc = "The circuit board for a lipid extractor."
	id = "fat_sucker"
	build_path = /obj/item/circuitboard/machine/fat_sucker
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/stasis
	name = "Machine Board (Lifeform Stasis Unit)"
	desc = "The circuit board for a stasis unit."
	id = "stasis"
	build_path = /obj/item/circuitboard/machine/stasis
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/spaceship_navigation_beacon
	name = "Machine Board (Bluespace Navigation Gigabeacon)"
	desc = "The circuit board for a Bluespace Navigation Gigabeacon."
	id = "spaceship_navigation_beacon"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/machine/spaceship_navigation_beacon
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/medipen_refiller
	name = "Machine Board (Medipen Refiller)"
	desc = "The circuit board for a Medipen Refiller."
	id = "medipen_refiller"
	build_path = /obj/item/circuitboard/machine/medipen_refiller
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/sheetifier
	name = "Machine Board (Sheet-meister 2000)"
	desc = "The circuit board for a Sheet-meister 2000."
	id = "sheetifier"
	build_path = /obj/item/circuitboard/machine/sheetifier
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/restaurant_portal
	name = "Machine Board (Restaurant Portal)"
	desc = "The circuit board for a restaurant portal"
	id = "restaurant_portal"
	build_path = /obj/item/circuitboard/machine/restaurant_portal
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/vendatray
	name = "Machine Board (Vend-a-Tray)"
	desc = "The circuit board for a Vend-a-Tray."
	id = "vendatray"
	build_path = /obj/item/circuitboard/machine/vendatray
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/skill_station
	name = "Machine Board (Skill station)"
	desc = "The circuit board for Skill station."
	id = "skill_station"
	build_path = /obj/item/circuitboard/machine/skill_station
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/exoscanner
	name = "Machine Board (Scanner Array)"
	desc = "The circuit board for scanner array."
	id = "exoscanner"
	build_path = /obj/item/circuitboard/machine/exoscanner
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/exodrone_launcher
	name = "Machine Board (Exploration Drone Launcher)"
	desc = "The circuit board for exodrone launcher."
	id = "exodrone_launcher"
	build_path = /obj/item/circuitboard/machine/exodrone_launcher
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/component_printer
	name = "Machine Board (Component Printer)"
	desc = "The circuit board for a component printer"
	id = "component_printer"
	build_path = /obj/item/circuitboard/machine/component_printer
	mapload_design_flags = DESIGN_IMPRINTER

/datum/design/board/module_printer
	name = "Machine Board (Module Duplicator)"
	desc = "The circuit board for a module duplicator"
	id = "module_duplicator"
	build_path = /obj/item/circuitboard/machine/module_duplicator
	mapload_design_flags = DESIGN_IMPRINTER
