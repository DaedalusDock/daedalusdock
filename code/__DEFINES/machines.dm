// channel numbers for power
// These are indexes in a list, and indexes for "dynamic" and static channels should be kept contiguous
#define AREA_USAGE_EQUIP 1
#define AREA_USAGE_LIGHT 2
#define AREA_USAGE_ENVIRON 3
#define AREA_USAGE_STATIC_EQUIP 4
#define AREA_USAGE_STATIC_LIGHT 5
#define AREA_USAGE_STATIC_ENVIRON 6
#define AREA_USAGE_LEN AREA_USAGE_STATIC_ENVIRON // largest idx

/// Index of the first dynamic usage channel
#define AREA_USAGE_DYNAMIC_START AREA_USAGE_EQUIP
/// Index of the last dynamic usage channel
#define AREA_USAGE_DYNAMIC_END AREA_USAGE_ENVIRON

/// Index of the first static usage channel
#define AREA_USAGE_STATIC_START AREA_USAGE_STATIC_EQUIP
/// Index of the last static usage channel
#define AREA_USAGE_STATIC_END AREA_USAGE_STATIC_ENVIRON

#define DYNAMIC_TO_STATIC_CHANNEL(dyn_channel) (dyn_channel + (AREA_USAGE_STATIC_START - AREA_USAGE_DYNAMIC_START))
#define STATIC_TO_DYNAMIC_CHANNEL(static_channel) (static_channel - (AREA_USAGE_STATIC_START - AREA_USAGE_DYNAMIC_START))


//Power use
#define NO_POWER_USE 0
#define IDLE_POWER_USE 1
#define ACTIVE_POWER_USE 2

#define BASE_MACHINE_IDLE_CONSUMPTION 100
#define BASE_MACHINE_ACTIVE_CONSUMPTION (BASE_MACHINE_IDLE_CONSUMPTION * 10)

/// Bitflags for a machine's preferences on when it should start processing. For use with machinery's `processing_flags` var.
#define START_PROCESSING_ON_INIT (1<<0) /// Indicates the machine will automatically start processing right after it's `Initialize()` is ran.
#define START_PROCESSING_MANUALLY (1<<1) /// Machines with this flag will not start processing when it's spawned. Use this if you want to manually control when a machine starts processing.

//bitflags for door switches.
#define OPEN (1<<0)
#define IDSCAN (1<<1)
#define BOLTS (1<<2)
#define SHOCK (1<<3)
#define SAFE (1<<4)

//used in design to specify which machine can build it
#define FABRICATOR (1<<0) //For circuits. Uses glass/chemicals.
#define AUTOLATHE (1<<1) //Prints basic designs without research
#define MECHFAB (1<<2) //Remember, objects utilising this flag should have construction_time and construction_cost vars.
#define BIOGENERATOR (1<<3) //Uses biomass
#define LIMBGROWER (1<<4) //Uses synthetic flesh
#define SMELTER (1<<5) //uses various minerals
/// Imprinters for offstation roles. More limited tech tree.
#define AWAY_IMPRINTER (1<<6)
/// For wiremod/integrated circuits. Uses various minerals.
#define COMPONENT_PRINTER (1<<7)
//Note: More than one of these can be added to a design but imprinter and lathe designs are incompatable.
#define IMPRINTER (1<<8)//temp

//Modular computer/NTNet defines

//Modular computer part defines
#define MC_HDD "HDD"
#define MC_HDD_JOB "HDD_JOB"
#define MC_SDD "SDD"
#define MC_CARD "CARD"
#define MC_CARD2 "CARD2"
#define MC_NET "NET"
#define MC_PRINT "PRINT"
#define MC_CELL "CELL"
#define MC_CHARGE "CHARGE"
#define MC_AI "AI"

/// Modular Computer Autorun file
#define MC_AUTORUN_FILE "autorun"

//NTNet stuff, for modular computers
									// NTNet module-configuration values. Do not change these. If you need to add another use larger number (5..6..7 etc)
