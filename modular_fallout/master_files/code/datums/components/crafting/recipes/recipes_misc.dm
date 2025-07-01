/datum/crafting_recipe/binoculars
	name = "Binoculars"
	result = /obj/item/binoculars
	time = 60
	reqs = list(/obj/item/stack/sheet/iron = 10,
				/obj/item/stack/sheet/glass = 5)
	tool_behaviors = list(TOOL_SCREWDRIVER,TOOL_WORKBENCH)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/////////////////
//Large Objects//
/////////////////

/datum/crafting_recipe/ncrgate
	name = "NCR reinforced door"
	result = /obj/machinery/door/unpowered/secure_NCR
	reqs = list(/obj/item/stack/sheet/iron = 20,
				/obj/item/stack/sheet/mineral/wood = 20,)
	time = 60
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC
	always_available = FALSE

/datum/crafting_recipe/legiongate
	name = "Legion iron gate"
	result = /obj/machinery/door/unpowered/secure_legion
	reqs = list(/obj/item/stack/sheet/iron = 25)
	time = 60
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC
	always_available = FALSE

/datum/crafting_recipe/gate_bos
	name = "Brotherhood steel door"
	result = /obj/machinery/door/unpowered/secure_bos
	reqs = list(/obj/item/stack/sheet/iron = 35)
	time = 60
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC
	always_available = FALSE

/datum/crafting_recipe/gate_khanate
	name = "Khans steel-reinforced wood door"
	result = /obj/machinery/door/unpowered/securedoor/khandoor
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/stack/sheet/mineral/wood = 10,)
	time = 60
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC
	always_available = FALSE

/datum/crafting_recipe/gate_biker
	name = "Hell's Nomad wood door"
	result = /obj/machinery/door/unpowered/securedoor/bikerdoor
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/stack/sheet/mineral/wood = 10,)
	time = 60
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC
	always_available = FALSE

/datum/crafting_recipe/plant
	name = "Potted plant"
	result = /obj/item/kirbyplants/random
	reqs = list(/obj/item/stack/sheet/mineral/sandstone=5,
				/obj/item/seeds=1)
	time = 20
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/toilet
	name = "Toilet"
	result = /obj/structure/toilet
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/stack/crafting/metalparts = 5)
	time = 50
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/sink
	name = "Sink"
	result = /obj/structure/sink
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/stack/crafting/metalparts = 5)
	time = 50
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/shower
	name = "Shower"
	result = /obj/machinery/shower
	reqs = list(/obj/item/stack/sheet/iron = 10,
				/obj/item/stack/crafting/metalparts = 10)
	tool_behaviors = list(TOOL_WRENCH, TOOL_SCREWDRIVER)
	time = 80
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/showercurtain
	name = "Shower Curtains"
	reqs = 	list(/obj/item/stack/sheet/cloth = 2,
				/obj/item/stack/sheet/plastic = 2,
				/obj/item/stack/rods = 1)
	result = /obj/structure/curtain
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/curtain
	name = "Curtains"
	reqs = list(/obj/item/stack/sheet/cloth = 2,
				/obj/item/stack/rods = 1)
	result = /obj/structure/curtain
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/dogbed
	name = "Dog Bed"
	result = /obj/structure/bed/dogbed
	reqs = 	list(/obj/item/stack/sheet/cloth = 2,
				/obj/item/stack/sheet/mineral/wood = 5)
	time = 10
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/junk_table
	name = "Makeshift Bar Table"
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/stack/sheet/mineral/wood = 2)
	result = /obj/structure/table/wood/junk
	time = 10
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

///////////////////////////
//Scavenging and Tinkering//
///////////////////////////

/datum/crafting_recipe/pico_manip
	name = "Delicate Mechanism"
	result = /obj/item/stock_parts/manipulator/pico
	reqs = list(/obj/item/stack/crafting/goodparts = 2,
				/obj/item/stock_parts/manipulator/nano = 1)
	time = 5
	category = CAT_CRAFTING
	subcategory = CAT_SCAVENGING
	always_available = FALSE

/datum/crafting_recipe/super_matter_bin
	name = "Storage Bin"
	result = /obj/item/stock_parts/matter_bin/super
	reqs = list(/obj/item/stack/crafting/goodparts = 2,
				/obj/item/stock_parts/matter_bin/adv = 1)
	time = 5
	category = CAT_CRAFTING
	subcategory = CAT_SCAVENGING
	always_available = FALSE

