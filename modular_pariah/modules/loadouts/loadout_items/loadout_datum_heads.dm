// --- Loadout item datums for heads ---

/// Head Slot Items (Moves overrided items to backpack)
GLOBAL_LIST_INIT(loadout_helmets, generate_loadout_items(/datum/loadout_item/head))

/datum/loadout_item/head
	category = LOADOUT_ITEM_HEAD

/datum/loadout_item/head/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(isplasmaman(equipper))
		if(!visuals_only)
			to_chat(equipper, "Your loadout helmet was not equipped directly due to your envirosuit helmet.")
			LAZYADD(outfit.backpack_contents, item_path)
	else if(override_items == LOADOUT_OVERRIDE_BACKPACK && !visuals_only)
		if(outfit.head)
			LAZYADD(outfit.backpack_contents, outfit.head)
		outfit.head = item_path
	else
		outfit.head = item_path


/datum/loadout_item/head/black_beanie
	name = "Black Beanie"
	item_path = /obj/item/clothing/head/beanie/black

/datum/loadout_item/head/christmas_beanie
	name = "Christmas Beanie"
	item_path = /obj/item/clothing/head/beanie/christmas

/datum/loadout_item/head/cyan_beanie
	name = "Cyan Beanie"
	item_path = /obj/item/clothing/head/beanie/cyan

/datum/loadout_item/head/dark_blue_beanie
	name = "Dark Blue Beanie"
	item_path = /obj/item/clothing/head/beanie/darkblue

/datum/loadout_item/head/green_beanie
	name = "Green Beanie"
	item_path = /obj/item/clothing/head/beanie/green

/datum/loadout_item/head/orange_beanie
	name = "Orange Beanie"
	item_path = /obj/item/clothing/head/beanie/orange

/datum/loadout_item/head/purple_beanie
	name = "Purple Beanie"
	item_path = /obj/item/clothing/head/beanie/purple

/datum/loadout_item/head/red_beanie
	name = "Red Beanie"
	item_path = /obj/item/clothing/head/beanie/red

/datum/loadout_item/head/striped_beanie
	name = "Striped Beanie"
	item_path = /obj/item/clothing/head/beanie/striped

/datum/loadout_item/head/striped_red_beanie
	name = "Striped Red Beanie"
	item_path = /obj/item/clothing/head/beanie/stripedred

/datum/loadout_item/head/striped_blue_beanie
	name = "Striped Blue Beanie"
	item_path = /obj/item/clothing/head/beanie/stripedblue

/datum/loadout_item/head/striped_green_beanie
	name = "Striped Green Beanie"
	item_path = /obj/item/clothing/head/beanie/stripedgreen

/datum/loadout_item/head/white_beanie
	name = "White Beanie"
	item_path = /obj/item/clothing/head/beanie

/datum/loadout_item/head/yellow_beanie
	name = "Yellow Beanie"
	item_path = /obj/item/clothing/head/beanie/yellow

/datum/loadout_item/head/greyscale_beret
	name = "Greyscale Beret"
	item_path = /obj/item/clothing/head/beret

/datum/loadout_item/head/black_beret
	name = "Black Beret"
	item_path = /obj/item/clothing/head/beret/black

/datum/loadout_item/head/black_cap
	name = "Black Cap"
	item_path = /obj/item/clothing/head/soft/black

/datum/loadout_item/head/blue_cap
	name = "Blue Cap"
	item_path = /obj/item/clothing/head/soft/blue

/datum/loadout_item/head/delinquent_cap
	name = "Delinquent Cap"
	item_path = /obj/item/clothing/head/delinquent

/datum/loadout_item/head/green_cap
	name = "Green Cap"
	item_path = /obj/item/clothing/head/soft/green

/datum/loadout_item/head/grey_cap
	name = "Grey Cap"
	item_path = /obj/item/clothing/head/soft/grey

/datum/loadout_item/head/orange_cap
	name = "Orange Cap"
	item_path = /obj/item/clothing/head/soft/orange

/datum/loadout_item/head/purple_cap
	name = "Purple Cap"
	item_path = /obj/item/clothing/head/soft/purple

/datum/loadout_item/head/rainbow_cap
	name = "Rainbow Cap"
	item_path = /obj/item/clothing/head/soft/rainbow

/datum/loadout_item/head/red_cap
	name = "Red Cap"
	item_path = /obj/item/clothing/head/soft/red

/datum/loadout_item/head/white_cap
	name = "White Cap"
	item_path = /obj/item/clothing/head/soft

