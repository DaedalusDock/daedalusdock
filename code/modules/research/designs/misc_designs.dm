
/////////////////////////////////////////
/////////////////HUDs////////////////////
/////////////////////////////////////////

/datum/design/health_hud
	name = "Health Scanner HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their health status."
	id = "health_hud"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/clothing/glasses/hud/health
	category = list(DCAT_WEARABLE)
	mapload_design_flags = DESIGN_FAB_MEDICAL

/datum/design/security_hud
	name = "Security HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their ID status."
	id = "security_hud"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/clothing/glasses/hud/security
	category = list(DCAT_WEARABLE)
	mapload_design_flags = DESIGN_FAB_SECURITY

/datum/design/diagnostic_hud
	name = "Diagnostic HUD"
	desc = "A HUD used to analyze and determine faults within robotic machinery."
	id = "diagnostic_hud"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/clothing/glasses/hud/diagnostic
	category = list(DCAT_WEARABLE)
	mapload_design_flags = DESIGN_FAB_OMNI

/////////////////////////////////////////
//////////////////Misc///////////////////
/////////////////////////////////////////

/datum/design/welding_goggles
	name = "Welding Goggles"
	desc = "Protects the eyes from bright flashes; approved by the mad scientist association."
	id = "welding_goggles"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/clothing/glasses/welding
	category = list(DCAT_WEARABLE)
	mapload_design_flags = DESIGN_FAB_OMNI | DESIGN_FAB_ENGINEERING

/datum/design/welding_mask
	name = "Welding Gas Mask"
	desc = "A gas mask with built in welding goggles and face shield. Looks like a skull, clearly designed by a nerd."
	id = "weldingmask"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 3000, /datum/material/glass = 1000)
	build_path = /obj/item/clothing/mask/gas/welding
	category = list(DCAT_WEARABLE, DCAT_ATMOS)
	mapload_design_flags = DESIGN_FAB_OMNI | DESIGN_FAB_ENGINEERING

/datum/design/rolling_table //Should probably be craftable..?
	name = "Rolly poly"
	desc = "We duct-taped some wheels to the bottom of a table. It's goddamn science alright?"
	id = "rolling_table"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 4000)
	build_path = /obj/structure/table/rolling
	category = list(DCAT_WEARABLE)

/datum/design/portaseeder
	name = "Portable Seed Extractor"
	desc = "For the enterprising botanist on the go. Less efficient than the stationary model, it creates one seed per plant."
	id = "portaseeder"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 1000, /datum/material/glass = 400)
	build_path = /obj/item/storage/bag/plants/portaseeder
	category = list(DCAT_BOTANICAL)
	mapload_design_flags = DESIGN_FAB_SERVICE

/datum/design/air_horn
	name = "Air Horn"
	desc = "Damn son, where'd you find this?"
	id = "air_horn"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 4000, /datum/material/bananium = 1000)
	build_path = /obj/item/bikehorn/airhorn
	category = list(DCAT_MISC_TOOL)

/datum/design/mesons
	name = "Optical Meson Scanners"
	desc = "Used by engineering and mining staff to see basic structural and terrain layouts through walls, regardless of lighting condition."
	id = "mesons"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/clothing/glasses/meson
	category = list(DCAT_WEARABLE)
	mapload_design_flags = DESIGN_FAB_SUPPLY | DESIGN_FAB_ENGINEERING

/datum/design/engine_goggles
	name = "Engineering Scanner Goggles"
	desc = "Goggles used by engineers. The Meson Scanner mode lets you see basic structural and terrain layouts through walls, regardless of lighting condition. The T-ray Scanner mode lets you see underfloor objects such as cables and pipes."
	id = "engine_goggles"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500, /datum/material/plasma = 100)
	build_path = /obj/item/clothing/glasses/meson/engine
	category = list(DCAT_WEARABLE)
	mapload_design_flags = DESIGN_FAB_ENGINEERING

/datum/design/tray_goggles
	name = "Optical T-Ray Scanners"
	desc = "Used by engineering staff to see underfloor objects such as cables and pipes."
	id = "tray_goggles"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/clothing/glasses/meson/engine/tray
	category = list(DCAT_WEARABLE)
	mapload_design_flags = DESIGN_FAB_ENGINEERING

/datum/design/night_vision_goggles
	name = "Night Vision Goggles"
	desc = "Goggles that let you see through darkness unhindered."
	id = "night_visision_goggles"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 600, /datum/material/glass = 600, /datum/material/plasma = 350, /datum/material/uranium = 1000)
	build_path = /obj/item/clothing/glasses/night
	category = list(DCAT_WEARABLE)
	mapload_design_flags = DESIGN_FAB_OMNI | DESIGN_FAB_SECURITY