/datum/crafting_recipe/phasic_scanning
	name = "Advanced Antenna"
	result = /obj/item/stock_parts/scanning_module/phasic
	reqs = list(/obj/item/stack/crafting/goodparts = 2,
				/obj/item/stock_parts/scanning_module/adv = 1)
	time = 5
	category = CAT_CRAFTING
	subcategory = CAT_SCAVENGING
	always_available = FALSE

/datum/crafting_recipe/super_capacitor
	name = "Advanced Capacitor"
	result = /obj/item/stock_parts/capacitor/super
	reqs = list(/obj/item/stack/crafting/goodparts = 2,
				/obj/item/stock_parts/capacitor/adv = 1)
	time = 5
	category = CAT_CRAFTING
	subcategory = CAT_SCAVENGING
	always_available = FALSE

/datum/crafting_recipe/ultra_micro_laser
	name = "Laser Diode"
	result = /obj/item/stock_parts/micro_laser/ultra
	reqs = list(/obj/item/stack/crafting/goodparts = 2,
				/obj/item/stock_parts/micro_laser/high = 1)
	time = 5
	category = CAT_CRAFTING
	subcategory = CAT_SCAVENGING
	always_available = FALSE

/datum/crafting_recipe/pin_removal
	name = "Render gun unusable"
	result = /obj/item/gun
	reqs = list(/obj/item/gun = 1)
	parts = list(/obj/item/gun = 1)
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	time = 50
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/pin_removal/check_requirements(mob/user, list/collected_requirements)
	var/obj/item/gun/G = collected_requirements[/obj/item/gun][1]
	if (G.no_pin_required || !G.pin)
		return FALSE
	return TRUE

//////////////////////
//Burial & Execution//
//////////////////////

/datum/crafting_recipe/rip
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/rip/gravemarker
	name = "Gravemarker"
	result = /obj/structure/statue/wood/headstonewood
	reqs = list(/obj/item/stack/sheet/mineral/wood = 3)
	time = 10

/datum/crafting_recipe/rip/coffin
	name = "Coffin"
	result = /obj/structure/closet/crate/coffin
	reqs = list(/obj/item/stack/sheet/mineral/wood = 5)
	time = 20

/datum/crafting_recipe/rip/blackcoffin
	name = "Black Coffin"
	result = /obj/structure/closet/crate/coffin/blackcoffin
	tool_behaviors = list(/obj/item/weldingtool,
				/obj/item/screwdriver)
	reqs = list(/obj/item/stack/sheet/cloth = 1,
				/obj/item/stack/sheet/mineral/wood = 5,
				/obj/item/stack/sheet/iron = 1)
	time = 20

/datum/crafting_recipe/rip/metalcoffin
	name = "Metal Coffin"
	result =/obj/structure/closet/crate/coffin/metalcoffin
	tool_behaviors = list(/obj/item/weldingtool,
				/obj/item/screwdriver)
	reqs = list(/obj/item/stack/sheet/iron = 5)
	time = 20

/datum/crafting_recipe/rip/crossexecution
	name = "Legion Cross"
	result = /obj/structure/cross
	time = 15
	reqs = list(/obj/item/stack/sheet/mineral/wood = 10)

/datum/crafting_recipe/rip/gallows
	name = "Gallows"
	result = /obj/structure/gallow
	time = 15
	reqs = list(/obj/item/stack/sheet/mineral/wood = 10)

/datum/crafting_recipe/rip/guillotine
	name = "Guillotine"
	result = /obj/structure/guillotine
	time = 150 // Building a functioning guillotine takes time
	reqs = list(/obj/item/stack/sheet/plasteel = 3,
				/obj/item/stack/sheet/mineral/wood = 20,
				/obj/item/stack/cable_coil = 10)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WRENCH, TOOL_WELDER)

/datum/crafting_recipe/rip/femur_breaker
	name = "Femur Breaker"
	result = /obj/structure/femur_breaker
	time = 150
	reqs = list(/obj/item/stack/sheet/iron = 20,
				/obj/item/stack/cable_coil = 30)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WRENCH, TOOL_WELDER)