/datum/loadout_item/head/yellow_cap
	name = "Yellow Cap"
	item_path = /obj/item/clothing/head/soft/yellow

/datum/loadout_item/head/flatcap
	name = "Flat Cap"
	item_path = /obj/item/clothing/head/flatcap

/datum/loadout_item/head/beige_fedora
	name = "Beige Fedora"
	item_path = /obj/item/clothing/head/fedora/beige

/datum/loadout_item/head/black_fedora
	name = "Black Fedora"
	item_path = /obj/item/clothing/head/fedora

/datum/loadout_item/head/white_fedora
	name = "White Fedora"
	item_path = /obj/item/clothing/head/fedora/white

/datum/loadout_item/head/dark_blue_hardhat
	name = "Dark Blue Hardhat"
	item_path = /obj/item/clothing/head/hardhat/dblue
	restricted_roles = list(JOB_CHIEF_ENGINEER, JOB_STATION_ENGINEER, JOB_ATMOSPHERIC_TECHNICIAN)

/datum/loadout_item/head/orange_hardhat
	name = "Orange Hardhat"
	item_path = /obj/item/clothing/head/hardhat/orange
	restricted_roles = list(JOB_CHIEF_ENGINEER, JOB_STATION_ENGINEER, JOB_ATMOSPHERIC_TECHNICIAN)

/datum/loadout_item/head/red_hardhat
	name = "Red Hardhat"
	item_path = /obj/item/clothing/head/hardhat/red
	restricted_roles = list(JOB_CHIEF_ENGINEER, JOB_STATION_ENGINEER, JOB_ATMOSPHERIC_TECHNICIAN)

/datum/loadout_item/head/white_hardhat
	name = "White Hardhat"
	item_path = /obj/item/clothing/head/hardhat/white
	restricted_roles = list(JOB_CHIEF_ENGINEER)

/datum/loadout_item/head/yellow_hardhat
	name = "Yellow Hardhat"
	item_path = /obj/item/clothing/head/hardhat
	restricted_roles = list(JOB_CHIEF_ENGINEER, JOB_STATION_ENGINEER, JOB_ATMOSPHERIC_TECHNICIAN)

/datum/loadout_item/head/bandana
	name = "Bandana"
	item_path = /obj/item/clothing/head/bandana

/datum/loadout_item/head/rastafarian
	name = "Rastafarian Cap"
	item_path = /obj/item/clothing/head/beanie/rasta

/datum/loadout_item/head/top_hat
	name = "Top Hat"
	item_path = /obj/item/clothing/head/that

/datum/loadout_item/head/bowler_hat
	name = "Bowler Hat"
	item_path = /obj/item/clothing/head/bowler

//MISC
/datum/loadout_item/head/baseball
	name = "Ballcap"
	item_path = /obj/item/clothing/head/soft/mime

/datum/loadout_item/head/beanie
	name = "Beanie"
	item_path = /obj/item/clothing/head/beanie

/datum/loadout_item/head/beret
	name = "Black beret"
	item_path = /obj/item/clothing/head/beret/black

/datum/loadout_item/head/pirate
	name = "Pirate hat"
	item_path = /obj/item/clothing/head/pirate

/datum/loadout_item/head/rice_hat
	name = "Rice hat"
	item_path = /obj/item/clothing/head/rice_hat

/datum/loadout_item/head/ushanka
	name = "Ushanka"
	item_path = /obj/item/clothing/head/ushanka

/datum/loadout_item/head/ushanka/soviet
	name = "Soviet Ushanka"
	item_path = /obj/item/clothing/head/ushanka/soviet

/datum/loadout_item/head/slime
	name = "Slime hat"
	item_path = /obj/item/clothing/head/collectable/slime

/datum/loadout_item/head/fedora
	name = "Fedora"
	item_path = /obj/item/clothing/head/fedora

/datum/loadout_item/head/that
	name = "Top Hat"
	item_path = /obj/item/clothing/head/that

//Job Locked Hats

/datum/loadout_item/head/nursehat
	name = "Nurse Hat"
	item_path = /obj/item/clothing/head/nursehat
	restricted_roles = list(JOB_MEDICAL_DOCTOR, JOB_CHIEF_MEDICAL_OFFICER, JOB_GENETICIST, JOB_CHEMIST, JOB_VIROLOGIST)

/datum/loadout_item/head/mailmanhat
	name = "Mailman's Hat"
	item_path = /obj/item/clothing/head/mailman
	restricted_roles = list(JOB_QUARTERMASTER, JOB_CARGO_TECHNICIAN)