/datum/design/magboots
	name = "Magnetic Boots"
	desc = "Magnetic boots, often used during extravehicular activity to ensure the user remains safely attached to the vehicle."
	id = "magboots"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 4500, /datum/material/silver = 1500, /datum/material/gold = 2500)
	build_path = /obj/item/clothing/shoes/magboots
	category = list(DCAT_WEARABLE)
	mapload_design_flags = DESIGN_FAB_ENGINEERING

/datum/design/sci_goggles
	name = "Science Goggles"
	desc = "Goggles fitted with a portable analyzer capable of determining the research worth of an item or components of a machine."
	id = "scigoggles"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/clothing/glasses/science
	category = list(DCAT_WEARABLE)
	mapload_design_flags = DESIGN_FAB_OMNI

/datum/design/roastingstick
	name = "Advanced Roasting Stick"
	desc = "A roasting stick for cooking sausages in exotic ovens."
	id = "roastingstick"
	build_type = FABRICATOR
	materials = list(/datum/material/iron=1000, /datum/material/glass = 500, /datum/material/bluespace = 250)
	build_path = /obj/item/melee/roastingstick
	category = list("Equipment")
	mapload_design_flags = DESIGN_FAB_SERVICE

/datum/design/locator
	name = "Radio Tracker"
	desc = "Used to track portable teleportation beacons and targets with embedded tracking implants."
	id = "locator"
	build_type = FABRICATOR
	materials = list(/datum/material/iron=1000, /datum/material/glass = 500, /datum/material/silver = 500)
	build_path = /obj/item/locator
	category = list(DCAT_RADIO)
	mapload_design_flags = DESIGN_FAB_SECURITY

/datum/design/quantum_keycard
	name = "Quantum Keycard"
	desc = "Allows for the construction of a quantum keycard."
	id = "quantum_keycard"
	build_type = FABRICATOR
	materials = list(/datum/material/glass = 500, /datum/material/iron = 500, /datum/material/silver = 500, /datum/material/bluespace = 1000)
	build_path = /obj/item/quantum_keycard
	category = list(DCAT_RADIO)
	mapload_design_flags = DESIGN_FAB_OMNI | DESIGN_FAB_ENGINEERING

/datum/design/anomaly_neutralizer
	name = "Anomaly Neutralizer"
	desc = "An advanced tool capable of instantly neutralizing anomalies, designed to capture the fleeting aberrations created by the engine."
	id = "anomaly_neutralizer"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 2000, /datum/material/gold = 2000, /datum/material/plasma = 5000, /datum/material/uranium = 2000)
	build_path = /obj/item/anomaly_neutralizer
	category = list("Equipment")
	mapload_design_flags = DESIGN_FAB_OMNI

/datum/design/oxygen_tank
	name = "Oxygen Tank"
	desc = "An empty oxygen tank."
	id = "oxygen_tank"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 2000)
	build_path = /obj/item/tank/internals/oxygen/empty
	category = list(DCAT_ATMOS)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/plasma_tank
	name = "Plasma Tank"
	desc = "An empty oxygen tank."
	id = "plasma_tank"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 2000)
	build_path = /obj/item/tank/internals/plasma/empty
	category = list(DCAT_ATMOS)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/datum/design/pneumatic_seal // bay :pleading:
	name = "Pneumatic Airlock Seal"
	desc = "A heavy brace used to seal airlocks. Useful for keeping out people without the dexterity to remove it."
	id = "pneumatic_seal"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 20000, /datum/material/plasma = 10000)
	build_path = /obj/item/door_seal
	category = list(DCAT_CONSTRUCTION)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_SECURITY

/////////////////////////////////////////
////////////Janitor Designs//////////////
/////////////////////////////////////////

/datum/design/advmop
	name = "Advanced Mop"
	desc = "An upgraded mop with a large internal capacity for holding water or other cleaning chemicals."
	id = "advmop"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 2500, /datum/material/glass = 200)
	build_path = /obj/item/mop/advanced
	category = list(DCAT_JANITORIAL)
	mapload_design_flags = DESIGN_FAB_SERVICE

/datum/design/normtrash
	name = "Trashbag"
	desc = "It's a bag for trash, you put garbage in it."
	id = "normtrash"
	build_type = FABRICATOR
	materials = list(/datum/material/plastic = 2000)
	build_path = /obj/item/storage/bag/trash
	category = list(DCAT_JANITORIAL)
	mapload_design_flags = DESIGN_FAB_SERVICE