/datum/crafting_recipe/shutters/old
	name = "Shutters"
	reqs = list(/obj/item/stack/sheet/prewar = 10, //Changed to use more readily available Pre-War Alloys for CB. Maybe we'll see more use out of them this way.
				/obj/item/stack/cable_coil = 10,
				/obj/item/electronics/airlock = 1
				)
	result = /obj/machinery/door/poddoor/shutters/old/preopen
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WIRECUTTER, TOOL_WELDER)
	time = 15 SECONDS
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/blast_doors
	name = "Blast Door"
	reqs = list(/obj/item/stack/sheet/prewar = 20, //Again, changed to use more readily available materials.
				/obj/item/stack/cable_coil = 15,
				/obj/item/electronics/airlock = 1
				)
	result = /obj/machinery/door/poddoor/preopen
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WIRECUTTER, TOOL_WELDER)
	time = 30 SECONDS
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/shutters/window
	name = "Windowed Shutters"
	reqs = list(/obj/item/stack/sheet/prewar = 5,
				/obj/item/stack/sheet/rglass = 10,
				/obj/item/stack/cable_coil = 10,
				/obj/item/electronics/airlock = 1
				)
	result = /obj/machinery/door/poddoor/shutters/window/preopen
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WIRECUTTER, TOOL_WELDER)
	time = 15 SECONDS
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

///////////////////
//Various Things//
///////////////////

/datum/crafting_recipe/papersack
	name = "Paper Sack"
	result = /obj/item/storage/box/papersack
	time = 10
	reqs = list(/obj/item/paper = 5)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/smallcarton
	name = "Small Carton"
	result = /obj/item/food/drinks/sillycup/smallcarton
	time = 10
	reqs = list(/obj/item/stack/sheet/cardboard = 1)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/picket_sign
	name = "Picket Sign"
	result = /obj/item/picket_sign
	reqs = list(/obj/item/stack/rods = 1,
				/obj/item/stack/sheet/cardboard = 2)
	time = 80
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/wheelchair
	name = "Wheelchair"
	result = /obj/vehicle/ridden/wheelchair
	reqs = list(/obj/item/stack/sheet/plasteel = 2,
				/obj/item/stack/rods = 8)
	time = 100
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/blackcarpet
	name = "Black Carpet"
	reqs = list(/obj/item/stack/tile/carpet = 50, /obj/item/toy/crayon/black = 1)
	result = /obj/item/stack/tile/carpet/black/fifty
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/paperframes
	name = "Paper Frames"
	result = /obj/item/stack/sheet/paperframes/five
	time = 10
	reqs = list(/obj/item/stack/sheet/mineral/wood = 5, /obj/item/paper = 20)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/naturalpaper
	name = "Hand-Pressed Paper"
	time = 30
	reqs = list(/datum/reagent/water = 50, /datum/reagent/ash = 20, /obj/item/stack/sheet/mineral/wood = 1)
	result = /obj/item/paper_bin/bundlenatural
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC


/datum/crafting_recipe/electrochromatic_kit
	name = "Electrochromatic Kit"
	result = /obj/item/electronics/electrochromatic_kit
	reqs = list(/obj/item/stack/sheet/iron = 1,
				/obj/item/stack/cable_coil = 1)
	time = 5
	subcategory = CAT_TOOL
	category = CAT_MISC
	always_available = FALSE

/datum/crafting_recipe/plunger
	name = "Plunger"
	result = /obj/item/plunger
	time = 1
	reqs = list(/obj/item/stack/sheet/plastic = 1,
				/obj/item/stack/sheet/mineral/wood = 1)
	category = CAT_MISC
	subcategory = CAT_TOOL

