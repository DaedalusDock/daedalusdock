
/// The Starfury map template itself.
/datum/map_template/battlecruiser_starfury
	name = "SBC Starfury"
	mappath = "_maps/templates/battlecruiser_starfury.dmm"

// Stationary docking ports for the Starfury's strike shuttles.
/obj/docking_port/stationary/starfury_corvette
	name = "SBC Starfury Corvette Bay"
	id = "SBC_corvette_bay"
	roundstart_template = /datum/map_template/shuttle/starfury/corvette
	hidden = TRUE
	width = 14
	height = 7
	dwidth = 7
	dir = NORTH

/obj/docking_port/stationary/starfury_fighter
	name = "SBC Starfury Fighter Bay"
	id = "SBC_fighter_bay"
	hidden = TRUE
	width = 5
	height = 7
	dwidth = 2
	dir = NORTH

/obj/docking_port/stationary/starfury_fighter/fighter_one
	name = "SBC Starfury Port Fighter Bay"
	id = "SBC_fighter1_bay"
	roundstart_template = /datum/map_template/shuttle/starfury/fighter_one

/obj/docking_port/stationary/starfury_fighter/fighter_two
	name = "SBC Starfury Center Fighter Bay"
	id = "SBC_fighter2_bay"
	roundstart_template = /datum/map_template/shuttle/starfury/fighter_two

/obj/docking_port/stationary/starfury_fighter/fighter_three
	name = "SBC Starfury Starboard Fighter Bay"
	id = "SBC_fighter3_bay"
	roundstart_template = /datum/map_template/shuttle/starfury/fighter_three

// Mobile docking ports for the Starfury's strike shuttles.
/obj/docking_port/mobile/syndicate_fighter
	name = "syndicate fighter"
	id = "syndicate_fighter"
	movement_force = list("KNOCKDOWN" = 0, "THROW" = 0)
	hidden = TRUE
	dir = NORTH
	port_direction = SOUTH
	width = 5
	height = 7
	dwidth = 2

/obj/docking_port/mobile/syndicate_fighter/fighter_one
	name = "syndicate fighter one"
	id = "SBC_fighter1"

/obj/docking_port/mobile/syndicate_fighter/fighter_two
	name = "syndicate fighter two"
	id = "SBC_fighter2"

/obj/docking_port/mobile/syndicate_fighter/fighter_three
	name = "syndicate fighter three"
	id = "SBC_fighter3"

/obj/docking_port/mobile/syndicate_corvette
	name = "syndicate corvette"
	id = "SBC_corvette"
	movement_force = list("KNOCKDOWN" = 0, "THROW" = 0)
	hidden = TRUE
	dir = NORTH
	port_direction = SOUTH
	preferred_direction = WEST
	width = 14
	dwidth = 6
	height = 7

/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate/fighter
	name = "syndicate fighter navigation computer"
	desc = "Used to pilot syndicate fighters to commence precision strikes."
	x_offset = 0
	y_offset = 3

/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate/fighter/fighter_one
	shuttleId = "SBC_fighter1"
	shuttlePortId = "SBC_fighter1_custom"
	jump_to_ports = list("syndicate_ne" = 1, "syndicate_nw" = 1, "syndicate_n" = 1, "syndicate_se" = 1, "syndicate_sw" = 1, "syndicate_s" = 1, "SBC_fighter1_bay" = 1)
	req_access = list(ACCESS_SYNDICATE)

/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate/fighter/fighter_two
	shuttleId = "SBC_fighter2"
	shuttlePortId = "SBC_fighter2_custom"
	jump_to_ports = list("syndicate_ne" = 1, "syndicate_nw" = 1, "syndicate_n" = 1, "syndicate_se" = 1, "syndicate_sw" = 1, "syndicate_s" = 1, "SBC_fighter2_bay" = 1)
	req_access = list(ACCESS_SYNDICATE)

/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate/fighter/fighter_three
	shuttleId = "SBC_fighter3"
	shuttlePortId = "SBC_fighter3_custom"
	jump_to_ports = list("syndicate_ne" = 1, "syndicate_nw" = 1, "syndicate_n" = 1, "syndicate_se" = 1, "syndicate_sw" = 1, "syndicate_s" = 1, "SBC_fighter3_bay" = 1)
	req_access = list(ACCESS_SYNDICATE)