#define NTNET_SOFTWAREDOWNLOAD 1 // Downloads of software from NTNet
#define NTNET_PEERTOPEER 2 // P2P transfers of files between devices
#define NTNET_COMMUNICATION 3 // Communication (messaging)
#define NTNET_SYSTEMCONTROL 4 // Control of various systems, RCon, air alarm control, etc.

//NTNet transfer speeds, used when downloading/uploading a file/program.
#define NTNETSPEED_LOWSIGNAL 0.5 // GQ/s transfer speed when the device is wirelessly connected and on Low signal
#define NTNETSPEED_HIGHSIGNAL 1 // GQ/s transfer speed when the device is wirelessly connected and on High signal
#define NTNETSPEED_ETHERNET 2 // GQ/s transfer speed when the device is using wired connection

//Caps for NTNet logging. Less than 10 would make logging useless anyway, more than 500 may make the log browser too laggy. Defaults to 100 unless user changes it.
#define MAX_NTNET_LOGS 300
#define MIN_NTNET_LOGS 10

//Program bitflags
#define PROGRAM_ALL (~0)
#define PROGRAM_CONSOLE (1<<0)
#define PROGRAM_LAPTOP (1<<1)
#define PROGRAM_TABLET (1<<2)
//Program states
#define PROGRAM_STATE_KILLED 0
#define PROGRAM_STATE_BACKGROUND 1
#define PROGRAM_STATE_ACTIVE 2
//Program categories
#define PROGRAM_CATEGORY_CREW "Crew"
#define PROGRAM_CATEGORY_ENGI "Engineering"
#define PROGRAM_CATEGORY_SUPL "Supply"
#define PROGRAM_CATEGORY_SCI  "Science"
#define PROGRAM_CATEGORY_MISC "Other"

#define FIREDOOR_OPEN 1
#define FIREDOOR_CLOSED 2

#define HYPERTORUS_INACTIVE 0 // No or minimal energy
#define HYPERTORUS_NOMINAL 1 // Normal operation
#define HYPERTORUS_WARNING 2 // Integrity damaged
#define HYPERTORUS_DANGER 3 // Integrity < 50%
#define HYPERTORUS_EMERGENCY 4 // Integrity < 25%
#define HYPERTORUS_MELTING 5 // Pretty obvious.

//Nuclear bomb stuff
#define NUKESTATE_INTACT 5
#define NUKESTATE_UNSCREWED 4
#define NUKESTATE_PANEL_REMOVED 3
#define NUKESTATE_WELDED 2
#define NUKESTATE_CORE_EXPOSED 1
#define NUKESTATE_CORE_REMOVED 0

#define NUKEUI_AWAIT_DISK 0
#define NUKEUI_AWAIT_CODE 1
#define NUKEUI_AWAIT_TIMER 2
#define NUKEUI_AWAIT_ARM 3
#define NUKEUI_TIMING 4
#define NUKEUI_EXPLODED 5

#define NUKE_OFF_LOCKED 0
#define NUKE_OFF_UNLOCKED 1
#define NUKE_ON_TIMING 2
#define NUKE_ON_EXPLODING 3

#define MACHINE_NOT_ELECTRIFIED 0
#define MACHINE_ELECTRIFIED_PERMANENT -1
#define MACHINE_DEFAULT_ELECTRIFY_TIME 30

//mass drivers and related machinery
#define MASSDRIVER_ORDNANCE "ordnancedriver"
#define MASSDRIVER_CHAPEL "chapelgun"
#define MASSDRIVER_DISPOSALS "trash"
#define MASSDRIVER_SHACK "shack"

//orion game states
#define ORION_STATUS_START 0
#define ORION_STATUS_INSTRUCTIONS 1
#define ORION_STATUS_NORMAL 2
#define ORION_STATUS_GAMEOVER 3
#define ORION_STATUS_MARKET 4

//orion delays (how many turns an action costs)
#define ORION_SHORT_DELAY 2
#define ORION_LONG_DELAY 6

//starting orion crew count
#define ORION_STARTING_CREW_COUNT 4

//orion food to fuel / fuel to food conversion rate
#define ORION_TRADE_RATE 5