/datum/crafting_recipe/shock_collar
	name = "Shock Collar"
	result = /obj/item/electropack/shockcollar
	reqs = list(/obj/item/stock_parts/capacitor = 1,
				/obj/item/stack/cable_coil = 1,
				/obj/item/stack/sheet/leather = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER,TOOL_WORKBENCH)
	time = 30
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/rolling_paper
	name = "Rolling Paper"
	result = /obj/item/rollingpaper
	reqs = list(/obj/item/paper/natural = 1)
	time = 10
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/rolling_paper_bulk
	name = "Rolling Paper (Bulk)"
	result = /obj/item/storage/fancy/rollingpapers/makeshift
	reqs = list(/obj/item/paper/natural = 10,
				/obj/item/stack/sheet/cardboard = 1)
	time = 80
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/well
	name = "Water Well"
	result = /obj/structure/sink/well
	reqs = list(/obj/item/stack/sheet/iron = 20, /obj/item/stack/sheet/mineral/wood = 20, /obj/item/stack/sheet/mineral/sandstone = 5, /obj/item/weaponcrafting/string = 5, /obj/item/reagent_containers/cup/bucket =1)
	tool_behaviors = list(TOOL_SHOVEL)
	time = 100
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/skyfort_girder
	name = "Aerial Support Girder"
	result = /obj/item/stack/rods/scaffold
	reqs = list(
		/obj/item/stack/sheet/iron = 5,
		/obj/item/stack/sheet/plastic = 1,
		/obj/item/stack/sheet/prewar = 5,
		/obj/item/stack/sheet/bronze = 1
		)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 10
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/skyfort_girder_ten
	name = "Aerial Support Girder (x10)"
	result = /obj/item/stack/rods/scaffold/ten
	reqs = list(
		/obj/item/stack/sheet/iron = 50,
		/obj/item/stack/sheet/plastic = 10,
		/obj/item/stack/sheet/prewar = 50,
		/obj/item/stack/sheet/bronze = 10
		)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 20
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/portaturret
	name = "portable sentry turret"
	result = /obj/item/turret_box
	reqs = list(/obj/item/stack/sheet/iron = 20,
			/obj/item/stack/crafting/metalparts = 5,
			/obj/item/stack/crafting/goodparts = 3,
			/obj/item/stack/crafting/electronicparts = 10,
			/obj/item/stack/ore/blackpowder = 2,
			/obj/item/assembly/prox_sensor = 2,
			/obj/item/stack/cable_coil = 20,
			/obj/item/gun/ballistic/automatic/sportcarbine = 1
	)
	time = 5 SECONDS
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/portaturret_nogun // todo: make a var on the box whether or not it was made with a gun
	name = "portable sentry turret (from scrap)"
	result = /obj/item/turret_box
	reqs = list(/obj/item/stack/sheet/iron = 25,
			/obj/item/stack/crafting/metalparts = 8,
			/obj/item/stack/crafting/goodparts = 4,
			/obj/item/stack/crafting/electronicparts = 10,
			/obj/item/assembly/prox_sensor = 2,
			/obj/item/stack/cable_coil = 20
	)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 5 SECONDS
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/scrap_pa
	name = "Powered Scrap Suit"
	result = /obj/item/clothing/suit/armor/power_armor/t45b/raider
	reqs = list(/obj/item/stack/crafting/goodparts = 2,
				/obj/item/stack/crafting/metalparts = 5,
				/obj/item/stack/crafting/electronicparts = 5,
				/obj/item/stock_parts/manipulator/pico = 1,
				/obj/item/advanced_crafting_components/conductors = 1,
				/obj/item/stock_parts/cell/ammo/mfc = 1,
				/obj/item/stack/cable_coil = 30,
				/obj/item/stack/sheet/iron = 35,
				/obj/item/stack/sheet/bronze = 25)
	time = 35
	category = CAT_CRAFTING
	subcategory = CAT_SCAVENGING
	always_available = FALSE

/datum/crafting_recipe/scrap_pa_helm
	name = "Powered Scrap Suit Helmet"
	result = /obj/item/clothing/head/helmet/f13/power_armor/t45b/raider
	reqs = list(/obj/item/stack/crafting/goodparts = 1,
				/obj/item/stack/crafting/electronicparts = 2,
				/obj/item/stock_parts/manipulator/pico = 1,
				/obj/item/stack/cable_coil = 5,
				/obj/item/stack/sheet/iron = 15,
				/obj/item/stack/sheet/bronze = 5)
	time = 25
	category = CAT_CRAFTING
	subcategory = CAT_SCAVENGING
	always_available = FALSE