/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate/corvette
	name = "syndicate corvette navigation computer"
	desc = "Used to pilot the syndicate corvette to board enemy stations and ships."
	shuttleId = "SBC_corvette"
	shuttlePortId = "SBC_corvette_custom"
	jump_to_ports = list("syndicate_ne" = 1, "syndicate_nw" = 1, "syndicate_n" = 1, "syndicate_se" = 1, "syndicate_sw" = 1, "syndicate_s" = 1, "SBC_corvette_bay" = 1)
	y_offset = 3
	x_offset = 0

/obj/machinery/computer/shuttle/starfury/fighter
	name = "syndicate fighter control console"
	desc = "A control computer which controls a shuttle which operates from the SBC Starfury.."
	req_access = list(ACCESS_SYNDICATE)

/obj/machinery/computer/shuttle/starfury/fighter/fighter_one
	shuttleId = "SBC_fighter1"
	possible_destinations = "SBC_fighter1_custom;SBC_fighter1_bay;SBC_fighter2_bay;SBC_fighter3_bay;syndicate_ne;syndicate_nw;syndicate_n;syndicate_se;syndicate_sw;syndicate_s"
	req_access = list(ACCESS_SYNDICATE)

/obj/machinery/computer/shuttle/starfury/fighter/fighter_two
	shuttleId = "SBC_fighter2"
	possible_destinations = "SBC_fighter2_custom;SBC_fighter1_bay;SBC_fighter2_bay;SBC_fighter3_bay;syndicate_ne;syndicate_nw;syndicate_n;syndicate_se;syndicate_sw;syndicate_s"
	req_access = list(ACCESS_SYNDICATE)

/obj/machinery/computer/shuttle/starfury/fighter/fighter_three
	shuttleId = "SBC_fighter3"
	possible_destinations = "SBC_fighter3_custom;SBC_fighter1_bay;SBC_fighter2_bay;SBC_fighter3_bay;syndicate_ne;syndicate_nw;syndicate_n;syndicate_se;syndicate_sw;syndicate_s"
	req_access = list(ACCESS_SYNDICATE)

/obj/machinery/computer/shuttle/starfury/corvette
	name = "syndicate corvette control console"
	desc = "A control computer which controls a shuttle which operates from the SBC Starfury.."
	shuttleId = "SBC_corvette"
	possible_destinations = "SBC_corvette_custom;SBC_corvette_bay;syndicate_ne;syndicate_nw;syndicate_n;syndicate_se;syndicate_sw;syndicate_s"
	req_access = list(ACCESS_SYNDICATE)

/obj/machinery/vending/medical/syndicate_access/cybersun
	name = "\improper CyberMed ++"
	desc = "An advanced vendor that dispenses medical drugs, both recreational and medicinal."
	products = list(/obj/item/reagent_containers/syringe = 4,
					/obj/item/healthanalyzer = 4,
					/obj/item/reagent_containers/glass/bottle/bicaridine = 2,
					/obj/item/reagent_containers/glass/bottle/kelotane = 5,
					/obj/item/reagent_containers/glass/bottle/dylovene = 1,
					/obj/item/reagent_containers/glass/bottle/epinephrine = 3,
					/obj/item/reagent_containers/glass/bottle/morphine = 3,
					/obj/item/reagent_containers/glass/bottle/potass_iodide = 1,
					/obj/item/reagent_containers/glass/bottle/saline_glucose = 3,
					/obj/item/reagent_containers/syringe/antiviral = 5,
			)
	contraband = list(/obj/item/reagent_containers/glass/bottle/cold = 2,
					/obj/item/restraints/handcuffs = 4,
					/obj/item/storage/backpack/duffelbag/syndie/surgery = 1,
					/obj/item/storage/medkit/tactical = 1)
	premium = list(/obj/item/storage/pill_bottle/ryetalyn = 2,
					/obj/item/reagent_containers/hypospray/medipen = 3,
					/obj/item/reagent_containers/hypospray/medipen/atropine = 2,
					/obj/item/storage/medkit/regular = 3,
					/obj/item/storage/medkit/brute = 1,
					/obj/item/storage/medkit/fire = 1,
					/obj/item/storage/medkit/toxin = 1,
					/obj/item/storage/medkit/o2 = 1,
					/obj/item/storage/medkit/advanced = 1,
					/obj/item/defibrillator/loaded = 1,
					/obj/item/wallframe/defib_mount = 1,
					/obj/item/sensor_device = 2,
					/obj/item/pinpointer/crew = 2,
					/obj/item/shears = 1)