/datum/design/light_replacer
	name = "Light Replacer"
	desc = "A device to automatically replace lights. Refill with working light bulbs."
	id = "light_replacer"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 1500, /datum/material/silver = 150, /datum/material/glass = 3000)
	build_path = /obj/item/lightreplacer
	category = list(DCAT_MISC_TOOL)
	mapload_design_flags = DESIGN_FAB_SERVICE | DESIGN_FAB_ENGINEERING

/datum/design/buffer_upgrade
	name = "Floor Buffer Upgrade"
	desc = "A floor buffer that can be attached to vehicular janicarts."
	id = "buffer"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 3000, /datum/material/glass = 200)
	build_path = /obj/item/janicart_upgrade/buffer
	category = list(DCAT_JANITORIAL)
	mapload_design_flags = DESIGN_FAB_SERVICE

/datum/design/vacuum_upgrade
	name = "Vacuum Upgrade"
	desc = "A vacuum that can be attached to vehicular janicarts."
	id = "vacuum"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 3000, /datum/material/glass = 200)
	build_path = /obj/item/janicart_upgrade/vacuum
	category = list(DCAT_JANITORIAL)
	mapload_design_flags = DESIGN_FAB_SERVICE

/datum/design/paint_remover
	name = "Paint Remover"
	desc = "Removes stains from the floor, and not much else."
	id = "paint_remover"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 1000)
	reagents_list = list(/datum/reagent/acetone = 60)
	build_path = /obj/item/paint_remover
	category = list(DCAT_MISC_TOOL)
	mapload_design_flags = DESIGN_FAB_SERVICE

/datum/design/spraybottle
	name = "Spray Bottle"
	desc = "A spray bottle, with an unscrewable top."
	id = "spraybottle"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 3000, /datum/material/glass = 200)
	build_path = /obj/item/reagent_containers/spray
	category = list(DCAT_JANITORIAL)
	mapload_design_flags = DESIGN_FAB_SERVICE

/////////////////////////////////////////
/////////////Holobarriers////////////////
/////////////////////////////////////////

/datum/design/holosign
	name = "Holographic Sign Projector"
	desc = "A holograpic projector used to project various warning signs."
	id = "holosign"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 1000)
	build_path = /obj/item/holosign_creator
	category = list(DCAT_MISC_TOOL)
	mapload_design_flags = DESIGN_FAB_SERVICE

/datum/design/holobarrier_jani
	name = "Custodial Holobarrier Projector"
	desc = "A holograpic projector used to project hard light wet floor barriers."
	id = "holobarrier_jani"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 1000, /datum/material/silver = 1000)
	build_path = /obj/item/holosign_creator/janibarrier
	category = list(DCAT_JANITORIAL)
	mapload_design_flags = DESIGN_FAB_SERVICE


/datum/design/holosignsec
	name = "Security Holobarrier Projector"
	desc = "A holographic projector that creates holographic security barriers."
	id = "holosignsec"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 1000, /datum/material/gold = 1000, /datum/material/silver = 1000)
	build_path = /obj/item/holosign_creator/security
	category = list(DCAT_SECURITY)
	mapload_design_flags = DESIGN_FAB_SECURITY

/datum/design/holosignengi
	name = "Engineering Holobarrier Projector"
	desc = "A holographic projector that creates holographic engineering barriers."
	id = "holosignengi"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 1000, /datum/material/gold = 1000, /datum/material/silver = 1000)
	build_path = /obj/item/holosign_creator/engineering
	category = list("Equipment")
	mapload_design_flags = DESIGN_FAB_ENGINEERING

/datum/design/holosignatmos
	name = "ATMOS Holofan Projector"
	desc = "A holographic projector that creates holographic barriers that prevent changes in atmospheric conditions."
	id = "holosignatmos"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 1000, /datum/material/gold = 1000, /datum/material/silver = 1000)
	build_path = /obj/item/holosign_creator/atmos
	category = list(DCAT_ATMOS)
	mapload_design_flags = DESIGN_FAB_ENGINEERING

/datum/design/holobarrier_med
	name = "PENLITE Holobarrier Projector"
	desc = "PENLITE holobarriers, a device that halts individuals with malicious diseases."
	build_type = FABRICATOR
	build_path = /obj/item/holosign_creator/medical
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500, /datum/material/silver = 100) //a hint of silver since it can troll 2 antags (bad viros and sentient disease)
	id = "holobarrier_med"
	category = list(DCAT_MEDICAL)
	mapload_design_flags = DESIGN_FAB_MEDICAL