/datum/crafting_recipe/repair_t45
	name = "Refurbished T-45b Power Armor"
	result = /obj/item/clothing/suit/armor/power_armor/t45b
	reqs = list(/obj/item/clothing/suit/armor/heavy/salvaged_pa/t45b = 1,
				/obj/item/stack/cable_coil = 5,
				/obj/item/stack/crafting/electronicparts = 5,
				/obj/item/stock_parts/manipulator/pico = 1,
				/obj/item/stock_parts/cell/ammo/mfc = 1)
	time = 35
	category = CAT_CRAFTING
	subcategory = CAT_SCAVENGING
	always_available = FALSE

/datum/crafting_recipe/repair_t45_helm
	name = "Refurbished T-45b Power Armor Helmet"
	result = /obj/item/clothing/head/helmet/f13/power_armor/t45b
	reqs = list(/obj/item/clothing/head/helmet/f13/heavy/salvaged_pa/t45b = 1,
				/obj/item/stack/cable_coil = 5,
				/obj/item/stack/crafting/electronicparts = 2)
	time = 25
	category = CAT_CRAFTING
	subcategory = CAT_SCAVENGING
	always_available = FALSE
////////////////////////////////////
///////Faction Crafting/////////////
////////////////////////////////////

////////////////////////////////////
//////////////BOS///////////////////
////////////////////////////////////

/datum/crafting_recipe/bos_t45helm_convert
	name = "Converted T-45b Power Armor Helmet"
	result = /obj/item/clothing/head/helmet/f13/power_armor/t45d/bos
	reqs = list(/obj/item/clothing/head/helmet/f13/power_armor/t45d = 1,
				/obj/item/stack/cable_coil = 30,
				/obj/item/stack/crafting/electronicparts = 35,
				/obj/item/stack/sheet/iron = 40,
				/obj/item/stack/crafting/goodparts = 15,
				/obj/item/stack/crafting/metalparts = 30)
	time = 30
	category = CAT_CRAFTING
	subcategory = CAT_CONVERT
	always_available = FALSE

/datum/crafting_recipe/bos_t45_convert
	name = "Converted T-45b Power Armor"
	result = /obj/item/clothing/suit/armor/power_armor/t45d/bos
	reqs = list(/obj/item/clothing/suit/armor/power_armor/t45d = 1,
				/obj/item/stack/cable_coil = 30,
				/obj/item/stack/crafting/electronicparts = 35,
				/obj/item/stack/sheet/iron = 40,
				/obj/item/stack/crafting/goodparts = 15,
				/obj/item/stack/crafting/metalparts = 30)
	time = 30
	category = CAT_CRAFTING
	subcategory = CAT_CONVERT
	always_available = FALSE

/datum/crafting_recipe/bos_st45helm_convert
	name = "Converted Salvaged T-45b Power Armor Helmet"
	result = /obj/item/clothing/head/helmet/f13/power_armor/t45d/bos
	reqs = list(/obj/item/clothing/head/helmet/f13/heavy/salvaged_pa/t45b = 1,
				/obj/item/stack/cable_coil = 15,
				/obj/item/stack/crafting/electronicparts = 30,
				/obj/item/stack/sheet/iron = 20,
				/obj/item/stack/sheet/mineral/titanium = 15,
				/obj/item/stack/crafting/goodparts = 5,
				/obj/item/stack/crafting/metalparts = 20)
	time = 30
	category = CAT_CRAFTING
	subcategory = CAT_CONVERT
	always_available = FALSE

/datum/crafting_recipe/bos_st45_convert
	name = "Converted Salvaged T-45b Power Armor"
	result = /obj/item/clothing/suit/armor/heavy/salvaged_pa/t45b/bos
	reqs = list(/obj/item/clothing/suit/armor/heavy/salvaged_pa/t45b = 1,
				/obj/item/stack/cable_coil = 15,
				/obj/item/stack/crafting/electronicparts = 30,
				/obj/item/stack/sheet/iron = 20,
				/obj/item/stack/sheet/mineral/titanium = 15,
				/obj/item/stack/crafting/goodparts = 5,
				/obj/item/stack/crafting/metalparts = 20)
	time = 30
	category = CAT_CRAFTING
	subcategory = CAT_CONVERT
	always_available = FALSE