//and whether you want fuel or food
#define ORION_I_WANT_FUEL 1
#define ORION_I_WANT_FOOD 2

//orion price of buying pioneer
#define ORION_BUY_CREW_PRICE 10

//...and selling one (its less because having less pioneers is actually not that bad)
#define ORION_SELL_CREW_PRICE 7

//defining the magic numbers sent by tgui
#define ORION_BUY_ENGINE_PARTS 1
#define ORION_BUY_ELECTRONICS 2
#define ORION_BUY_HULL_PARTS 3

//orion gaming record (basically how worried it is that you're a deranged gunk gamer)
//game gives up on trying to help you
#define ORION_GAMER_GIVE_UP -2
//game spawns a pamphlet, post report
#define ORION_GAMER_PAMPHLET -1
//game begins to have a chance to warn sec and med
#define ORION_GAMER_REPORT_THRESHOLD 2

// Air alarm [/obj/machinery/airalarm/buildstage]
/// Air alarm missing circuit
#define AIRALARM_BUILD_NO_CIRCUIT 0
/// Air alarm has circuit but is missing wires
#define AIRALARM_BUILD_NO_WIRES 1
/// Air alarm has all components but isn't completed
#define AIRALARM_BUILD_COMPLETE 2

///TLV datums wont check limits set to this
#define TLV_DONT_CHECK -1
///the gas mixture is within the bounds of both warning and hazard limits
#define TLV_NO_DANGER 0
///the gas value is outside the warning limit but within the hazard limit, the air alarm will go into warning mode
#define TLV_OUTSIDE_WARNING_LIMIT 1
///the gas is outside the hazard limit, the air alarm will go into hazard mode
#define TLV_OUTSIDE_HAZARD_LIMIT 2

// Design categories
#define DCAT_COMPUTER_PART "Computer Parts"
#define DCAT_WIREMOD "Wiremod"
#define DCAT_POWER "Power Management"
#define DCAT_AMMO "Ammunition"
#define DCAT_BASIC_TOOL "Basic Tools"
#define DCAT_AI_LAW "Law Boards"
#define DCAT_JANITORIAL "Janitorial"
#define DCAT_MISC_TOOL "Misc. Tools"
#define DCAT_MATERIAL "Materials"
#define DCAT_BOTANICAL "Botanical"
#define DCAT_MEDICAL "Medical"
#define DCAT_REAGENTS "Reagents"
#define DCAT_ASSEMBLY "Assemblies"
#define DCAT_RADIO "Radio"
#define DCAT_FRAME "Wallframes"
#define DCAT_CONSTRUCTION "Construction"
#define DCAT_ATMOS "EVA"
#define DCAT_DINNERWARE "Dining"
#define DCAT_FORENSICS "Forensics"
#define DCAT_SECURITY "Security Tools"
#define DCAT_WEAPON "Weaponry"
#define DCAT_MECHA_OBJ "Exosuit Equipment"
#define DCAT_CIRCUIT "Circuit Boards"
#define DCAT_SUPPLY "Supply Tools"
#define DCAT_STOCK_PART "Stock Parts"
#define DCAT_WEARABLE "Wearables"
#define DCAT_MISC "Miscellaneous"
#define DCAT_SILICON "Silicons"
#define DCAT_MINING "Mining Tools"
#define DCAT_PAINTER "Painters"

// Design categories for the mechfab
#define DCAT_CYBORG "Cyborg"
#define DCAT_RIPLEY "Ripley"
#define DCAT_ODYSSEUS "Odysseus"
#define DCAT_GYGAX "Gygax"
#define DCAT_CLARKE "Clarke"
#define DCAT_DURAND "Durand"
#define DCAT_HONK "H.O.N.K"
#define DCAT_PHAZON "Phazon"
#define DCAT_SAVANNAH "Savannah-Ivanov"
#define DCAT_EXOSUIT_MOD "Exosuit Modules"
#define DCAT_AUGMENT "Augmentation"

#define DISK_INTERNAL "internal"
#define DISK_EXTERNAL "external"

#define FABRICATOR_FILE_NAME "fabrec"
