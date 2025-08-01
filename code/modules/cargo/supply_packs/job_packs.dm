/datum/supply_pack/job_equipment
	group = "Occupation Equipment"

/datum/supply_pack/job_equipment/janitank
	name = "Hydropack"
	desc = "Call forth divine judgement upon dirt and grime with this high capacity janitor backpack. Contains 500 units of station-cleansing cleaner. Requires janitor access to open."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/watertank/janitor)
	crate_name = "hydropack crate"

/datum/supply_pack/job_equipment/forensics
	name = "Forensics Bundle"
	desc = "Stay hot on the criminal's heels with Mars' Detective Essentials(tm). Contains a crime scene kit, six evidence bags, camera, tape recorder, white crayon, and of course, a fedora. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 2.5
	access_view = ACCESS_FORENSICS
	contains = list(
		/obj/item/storage/scene_cards,
		/obj/item/storage/box/evidence,
		/obj/item/camera,
		/obj/item/taperecorder,
		/obj/item/toy/crayon/white,
		/obj/item/storage/briefcase/crimekit
	)
	crate_name = "forensics crate"

/datum/supply_pack/job_equipment/beekeeping_suits
	name = "Beekeeper Suit Crate"
	desc = "Bee business booming? Better be benevolent and boost botany by bestowing a Beekeeper-suit! Contains a beekeeper suit."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(
		/obj/item/clothing/head/beekeeper_head,
		/obj/item/clothing/suit/beekeeper_suit,
	)
	crate_name = "beekeeper suits"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/job_equipment/beekeeping_fullkit
	name = "Beekeeping Starter Crate"
	desc = "BEES BEES BEES. Contains three honey frames, a beekeeper suit and helmet, flyswatter, bee house, and, of course, a pure-bred Priapus-Standardized Queen Bee!"
	cost = CARGO_CRATE_VALUE * 3
	contains = list(
		/obj/structure/beebox/unwrenched,
		/obj/item/honey_frame,
		/obj/item/honey_frame,
		/obj/item/honey_frame,
		/obj/item/queen_bee/bought,
		/obj/item/clothing/head/beekeeper_head,
		/obj/item/clothing/suit/beekeeper_suit,
		/obj/item/melee/flyswatter
	)
	crate_name = "beekeeping starter crate"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/job_equipment/hydroponics
	name = "Hydroponics Crate"
	desc = "Supplies for growing a great garden! Contains two bottles of ammonia, two Plant-B-Gone spray bottles, a hatchet, cultivator, plant analyzer, as well as a pair of leather gloves and a botanist's apron."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(
		/obj/item/reagent_containers/spray/plantbgone,
		/obj/item/reagent_containers/spray/plantbgone,
		/obj/item/reagent_containers/cup/bottle/ammonia,
		/obj/item/reagent_containers/cup/bottle/ammonia,
		/obj/item/hatchet,
		/obj/item/plant_analyzer,
		/obj/item/clothing/gloves/botanic_leather,
		/obj/item/clothing/suit/apron
	)
	crate_name = "hydroponics crate"
	crate_type = /obj/structure/closet/crate/hydroponics