/datum/crafting_recipe/bos_t51_convert
	name = "Converted T-51b Power Armor"
	result = /obj/item/clothing/suit/armor/power_armor/t51b/bos
	reqs = list(/obj/item/clothing/suit/armor/power_armor/t51b = 1,
				/obj/item/stack/cable_coil = 30,
				/obj/item/stack/crafting/electronicparts = 35,
				/obj/item/stack/sheet/iron = 40,
				/obj/item/stack/sheet/mineral/titanium = 20,
				/obj/item/stack/crafting/goodparts = 10,
				/obj/item/stack/crafting/metalparts = 30)
	time = 30
	category = CAT_CRAFTING
	subcategory = CAT_CONVERT
	always_available = FALSE

/datum/crafting_recipe/bos_t51helm_convert
	name = "Converted T-51b Power Armor"
	result = /obj/item/clothing/head/helmet/f13/power_armor/t51b/bos
	reqs = list(/obj/item/clothing/head/helmet/f13/power_armor/t51b = 1,
				/obj/item/stack/cable_coil = 30,
				/obj/item/stack/crafting/electronicparts = 35,
				/obj/item/stack/sheet/iron = 40,
				/obj/item/stack/sheet/mineral/titanium = 20,
				/obj/item/stack/crafting/goodparts = 10,
				/obj/item/stack/crafting/metalparts = 30)
	time = 30
	category = CAT_CRAFTING
	subcategory = CAT_CONVERT
	always_available = FALSE

/datum/crafting_recipe/bos_ca_convert
	name = "Converted Combat Armor"
	result = /obj/item/clothing/suit/armor/medium/combat/brotherhood
	reqs = list(/obj/item/clothing/suit/armor/medium/combat = 1,
				/obj/item/stack/sheet/iron = 20,
				/obj/item/stack/crafting/metalparts = 10)
	time = 30
	category = CAT_CRAFTING
	subcategory = CAT_CONVERT
	always_available = FALSE

/datum/crafting_recipe/bos_ca_helm_convert
	name = "Converted Combat Armor Helmet"
	result = /obj/item/clothing/head/helmet/f13/combat/brotherhood
	reqs = list(/obj/item/clothing/head/helmet/f13/combat = 1,
				/obj/item/stack/sheet/iron = 20,
				/obj/item/stack/crafting/metalparts = 10)
	time = 30
	category = CAT_CRAFTING
	subcategory = CAT_CONVERT
	always_available = FALSE

/datum/crafting_recipe/bos_rca_convert
	name = "Converted Combat Armor"
	result = /obj/item/clothing/suit/armor/medium/combat/brotherhood/initiate/mk2
	reqs = list(/obj/item/clothing/suit/armor/medium/combat = 1,
				/obj/item/stack/sheet/iron = 20,
				/obj/item/stack/crafting/goodparts = 5,
				/obj/item/stack/crafting/metalparts = 10)
	time = 30
	category = CAT_CRAFTING
	subcategory = CAT_CONVERT
	always_available = FALSE

/datum/crafting_recipe/bos_rca_helm_convert
	name = "Converted Combat Armor Helmet"
	result = /obj/item/clothing/head/helmet/f13/combat/brotherhood/initiate/mk2
	reqs = list(/obj/item/clothing/suit/armor/medium/combat/mk2 = 1,
				/obj/item/stack/sheet/iron = 30,
				/obj/item/stack/crafting/goodparts = 5,
				/obj/item/stack/crafting/metalparts = 10)
	time = 30
	category = CAT_CRAFTING
	subcategory = CAT_CONVERT
	always_available = FALSE

/datum/crafting_recipe/bos_riot_convert
	name = "Converted Broken Riot Armor"
	result = /obj/item/clothing/suit/armor/heavy/riot/bos
	reqs = list(/obj/item/clothing/suit/armor/heavy/riot/combat = 1,
				/obj/item/stack/sheet/iron = 40,
				/obj/item/stack/crafting/goodparts = 10,
				/obj/item/stack/crafting/metalparts = 20)
	time = 30
	category = CAT_CRAFTING
	subcategory = CAT_CONVERT
	always_available = FALSE

