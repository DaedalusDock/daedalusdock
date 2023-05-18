/datum/job/chemist
	title = JOB_CHEMIST
	description = "Supply the doctors with chemicals, make medicine, as well as \
		less likable substances in the comfort of a fully reinforced room."
	department_head = list("Medical Director")
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	supervisors = "the medical director"
	selection_color = "#013d3b"
	exp_requirements = 60
	exp_required_type = EXP_TYPE_CREW
	exp_granted_type = EXP_TYPE_CREW

	employers = list(
		/datum/employer/contractor,
		/datum/employer/ananke,
		/datum/employer/aether
	)

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/chemist,
			SPECIES_PLASMAMAN = /datum/outfit/job/chemist/plasmaman,
		),
	)

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_STATION_MASTER

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)

	bounty_types = CIV_JOB_CHEM
	departments_list = list(
		/datum/job_department/medical,
	)

	family_heirlooms = list(/obj/item/book/manual/wiki/chemistry, /obj/item/ph_booklet)

	mail_goodies = list(
		/obj/item/reagent_containers/glass/bottle/flash_powder = 15,
		/obj/item/reagent_containers/glass/bottle/exotic_stabilizer = 5,
		/obj/item/reagent_containers/glass/bottle/leadacetate = 5,
		/obj/item/paper/secretrecipe = 1
	)
	rpg_title = "Alchemist"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN


/datum/outfit/job/chemist
	name = "Chemist"
	jobtype = /datum/job/chemist

	id_trim = /datum/id_trim/job/chemist
	uniform = /obj/item/clothing/under/rank/medical/chemist
	suit = /obj/item/clothing/suit/toggle/labcoat/chemist
	belt = /obj/item/modular_computer/tablet/pda/chemist
	ears = /obj/item/radio/headset/headset_med
	glasses = /obj/item/clothing/glasses/science
	shoes = /obj/item/clothing/shoes/sneakers/white
	l_pocket = /obj/item/reagent_containers/glass/bottle/random_buffer
	r_pocket = /obj/item/reagent_containers/dropper

	backpack = /obj/item/storage/backpack/chemistry
	satchel = /obj/item/storage/backpack/satchel/chem
	duffelbag = /obj/item/storage/backpack/duffelbag/chemistry

	box = /obj/item/storage/box/survival/medical
	chameleon_extras = /obj/item/gun/syringe

/datum/outfit/job/chemist/plasmaman
	name = "Chemist (Plasmaman)"

	uniform = /obj/item/clothing/under/plasmaman/chemist
	gloves = /obj/item/clothing/gloves/color/plasmaman/white
	head = /obj/item/clothing/head/helmet/space/plasmaman/chemist
	mask = /obj/item/clothing/mask/breath
	r_hand = /obj/item/tank/internals/plasmaman/belt/full