// JOB - Berets
/datum/loadout_item/head/atmos_beret
	name = "Atmospherics Beret"
	item_path = /obj/item/clothing/head/beret/atmos
	restricted_roles = list(JOB_STATION_ENGINEER, JOB_ATMOSPHERIC_TECHNICIAN, JOB_CHIEF_ENGINEER)

/datum/loadout_item/head/engi_beret
	name = "Engineering Beret"
	item_path = /obj/item/clothing/head/beret/engi
	restricted_roles = list(JOB_STATION_ENGINEER, JOB_ATMOSPHERIC_TECHNICIAN, JOB_CHIEF_ENGINEER)
/datum/loadout_item/head/beret_med
	name = "Medical Beret"
	item_path = /obj/item/clothing/head/beret/medical
	restricted_roles = list(JOB_MEDICAL_DOCTOR,JOB_VIROLOGIST, JOB_CHEMIST, JOB_CHIEF_MEDICAL_OFFICER)

/datum/loadout_item/head/beret_sec
	name = "Security Beret"
	item_path = /obj/item/clothing/head/beret/sec
	restricted_roles = list(JOB_SECURITY_OFFICER, JOB_HEAD_OF_SECURITY, JOB_WARDEN)

/datum/loadout_item/head/navyblueofficerberet
	name = "Security Navy Blue Beret"
	item_path = /obj/item/clothing/head/beret/sec/navyofficer
	restricted_roles = list(JOB_SECURITY_OFFICER, JOB_HEAD_OF_SECURITY, JOB_WARDEN)

/datum/loadout_item/head/navybluewardenberet
	name = "Warden's Navy Blue beret"
	item_path = /obj/item/clothing/head/beret/sec/navywarden
	restricted_roles = list(JOB_WARDEN)

/datum/loadout_item/head/beret_paramedic
	name = "Paramedic Beret"
	item_path = /obj/item/clothing/head/beret/medical/paramedic
	restricted_roles = list(JOB_PARAMEDIC, JOB_CHIEF_MEDICAL_OFFICER)

/datum/loadout_item/head/beret_viro
	name = "Virologist Beret"
	item_path = /obj/item/clothing/head/beret/medical/virologist
	restricted_roles = list(JOB_VIROLOGIST, JOB_CHIEF_MEDICAL_OFFICER)

/datum/loadout_item/head/beret_chem
	name = "Chemist Beret"
	item_path = /obj/item/clothing/head/beret/medical/chemist
	restricted_roles = list(JOB_CHEMIST, JOB_CHIEF_MEDICAL_OFFICER)

/datum/loadout_item/head/beret_sci
	name = "Science Beret"
	item_path = /obj/item/clothing/head/beret/science
	restricted_roles = list(JOB_SCIENTIST, JOB_ROBOTICIST, JOB_GENETICIST, JOB_RESEARCH_DIRECTOR)

/datum/loadout_item/head/beret_robo
	name = "Robotics Beret"
	item_path = /obj/item/clothing/head/beret/science/fancy/robo
	restricted_roles = list(JOB_ROBOTICIST, JOB_RESEARCH_DIRECTOR)

/datum/loadout_item/head/poppy
	name = "Poppy Flower"
	item_path = /obj/item/food/grown/poppy

/datum/loadout_item/head/lily
	name = "Lily Flower"
	item_path = /obj/item/food/grown/poppy/lily

/datum/loadout_item/head/geranium
	name = "Geranium Flower"
	item_path = /obj/item/food/grown/poppy/geranium

/datum/loadout_item/head/fraxinella
	name = "Fraxinella Flower"
	item_path = /obj/item/food/grown/poppy/geranium/fraxinella

/datum/loadout_item/head/harebell
	name = "Harebell Flower"
	item_path = /obj/item/food/grown/harebell

/datum/loadout_item/head/rose
	name = "Rose Flower"
	item_path = /obj/item/food/grown/rose

/datum/loadout_item/head/carbon_rose
	name = "Carbon Rose Flower"
	item_path = /obj/item/grown/carbon_rose

/datum/loadout_item/head/sunflower
	name = "Sunflower"
	item_path = /obj/item/food/grown/sunflower

/datum/loadout_item/head/rainbow_bunch
	name = "Rainbow Bunch"
	item_path = /obj/item/food/grown/rainbow_flower
	additional_tooltip_contents = list(TOOLTIP_RANDOM_COLOR)