/datum/crafting_recipe/bos_riot_helm_convert
	name = "Converted Broken Riot Helmet"
	result = /obj/item/clothing/head/helmet/f13/combat/rangerbroken/bos
	reqs = list(/obj/item/clothing/head/helmet/f13/combat/rangerbroken = 1,
				/obj/item/stack/sheet/iron = 40,
				/obj/item/stack/crafting/goodparts = 10,
				/obj/item/stack/crafting/metalparts = 20)
	time = 30
	category = CAT_CRAFTING
	subcategory = CAT_CONVERT
	always_available = FALSE

////////////////////////////////////
//////////////Enclave///////////////
////////////////////////////////////

/datum/crafting_recipe/enclave_t45helm_convert
	name = "Converted T-45b Power Armor Helmet"
	result = /obj/item/clothing/head/helmet/f13/power_armor/t45d/enclave
	reqs = list(/obj/item/clothing/head/helmet/f13/power_armor/t45d = 1,
				/obj/item/stack/cable_coil = 30,
				/obj/item/stack/crafting/electronicparts = 35,
				/obj/item/stack/sheet/iron = 40,
				/obj/item/stack/crafting/goodparts = 15,
				/obj/item/stack/crafting/metalparts = 30)
	time = 30
	category = CAT_CRAFTING
	subcategory = CAT_CONVERT
	always_available = FALSE

/datum/crafting_recipe/enclave_t45_convert
	name = "Converted T-45b Power Armor"
	result = /obj/item/clothing/suit/armor/power_armor/t45d/enclave
	reqs = list(/obj/item/clothing/suit/armor/power_armor/t45d = 1,
				/obj/item/stack/cable_coil = 30,
				/obj/item/stack/crafting/electronicparts = 35,
				/obj/item/stack/sheet/iron = 40,
				/obj/item/stack/crafting/goodparts = 15,
				/obj/item/stack/crafting/metalparts = 30)
	time = 30
	category = CAT_CRAFTING
	subcategory = CAT_CONVERT
	always_available = FALSE

/datum/crafting_recipe/enclave_st45helm_convert
	name = "Converted Salvaged T-45b Power Armor Helmet"
	result = /obj/item/clothing/suit/armor/heavy/salvaged_pa/t45b/enclave
	reqs = list(/obj/item/clothing/head/helmet/f13/heavy/salvaged_pa/t45b = 1,
				/obj/item/stack/cable_coil = 15,
				/obj/item/stack/crafting/electronicparts = 30,
				/obj/item/stack/sheet/iron = 20,
				/obj/item/stack/sheet/mineral/titanium = 15,
				/obj/item/stack/crafting/goodparts = 5,
				/obj/item/stack/crafting/metalparts = 20)
	time = 30
	category = CAT_CRAFTING
	subcategory = CAT_CONVERT
	always_available = FALSE

/datum/crafting_recipe/enclave_st45_convert
	name = "Converted Salvaged T-45b Power Armor"
	result = /obj/item/clothing/head/helmet/f13/heavy/salvaged_pa/t45b/enclave
	reqs = list(/obj/item/clothing/head/helmet/f13/heavy/salvaged_pa/t45b = 1,
				/obj/item/stack/cable_coil = 15,
				/obj/item/stack/crafting/electronicparts = 30,
				/obj/item/stack/sheet/iron = 20,
				/obj/item/stack/sheet/mineral/titanium = 15,
				/obj/item/stack/crafting/goodparts = 5,
				/obj/item/stack/crafting/metalparts = 20)
	time = 30
	category = CAT_CRAFTING
	subcategory = CAT_CONVERT
	always_available = FALSE

/datum/crafting_recipe/enclave_t51_convert
	name = "Converted T-51b Power Armor"
	result = /obj/item/clothing/suit/armor/power_armor/t51b/enclave
	reqs = list(/obj/item/clothing/suit/armor/power_armor/t51b = 1,
				/obj/item/stack/cable_coil = 30,
				/obj/item/stack/crafting/electronicparts = 35,
				/obj/item/stack/sheet/iron = 40,
				/obj/item/stack/sheet/mineral/titanium = 20,
				/obj/item/stack/crafting/goodparts = 10,
				/obj/item/stack/crafting/metalparts = 30)
	time = 30
	category = CAT_CRAFTING
	subcategory = CAT_CONVERT
	always_available = FALSE