/////////////////////////////////////////
////////////////Armour///////////////////
/////////////////////////////////////////

/datum/design/reactive_armour
	name = "Reactive Armour Shell"
	desc = "An experimental suit of armour capable of utilizing an implanted anomaly core to protect the user."
	id = "reactive_armour"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 10000, /datum/material/diamond = 5000, /datum/material/uranium = 8000, /datum/material/silver = 4500, /datum/material/gold = 5000)
	build_path = /obj/item/reactive_armour_shell
	category = list("Equipment")
	mapload_design_flags = DESIGN_FAB_OMNI | DESIGN_FAB_ENGINEERING

/datum/design/knight_armour
	name = "Knight Armour"
	desc = "A royal knight's favorite garments. Can be trimmed by any friendly person."
	id = "knight_armour"
	build_type = AUTOLATHE
	materials = list(MAT_CATEGORY_ITEM_MATERIAL = 10000)
	build_path = /obj/item/clothing/suit/armor/riot/knight/greyscale
	category = list("Imported")

/datum/design/knight_helmet
	name = "Knight Helmet"
	desc = "A royal knight's favorite hat. If you hold it upside down it's actually a bucket."
	id = "knight_helmet"
	build_type = AUTOLATHE
	materials = list(MAT_CATEGORY_ITEM_MATERIAL = 5000)
	build_path = /obj/item/clothing/head/helmet/knight/greyscale
	category = list("Imported")



/////////////////////////////////////////
/////////////Security////////////////////
/////////////////////////////////////////

/datum/design/seclite
	name = "Seclite"
	desc = "A robust flashlight used by security."
	id = "seclite"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 2500)
	build_path = /obj/item/flashlight/seclite
	category = list(DCAT_SECURITY)
	mapload_design_flags = DESIGN_FAB_SECURITY

/datum/design/evidencebag
	name = "Evidence Bag"
	desc = "An empty evidence bag."
	id = "evidencebag"
	build_type = FABRICATOR
	materials = list(/datum/material/plastic = 100)
	build_path = /obj/item/storage/evidencebag
	category = list(DCAT_FORENSICS)
	mapload_design_flags = DESIGN_FAB_SECURITY

/datum/design/gas_filter
	name = "Gas filter"
	id = "gas_filter"
	build_type = FABRICATOR | AUTOLATHE
	materials = list(/datum/material/iron = 100)
	build_path = /obj/item/gas_filter
	category = list(DCAT_ATMOS)
	mapload_design_flags = DESIGN_FAB_ENGINEERING | DESIGN_FAB_OMNI

/////////////////////////////////////////
/////////Restaurant Equipment////////////
/////////////////////////////////////////

/datum/design/holosign/restaurant
	name = "Restaurant Seating Projector"
	desc = "A holographic projector that creates seating designation for restaurants."
	id = "holosignrestaurant"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 1000)
	build_path = /obj/item/holosign_creator/robot_seat/restaurant
	category = list(DCAT_DINNERWARE)
	mapload_design_flags = DESIGN_FAB_SERVICE

/datum/design/holosign/bar
	name = "Bar Seating Projector"
	desc = "A holographic projector that creates seating designation for bars."
	id = "holosignbar"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 1000)
	build_path = /obj/item/holosign_creator/robot_seat/bar
	category = list(DCAT_DINNERWARE)
	mapload_design_flags = DESIGN_FAB_SERVICE

/datum/design/oven_tray
	name = "Oven Tray"
	desc = "Gotta shove something in!"
	id = "oven_tray"
	build_type = AUTOLATHE | FABRICATOR
	materials = list(/datum/material/iron = 500)
	build_path = /obj/item/plate/oven_tray
	category = list(DCAT_DINNERWARE)
	mapload_design_flags = DESIGN_FAB_SERVICE

/////////////////////////////////////////
////////////////Data Terminal////////////
/////////////////////////////////////////

/datum/design/data_terminal
	name = "Data Terminal"
	desc = "A floor-mountable data terminal for powerline networks."
	id = "data_terminal"
	build_type = FABRICATOR
	materials = list(/datum/material/iron = 500)
	build_path = /obj/item/data_terminal_construct
	category = list(DCAT_ASSEMBLY, DCAT_RADIO)
	mapload_design_flags = DESIGN_FAB_ENGINEERING