/datum/crafting_recipe/enclave_t51helm_convert
	name = "Converted T-51b Power Armor"
	result = /obj/item/clothing/head/helmet/f13/power_armor/t51b/enclave
	reqs = list(/obj/item/clothing/head/helmet/f13/power_armor/t51b = 1,
				/obj/item/stack/cable_coil = 30,
				/obj/item/stack/crafting/electronicparts = 35,
				/obj/item/stack/sheet/iron = 40,
				/obj/item/stack/sheet/mineral/titanium = 20,
				/obj/item/stack/crafting/goodparts = 10,
				/obj/item/stack/crafting/metalparts = 30)
	time = 30
	category = CAT_CRAFTING
	subcategory = CAT_CONVERT
	always_available = FALSE

/datum/crafting_recipe/enclave_ca_convert
	name = "Converted Combat Armor"
	result = /obj/item/clothing/suit/armor/medium/vest/enclave
	reqs = list(/obj/item/clothing/suit/armor/medium/combat = 1,
				/obj/item/stack/sheet/iron = 20,
				/obj/item/stack/crafting/metalparts = 10)
	time = 30
	category = CAT_CRAFTING
	subcategory = CAT_CONVERT
	always_available = FALSE

/datum/crafting_recipe/enclave_ca_helm_convert
	name = "Converted Combat Armor Helmet"
	result = /obj/item/clothing/head/helmet/f13/combat/swat
	reqs = list(/obj/item/clothing/head/helmet/f13/combat = 1,
				/obj/item/stack/sheet/iron = 20,
				/obj/item/stack/crafting/metalparts = 10)
	time = 30
	category = CAT_CRAFTING
	subcategory = CAT_CONVERT
	always_available = FALSE

/*
/datum/crafting_recipe/enclave_rca_convert
	name = "Converted Combat Armor"
	result = /obj/item/clothing/suit/armor/medium/combat/brotherhood/initiate/mk2
	reqs = list(/obj/item/clothing/suit/armor/medium/combat = 1,
				/obj/item/stack/sheet/iron = 20,
				/obj/item/stack/crafting/goodparts = 5,
				/obj/item/stack/crafting/metalparts = 10)
	time = 30
	category = CAT_CRAFTING
	subcategory = CAT_CONVERT
	always_available = FALSE

/datum/crafting_recipe/enclave_rca_helm_convert
	name = "Converted Combat Armor Helmet"
	result = /obj/item/clothing/head/helmet/f13/combat/brotherhood/initiate/mk2
	reqs = list(/obj/item/clothing/suit/armor/medium/combat/mk2 = 1,
				/obj/item/stack/sheet/iron = 30,
				/obj/item/stack/crafting/goodparts = 5,
				/obj/item/stack/crafting/metalparts = 10)
	time = 30
	category = CAT_CRAFTING
	subcategory = CAT_CONVERT
	always_available = FALSE
*/

/datum/crafting_recipe/enclave_riot_convert
	name = "Converted Broken Riot Armor"
	result = /obj/item/clothing/suit/armor/heavy/riot/enclave
	reqs = list(/obj/item/clothing/suit/armor/heavy/riot/combat = 1,
				/obj/item/stack/sheet/iron = 40,
				/obj/item/stack/crafting/goodparts = 10,
				/obj/item/stack/crafting/metalparts = 20)
	time = 30
	category = CAT_CRAFTING
	subcategory = CAT_CONVERT
	always_available = FALSE

/datum/crafting_recipe/enclave_riot_helm_convert
	name = "Converted Broken Riot Helmet"
	result = /obj/item/clothing/head/helmet/f13/combat/rangerbroken/enclave
	reqs = list(/obj/item/clothing/head/helmet/f13/combat/rangerbroken = 1,
				/obj/item/stack/sheet/iron = 40,
				/obj/item/stack/crafting/goodparts = 10,
				/obj/item/stack/crafting/metalparts = 20)
	time = 30
	category = CAT_CRAFTING
	subcategory = CAT_CONVERT
	always_available = FALSE

////////////////////////////////////
///////////Minutemen////////////////
////////////////////////////////////

////////////////////////////////////
/////////////Raider/////////////////
////////////////////////////////////

////////////////////////////////////
/////////////Tribal/////////////////
////////////////////////////////////

////////////////////////////////////
//////////Super Mutant//////////////
////////////////////////////////////
